// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:pod/models/candidate.dart';

import 'package:pod/providers/firebase_api.dart';

import '../models/poll.dart';

class Polls with ChangeNotifier {
  UploadTask? uploadTask;

  List cameras = [];

  //FUNCTION TO CREATE A POLL
  Future<void> addPoll(Poll poll, BuildContext context) async {
    try {
      //this loop stores each candidate information in a map and sends it seperately from the others
      for (var element in poll.candidates) {
        //download url of each candidate
        final imageUrl = await uploadImage(element.candidateImage, poll.pollId);
        //the object to send the candidate information
        final candidateUpload = FirebaseFirestore.instance
            .collection(poll.pollId)
            .doc("${element.id}");

        final info = {
          "id": element.id,
          "vote-count": element.voteCount,
          "name": element.name,
          "party": element.party,
          "image-url": imageUrl,
        };
        //sending the candidate information
        await candidateUpload.set(info);
      }

      //data containes the document to sent to the server
      final pollData =
          FirebaseFirestore.instance.collection(poll.pollId).doc("Poll-Data");

      //this json stores the poll object in json form
      //this is without the candidate details because that has being sent
      final json = {
        "poll-name": poll.name,
        "admin-id": poll.adminId,
        "start-time": poll.startTime.toIso8601String(),
        "end-time": poll.endTime.toIso8601String(),
        "eligible-voters": poll.eligibleVotersCode,
        "poll-id": poll.pollId,
        "voted-candidates": [],
      };

      //this lines sends the json data to firebase storage(cloud firestore)
      await pollData.set(json);

      //after that, we show a toast to the user that everything is hopefully successful
      showToast(
        "Poll has being created successfully",
        context: context,
        duration: const Duration(seconds: 4),
      );
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  //THIS FUNCTION IS USED TO FIND A POLL
  Future<Poll> fetchPoll(String pollId) async {
    try {
      //pollData will later store information of the poll
      Map<String, dynamic> pollData = {};

      //candidates will store the extracted candidate information
      List<Candidate> candidates = [];

      //snapshot contain raw data which is about each candidate
      //this will later be organized into a candidate object
      List snapshots = [];

      //data containes the document to be read from the server about the poll
      await FirebaseFirestore.instance
          .collection(pollId)
          .doc("Poll-Data")
          .get()
          .then((value) {
        final extract = value.data();
        pollData = extract!;
      });

      //extracting the raw document id of each candidate
      await FirebaseFirestore.instance
          .collection(pollId)
          .get()
          .then((value) => value.docs.forEach((element) {
                snapshots.add(element.reference.id);
              }));

      //using the extracted document id to fetch the info about each candidate
      //after that it is organized into a candidate object
      for (int i = 0; i < snapshots.length; i++) {
        if (snapshots[i] == "Poll-Data") continue;
        await FirebaseFirestore.instance
            .collection(pollId)
            .doc(snapshots[i])
            .get()
            .then((value) {
          final extract = value.data();
          Candidate candidate = Candidate(
            name: extract!["name"],
            party: extract["party"],
            id: extract["id"],
            imageUrl: extract["image-url"],
          );
          candidates.add(candidate);
        });
      }
      //organizing the extracted data back into the poll form
      Poll poll = Poll(
        candidates: candidates,
        name: pollData["poll-name"],
        adminId: pollData["admin-id"],
        startTime: DateTime.parse(pollData["start-time"]),
        endTime: DateTime.parse(pollData["end-time"]),
        eligibleVotersCode: pollData["eligible-voters"],
        pollId: pollData["poll-id"],
      );

      //returning the poll to the needed class
      return poll;
    } catch (error) {
      rethrow;
    }
  }

  //THIS FUNCTION IS USED TO UPLOAD AN IMAGE TO THE SERVER AND RETURNS THE IMAGEURL
  Future<String> uploadImage(File? candidateImage, String basePath) async {
    try {
      final filename = candidateImage!.path;
      final destination = "/$basePath/$filename";
      uploadTask = FirebaseApi.uploadFile(destination, candidateImage);
      if (uploadTask == null) return "";
      final snapshot = await uploadTask!.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (error) {
      rethrow;
    }
  }

  //THIS FUNCTION ENABLES VOTING FOR CANDIDATES
  Future<void> voteForCandidate({
    required Poll poll,
    required int id,
    required String candidateKey,
  }) async {
    try {
      //incrementing that candidate vote count
      final update =
          FirebaseFirestore.instance.collection(poll.pollId).doc(id.toString());
      await update.update({
        "vote-count": FieldValue.increment(1),
      });

      //registering the candidate as votered
      final clear =
          FirebaseFirestore.instance.collection(poll.pollId).doc("Poll-Data");
      await clear.update({
        "voted-candidates": FieldValue.arrayUnion([candidateKey])
      });
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> isVoterEligible(String pollId, String voterCode) async {
    try {
      final eligibleVoters = await FirebaseFirestore.instance
          .collection(pollId)
          .doc("Poll-Data")
          .get()
          .then((value) {
        return value.data()!["eligible-voters"];
      }) as List;
      final alreadyVoted = await FirebaseFirestore.instance
          .collection(pollId)
          .doc("Poll-Data")
          .get()
          .then((value) {
        return value.data()!["voted-candidates"];
      }) as List;

      if (alreadyVoted.contains(voterCode)) return false;
      if (eligibleVoters.contains(voterCode)) return true;
      return false;
    } catch (error) {
      return false;
    }
  }
}

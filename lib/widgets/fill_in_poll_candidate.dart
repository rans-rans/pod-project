// ignore_for_file: curly_braces_in_flow_control_structures, must_be_immutable, sort_child_properties_last

import 'dart:io';
import 'package:flutter/material.dart';

import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pod/widgets/poll_text_field.dart';

import '../models/candidate.dart';
import 'candidate_image_view.dart';


class FillInPollCandidate extends StatefulWidget {
  List<Candidate> candidates;
  final ValueNotifier<String> candidateImage;
  final TextEditingController candidateNameController;
  final TextEditingController partyController;
  final FocusNode nameFocus;
  final FocusNode partyFocus;

  final Function setState;
  bool hasTakenImage;

  FillInPollCandidate({
    required this.candidates,
    required this.candidateImage,
    required this.nameFocus,
    required this.partyFocus,
    required this.candidateNameController,
    required this.partyController,
    required this.setState,
    required this.hasTakenImage,
    Key? key,
  }) : super(key: key);

  @override
  State<FillInPollCandidate> createState() => _FillInPollCandidateState();
}

class _FillInPollCandidateState extends State<FillInPollCandidate> {
  int candidateId = 1;

  Future<void> takePicture(ImageSource source) async {
    try {
      final picture = ImagePicker();
      final imageFile = await picture.pickImage(
        source: source,
        maxHeight: 300,
        imageQuality: 80,
        preferredCameraDevice: CameraDevice.rear,
      );
      if (imageFile == null) return;
      widget.hasTakenImage = true;
      widget.candidateImage.value = imageFile.path;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addCandidate(BuildContext context) async {
    if (widget.candidateNameController.text.isEmpty) {
      FocusScope.of(context).requestFocus(widget.nameFocus);
      widget.hasTakenImage = false;
      showToast(
        "Candidate name cannot be empty",
        context: context,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    if (widget.hasTakenImage == false) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content:
              const Text("Please select or take a photo for the candidate"),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("OK"))
          ],
        ),
      );
      return;
    }

    widget.candidates.add(Candidate(
      name: widget.candidateNameController.text,
      party: widget.partyController.text,
      id: candidateId,
      candidateImage: File(widget.candidateImage.value),
    ));
    widget.partyController.clear();
    widget.candidateNameController.clear();
    candidateId++;
    widget.hasTakenImage = false;
  }



  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        
        CandidateImageView(widget.candidateImage),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              child: const Text("Select from gallery"),
              onPressed: () => takePicture(ImageSource.gallery),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
              ),
            ),
            ElevatedButton(
              child: const Text("Take Picture"),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor),
              onPressed: () => takePicture(ImageSource.camera),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: PollTextField(
            controller: widget.candidateNameController,
            hintText: "Candidate Name",
            helperText: "Enter Candidate name here",
            elementScope: widget.nameFocus,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: PollTextField(
            controller: widget.partyController,
            hintText: "Party",
            helperText: "Optional: Enter the party this person stands for",
            elementScope: widget.partyFocus,
          ),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          margin: const EdgeInsets.all(10),
          width: double.infinity,
          height: 100,
          child: ElevatedButton(
            child: const Text("ADD TO LIST"),
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor),
            onPressed: () => addCandidate(context).then((value) {
              widget.candidateImage.value = "";
              widget.setState();
            }),
          ),
        ),
      ],
    ));
  }
}

// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pod/widgets/time_tile.dart';

import '../models/poll.dart';
import 'voting_page.dart';

class SeeResults extends StatefulWidget {
  final Poll poll;
  const SeeResults(this.poll, {Key? key}) : super(key: key);

  @override
  State<SeeResults> createState() => _SeeResultsState();
}

class _SeeResultsState extends State<SeeResults> {
  ValueNotifier<Duration>? duration;
  Timer pollTimer = Timer(const Duration(), () {});

  PollStatus get pollStatus {
    if (widget.poll.startTime.isAfter(DateTime.now()) &&
        widget.poll.endTime.isAfter(DateTime.now()))
      return PollStatus.notStarted;
    if (widget.poll.startTime.isBefore(DateTime.now()) &&
        widget.poll.endTime.isBefore(DateTime.now())) return PollStatus.ended;
    return PollStatus.onGoing;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> stream() =>
      FirebaseFirestore.instance.collection(widget.poll.pollId).snapshots();

  Future<List<Map<String, dynamic>?>> some() async {
    final something = await stream().first.then(
          (value) => value.docs.map(
            (element) {
              if (!element.data().containsKey("poll-id")) {
                return element.data();
              }
            },
          ),
        );

    final another = something.toList();
    another.removeWhere((element) => element == null);
    return another;
  }

  @override
  void initState() {
    duration = ValueNotifier(
      Duration(
          seconds:
              widget.poll.endTime.difference(widget.poll.startTime).inSeconds),
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    if (pollTimer.isActive) pollTimer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    ValueNotifier<PollStatus> thePollStatus = ValueNotifier(pollStatus);

    //this timer checks to see if poll has not started, on-going or ended
    void startTimer() {
      pollTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (widget.poll.startTime.isAfter(DateTime.now())) {
          thePollStatus.value = PollStatus.notStarted;
          return;
        }
        if (widget.poll.endTime.isBefore(DateTime.now())) {
          thePollStatus.value = PollStatus.ended;
          pollTimer.cancel();
          return;
        }

        final timeLeft =
            widget.poll.endTime.difference(DateTime.now()).inSeconds;
        if (timeLeft <= 0.5) {
          thePollStatus.value = PollStatus.ended;
          pollTimer.cancel();
          return;
        }
        thePollStatus.value = PollStatus.onGoing;
        duration!.value = Duration(seconds: timeLeft);
      });
    }

    startTimer();

    return Scaffold(
      appBar: AppBar(
        title: const Text("FINAL RESULTS"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ValueListenableBuilder(
        valueListenable: thePollStatus,
        builder: (
          context,
          value,
          child,
        ) =>
            thePollStatus.value == PollStatus.notStarted
                ? NotStarted(
                    widget.poll.startTime,
                  )
                : thePollStatus.value == PollStatus.onGoing
                    ? Center(
                        child: Wrap(
                          children: [
                            TimeTile(duration!, 3, "DAY(s)"),
                            TimeTile(duration!, 1, "HOURS(s)"),
                            TimeTile(duration!, 2, "MINUTE(s)"),
                            TimeTile(duration!, 0, "SECOND(s)"),
                          ],
                        ),
                      )
                    : FutureBuilder<List>(
                        future: some(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: Theme.of(context).primaryColor,
                              ),
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.all(15),
                              child: ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) => ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      snapshot.data![index]["image-url"],
                                    ),
                                  ),
                                  title: Text(
                                    snapshot.data![index]["name"],
                                    style: const TextStyle(
                                      fontSize: 25,
                                    ),
                                  ),
                                  trailing: ValueListenableBuilder<int>(
                                    valueListenable: ValueNotifier(
                                      snapshot.data![index]["vote-count"],
                                    ),
                                    builder: (context, value, child) => Text(
                                      value.toString(),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      ),
      ),
    );
  }
}

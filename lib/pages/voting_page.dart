// ignore_for_file: curly_braces_in_flow_control_structures, prefer_typing_uninitialized_variables, sort_child_properties_last, use_build_context_synchronously
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import 'package:provider/provider.dart';

import '../models/poll.dart';
import '../providers/polls.dart';
import '../widgets/poll_timer_count.dart';

class VotingPage extends StatefulWidget {
  final Poll vote;
  final String voterCode;
  const VotingPage(
    this.vote,
    this.voterCode, {
    Key? key,
  }) : super(key: key);

  @override
  State<VotingPage> createState() => _VotingPageState();
}

class _VotingPageState extends State<VotingPage> {
  //this variable will store the selected candidate
  int? selected;

  //the timer of the poll
  Timer pollTimer = Timer(const Duration(), () {});

  PollStatus get pollStatus {
    if (widget.vote.startTime.isAfter(DateTime.now()) &&
        widget.vote.endTime.isAfter(DateTime.now()))
      return PollStatus.notStarted;
    if (widget.vote.startTime.isBefore(DateTime.now()) &&
        widget.vote.endTime.isBefore(DateTime.now())) return PollStatus.ended;
    return PollStatus.onGoing;
  }

  //duration keeps track of the time left for the poll
  var duration;
  @override
  void initState() {
    duration = ValueNotifier(
      Duration(
          seconds:
              widget.vote.endTime.difference(widget.vote.startTime).inSeconds),
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
    //thePollStatus stores the current status of the poll whether time is up or not
    ValueNotifier<PollStatus> thePollStatus = ValueNotifier(pollStatus);

    //this timer checks to see if poll has not started, on-going or ended
    void startTimer() {
      pollTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (widget.vote.startTime.isAfter(DateTime.now())) return;
        if (widget.vote.endTime.isBefore(DateTime.now())) {
          pollTimer.cancel();
          return;
        }

        final timeLeft =
            widget.vote.endTime.difference(DateTime.now()).inSeconds;
        if (timeLeft <= 0.5) {
          thePollStatus.value = PollStatus.ended;
          pollTimer.cancel();
          return;
        }
        thePollStatus.value = PollStatus.onGoing;
        duration.value = Duration(seconds: timeLeft);
      });
    }

    startTimer();
    return Scaffold(
      appBar: AppBar(
        title: const Text("CAST YOUR VOTE"),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          ValueListenableBuilder(
            valueListenable: thePollStatus,
            builder: (BuildContext context, value, Widget? child) => Container(
              padding: const EdgeInsets.all(10),
              color: thePollStatus.value == PollStatus.onGoing
                  ? Colors.green
                  : thePollStatus.value == PollStatus.notStarted
                      ? Colors.yellow
                      : Colors.red,
              child: Text(
                thePollStatus.value == PollStatus.onGoing
                    ? "On going"
                    : thePollStatus.value == PollStatus.notStarted
                        ? "Not Started"
                        : "Poll Ended",
              ),
            ),
          ),
        ],
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
                    widget.vote.startTime,
                  )
                : thePollStatus.value == PollStatus.ended
                    ? VoteEnded(
                        widget.vote.endTime,
                      )
                    : Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            const Text("Select your choice"),
                            if (thePollStatus.value == PollStatus.onGoing)
                              ValueListenableBuilder(
                                valueListenable: duration,
                                builder: (BuildContext context, value,
                                        Widget? child) =>
                                    Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const Text("TIME LEFT: "),
                                    PollTimerCount(
                                      duration.value.inDays.toString(),
                                      "days",
                                    ),
                                    PollTimerCount(
                                      duration.value.inHours
                                          .remainder(60)
                                          .toString(),
                                      "hrs",
                                    ),
                                    PollTimerCount(
                                      duration.value.inMinutes
                                          .remainder(60)
                                          .toString(),
                                      "mins",
                                    ),
                                    PollTimerCount(
                                      duration.value.inSeconds
                                          .remainder(60)
                                          .toString(),
                                      "secs",
                                    ),
                                  ],
                                ),
                              ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    ...widget.vote.candidates.map(
                                      (e) => Container(
                                        margin: const EdgeInsets.only(top: 15),
                                        child: ListTile(
                                          onTap: () {
                                            setState(() => selected = e.id);
                                          },
                                          contentPadding:
                                              const EdgeInsets.all(10),
                                          selectedTileColor:
                                              Colors.green.shade800,
                                          selected: selected == e.id,
                                          selectedColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            side: const BorderSide(
                                                color: Colors.black, width: 1),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          title: Text(e.name),
                                          subtitle: Text(e.party),
                                          leading: CircleAvatar(
                                            backgroundImage: NetworkImage(
                                              e.imageUrl.toString(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ElevatedButton(
                              child: const Text("DONE"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                              ),
                              onPressed: () {
                                if (selected == null) {
                                  showToast(
                                    "Select a candidate",
                                    context: context,
                                    duration: const Duration(seconds: 2),
                                  );
                                  return;
                                }
                                int index = widget.vote.candidates.indexWhere(
                                    (element) => selected == element.id);
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    bool isVoteSending = false;
                                    return StatefulBuilder(
                                      builder: (context, setState) =>
                                          AlertDialog(
                                        content: Text(
                                            "Do you really want to vote for ${widget.vote.candidates[index].name} ??"),
                                        actions: [
                                          isVoteSending
                                              ? CircularProgressIndicator(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                )
                                              : ElevatedButton(
                                                  child: const Text("VOTE"),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Theme.of(context)
                                                            .primaryColor,
                                                  ),
                                                  onPressed: () async {
                                                    try {
                                                      isVoteSending = true;
                                                      setState(() {});

                                                      if (selected == null) {
                                                        showToast(
                                                          "Please select a candidate first",
                                                        );
                                                        return;
                                                      }
                                                      await Provider.of<Polls>(
                                                        context,
                                                        listen: false,
                                                      ).voteForCandidate(
                                                        poll: widget.vote,
                                                        id: selected!,
                                                        candidateKey:
                                                            widget.voterCode,
                                                      );
                                                      setState(() =>
                                                          isVoteSending =
                                                              false);

                                                      showToast(
                                                          "VOTE SUCCESSFUL 💥💥💥",
                                                          context: context,
                                                          duration:
                                                              const Duration(
                                                                  seconds: 2));
                                                      Navigator.of(context)
                                                          .pop();
                                                      Navigator.of(context)
                                                          .pop();
                                                      Navigator.of(context)
                                                          .pop();
                                                    } catch (error) {
                                                      setState(() =>
                                                          isVoteSending =
                                                              false);
                                                      showToast(
                                                        "Error occurred during voting",
                                                        context: context,
                                                        duration:
                                                            const Duration(
                                                                seconds: 2),
                                                      );
                                                      rethrow;
                                                    }
                                                  },
                                                ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            )
                          ],
                        ),
                      ),
      ),
    );
  }
}

enum PollStatus {
  notStarted,
  onGoing,
  ended,
}

class NotStarted extends StatelessWidget {
  final DateTime date;
  const NotStarted(this.date, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            "VOTING WILL START AT ${date.day}/${date.month}/${date.year} at ${date.hour.toString().padLeft(2, "0")}:${date.minute.toString().padLeft(2, "0")}",
            style: const TextStyle(fontSize: 25),
          ),
        ),
      );
}

class VoteEnded extends StatelessWidget {
  final DateTime date;
  const VoteEnded(this.date, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            "VOTING ENDED  AT ${date.day}/${date.month}/${date.year} at ${date.hour.toString().padLeft(2, "0")}:${date.minute.toString().padLeft(2, "0")}",
            style: const TextStyle(fontSize: 25),
          ),
        ),
      );
}

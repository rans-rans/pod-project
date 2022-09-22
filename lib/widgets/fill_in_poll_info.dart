// ignore_for_file: curly_braces_in_flow_control_structures, sort_child_properties_last, use_build_context_synchronously

import 'dart:io';

import "package:flutter/material.dart";
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:pod/models/poll.dart';
import 'package:pod/pages/add_voters_page.dart';
import 'package:pod/widgets/poll_text_field.dart';
import 'package:provider/provider.dart';

import '../models/candidate.dart';
import '../providers/polls.dart';
import 'the_timer.dart';

class FillInPollInfo extends StatefulWidget {
  final List<Candidate> candidates;
  final TextEditingController pollNameController;
  final TextEditingController adminIdController;
  final FocusNode adminFocus;
  final FocusNode pollFocus;

  const FillInPollInfo(
    this.candidates,
    this.pollNameController,
    this.adminIdController,
    this.pollFocus,
    this.adminFocus, {
    Key? key,
  }) : super(key: key);

  @override
  State<FillInPollInfo> createState() => _FillInPollInfoState();
}

class _FillInPollInfoState extends State<FillInPollInfo> {
  DateTime start = DateTime.now();
  DateTime end = DateTime.now();
  List<String> eligibleVoters = [];
  bool isLoading = false;
  String pollId =
      "V${DateTime.now().second}${DateTime.now().day}${DateTime.now().hour}${DateTime.now().millisecond}V";

  String get theName {
    return widget.pollNameController.text;
  }

  @override
  Widget build(BuildContext context) {
    MaterialBanner materialBanner = MaterialBanner(
      content: const Text(
        "Please the poll must have of a duration more than an 15 mins",
      ),
      actions: [
        TextButton(
          onPressed: () => ScaffoldMessenger.of(context).removeCurrentMaterialBanner(),
          child: const Text("DISMISS"),
        ),
      ],
    );
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 80,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(top: 5, bottom: 20),
            child: const Text(
              "ALMOST DONE",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(5),
              ),
            ),
          ),
          PollTextField(
            controller: widget.adminIdController,
            hintText: "Admin Code",
            helperText: "Enter admin code here",
            elementScope: widget.adminFocus,
          ),
          Row(
            children: const [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "⨀ Please copy the text below as your poll id",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                  softWrap: true,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                const Text("POLL-ID: "),
                SelectableText(
                  pollId,
                  style: const TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
                  toolbarOptions: const ToolbarOptions(
                    copy: true,
                    selectAll: true,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 5, bottom: 10),
            child: ListTile(
              leading: const Icon(Icons.watch_later_rounded),
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  color: Colors.black,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: const EdgeInsets.all(10),
              title: Text("START TIME".toString()),
              subtitle: Text(
                "${start.hour.toString().padLeft(2, "0")}:${start.minute.toString().padLeft(2, "0")}",
              ),
              trailing: Text(
                "${start.day.toString().padLeft(2, "0")}/ ${start.month.toString().padLeft(2, "0")}/ ${start.year}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () async => await TheTimer()
                  .showDateAndTime(
                context,
                start,
                start.year,
                start.month,
                start.day,
                start.hour,
                start.minute,
              )
                  .then(
                (value) {
                  if (value == null) return;
                  start = value;
                  setState(() {});
                },
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 5, bottom: 10),
            child: ListTile(
              leading: const Icon(Icons.watch_later_rounded),
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: const EdgeInsets.all(10),
              title: Text("END TIME".toString()),
              subtitle: Text(
                "${end.hour.toString().padLeft(2, "0")}:${end.minute.toString().padLeft(2, "0")}",
              ),
              trailing: Text(
                "${end.day.toString().padLeft(2, "0")}/ ${end.month.toString().padLeft(2, "0")}/ ${end.year}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () async => await TheTimer()
                  .showDateAndTime(
                context,
                end,
                end.year,
                end.month,
                end.day,
                end.hour,
                end.minute,
              )
                  .then(
                (value) {
                  if (value == null) return;
                  end = value;
                  setState(() {});
                },
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomRight,
            margin: const EdgeInsets.symmetric(vertical: 15),
            child: ElevatedButton(
              child: const Text("UPLOAD VOTERS"),
              onPressed: () => Navigator.of(context).pushNamed(
                AddVotersPage.routeName,
                arguments: eligibleVoters,
              ),
              style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              minimumSize: const Size(230, 50),
            ),
            child: const Text("DONE"),
            onPressed: () async {
              if (widget.adminIdController.text.isEmpty) {
                FocusScope.of(context).requestFocus(widget.adminFocus);
                showToast(
                  "Please provide an admin Code",
                  context: context,
                  duration: const Duration(seconds: 2),
                );
                return;
              }

              if (widget.candidates.length < 2) {
                showToast(
                  "Please add more than one voter code",
                  context: context,
                );
              }

              if (eligibleVoters.length < 2) {
                showToast("Please add some more voter", context: context);
              }

              Duration pollDuration = end.difference(start);
              if (pollDuration < const Duration(minutes: 15)) {
                ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
                ScaffoldMessenger.of(context).showMaterialBanner(materialBanner);
                return;
              }
              ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
              await showDialog(
                context: context,
                builder: (context) => StatefulBuilder(
                  builder: (context, setState) => Center(
                    child: Card(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.all(5),
                        height: 320,
                        child: Column(
                          children: [
                            Expanded(
                              child: Scrollbar(
                                thumbVisibility: true,
                                child: SingleChildScrollView(
                                  child: Material(
                                    child: Column(
                                      children: [
                                        ...widget.candidates.map(
                                          (e) => ListTile(
                                            leading: CircleAvatar(
                                              maxRadius: 40,
                                              backgroundImage: FileImage(
                                                File(e.candidateImage!.path),
                                              ),
                                            ),
                                            title: Text(e.name),
                                            subtitle: Text(e.party),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            isLoading
                                ? CircularProgressIndicator(
                                    color: Theme.of(context).primaryColor,
                                  )
                                : ElevatedButton(
                                    child: const Text("SUBMIT"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context).primaryColor,
                                    ),
                                    onPressed: () async {
                                      try {
                                        setState(() => isLoading = true);

                                        await Provider.of<Polls>(
                                          context,
                                          listen: false,
                                        ).addPoll(
                                            Poll(
                                              candidates: widget.candidates,
                                              name: theName,
                                              adminId: widget.adminIdController.text,
                                              startTime: start,
                                              endTime: end,
                                              pollId: pollId,
                                              eligibleVotersCode: eligibleVoters,
                                            ),
                                            context);
                                        setState(() {
                                          isLoading = false;
                                        });

                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                      } catch (error) {
                                        setState(() => isLoading = false);
                                      }
                                    },
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

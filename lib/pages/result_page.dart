// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:pod/providers/polls.dart';
import 'package:pod/widgets/poll_text_field.dart';
import 'package:provider/provider.dart';

import 'see_result_page.dart';

class ResultsPage extends StatefulWidget {
  static const routeName = "/result-page";
  const ResultsPage({Key? key}) : super(key: key);

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  final idController = TextEditingController();
  final codeController = TextEditingController();
  bool isLoading = false;
  bool isEligible = false;

  Future<bool> hasVoterCode(String pollId, String voterCode) async {
    try {
      final data =
          FirebaseFirestore.instance.collection(pollId).doc("Poll-Data");
      final eligibleVoters = await data
          .get()
          .then((value) => value.data()!["eligible-voters"] as List);
      if (eligibleVoters.contains(voterCode)) {
        return true;
      }
      return false;
    } catch (error) {
      return false;
    }
  }

  @override
  void dispose() {
    idController.dispose();
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AUTHENTICATE"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            )
          : SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.9,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: PollTextField(
                        hintText: "Poll ID",
                        controller: idController,
                        elementScope: null,
                        helperText: "Enter the poll id over here",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: PollTextField(
                        hintText: "Voter code",
                        controller: codeController,
                        elementScope: null,
                        helperText: "Enter the voter code here",
                      ),
                    ),
                    TextButton(
                      child: const Text(
                        "Let's Go →→→",
                        style: TextStyle(
                          color: Colors.green,
                        ),
                      ),
                      onPressed: () async {
                        try {
                          setState(() => isLoading = true);

                          if (!await hasVoterCode(
                              idController.text, codeController.text)) {
                            setState(() => isLoading = false);
                            showToast("An error occurred", context: context);
                            return;
                          }
                          final poll =
                              await Provider.of<Polls>(context, listen: false)
                                  .fetchPoll(
                            idController.text,
                          );
                          setState(() => isLoading = false);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SeeResults(poll),
                            ),
                          );
                        } catch (error) {
                          setState(() => isLoading = false);

                          showToast("An error occurred", context: context);
                          rethrow;
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

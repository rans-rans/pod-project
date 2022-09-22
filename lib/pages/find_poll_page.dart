// ignore_for_file: unnecessary_null_comparison, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:pod/pages/voting_page.dart';
import 'package:pod/providers/polls.dart';
import 'package:pod/widgets/poll_text_field.dart';
import 'package:provider/provider.dart';

class FindPollPage extends StatefulWidget {
  const FindPollPage({Key? key}) : super(key: key);

  @override
  State<FindPollPage> createState() => _FindPollPageState();
}

class _FindPollPageState extends State<FindPollPage> {
  TextEditingController idController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  FocusNode focus = FocusNode();

  bool isLoading = false;

  @override
  void dispose() {
    idController.dispose();
    codeController.dispose();
    focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Find your Poll"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              PollTextField(
                hintText: "Voter Code",
                controller: codeController,
                elementScope: null,
                helperText: "Enter your special voter code here",
              ),
              PollTextField(
                  hintText: "Poll ID",
                  controller: idController,
                  elementScope: focus,
                  helperText: ""),
              isLoading
                  ? CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    )
                  : ElevatedButton(
                      child: const Text("Procced"),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor),
                      onPressed: () async {
                        try {
                          setState(() => isLoading = true);

                          final poll = await Provider.of<Polls>(
                            context,
                            listen: false,
                          ).fetchPoll(idController.text);

                          setState(() => isLoading = false);
                          final code = codeController.text;
                          // ignore: use_build_context_synchronously
                          Navigator.of(
                            context,
                          ).push(
                            MaterialPageRoute(
                              builder: (
                                context,
                              ) =>
                                  VotingPage(poll, code),
                            ),
                          );
                        } catch (error) {
                          setState(() => isLoading = false);

                          showToast(
                            "An error occurred or you are not eligible",
                            context: context,
                            duration: const Duration(seconds: 3),
                          );
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

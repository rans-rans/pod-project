import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import 'package:pod/models/candidate.dart';
import 'package:pod/widgets/fill_in_poll_candidate.dart';
import 'package:pod/widgets/fill_in_poll_info.dart';

class CreatePollPage extends StatefulWidget {
  static const routeName = "/create-poll";
  const CreatePollPage({Key? key}) : super(key: key);

  @override
  State<CreatePollPage> createState() => _CreatePollPageState();
}

bool hasTakenImage = false;

class _CreatePollPageState extends State<CreatePollPage> {
  ValueNotifier<String> candidateImage =
      ValueNotifier("assets/images/default-profile-picture.png");
  List<Candidate> candidates = [];
  final TextEditingController candidateNameController = TextEditingController();
  final TextEditingController partyController = TextEditingController();
  final TextEditingController pollNameController = TextEditingController();
  final TextEditingController adminIdController = TextEditingController();
  final FocusNode nameFocus = FocusNode();
  final FocusNode partyFocus = FocusNode();
  final FocusNode adminFocus = FocusNode();
  final FocusNode pollFocus = FocusNode();

  int currentStep = 0;

  @override
  void dispose() {
    candidateNameController.dispose();

    partyController.dispose();
    pollNameController.dispose();
    nameFocus.dispose();
    partyFocus.dispose();
    adminFocus.dispose();
    pollFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text("Create your poll"),
        ),
        body: Stepper(
          type: StepperType.horizontal,
          currentStep: currentStep,
          controlsBuilder: (context, details) => ElevatedButton(
            onPressed: () {
              if (candidates.length < 2) {
                showToast(
                  "Candidates must be more than one",
                  context: context,
                  duration: const Duration(seconds: 2),
                );
                return;
              }
              if (currentStep == 0) {
                setState(() {
                  currentStep++;
                });
              } else {
                setState(() {
                  currentStep--;
                });
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor),
            child: Text(currentStep == 0 ? "NEXT" : "BACK"),
          ),
          steps: [
            Step(
              isActive: currentStep == 0,
              title: const Text("CANDIDATE"),
              content: FillInPollCandidate(
                candidates: candidates,
                hasTakenImage: hasTakenImage,
                nameFocus: nameFocus,
                partyFocus: partyFocus,
                candidateImage: candidateImage,
                candidateNameController: candidateNameController,
                partyController: partyController,
                setState: () => setState,
              ),
            ),
            Step(
              isActive: currentStep == 1,
              title: const Text("POLL"),
              content: FillInPollInfo(
                candidates,
                pollNameController,
                adminIdController,
                adminFocus,
                pollFocus,
              ),
            ),
          ],
        )
        /*
      */
        );
  }
}

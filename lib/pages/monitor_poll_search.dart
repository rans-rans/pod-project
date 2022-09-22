// ignore_for_file: sort_child_properties_last, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import '../widgets/poll_text_field.dart';
import 'monitor_poll_page.dart';

class MonitorPollSearch extends StatefulWidget {
  static const routeName = "/monitor-search";
  const MonitorPollSearch({Key? key}) : super(key: key);

  @override
  State<MonitorPollSearch> createState() => _MonitorPollSearchState();
}

class _MonitorPollSearchState extends State<MonitorPollSearch> {
  final TextEditingController adminController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  bool isAdmin = false;
  bool isLoading = false;

  @override
  void dispose() {
    adminController.dispose();
    idController.dispose();
    super.dispose();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> stream() {
    try {
      return FirebaseFirestore.instance
          .collection(idController.text)
          .snapshots();
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> hasAdminCode(String pollId, String adminId) async {
    try {
      final data =
          FirebaseFirestore.instance.collection(pollId).doc("Poll-Data");
      final pollAdminId =
          await data.get().then((value) => value.data()!["admin-id"] as String);
      if (adminId == pollAdminId) {
        return true;
      }
      return false;
    } catch (error) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Monitor Poll"),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: PollTextField(
                      hintText: "Admin ID",
                      controller: adminController,
                      elementScope: null,
                      helperText: "Enter the Admin ID",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: PollTextField(
                      hintText: "Poll ID",
                      controller: idController,
                      elementScope: null,
                      helperText: "Enter the poll id here",
                    ),
                  ),
                  if (isLoading)
                    CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    )
                  else
                    ElevatedButton(
                      child: const Text("NEXT"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      onPressed: () async {
                        try {
                          setState(() => isLoading = true);
                          final isReallyAdmin = await hasAdminCode(
                              idController.text, adminController.text);
                          if (!isReallyAdmin) {
                            setState(() => isLoading = false);
                            showToast("Error Ocurred ❌❌❌", context: context);
                            return;
                          }
                          setState(() => isLoading = false);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => MonitorPollPage(stream()),
                            ),
                          );
                        } catch (error) {
                          setState(() => isLoading = false);
                          showToast("Error Ocurred ❌❌❌", context: context);
                          rethrow;
                        }
                      },
                    ),
                ],
              ),
            ),
          ),
        ));
  }
}

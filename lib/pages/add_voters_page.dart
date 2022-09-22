// ignore_for_file: sort_child_properties_last

import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import "package:flutter/material.dart";
import 'package:flutter_slidable/flutter_slidable.dart';

class AddVotersPage extends StatefulWidget {
  static const routeName = "/add-voters";
  const AddVotersPage({Key? key}) : super(key: key);

  @override
  State<AddVotersPage> createState() => _AddVotersPageState();
}

class _AddVotersPageState extends State<AddVotersPage> {
  final textController = TextEditingController();
  bool isLoading = false;

  Future<void> readFromFile(List entries) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
      );
      if (result == null) return;
      final filePath = result.files.first.path;
      if (!filePath!.endsWith(".txt")) return;
      entries.clear();
      final pickedFile = File(filePath.toString());
      await pickedFile
          .openRead()
          .map(utf8.decode)
          .transform(const LineSplitter())
          .forEach((element) {
        entries.add(element);
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      rethrow;
    }
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eligibleCredentials =
        ModalRoute.of(context)!.settings.arguments as List;
    ValueNotifier<int> voterLength = ValueNotifier(eligibleCredentials.length);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add your Voters"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            )
          : Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Tip: You can swipe to left to remove an entry"),
                    Column(
                      children: [
                        ElevatedButton(
                          child: const Icon(Icons.file_download),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 64, 196, 12),
                          ),
                          onPressed: () async {
                            setState(() => isLoading = true);
                            await readFromFile(eligibleCredentials);
                            setState(() => isLoading = false);
                          },
                        ),
                        const Text("READ FROM .txt"),
                      ],
                    )
                  ],
                ),
                ValueListenableBuilder(
                  valueListenable: voterLength,
                  builder: (context, value, child) => Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    color: Colors.green,
                    child: Text(
                      "Numbers of entries = ${voterLength.value}",
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Scrollbar(
                    thumbVisibility: true,
                    thickness: 4,
                    child: ListView.builder(
                      itemCount: eligibleCredentials.length,
                      itemBuilder: (context, index) => Slidable(
                        child: Card(
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(2),
                            title: Text(
                              eligibleCredentials[index],
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (_) => setState(
                                () => eligibleCredentials.removeAt(index),
                              ),
                              label: "Delete",
                              icon: Icons.info,
                              backgroundColor: Colors.red,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: textController,
                        autofocus: false,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(15),
                            ),
                            borderSide: BorderSide(
                              width: 2,
                              color: Colors.green.shade100,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(15),
                            ),
                            borderSide: BorderSide(
                              width: 2,
                              color: Colors.green.shade100,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton(
                        onPressed: () => setState(
                          () {
                            if (textController.text.trim().isEmpty) return;
                            eligibleCredentials.add(textController.text);
                            textController.clear();
                          },
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}

// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class PollTimerCount extends StatelessWidget {
  String time;
  final String label;
  PollTimerCount(this.time, this.label, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 142, 185, 144),
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(5),
      child: Column(
        children: [
          Text(
            time.padLeft(2, "0"),
          ),
          Text(label),
        ],
      ),
    );
  }
}

// ignore_for_file: sort_child_properties_last
import 'package:flutter/material.dart';

class TimeTile extends StatelessWidget {
  final ValueNotifier<Duration> duration;
  final int format;
  final String label;
  const TimeTile(this.duration, this.format, this.label, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: ValueListenableBuilder(
            valueListenable: duration,
            builder: (context, value, child) => Text(
              format == 1
                  ? duration.value.inHours.toString().padLeft(2, "0")
                  : format == 3
                      ? duration.value.inDays.toString().padLeft(2, "0")
                      : format == 2
                          ? duration.value.inMinutes
                              .remainder(60)
                              .toString()
                              .padLeft(2, "0")
                          : duration.value.inSeconds
                              .remainder(60)
                              .toString()
                              .padLeft(2, "0"),
              style: const TextStyle(
                fontSize: 50,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 20,
                ),
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 20,
                ),
              ],
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              )),
          padding: const EdgeInsets.all(10),
        ),
        Container(
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          margin: const EdgeInsets.all(5),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black38,
                blurRadius: 10,
              ),
              BoxShadow(
                color: Colors.black54,
                blurRadius: 5,
              ),
            ],
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          padding: const EdgeInsets.all(5),
        ),
      ],
    );
  }
}

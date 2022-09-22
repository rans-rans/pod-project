import 'dart:io';

import 'package:flutter/material.dart';

class CandidateImageView extends StatelessWidget {
  final ValueNotifier<String> notifier;

  const CandidateImageView(this.notifier, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        child: ValueListenableBuilder(
            valueListenable: notifier,
            builder: (context, value, imagePreview) {
              return Image.file(
                File(notifier.value),
                fit: BoxFit.scaleDown,
                //image is stll disoriented
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  "assets/images/default-profile-picture.png",
                  fit: BoxFit.cover,
                ),
              );
            }),
      ),
    );
  }
}

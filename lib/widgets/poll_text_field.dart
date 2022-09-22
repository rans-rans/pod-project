import 'package:flutter/material.dart';

class PollTextField extends StatelessWidget {
  final String hintText;
  final FocusNode? elementScope;
  final String helperText;
  final TextEditingController controller;

  const PollTextField({
    Key? key,
    required this.hintText,
    required this.controller,
    required this.elementScope,
    required this.helperText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.only(top: 5, bottom: 10),
      child: TextField(
          autofocus: false,
          controller: controller,
          cursorColor: Theme.of(context).primaryColor,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            hintText: hintText,
            helperText: helperText,
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
            ),
          )),
    );
  }
}

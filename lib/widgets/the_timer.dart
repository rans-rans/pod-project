import "package:flutter/material.dart";

class TheTimer {
  Future showDateAndTime(
    BuildContext context,
    DateTime time,
    int year,
    int month,
    int day,
    int hour,
    int minute,
  ) =>
      _showDateAndTime(
        context,
        time,
        year,
        month,
        day,
        hour,
        minute,
      );

  Future _showDateAndTime(
    BuildContext context,
    DateTime time,
    int year,
    int month,
    int day,
    int hour,
    int minute,
  ) async {
    return await showDatePicker(
      context: context,
      initialDate: time,
      firstDate: time,
      lastDate: DateTime(time.year + 2),
    ).then(
      (value) async {
        if (value == null) return null;
        year = value.year;
        month = value.month;
        day = value.day;
        return await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        ).then((value) {
          if (value == null) return null;
          hour = value.hour;
          minute = value.minute;
          return time = DateTime(
            year,
            month,
            day,
            hour,
            minute,
          );
        });
      },
    );
  }
}

import 'package:flutter/material.dart';

class FormatDate {
  static String getFormatDate({
    required BuildContext context,
    required String time,
  }) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));

    return TimeOfDay.fromDateTime(date).format(context);
  }

  static String getLastMessageTime({
    required BuildContext context,
    required String time,
    bool showYear = false,
  }) {
    final DateTime sent =
        DateTime.fromMillisecondsSinceEpoch(int.parse(time.toString()));
    final DateTime now = DateTime.now();

    if (now.day == sent.day &&
        now.month == sent.month &&
        now.year == sent.year) {
      return TimeOfDay.fromDateTime(sent).format(context);
    }
    return showYear
        ? '${sent.day} ${_getMonth(sent)} ${sent.year}'
        : '${sent.day} ${_getMonth(sent)}';
  }

// get formatted last active time of user in chat screen
  static String getLastActiveTime({
    required BuildContext context,
    required String lastActiveTime,
  }) {
    final int i = int.tryParse(lastActiveTime) ?? -1;
    if (i == 1) return 'last seen not available';
    DateTime time = DateTime.fromMillisecondsSinceEpoch(i);
    DateTime now = DateTime.now();

    String formattedTime = TimeOfDay.fromDateTime(time).format(context);
    if (time.day == now.day &&
        time.month == now.month &&
        time.year == now.year) {
      return 'Last seen today $formattedTime';
    }
    if ((now.difference(time).inHours / 24).round() == 1) {
      return 'Last seen yesterday $formattedTime';
    }
    String month = _getMonth(time);
    return 'Last seen on ${time.day} $month on $formattedTime';
  }

  static String _getMonth(DateTime dateTime) {
    switch (dateTime.month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
    }
    return 'NA';
  }
}

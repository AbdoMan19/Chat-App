import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class TimeConverter {
  static String convertTimeToString(Timestamp time) {
    DateTime dateTime = time.toDate();
    DateTime now = DateTime.now();
    int diff = now.difference(dateTime).inSeconds;
    if (diff < 60) {
      return '${diff.toString()}s agos';
    } else if (diff < 3600) {
      return '${diff ~/ 60}m ago and ${diff % 60}s ago';
    } else if (diff < 86400) {
      return '${diff ~/ 3600}h ago and ${(diff % 3600) ~/ 60}m ago';
    } else if (diff < 604800) {
      return '${diff ~/ 86400}d ago and ${(diff % 86400) ~/ 3600}h ago';
    } else {
      return convertTimeToDate(time, isNumber: true);
    }
  }

  static String convertTimeToDate(Timestamp time,
      {bool isNumber = false, bool isDay = false}) {
    DateTime dateTime = time.toDate();
    if (isNumber) {
      if (isDay) {
        return '${dateTime.month}/${dateTime.year}';
      }
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } else {
      if (isDay) {
        return '${_changeMonthNumberToText(dateTime.month)} ${dateTime.year}';
      }
      return '${dateTime.day} ${_changeMonthNumberToText(dateTime.month)} ${dateTime.year}';
    }
  }

  static String convertTimeToTime(Timestamp time) {
    DateTime dateTime = time.toDate();
    return '${dateTime.hour}:${dateTime.minute}';
  }

  static String _changeMonthNumberToText(int month) {
    switch (month) {
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
        return 'June';
      case 7:
        return 'July';
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
      default:
        return 'Unknown';
    }
  }

  static Duration convertTimeToDuration(Timestamp time) {
    DateTime dateTime = time.toDate();
    return DateTime.now().difference(dateTime);
  }
}

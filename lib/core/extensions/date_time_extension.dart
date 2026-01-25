import 'dart:math';

import 'package:intl/intl.dart';

extension DateTimeExt on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  bool get isToday {
    final nowDate = DateTime.now();
    return year == nowDate.year && month == nowDate.month && day == nowDate.day;
  }

  bool get isYesterday {
    final nowDate = DateTime.now();
    return year == nowDate.year && month == nowDate.month && day == nowDate.day - 1;
  }

  DateTime get today => DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  DateTime get date => DateTime(year, month, day);

  String get toRelativeTime {
    final duration = DateTime.now().difference(this);
    final dayDiff = duration.inDays;
    final secDiff = duration.inSeconds;

    if (dayDiff < 0 || dayDiff >= 31) {
      if (dayDiff > 365) {
        var year = DateTime.now().year - this.year;
        if (DateTime.now().month == month && day < DateTime.now().day || month < DateTime.now().month) {
          year--;
          return '$year year${year > 1 ? "s" : ""}';
        }
      } else {
        return '$dayDiff days';
      }
    }

    if (dayDiff == 1) {
      return '1 day';
    }

    if (dayDiff != 0) {
      if (dayDiff > 365) {
        final yearDiff = dayDiff ~/ 360;
        if (yearDiff >= 2) {
          return '$yearDiff years';
        } else {
          return '$yearDiff year';
        }
      } else {
        return '$dayDiff days';
      }
    }

    if (secDiff < 60) {
      return 'just now';
    }

    if (secDiff < 120) {
      return '1 min';
    }
    // C.
    // Less than one hour ago.
    if (secDiff < 3600) {
      final min = (secDiff / 60).floor();
      return '$min mins';
    }
    // D.
    // Less than 2 hours ago.
    if (secDiff < 7200) {
      return '1 hr';
    }

    if (secDiff < 86400) {
      final hr = (secDiff / 3600).floor();
      return '$hr hrs';
    }

    return '';
  }

  String toFormattedString([String? pattern]) {
    return DateFormat(pattern, 'en').format(this);
  }

  int monthDifference(DateTime other) {
    return (month - other.month) + 12 * (year - other.year);
  }

  DateTime applyTime({int hour = 0, int minute = 0, int second = 0}) {
    return DateTime(year, month, day, hour, minute, second);
  }

  DateTime addMonth({int month = 1}) {
    final year = this.year + ((this.month + month) ~/ 12);
    var monthVal = (this.month + month) % 12;
    if (monthVal == 0) monthVal = 12;
    var day = this.day;

    // Adjust day if the result is an invalid date, e.g., adding a month to January 31st
    if (day > 28) {
      day = min(day, DateTime(year, monthVal + month, 0).day);
    }

    return DateTime(year, monthVal, day, hour, minute, second, millisecond, microsecond);
  }

  DateTime subtractMonth({int month = 1}) {
    final year = this.month == 1 ? this.year - 1 : this.year + ((this.month - month) ~/ 12);
    var monthVal = (this.month - month) % 12;
    if (monthVal == 0) monthVal = 12;
    var day = this.day;

    // Adjust day if the result is an invalid date, e.g., adding a month to January 31st
    if (day > 28) {
      day = min(day, DateTime(year, monthVal - month, 0).day);
    }

    return DateTime(year, monthVal, day, hour, minute, second, millisecond, microsecond);
  }

  DateTime utcToLocalDateTime() {
    final date = DateTime.parse('${toIso8601String()}Z');
    return date.toLocal();
  }

  String utcToLocalDateTimeFormat([String? pattern]) {
    final date = utcToLocalDateTime();
    return date.toFormattedString(pattern);
  }
}

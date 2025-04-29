// MIT License
//
// Copyright (c) 2025 Vasyl Mayovets
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import 'dart:math';
import 'package:intl/intl.dart';

extension DatetimeExtensions on DateTime {
  /// Trim Hours & Minutes from date
  DateTime get dateOnly {
    return DateTime.parse(DateFormat('yyyy-MM-dd').format(this));
  }

  String get asString {
    return this.toString();
  }

  /// Get Date without Hour & Minutes
  String get dateOnlyAsString {
    return DateFormat("yyyy-MM-dd").format(this);
  }

  /// Get Day only without Hour & Minutes
  String get dayOnlyAsString {
    return DateFormat("d MMM").format(this);
  }

  /// EU format
  String get dateOnlyAsEuString {
    return DateFormat("dd-MM-yyyy").format(this);
  }

  /// EU format
  String get dayOnlyAsEuString {
    return DateFormat("d MMM").format(this);
  }

  /// Get Hours & Minutes from date
  String get timeOnlyAsString {
    String time = DateFormat("HH:mm").format(this);
    return time != "00:00" ? time : 'Anytime';
  }

  /// Date only as timestamp
  int get dateOnlyAsTimestamp {
    return DateTime.parse(DateFormat('yyyy-MM-dd').format(this)).millisecondsSinceEpoch;
  }

  /// Trim Hours & Minutes from date
  String get dateTimeOnlyAsString {
    return '${this.year}-${this.month}-${this.day} ${this.hour}:${this.minute}';
  }

  /// Check if date hour and minutes is not equeals to midnight
  bool get isMidnight {
    return (this.hour == 0 && this.minute == 0 && this.second == 0);
  }

  /// Start and end of day
  DateTime get startOfDay => DateTime(this.year, this.month, this.day, 0, 0, 0);
  DateTime get endOfDay => DateTime(this.year, this.month, this.day, 23, 59, 59);

  /// Days left
  int get daysLeft {
    final DateTime first = this;
    final DateTime now = DateTime.now();
    return first.difference(now).inDays;
  }

  /// Days ago from this date
  String get timeAgo {
    final DateTime date2 = DateTime.now();
    final Duration difference = date2.difference(this);

    return switch (difference) {
      Duration(inDays: 0) => 'today',
      Duration(inDays: 1) => 'tomorrow',
      Duration(inDays: -1) => 'yesterday',
      Duration(inDays: final days) when days > 7 => '${days ~/ 7} weeks from now',
      Duration(inDays: final days) when days < -7 => '${days.abs() ~/ 7} weeks ago',
      Duration(inDays: final days, isNegative: true) => '${days.abs()} days ago',
      Duration(inDays: final days) => '$days days ago',
    };

    // if (difference.inDays >= 1) {
    //   return '${difference.inDays} days ago';
    // } else if (difference.inHours >= 1) {
    //   return '${difference.inHours} hours ago';
    // } else if (difference.inMinutes >= 1) {
    //   return '${difference.inMinutes} minutes ago';
    // } else if (difference.inSeconds >= 1) {
    //   return '${difference.inSeconds} seconds ago';
    // } else {
    //   return 'just now';
    // }
  }

  /// Return true if the date is today
  bool get isToday {
    final DateTime now = DateTime.now();
    return now.day == day && now.month == month && now.year == year;
  }

  /// Return true if the date is tomorrow
  bool get isTomorrow {
    final DateTime tomorrow = DateTime.now().add(const Duration(days: 1));
    return tomorrow.day == day && tomorrow.month == month && tomorrow.year == year;
  }

  /// Return true if the date is yesterday
  bool get isYesterday {
    final DateTime yesterday = DateTime.now().subtract(const Duration(days: 1));
    return yesterday.day == day && yesterday.month == month && yesterday.year == year;
  }

  /// return true if the dates is the same
  bool isSameDate(DateTime other) {
    return this.year == other.year && this.month == other.month && this.day == other.day;
  }

  /// Check if time setted
  bool get hasTime {
    return this.hour != 0;
  }

  DateTime intervalCorrection(int interval) {
    final int correctedMinute = ((this.minute + interval / 2) ~/ interval) * interval;
    return DateTime(this.year, this.month, this.day, this.hour, correctedMinute);
  }

  /// Get number of week
  int get weekOfMonth {
    final DateTime date = this;
    final DateTime firstDayOfTheMonth = DateTime(date.year, date.month, 1);
    final int sum = firstDayOfTheMonth.weekday - 1 + date.day;

    if (sum % 7 == 0) {
      return sum ~/ 7;
    } else {
      return sum ~/ 7 + 1;
    }
  }

  /// Update Date
  DateTime? update(String key, int value) {
    switch (key) {
      case "minute":
        return DateTime(this.year, this.month, this.day, this.hour, value);
      case "hour":
        return DateTime(this.year, this.month, this.day, value, this.minute);
      case "day":
        return DateTime(this.year, this.month, value, this.hour, this.minute);
      case "month":
        return DateTime(this.year, value, this.day, this.hour, this.minute);
      case "year":
        return DateTime(value, this.month, this.day, this.hour, this.minute);
      default:
        return null;
    }
  }

  /// Update AM PM
  // 12 AM	00
  // 01 AM	01
  // 02 AM	02
  // 03 AM	03
  // 04 AM	04
  // 05 AM	05
  // 06 AM	06
  // 07 AM	07
  // 08 AM	08
  // 09 AM	09
  // 10 AM	10
  // 11 AM	11
  // 12 PM	12
  // 01 PM	13
  // 02 PM	14
  // 03 PM	15
  // 04 PM	16
  // 05 PM	17
  // 06 PM	18
  // 07 PM	19
  // 08 PM	20
  // 09 PM	21
  // 10 PM	22
  // 11 PM	23
  /// Update Date
  DateTime? updateWithApPm(int? value, String period) {
    int hour = value ?? 0;

    if (period == 'PM' && hour != 12) hour += 12;
    if (period == 'AM' && hour == 12) hour = 0;

    return DateTime(this.year, this.month, this.day, hour, this.minute);
  }

  DateTime addOrRemoveYears(int years) {
    return DateTime(year + years, month, day, minute, second);
  }

  /// to add month to a [DateTime] add a positive number
  /// to remove years pass a negative number
  DateTime addOrRemoveMonth(int months) {
    return DateTime(year, month + months, day, minute, second);
  }

  /// to add days to a [DateTime] add a positive number
  /// to remove days pass a negative number
  DateTime addDays(int days) {
    return this.add(Duration(days: days));
  }

  DateTime backDays(int days) {
    return this.add(Duration(days: -days));
  }

  /// to add min to a [DateTime] add a positive number
  /// to remove min pass a negative number
  DateTime addOrRemoveMinutes(int minutes) {
    return this.add(Duration(minutes: minutes));
  }

  /// to add sec to a [DateTime] add a positive number
  /// to remove sec pass a negative number
  DateTime addOrRemoveSeconds(int seconds) {
    return this.add(Duration(seconds: seconds));
  }

  ///  Start time of Date times
  DateTime startOfMonth() => DateTime(year, month);

  DateTime startOfYear() => DateTime(year);

  DateTime get getFirstDayOfMonth {
    return DateTime(this.year, this.month, 1);
  }

  DateTime get getLastDayOfMonth {
    final DateTime firstDayNextMonth = DateTime(this.year, this.month + 1, 1);
    final DateTime lastDayOfMonth =
        DateTime(firstDayNextMonth.year, firstDayNextMonth.month, 0);

    return lastDayOfMonth;
  }

  /// DateTime `+` operator
  DateTime operator +(DateTime time) => add(Duration(
      days: time.day,
      hours: time.hour,
      minutes: time.minute,
      seconds: time.second,
      milliseconds: time.millisecond));

  /// DateTime `-` operator
  DateTime operator -(DateTime time) => subtract(Duration(
      days: time.day,
      hours: time.hour,
      minutes: time.minute,
      seconds: time.second,
      milliseconds: time.millisecond));

  /// Next day
  DateTime tomorrow() => DateTime(year, month, day + 1);

  /// Last day
  DateTime yesterday() => DateTime(year, month, day - 1);

  /// Midnight time
  DateTime midnight() => DateTime(year, month, day);

  /// First date of current month
  DateTime get firstMonthDate => DateTime(DateTime.now().year, DateTime.now().month, 1);

  /// Last date of current month
  DateTime get lastMonthDate =>
      DateTime(DateTime.now().year, DateTime.now().month + 1, 1).subtract(Duration(days: 1));

  /// First week day date
  DateTime get firstWeekDate => DateTime.parse(
      DateFormat('yyyy-MM-dd').format(this.subtract(Duration(days: this.weekday - 1))));

  /// Last week day date
  DateTime get lastWeekDate => DateTime.parse(DateFormat('yyyy-MM-dd')
      .format(this.subtract(Duration(days: DateTime.daysPerWeek - this.weekday))));

  /// return the smaller date between
  DateTime min(DateTime that) =>
      (millisecondsSinceEpoch < that.millisecondsSinceEpoch) ? this : that;

  DateTime max(DateTime that) =>
      (millisecondsSinceEpoch > that.millisecondsSinceEpoch) ? this : that;

  bool get isLeapYear => (year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0));

  DateTime scTime(int hour, int minute) {
    return DateTime(this.year, this.month, this.day, hour, minute);
  }

  String get getTimeOnly {
    DateTime ft = DateTime.parse(DateFormat('yyyy-MM-dd HH:mm').format(this));
    return "${ft.hour}:${ft.minute}";
  }

  String format(String pattern) {
    switch (pattern) {
      case "MMMMEEEEdjm":
        return DateFormat.MMMMEEEEd().format(this);
      default:
        return "";
    }
  }

  bool get isPast {
    return this.isBefore(DateHelper.now);
  }
}

class DateHelper {
  static List<String> get monthsOrder =>
      ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

  /// Get current timestamp
  static DateTime get now => DateTime.now();

  static DateTime get today => DateTime(now.year, now.month, now.day);
  static String get todayAsIso8601 => DateTime(now.year, now.month, now.day).toIso8601String();

  static DateTime get tomorrow => DateTime(now.year, now.month, now.day + 1);

  static DateTime get currentTime =>
      DateTime(now.year, now.month, now.day, now.hour, now.minute);

  static DateTime get wakeUpInitValue => DateTime(now.year, now.month, now.day, 8, 0);
  static DateTime get goSleepInitValue => DateTime(now.year, now.month, now.day, 20, 0);

  static DateTime get firstMinuteForToday => DateTime(now.year, now.month, now.day, 0, 0);
  static DateTime get lastMinuteForToday => DateTime(now.year, now.month, now.day, 23, 59);

  static DateTime firstMinuteFromDate(DateTime date) =>
      DateTime(date.year, date.month, date.day, 0, 0);
  static DateTime lastMinuteFromDate(DateTime date) =>
      DateTime(date.year, date.month, date.day, 23, 59);

  static DateTime get firstDayOfYear => DateTime(now.year, 1, 1, 0, 0);
  static DateTime get lastDayOfYear => DateTime(now.year + 1, 1, -1, 0, 0, 0);

  static DateTime get firstMonthDay => DateTime(now.year, now.month, 1, 0, 0);

  static DateTime dateByWeekday(DateTime now, [int startDay = 1]) {
    return now.subtract(Duration(days: now.weekday - startDay));
  }

  static int countDaysBetween(DateTime startDate, DateTime endDate) {
    return endDate.difference(startDate).inDays;
  }

  static DateTime get lastMonthDay =>
      now.month < 12 ? DateTime(now.year, now.month + 1, 0) : DateTime(now.year + 1, 1, 0);

  /// Current week day
  static String get weekDay => now.weekday.toString();

  /// Get days by month
  static List<T> getDaysInMonth<T>(int year, int month) {
    const List<int> allMonthDays = <int>[31, -1, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    late final int daysInMonth;

    if (month == DateTime.february) {
      final bool isLeapYear = (year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0);
      daysInMonth = isLeapYear ? 29 : 28;
    } else {
      daysInMonth = allMonthDays[month - 1];
    }

    return List<T>.generate(daysInMonth, (index) {
      if (T == DateTime) {
        return DateTime(year, month, index + 1) as T;
      } else {
        return (index + 1) as T;
      }
    });
  }

  static String formatDuration(String duration) {
    // Convert milliseconds to total seconds
    int totalSeconds = (double.parse(duration) / 1000).round();

    // Handle less than 60 seconds case
    if (totalSeconds < 60) {
      return '$totalSeconds Sec';
    }

    // Calculate hours and minutes
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;

    // Build the formatted duration string
    String formattedDuration = '';
    if (hours > 0) {
      formattedDuration += '$hours Hrs ';
    }

    if (minutes > 0 || hours == 0) {
      formattedDuration += '$minutes Min';
    }

    return formattedDuration.trim();
  }

  /// Get weekends count
  static int weekendsCount(int year, int month) {
    int count = 0;
    // Number of days in the month
    int daysInMonth = DateTime(year, month + 1, 0).day;

    for (int i = 1; i <= daysInMonth; i++) {
      DateTime day = DateTime(year, month, i);
      // Check if the day is a Saturday (6) or Sunday (7)
      if (day.weekday == DateTime.saturday || day.weekday == DateTime.sunday) {
        count++;
      }
    }

    return count;
  }

  /// Generate randome time from 8AM to 18PM
  static (int hour, int minute) getRandomTime({int? dayStart, int? dayEnd}) {
    final Random random = Random();
    final int hour = (dayStart ?? 8) + random.nextInt(dayEnd ?? 11);
    final int minute = random.nextInt(60);

    return (hour, minute);
  }

  /// Get number of week
  static int get weekOfMonth {
    final DateTime date = DateTime.now();
    final DateTime firstDayOfTheMonth = DateTime(date.year, date.month, 1);
    final int sum = firstDayOfTheMonth.weekday - 1 + date.day;

    if (sum % 7 == 0) {
      return sum ~/ 7;
    } else {
      return sum ~/ 7 + 1;
    }
  }

  // Tomorrow morning
  static DateTime get tomorrowMorning {
    final DateTime now = DateTime.now();
    return DateTime(now.year, now.month, now.day + 1, 0, 0, 0);
  }

  /// Get Greating Time Period
  static String getDayTime(DateTime? dateTime, String defaultValue) {
    if (dateTime != null) {
      final double time = dateTime.hour + dateTime.minute / 60.0;
      final String period = switch (time) {
        (>= 4 && <= 11.59) => 'morning',
        (>= 12.0 && <= 16.59) => 'afternoon',
        (>= 17.0 && < 23.59) => 'evening',
        _ => 'night',
      };

      return period;
    }

    return defaultValue;
  }

  /// Day of year
  static int get todayInDays => now.difference(DateTime(now.year, 1, 1, 0, 0)).inDays;

  /// Yesterday
  static DateTime get yesterdayMorning => DateTime(now.year, now.month, now.day - 1, 0, 0, 1);
  static DateTime get yesterdayMidnight => DateTime(now.year, now.month, now.day - 1, 23, 59);

  static int get yesterdayMorningAsTimestamp =>
      DateTime(now.year, now.month, now.day, 0, 0).millisecondsSinceEpoch;
  static int get yesterdayMidnightAsTimestamp =>
      DateTime(now.year, now.month, now.day, 23, 59).millisecondsSinceEpoch;

  /// Merge to dates
  static DateTime mergeDateTime({required DateTime date, required DateTime time}) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  /// Universal date transformer
  static DateTime? toDate(dynamic date) {
    if (date == null) {
      return null;
    } else if (date is DateTime) {
      return date;
    } else if (date is String) {
      return DateTime.parse(date);
    } else if (date is int) {
      final int length = date.toString().length;

      return (length == 13)
          ? DateTime.fromMillisecondsSinceEpoch(date)
          : DateTime.fromMicrosecondsSinceEpoch(date);
    } else {
      return date.toDate();
    }
  }

  static DateTime? compose({required dynamic date, required dynamic time, String? offset}) {
    DateTime? dateAt = toDate(date);
    DateTime? timeAt = toDate(time);
    DateTime? dateTime;

    if (dateAt != null && timeAt != null && !timeAt.isMidnight) {
      dateTime = DateTime(dateAt.year, dateAt.month, dateAt.day, timeAt.hour, timeAt.minute);
    } else if (dateAt == null && timeAt != null) {
      dateTime = timeAt;
    } else {
      dateTime = dateAt;
    }

    return offset == null ? dateTime : dateTime?.add(Duration(minutes: int.parse(offset)));
  }

  static Map<int, Map<String, Map<String, String>>> get dayHours => {
        0: {
          '24': {'title': '00'},
          '12': {'title': '12', 'period': 'AM'}
        },
        1: {
          '24': {'title': '01'},
          '12': {'title': '01', 'period': 'AM'}
        },
        2: {
          '24': {'title': '02'},
          '12': {'title': '02', 'period': 'AM'}
        },
        3: {
          '24': {'title': '03'},
          '12': {'title': '03', 'period': 'AM'}
        },
        4: {
          '24': {'title': '04'},
          '12': {'title': '04', 'period': 'AM'}
        },
        5: {
          '24': {'title': '05'},
          '12': {'title': '05', 'period': 'AM'}
        },
        6: {
          '24': {'title': '06'},
          '12': {'title': '06', 'period': 'AM'}
        },
        7: {
          '24': {'title': '07'},
          '12': {'title': '07', 'period': 'AM'}
        },
        8: {
          '24': {'title': '08'},
          '12': {'title': '08', 'period': 'AM'}
        },
        9: {
          '24': {'title': '09'},
          '12': {'title': '09', 'period': 'AM'}
        },
        10: {
          '24': {'title': '10'},
          '12': {'title': '10', 'period': 'AM'}
        },
        11: {
          '24': {'title': '11'},
          '12': {'title': '11', 'period': 'AM'}
        },
        12: {
          '24': {'title': '12'},
          '12': {'title': '12', 'period': 'PM'}
        },
        13: {
          '24': {'title': '13'},
          '12': {'title': '01', 'period': 'PM'}
        },
        14: {
          '24': {'title': '14'},
          '12': {'title': '02', 'period': 'PM'}
        },
        15: {
          '24': {'title': '15'},
          '12': {'title': '03', 'period': 'PM'}
        },
        16: {
          '24': {'title': '16'},
          '12': {'title': '04', 'period': 'PM'}
        },
        17: {
          '24': {'title': '17'},
          '12': {'title': '05', 'period': 'PM'}
        },
        18: {
          '24': {'title': '18'},
          '12': {'title': '06', 'period': 'PM'}
        },
        19: {
          '24': {'title': '19'},
          '12': {'title': '07', 'period': 'PM'}
        },
        20: {
          '24': {'title': '20'},
          '12': {'title': '08', 'period': 'PM'}
        },
        21: {
          '24': {'title': '21'},
          '12': {'title': '09', 'period': 'PM'}
        },
        22: {
          '24': {'title': '22'},
          '12': {'title': '10', 'period': 'PM'}
        },
        23: {
          '24': {'title': '23'},
          '12': {'title': '11', 'period': 'PM'}
        },
      };
}

// const int _kThousand = 1000;
// const int _kMillion = 1000000;
// const int _kBillion = 1000000000;
//
// void _check(bool expr, String name, int value) {
//   if (!expr) {
//     throw ArgumentError('Timestamp $name out of range: $value');
//   }
// }

// class Timestamp implements Comparable<Timestamp> {
//   /// Creates a [Timestamp]
//   Timestamp(this._seconds, this._nanoseconds) {
//     _validateRange(_seconds, _nanoseconds);
//   }
//
//   /// Create a [Timestamp] fromMillisecondsSinceEpoch
//   factory Timestamp.fromMillisecondsSinceEpoch(int milliseconds) {
//     int seconds = (milliseconds / _kThousand).floor();
//     final int nanoseconds = (milliseconds - seconds * _kThousand) * _kMillion;
//     return Timestamp(seconds, nanoseconds);
//   }
//
//   /// Create a [Timestamp] fromMicrosecondsSinceEpoch
//   factory Timestamp.fromMicrosecondsSinceEpoch(int microseconds) {
//     final int seconds = microseconds ~/ _kMillion;
//     final int nanoseconds = (microseconds - seconds * _kMillion) * _kThousand;
//     return Timestamp(seconds, nanoseconds);
//   }
//
//   /// Create a [Timestamp] from [DateTime] instance
//   factory Timestamp.fromDate(DateTime date) {
//     return Timestamp.fromMicrosecondsSinceEpoch(date.microsecondsSinceEpoch);
//   }
//
//   /// Create a [Timestamp] from [DateTime].now()
//   factory Timestamp.now() {
//     return Timestamp.fromMicrosecondsSinceEpoch(
//       DateTime.now().microsecondsSinceEpoch,
//     );
//   }
//
//   final int _seconds;
//   final int _nanoseconds;
//
//   static const int _kStartOfTime = -62135596800;
//   static const int _kEndOfTime = 253402300800;
//
//   // ignore: public_member_api_docs
//   int get seconds => _seconds;
//
//   // ignore: public_member_api_docs
//   int get nanoseconds => _nanoseconds;
//
//   // ignore: public_member_api_docs
//   int get millisecondsSinceEpoch => seconds * _kThousand + nanoseconds ~/ _kMillion;
//
//   // ignore: public_member_api_docs
//   int get microsecondsSinceEpoch => seconds * _kMillion + nanoseconds ~/ _kThousand;
//
//   /// Converts [Timestamp] to [DateTime]
//   DateTime toDate() {
//     return DateTime.fromMicrosecondsSinceEpoch(microsecondsSinceEpoch);
//   }
//
//   @override
//   int get hashCode => Object.hash(seconds, nanoseconds);
//
//   @override
//   bool operator ==(Object other) =>
//       other is Timestamp && other.seconds == seconds && other.nanoseconds == nanoseconds;
//
//   @override
//   int compareTo(Timestamp other) {
//     if (seconds == other.seconds) {
//       return nanoseconds.compareTo(other.nanoseconds);
//     }
//
//     return seconds.compareTo(other.seconds);
//   }
//
//   @override
//   String toString() {
//     return 'Timestamp(seconds=$seconds, nanoseconds=$nanoseconds)';
//   }
//
//   static void _validateRange(int seconds, int nanoseconds) {
//     _check(nanoseconds >= 0, 'nanoseconds', nanoseconds);
//     _check(nanoseconds < _kBillion, 'nanoseconds', nanoseconds);
//     _check(seconds >= _kStartOfTime, 'seconds', seconds);
//     _check(seconds < _kEndOfTime, 'seconds', seconds);
//   }
// }

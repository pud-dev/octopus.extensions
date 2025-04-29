// Copyright 2022 by Mayovets Vasyl (OKTOPUS RESERCH LLC). All rights reserved.
// Use of this source code is governed by a license that can be
// found in the OCTOPOOS LICENSE file.

import 'package:intl/intl.dart';

extension DoubleExtensions on double {
  String get compactOrOrigin {
    return this % 1 == 0
        ? toInt().toString()
        : toStringAsFixed(2).replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '');
  }
}

extension IntExtensions on int {
  /// Clamps the current integer to be within the range of [min] and [max].
  ///
  /// The [min] parameter specifies the minimum value of the range.
  /// The [max] parameter specifies the maximum value of the range.
  ///
  /// Throws an [ArgumentError] if [min] is greater than [max].
  ///
  /// Returns the current integer if it is within the range. If the current integer is
  /// less than [min], returns [min]. If the current integer is greater than [max], returns [max].
  ///
  /// Example:
  /// ```dart
  /// int value = 5;
  /// int clampedValue = value.inRangeOf(1, 10);
  /// print(clampedValue); // Output: 5
  ///
  /// int clampedValueBelowMin = value.inRangeOf(6, 10);
  /// print(clampedValueBelowMin); // Output: 6
  ///
  /// int clampedValueAboveMax = value.inRangeOf(1, 4);
  /// print(clampedValueAboveMax); // Output: 4
  /// ```
  int inRangeOf(int min, int max) {
    if (min > max) throw ArgumentError('min must be smaller the max');

    if (this < min) return min;
    if (this > max) return max;
    return this;
  }

  /// Applies a discount to the current integer value and returns the discounted amount.
  ///
  /// The [discount] parameter is a nullable double representing the discount percentage (e.g., 0.2 for 20%).
  ///
  /// If [discount] is null or less than or equal to 0, the original value is returned.
  ///
  /// Returns an integer representing the value after applying the discount.
  ///
  /// Example:
  /// ```dart
  /// int price = 100;
  /// double discount = 0.2; // 20% discount
  /// int discountedPrice = price.withDiscount(discount);
  /// print(discountedPrice); // Output: 80
  ///
  /// int noDiscountPrice = price.withDiscount(null);
  /// print(noDiscountPrice); // Output: 100
  /// ```
  int withDiscount(double? discount) {
    if (discount != null && discount > 0) {
      return (this - (this * discount)).toInt();
    }

    return this;
  }

  /// Converts an integer value representing minutes to a formatted string pattern.
  ///
  /// The [this] parameter is the total number of minutes to be converted.
  ///
  /// Returns a string representation of the time in the format "Xh Ym", "Ym", or "Xh".
  ///
  /// Example:
  /// ```dart
  /// int minutes = 160;
  /// String time = minutes.convertMinutesToPattern;
  /// print(time); // Output: "2h 40m"
  ///
  /// int minutesOnly = 45;
  /// String timeOnlyMinutes = minutesOnly.convertMinutesToPattern;
  /// print(timeOnlyMinutes); // Output: "45m"
  ///
  /// int hoursOnly = 120;
  /// String timeOnlyHours = hoursOnly.convertMinutesToPattern;
  /// print(timeOnlyHours); // Output: "2h"
  /// ```
  String get convertMinutesToPattern {
    int hours = this ~/ 60; // Get the whole number of hours
    int minutes = this % 60; // Get the remaining minutes

    String? fmtTime;

    if (hours > 0 && minutes > 0) {
      fmtTime = '${hours} Hours ${minutes} Minutes';
    } else if (hours == 0 && minutes > 0) {
      fmtTime = '${minutes} Minutes';
    } else if (hours > 0 && minutes == 0) {
      fmtTime = '${hours} Hours';
    }

    return fmtTime ?? '';
  }

  /// Generates a list of integers from the current integer to [maxInclusive] with an optional [step].
  ///
  /// The [maxInclusive] parameter specifies the maximum value (inclusive) in the generated list.
  /// The [step] parameter specifies the increment between each integer in the list. The default value is 1.
  ///
  /// Returns a list of integers starting from the current integer up to [maxInclusive], incremented by [step].
  ///
  /// Example:
  /// ```dart
  /// int start = 1;
  /// List<int> numbers = start.to(5);
  /// print(numbers); // Output: [1, 2, 3, 4, 5]
  ///
  /// List<int> numbersWithStep = start.to(10, step: 2);
  /// print(numbersWithStep); // Output: [1, 3, 5, 7, 9]
  /// ```
  List<int> to(int maxInclusive, {int step = 1}) =>
      [for (int i = this; i <= maxInclusive; i += step) i];

  /// This getter provides a human-readable string representation of a number.
  ///
  /// Example:
  ///
  /// ```dart
  /// int number = 1000000;
  /// print(number.humanize);  // Output: 1M
  /// ```
  ///
  /// It uses the `NumberFormat.compact()` method to format the number in a compact way,
  /// such as using abbreviations like "K" for thousands or "M" for millions.
  ///
  /// Note: Make sure to import the necessary dependencies (e.g., `import 'package:intl/intl.dart';`) where you want to use this getter.
  String get humanize {
    String formatedNumber = NumberFormat.compact().format(this);
    return formatedNumber;
  }

  /// This extension provides a method `get humanNum` to get the ordinal form of an integer.
  ///
  /// Example:
  ///
  /// ```dart
  /// int num = 5;
  /// print(num.humanNum);  // Output: Fifth
  /// ```
  ///
  /// It works for numbers from 1 to 10. For any number outside this range, the method will simply return the original number.
  ///
  /// Note: Make sure to import this extension where you want to use it.
  ///
  String get humanNum {
    Map nums = {
      1: "	First",
      2: "	Second",
      3: "	Third",
      4: "	Fourth",
      5: "	Fifth",
      6: "	Sixth",
      7: "	Seventh",
      8: "	Eighth",
      9: "	Ninth",
      10: "	Tenth",
    };

    return '${nums[this] ?? this}';
  }

  /// Returns the absolute value
  get absolute => abs();

  /// Returns number of digits in this number
  int get numberOfDigits => toString().length;

  /// Returns if the number is even
  bool get isEven => this % 2 == 0;

  /// Returns if the number is odd
  bool get isOdd => this % 2 != 0;

  /// Returns if the number is positive
  bool get isPositive => this > 0;

  /// Returns if the number is negative
  bool get isNegative => this < 0;

  /// Returns tenth of the number
  double get tenth => this / 10;

  /// Returns fourth of the number
  double get fourth => this / 4;

  /// Returns third of the number
  double get third => this / 3;

  /// Returns half of the number
  double get half => this / 2;

  /// Return this number time two
  int get doubled => this * 2;

  /// Return this number time three
  int get tripled => this * 3;

  /// Return this number time four
  int get quadrupled => this * 4;

  /// Return squared number
  int get squared => this * this;

  /// Convert this integer into boolean.
  ///
  /// Returns `true` if this integer is greater than *0*.
  bool get asBool => this > 0;
}

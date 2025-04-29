// Copyright 2022 by Mayovets Vasyl (OKTOPUS RESERCH LLC). All rights reserved.
// Use of this source code is governed by a license that can be
// found in the OCTOPOOS LICENSE file.

import 'dart:math';

extension StringExtensions on String {
  /// Get first N words
  String wordLimit(int wordCount) {
    List<String> sentence = this.split(" ");
    List<String> cropped = [];

    if (sentence.length > wordCount) {
      cropped.addAll(sentence.take(wordCount));
      cropped.add('...');

      return cropped.join(" ");
    }

    return this;
  }

  /// Get first Slice before space
  String get getFirstSlice {
    List<String> slice = this.split(' ');
    return slice[0];
  }

  /// Extension to get boolean value from String
  bool parseBool() => this.toLowerCase() == 'true';

  /// Strip all tasks from String
  String get stripTags {
    return this.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ');
  }

  /// Get list of keywords from sentence
  List<String> get keywordsOnly {
    String clean = this.replaceAll(RegExp(r'[^a-zA-Z0-9\s]'), '');
    List<String> query = clean.split(" ");

    return query;
  }

  /// Ensure mi lenght and generate rand chars
  String ensureMinLength({int minLength = 8}) {
    const String characters = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final Random rand = Random();
    String input = this;

    while (input.length < minLength) {
      final randomChar = characters[rand.nextInt(characters.length)];
      input += randomChar;
    }

    return input;
  }

  /// Extension to validate minimum password lenght
  /// To use: 'vasyl mayovets'.isValidName;
  bool get isValidatePassword {
    return this.toString().length >= 6;
  }

  /// Extension to validate Email
  /// To use: 'my@email.com'.isValidEmail;
  bool get isValidEmail {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }

  /// Is valid URL
  bool get isValidURL {
    return RegExp(r"^(?:http|https):\/\/[\w\-_]+(?:\.[\w\-_]+)+[\w\-.,@?^=%&:/~\\+#]*$")
        .hasMatch(this);
  }

  /// Extension to validate YouTube video URL
  bool get isValidYouTubeVideo {
    return RegExp(
            r'^(?:https?:\/\/)?(?:www\.)?(?:youtu\.be\/|youtube\.com\/(?:embed\/|v\/|watch\?v=|watch\?.+&v=))((\w|-){11})(?:\S+)?$')
        .hasMatch(this);
  }

  /// Extension to validate Name
  /// To use: 'vasyl mayovets'.isValidName;
  bool get isValidQr {
    return this.contains(RegExp(r'@OctopusGoals', caseSensitive: true));
  }

  /// Extension to validate Name
  /// To use: 'vasyl mayovets'.isValidName;
  bool get isValidName {
    return RegExp(r"^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$").hasMatch(this);
  }

  /// Extension to validate Phone number
  /// To use: '0980001000'.isValidPhone;
  bool get isValidPhone {
    // r"^\D?(\d{3})\D?\D?(\d{3})\D?(\d{4})$"
    return RegExp(r"^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$").hasMatch(this);
  }

  /// Trim Octopoos tag from string
  String get trimByTag {
    return this.replaceAll('@OctopoosGoals', '');
  }

  ///  Replace part of string after the first occurrence of given delimiter with the [replacement] string.
  ///  If the string does not contain the delimiter, returns [defaultValue] which defaults to the original string.
  String replaceAfter(String delimiter, String replacement, [String defaultValue = '']) {
    final index = indexOf(delimiter);
    return (index == -1)
        ? defaultValue.isEmpty
            ? this
            : defaultValue
        : replaceRange(index + 1, length, replacement);
  }

  /// Get only digits from toString()
  /// usefull for formated phone extract
  int get onlyDigits {
    final intValue = int.parse(this.replaceAll(RegExp('[^0-9]'), ''));
    return intValue;
  }

  /// Get only digits from toString()
  /// usefull for formated phone extract
  int get toShortPhoneFormat {
    final intValue = int.parse(this.replaceAll(RegExp('[^0-9]'), ''));
    return intValue;
  }

  /// Convert to translite
  String get translite => TranslitHelper.transliterate(source: this);

  ///  Replace part of string after the first occurrence of given delimiter with the [replacement] string.
  ///  If the string does not contain the delimiter, returns [defaultValue] which defaults to the original string.
  String makeID({withTimestamp = false}) {
    String resultID;
    DateTime now = DateTime.now();
    int timestamp = now.millisecondsSinceEpoch;
    String myID = this.isNotEmpty ? this : 'User';
    List<String> charArray = myID.toCharArray();

    charArray[0] == '@' ? resultID = myID : resultID = '@$myID';

    return withTimestamp == true
        ? TranslitHelper.transliterate(source: '$resultID-$timestamp').toLowerCase()
        : TranslitHelper.transliterate(source: resultID).toLowerCase();
  }

  /// Check Octopoos referral ID
  String get checkID {
    List<String> charArray = this.toCharArray();
    return charArray[0] == '@' ? this : '@$this';
  }

  /// Split string by char lenght
  List<String> splitByLength(int length) {
    return [substring(0, length), substring(length)];
  }

  /// Check if specials contains
  bool get hasSpecialChars {
    return RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%$£]').hasMatch(this);
  }

  /// Strip all Emoji from String
  String get stripEmoji {
    final RegExp emojis = RegExp(
        r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])');
    if (this.contains(emojis)) {
      return this.replaceAll(emojis, '');
    }

    return this;
  }

  /// Convert to code style
  String get toCodeStyle {
    List<String> list = this.splitByLength(3);
    final sb = StringBuffer();
    sb.writeAll(list, '-');

    return sb.toString();
  }

  /// Remove first char [@] from String
  String trimFirst({String? char}) {
    List<String> charArray = this.toCharArray();

    if (char != null && char.isNotEmpty && charArray[0] == char) {
      charArray.removeAt(0);
    }

    return charArray.join();
  }

  /// Remove first char from string list
  int get trimOct {
    List<String> charArray = this.split(' ');
    return int.parse(charArray.first);
  }

  /// Get title tentacle (First two words)
  String get getTentacle {
    List<String> wordArray = this.split('.');
    if (wordArray.first.split(' ').length == 2) {
      return wordArray.first;
    }

    return '';
  }

  /// Get First Letters
  String getFirstLetters(int limitTo) {
    var buffer = StringBuffer();
    List<String> splitted = this.split(' ');

    if (splitted.isNotEmpty && splitted.length >= 2) {
      for (var i = 0; i < (limitTo); i++) {
        buffer.write(splitted[i][0]);
      }

      return buffer.toString();
    }

    return "AU";
  }

  /// Get first letter from word
  String get getFirstLetter {
    return this.isNotEmpty ? this[0].toUpperCase() : '';
  }

  /// Get First Word
  String get getFirst {
    List wordsList = this.split(' ');
    if (wordsList.isNotEmpty && wordsList.length >= 2) {
      return wordsList.first;
    } else {
      return ' ';
    }
  }

  ///
  /// Replace part of string before the first occurrence of given delimiter with the [replacement] string.
  ///  If the string does not contain the delimiter, returns [missingDelimiterValue] which defaults to the original string.
  String replaceBefore(String delimiter, String replacement, [String defaultValue = '']) {
    final index = indexOf(delimiter);
    return (index == -1)
        ? defaultValue.isEmpty
            ? this
            : defaultValue
        : replaceRange(0, index, replacement);
  }

  ///Returns `true` if at least one element matches the given [predicate].
  /// the [predicate] should have only one character
  bool anyChar(bool predicate(String element)) => split('').any((s) => predicate(s));

  /// Parses the string as an double or returns `null` if it is not a number.
  double? toDoubleOrNull() => double.tryParse(this);

  /// Parses the string as an int or returns `null` if it is not a number.
  int? toIntOrNull() => int.tryParse(this);

  /// Returns a String without white space at all
  /// "hello world" // helloworld
  String removeAllWhiteSpace() => replaceAll(RegExp(r"\s+\b|\b\s"), "");

  /// Returns true if s is neither null, empty nor is solely made of whitespace characters.
  bool get isNotBlank => trim().isNotEmpty;

  /// Returns a list of chars from a String
  List<String> toCharArray() => isNotBlank ? split('') : [];

  /// Returns a new string in which a specified string is inserted at a specified index position in this instance.
  String insert(int index, String str) =>
      (List<String>.from(this.toCharArray())..insert(index, str)).join();

  /// Indicates whether a specified string is `null`, `empty`, or consists only of `white-space` characters.
  bool get isNullOrWhiteSpace {
    var length = (this.split('')).where((x) => x == ' ').length;
    return length == (this.length) || this.isEmpty;
  }

  Map<String, String>? get parseEmailAndName {
    // Use a regular expression to capture the name and email parts
    final RegExp regExp = RegExp(r'^(.*?)(?:\s*<\s*([^>]+)\s*>)?$');
    final match = regExp.firstMatch(this.trim());

    if (match != null) {
      String? name = match.group(1)?.trim();
      String? email = match.group(2)?.trim();

      // If no name is provided and the input is a valid email, use the part before '@' as the name
      if (name == null || name.isEmpty) {
        // Directly validate the input as an email if no '<' and '>' are found
        final RegExp emailDirectRegExp = RegExp(r'^\S+@\S+\.\S+$');
        if (emailDirectRegExp.hasMatch(this.trim())) {
          email = this.trim();
          name = email.substring(0, email.indexOf('@'));
        }
      }

      // Check if the email is valid using a regular expression
      if (email != null && _isEmailValid(email)) {
        // Remove any leading or trailing whitespaces
        name = name?.replaceAll(RegExp(r'\s+$'), '');

        return {'fullName': name ?? '', 'email': email};
      }
    }

    return null;
  }

  bool _isEmailValid(String email) {
    // Simple regular expression for email validation
    final RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+$', // This is a simple regex for example purposes; for real-world scenarios, you may need a more comprehensive one.
      caseSensitive: false,
    );
    return emailRegExp.hasMatch(email);
  }

  /// Shrink a string to be no more than [maxSize] in length, extending from the end.
  /// For example, in a string with 10 charachters, a [maxSize] of 3 would return the last 3 charachters.
  String limitFromEnd(int maxSize) =>
      (this.length) < maxSize ? this : this.substring(this.length - maxSize);

  /// Shrink a string to be no more than [maxSize] in length, extending from the start.
  /// For example, in a string with 10 charachters, a [maxSize] of 3 would return the first 3 charachters.
  String limitFromStart(int maxSize) =>
      (this.length) < maxSize ? this : this.substring(0, maxSize);

// if the string is empty perform an action
  String ifEmpty(Function action) => isEmpty ? action() : this;

  /// Returns `true` if this string is empty or consists solely of whitespace
  /// characters.
  bool get isBlank => trimLeft().isEmpty;

  /// Returns `true` if the whole string is upper case.
  bool get isUpperCase => isNotEmpty && this == toUpperCase();

  /// Returns `true` if the whole string is lower case.
  bool get isLowerCase => isNotEmpty && this == toLowerCase();

  bool get isAscii {
    for (var codeUnit in codeUnits) {
      if (codeUnit > 0x007f) return false;
    }
    return true;
  }

  bool get isLatin1 {
    for (var codeUnit in codeUnits) {
      if (codeUnit > 0x00ff) return false;
    }

    return true;
  }

  bool get isInt => toIntOrNull() != null;

  String getOnly(int num) {
    List<String> fullNameList = this.split(" ");
    return fullNameList[num];
  }

  /// Parses the string as an [int] number and returns the result.
  int toInt() => int.parse(this);

  bool get isDouble => toDoubleOrNull() != null;

  /// Parses the string as a [double] number and returns the result.
  double toDouble() => double.parse(this);

  List<int> toUtf16() => codeUnits;

  String get camelCase => TextCase(this).camelCase;
  String get constantCase => TextCase(this).constantCase;
  String get sentenceCase => TextCase(this).sentenceCase;
  String get snakeCase => TextCase(this).snakeCase;
  String get dotCase => TextCase(this).dotCase;
  String get paramCase => TextCase(this).paramCase;
  String get pathCase => TextCase(this).pathCase;
  String get pascalCase => TextCase(this).pascalCase;
  String get headerCase => TextCase(this).headerCase;
  String get titleCase => TextCase(this).titleCase;
  String get upperCase => this.toUpperCase();
  String get lowerCase => this.toLowerCase();
}

/// Based on Recase
/// An instance of text to be re-cased.
/// Original code localed here - https://pub.dev/packages/recase
class TextCase {
  final RegExp _upperAlphaRegex = RegExp(r'[A-Z]');
  final symbolSet = {' ', '.', '/', '_', '\\', '-'};

  late String originalText;
  late List<String> _words;

  TextCase(String text) {
    this.originalText = text;
    this._words = _groupIntoWords(text);
  }

  List<String> _groupIntoWords(String text) {
    StringBuffer sb = StringBuffer();
    List<String> words = [];
    bool isAllCaps = text.toUpperCase() == text;

    for (int i = 0; i < text.length; i++) {
      String char = text[i];
      String? nextChar = i + 1 == text.length ? null : text[i + 1];

      if (symbolSet.contains(char)) {
        continue;
      }

      sb.write(char);

      bool isEndOfWord = nextChar == null ||
          (_upperAlphaRegex.hasMatch(nextChar) && !isAllCaps) ||
          symbolSet.contains(nextChar);

      if (isEndOfWord) {
        words.add(sb.toString());
        sb.clear();
      }
    }

    return words;
  }

  String get camelCase => _getCamelCase();
  String get constantCase => _getConstantCase();
  String get sentenceCase => _getSentenceCase();
  String get snakeCase => _getSnakeCase();
  String get dotCase => _getSnakeCase(separator: '.');
  String get paramCase => _getSnakeCase(separator: '-');
  String get pathCase => _getSnakeCase(separator: '/');
  String get pascalCase => _getPascalCase();
  String get headerCase => _getPascalCase(separator: '-');
  String get titleCase => _getPascalCase(separator: ' ');

  String _getCamelCase({String separator = ''}) {
    List<String> words = this._words.map(_upperCaseFirstLetter).toList();
    if (_words.isNotEmpty) {
      words[0] = words[0].toLowerCase();
    }

    return words.join(separator);
  }

  String _getConstantCase({String separator = '_'}) {
    List<String> words = this._words.map((word) => word.toUpperCase()).toList();

    return words.join(separator);
  }

  String _getPascalCase({String separator = ''}) {
    List<String> words = this._words.map(_upperCaseFirstLetter).toList();

    return words.join(separator);
  }

  String _getSentenceCase({String separator = ' '}) {
    List<String> words = this._words.map((word) => word.toLowerCase()).toList();
    if (_words.isNotEmpty) {
      words[0] = _upperCaseFirstLetter(words[0]);
    }

    return words.join(separator);
  }

  String _getSnakeCase({String separator = '_'}) {
    List<String> words = this._words.map((word) => word.toLowerCase()).toList();

    return words.join(separator);
  }

  String _upperCaseFirstLetter(String word) {
    return '${word.substring(0, 1).toUpperCase()}${word.substring(1).toLowerCase()}';
  }
}

class TranslitHelper {
  static final Map _symbols = {
    'А': 'A',
    'Б': 'B',
    'В': 'V',
    'Г': 'G',
    'Д': 'D',
    'Е': 'E',
    'З': 'Z',
    'И': 'I',
    'І': 'I',
    'Й': 'J',
    'К': 'K',
    'Л': 'L',
    'М': 'M',
    'Н': 'N',
    'О': 'O',
    'П': 'P',
    'Р': 'R',
    'С': 'S',
    'Т': 'T',
    'У': 'U',
    'Ф': 'F',
    'Х': 'H',
    'Ц': 'C',
    'Ы': 'Y',
    'а': 'a',
    'б': 'b',
    'в': 'v',
    'г': 'g',
    'д': 'd',
    'е': 'e',
    'з': 'z',
    'і': 'i',
    'и': 'i',
    'й': 'j',
    'к': 'k',
    'л': 'l',
    'м': 'm',
    'н': 'n',
    'о': 'o',
    'п': 'p',
    'р': 'r',
    'с': 's',
    'т': 't',
    'у': 'u',
    'ф': 'f',
    'х': 'h',
    'ц': 'c',
    'ы': 'y',
    "'": '',
    '"': '',
  };

  static final Map _compSymbols = {
    'Ё': 'Yo',
    'Ж': 'Zh',
    'Щ': 'Shhch',
    'Ш': 'Shh',
    'Ч': 'Ch',
    'Э': 'Eh\'',
    'Ю': 'Yu',
    'Я': 'Ya',
    'ё': 'yo',
    'ж': 'zh',
    'щ': 'shhch',
    'ш': 'shh',
    'ч': 'ch',
    'э': 'eh\'',
    'ъ': '"',
    'ь': "'",
    'ю': 'yu',
    'я': 'ya',
  };

  /// Get Day name by week number
  String get getDay {
    Map days = {
      "1": "Mon",
      "2": "Tue",
      "3": "Wed",
      "4": "Thur",
      "5": "Fri",
      "6": "Sat",
      "7": "Sun",
    };

    return days[this];
  }

  /// Get Month name by number
  String get getMonth {
    Map months = {
      "1": "Jan",
      "2": "Feb",
      "3": "Mar",
      "4": "Apr",
      "5": "May",
      "6": "June",
      "7": "Jul",
      "8": "Aug",
      "9": "Sep",
      "10": "Oct",
      "11": "Nov",
      "12": "Dec",
    };

    return months[this];
  }

  /// Method for converting from translit for the [source] value
  static String untransliterate({required String source}) {
    if (source.isEmpty) return source;

    RegExp regExp = RegExp(
      r'([a-z]+)',
      caseSensitive: false,
      multiLine: true,
    );

    if (!regExp.hasMatch(source)) return source;

    List sourceSymbols = [];
    List unTranslit = [];
    Map deTransliteratedSymbol = {};

    _compSymbols.forEach((key, value) {
      source = source.replaceAll(value, key);
    });

    sourceSymbols = source.split('');

    _symbols.forEach((key, value) {
      deTransliteratedSymbol[value] = key;
    });

    for (final element in sourceSymbols) {
      unTranslit.add(deTransliteratedSymbol.containsKey(element)
          ? deTransliteratedSymbol[element]
          : element);
    }

    return unTranslit.join();
  }

  /// Method for converting to translit for the [source] value
  static String transliterate({required String source}) {
    if (source.isEmpty) return source;

    return source.split('').map((element) {
      return _symbols.containsKey(element) ? _symbols[element]! : element;
    }).join();
  }
}

extension VersionExtensions on String {
  /// version: 1.0.0+10

  Map<String, String> get getAsMap {
    String number = this.getNumber;
    List<String> numberAsList = number.split('.');
    String build = this.getBuild;

    return {
      'major': numberAsList[0],
      'minor': numberAsList[1],
      'bugfix': numberAsList[2],
      'build': build,
    };
  }

  /// Get only Version number
  String get getNumber {
    List<String> current = this.split('+');
    return current.first;
  }

  /// Get only Version build
  String get getBuild {
    List<String> current = this.split('+');
    return current.last;
  }

  /// Upgrade version to the next
  String upgrade(String release, {int step = 1}) {
    List<String> parts = this.split('+');
    String version = parts.first;
    List<String> nums = version.split('.');

    int major = int.parse(nums[0]);
    int minor = int.parse(nums[1]);
    int bugfix = int.parse(nums[2]);

    late int build;
    if (parts.length > 1) {
      build = int.parse(parts.last);
      build++;
    } else {
      build = 1;
    }

    late String newVersion;
    switch (release) {
      case 'major':
        newVersion = "${major += step}.0.0";
        break;
      case 'minor':
        newVersion = "$major.${minor += step}.0";
        break;
      default:
        newVersion = "$major.$minor.${bugfix += step}";
    }

    return '$newVersion+$build';
  }
}

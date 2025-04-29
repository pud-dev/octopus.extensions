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

extension MapExtensions<T> on Map {
  /// Merges two maps of type `Map<String, Map>` into a new map, combining entries with matching keys.
  ///
  /// For each matching key, fields from the [other] map will override or add to the corresponding inner map
  /// from the current map (`this`). If a key exists only in [other], it will be added to the resulting map.
  ///
  /// This function is useful when combining configuration maps (e.g., settings with localized labels).
  ///
  /// Returns a new `Map<String, Map>` that represents the merged structure.
  ///
  /// Example:
  /// ```dart
  /// final settings = {
  ///   'tasks': {'type': 'agent', 'icon': 'add'},
  /// };
  ///
  /// final i18n = {
  ///   'tasks': {'title': 'Tasks'},
  ///   'goals': {'title': 'Goals'},
  /// };
  ///
  /// final merged = settings.mergeWith(i18n);
  /// print(merged);
  /// // Output:
  /// // {
  /// //   'tasks': {'type': 'agent', 'icon': 'add', 'title': 'Tasks'},
  /// //   'goals': {'title': 'Goals'},
  /// // }
  /// ```
  Map<String, Map> mergeWith(Map<String, Map> other) {
    final Map<String, Map> result = {};

    forEach((key, value) {
      final Map merged = Map.from(value);

      if (other.containsKey(key)) {
        merged.addAll(other[key]!);
      }

      result[key] = merged;
    });

    other.forEach((key, value) {
      if (!containsKey(key)) {
        result[key] = Map.from(value);
      }
    });

    return result;
  }

  /// Returns a new list of values from the specified [fieldName] in a map-like structure.
  ///
  /// The [fieldName] parameter represents the field name/key to extract from each map-like entry in the list.
  /// The function maps over the entries in the list and retrieves the value associated with the [fieldName].
  ///
  /// Returns a new list containing the values from the specified [fieldName].
  ///
  /// Example:
  /// ```dart
  /// List<Map<String, dynamic>> entries = [
  ///   {'name': 'Alice', 'age': 25},
  ///   {'name': 'Bob', 'age': 30},
  ///   {'name': 'Charlie', 'age': 35},
  /// ];
  ///
  /// List<String> names = entries.getByField<String>('name');
  /// print(names); // Output: [Alice, Bob, Charlie]
  /// ```
  List<T> getByField<T>(String fieldName) {
    List<T> list = this.entries.map<T>((e) {
      return e.value[fieldName];
    }).toList();

    return list;
  }

  /// Filters the map by specified [keys] and returns a new map containing only the selected key-value pairs.
  ///
  /// The [keys] parameter is a list of strings representing the keys to retain in the resulting map. The method iterates over the provided [keys] and includes only those entries in the new map whose keys are present in the [keys] list.
  ///
  /// Returns a new map with entries that match the specified [keys]. If a key from [keys] does not exist in the original map, it is ignored.
  ///
  /// Example:
  /// ```dart
  /// Map<String, Map> strategies = {
  ///   "smart": {
  ///     "title": "SMART",
  ///     "tracker": "target",
  ///     "step": {
  ///       "singular": "Step",
  ///       "plural": "Steps",
  ///     },
  ///     "subtitle": "An effective way that provides the clarity and focus you need to achieve your goals."
  ///   },
  ///   "hard": {
  ///     "title": "HARD",
  ///     "tracker": "challenge",
  ///     "step": {
  ///       "singular": "Challenge",
  ///       "plural": "Challenges",
  ///     },
  ///     "subtitle": "Goals like paying off debt or waking up early every day are common challenges that will do well with this framework."
  ///   },
  ///   // Add other strategies...
  /// };
  ///
  /// var filteredStrategies = strategies.filterByKeys(['smart']);
  /// print(filteredStrategies);
  /// // Output: Map containing only the entries for 'smart' and 'hard' keys.
  /// ```
  Map<String, Map> filterByKeys(List<String> keys) {
    return Map.fromIterables(
      keys.where((key) => this.containsKey(key)),
      keys.where((key) => this.containsKey(key)).map((key) => this[key]!),
    );
  }

  /// Filters the map of maps by a specific field value.
  ///
  /// The `filterBy` method filters the entries of the map based on the provided
  /// field value. It returns a new map containing only the entries where the
  /// specified field matches the provided value.
  ///
  /// Args:
  ///   field (String): The field name to filter by.
  ///
  /// Returns:
  ///   Map<K, Map<String, dynamic>>: A new map containing filtered entries.
  Map<String, dynamic> filterBy(String field, String value) {
    Map<String, dynamic> filtered = {};

    this.forEach((day, activities) {
      Map<String, dynamic> filteredActivities = {};

      activities.forEach((id, activity) {
        if (activity[field] == value) {
          filteredActivities[id] = activity;
        }
      });

      if (filteredActivities.isNotEmpty) {
        filtered[day] = filteredActivities;
      }
    });

    return filtered;
  }

  Map<String, int> countByField(String field) {
    Map<String, int> etypeCounts = {};

    this.forEach((day, events) {
      if (events is Map<String, dynamic>) {
        events.forEach((id, event) {
          if (event[field] != null) {
            String title = event[field];
            etypeCounts[title] = (etypeCounts[title] ?? 0) + 1;
          }
        });
      }
    });

    return etypeCounts;
  }

  /// Groups a map of season colors by their respective months.
  ///
  /// This getter organizes the color data by their 'group' attribute, which
  /// represents a specific time period, such as a month. It restructures the
  /// class's internal map into a new map that is indexed by these group values.
  ///
  /// Example:
  /// ```
  /// Map<String, Map<String, dynamic>> colorData = {
  ///   'color1': {'group': 'january', 'value': 'data'},
  ///   'color2': {'group': 'january', 'value': 'data'},
  ///   'color3': {'group': 'february', 'value': 'data'},
  /// };
  ///
  /// var groupedColors = colorData.getGroupedSeasonColors;
  /// print(groupedColors);
  /// ```
  ///
  /// Output:
  /// ```
  /// {
  ///   'january': {
  ///     'color1': {'group': 'january', 'value': 'data'},
  ///     'color2': {'group': 'january', 'value': 'data'}
  ///   },
  ///   'february': {
  ///     'color3': {'group': 'february', 'value': 'data'}
  ///   }
  /// }
  /// ```
  ///
  /// The output map will have keys that correspond to the groups (e.g., months)
  /// and each key maps to a nested map of color data that belongs to that group.
  ///
  /// Returns:
  /// A Map<String, Map<String, dynamic>> where each key is a month and
  /// each value is a Map of color attributes for that specific month.
  Map<String, Map<String, dynamic>> groupByChildField(String field) {
    Map<String, Map<String, dynamic>> result = {};

    this.forEach((key, value) {
      final String group = value[field];
      if (!result.containsKey(group)) {
        result[group] = {};
      }

      result[group]![key] = value;
    });

    return result;
  }

  Map<String, Map> filterByValue(String field, String type) {
    final Map<String, Map> filteredMap = {};

    this.forEach((key, value) {
      if (value is Map && value[field] == type) {
        filteredMap[key] = value;
      }
    });

    return filteredMap;
  }

  /// Groups the map's inner items based on a specified field.
  ///
  /// This extension method applies to a map structure where each key contains another map.
  /// It groups these inner maps by the specified field.
  ///
  /// Parameters:
  ///   fieldName (String): The field name by which to group the maps.
  ///
  /// Returns:
  ///   Map<String, List<Map<String, dynamic>>>: A map where each key is a unique value of the specified field,
  ///   and the value is a list of all maps that contain that field value.
  ///
  /// Example:
  /// ```dart
  /// Map<String, dynamic> data = {
  /// "24":{"priority":"hight","title":"s1"},
  /// "25":{"priority":"low","title":"s2"},
  /// };
  ///
  /// var groupedData = data.groupByField('priority');
  /// print(groupedData);
  /// ```
  Map<String, List<Map<String, dynamic>>> groupByField(String fieldName) {
    Map<String, List<Map<String, dynamic>>> groupedMap = {};

    this.forEach((key, value) {
      Map innerMap = value;
      innerMap.forEach((innerKey, innerValue) {
        if (innerValue is Map<String, dynamic> && innerValue.containsKey(fieldName)) {
          String fieldValue = innerValue[fieldName].toString();
          groupedMap[fieldValue] ??= [];
          groupedMap[fieldValue]!.add(Map<String, dynamic>.from(innerValue));
        }
      });
    });

    return groupedMap;
  }

  /// Returns a new map with string values only.
  ///
  /// The getter iterates over each key-value pair in the original map.
  /// If the value is of type DateTime, it converts it to a string representation.
  ///
  /// Returns a new map with the same keys but string values instead of DateTime values.
  ///
  /// Example:
  /// ```dart
  /// Map<dynamic, dynamic> originalMap = {
  ///   'name': 'Alice',
  ///   'age': 25,
  ///   'birthday': DateTime(1990, 1, 1),
  /// };
  ///
  /// Map<dynamic, dynamic> stringMap = originalMap.stringValuesOnly;
  /// print(stringMap); // Output: {name: Alice, age: 25, birthday: 1990-01-01 00:00:00.000}
  /// ```
  Map<dynamic, dynamic> get stringValuesOnly {
    Map<dynamic, dynamic> map = this;
    map.forEach((key, value) {
      if (value is DateTime) map[key] = value.toString();
    });

    return map;
  }

  /// Returns a new map with string values only.
  ///
  /// The method iterates over each key-value pair in the original map.
  /// If the value is of type Map, it recursively converts its values to strings.
  /// If the value is of type DateTime, it converts it to a string representation in ISO 8601 format.
  /// Otherwise, it converts the value to a string using `toString()`.
  ///
  /// Returns a new map with the same keys but values converted to strings.
  ///
  /// Example:
  /// ```dart
  /// Map<dynamic, dynamic> originalMap = {
  ///   'name': 'Alice',
  ///   'age': 25,
  ///   'birthday': DateTime(1990, 1, 1),
  /// };
  ///
  /// Map<dynamic, dynamic> stringMap = originalMap.convertAllValuesToString();
  /// print(stringMap); // Output: {name: Alice, age: 25, birthday: 1990-01-01T00:00:00.000}
  /// ```
  Map<String, dynamic> convertAllValuesToString() {
    var result = <String, dynamic>{};

    this.forEach((key, value) {
      if (value is Map) {
        result[key.toString()] = (value).convertAllValuesToString();
      } else if (value is DateTime) {
        result[key.toString()] = value.toIso8601String();
      } else {
        result[key.toString()] = "$value";
      }
    });

    return result;
  }

  Map<String, List<Map>> getOptionsAsList({required String byField}) {
    Map<String, List<Map>> grouped = {};

    this.forEach((key, value) {
      String group = value[byField];
      value.remove(byField);
      value['strategy'] = key;

      if (!grouped.containsKey(group)) {
        grouped[group] = [];
      }

      grouped[group]!.add(value);
    });

    return grouped;
  }

  /// Returns a new List<bool> representation of the current List.
  ///
  /// The getter calls the `toBoolList` method to convert the current List
  /// to a List<bool>.
  ///
  /// Returns a new List<bool> representation of the current List.
  ///
  /// Example:
  /// ```dart
  /// List<int> numbers = [0, 1, 0, 1, 1];
  /// List<bool> boolList = numbers.getBoolList;
  /// print(boolList); // Output: [false, true, false, true, true]
  /// ```
  List<bool> get getBoolList => toBoolList();

  /// Converts the current List to a List<bool> representation.
  ///
  /// The `trueAtIndex` parameter specifies the index at which the value `true` should be set in the resulting list.
  /// By default, the value `true` is set at index 0 if `trueAtIndex` is out of range.
  ///
  /// Returns a new List<bool> representation of the current List.
  ///
  /// Example:
  /// ```dart
  /// List<int> numbers = [0, 1, 2, 3, 4];
  /// List<bool> boolList = numbers.toBoolList(trueAtIndex: 2);
  /// print(boolList); // Output: [false, false, true, false, false]
  /// ```
  List<bool> toBoolList({int trueAtIndex = 0}) {
    var list = List<bool>.filled(this.length, false, growable: true);
    if (list.asMap().containsKey(trueAtIndex) == true) {
      list[trueAtIndex] = true;
    } else {
      list[0] = true;
    }

    return list;
  }

  /// Calculates and returns the average value based on the key-value pairs in the current Map.
  ///
  /// The getter iterates over each key-value pair in the Map.
  /// It calculates the sum of the products of each key multiplied by its corresponding value,
  /// as well as the total count of values.
  /// The average is then computed by dividing the total sum by the count of values.
  ///
  /// Returns the average value as a double.
  ///
  /// Example:
  /// ```dart
  /// Map<String, int> data = {
  ///   '10': 3,
  ///   '20': 2,
  ///   '30': 4,
  /// };
  ///
  /// double average = data.calculateAverage;
  /// print(average); // Output: 22.5
  /// ```
  double get calculateAvarage {
    double total = 0;
    double count = 0;

    this.forEach((key, value) {
      total += (double.parse(key) * value);
      count += value;
    });

    return (total / count);
  }

  /// Calculates and returns the sum of all values in the current Map.
  ///
  /// The getter uses the `reduce` method to iterate over the values in the Map.
  /// It accumulates the sum of the values by adding each value to the running total.
  /// The values are converted to double using `toDouble()` to handle numeric types properly.
  ///
  /// Returns the sum of all values as a double.
  ///
  /// Example:
  /// ```dart
  /// Map<String, int> data = {
  ///   'A': 10,
  ///   'B': 20,
  ///   'C': 30,
  /// };
  ///
  /// double sum = data.sumValues;
  /// print(sum); // Output: 60.0
  /// ```
  double get sumValues {
    return this.values.reduce((sum, element) => sum + element.toDouble());
  }

  /// Retrieves a random value from a random entry in the Map based on the specified [field].
  ///
  /// The [field] parameter represents the field/key in the entry from which the random value should be retrieved.
  /// The function generates a random index within the range of the Map's length using a Random generator.
  /// It retrieves a random entry using the generated index and then retrieves the value associated with the specified [field].
  ///
  /// Returns a string representation of the random value.
  ///
  /// Example:
  /// ```dart
  /// Map<String, dynamic> data = {
  ///   'entry1': {'name': 'Alice', 'age': 25},
  ///   'entry2': {'name': 'Bob', 'age': 30},
  ///   'entry3': {'name': 'Charlie', 'age': 35},
  /// };
  ///
  /// String randomName = data.randomEntryByField('name');
  /// print(randomName); // Output: Alice (or Bob, or Charlie)
  /// ```
  String randomEntryByField(String field) {
    Random generator = Random();
    int index = generator.nextInt(this.length);
    MapEntry entry = this.entries.toList()[index];
    return entry.value[field].toString();
  }

  Map get reversedKeys {
    // Extract the keys and reverse their order
    Iterable keys = this.keys.toList().reversed;

    // Create a new map with the reversed key order
    var reversedMap = {for (var k in keys) k: this[k]};

    return reversedMap;
  }
}

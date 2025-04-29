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

import 'dart:collection';
import 'dart:math';

extension CollectionsExtensions<T> on Iterable<T> {
  /// Returns a random element from the list.
  ///
  /// If the list is not empty, this method selects a random index using `Random().nextInt(length)`
  /// and returns the corresponding element.
  ///
  /// Throws an exception if the list is empty.
  ///
  /// Example:
  /// ```dart
  /// List<String> greetings = ["Hello!", "Hi!", "Welcome!"];
  /// String randomGreeting = greetings.random;
  /// print(randomGreeting); // Output: A random greeting from the list
  /// ```
  T get random {
    return isNotEmpty
        ? (this as List<T>)[Random().nextInt(length)]
        : throw Exception("List is empty");
  }

  /// Returns a new list that contains the unique elements of the original list.
  ///
  /// The getter converts the original list into a Set to remove duplicate elements,
  /// and then converts the Set back into a List.
  ///
  /// Returns a new list without duplicate elements.
  ///
  /// Example:
  /// ```dart
  /// List<int> numbers = [1, 2, 3, 1, 4, 2, 5];
  /// List<int> uniqueNumbers = numbers.withoutDups;
  /// print(uniqueNumbers); // Output: [1, 2, 3, 4, 5]
  /// ```
  List<T> get withoutDups {
    return this.toSet().toList();
  }

  /// Returns a new list where all elements of the specified sublist are replaced with a given value.
  ///
  /// This method iterates through the list and, for each entry containing the specified sublist,
  /// replaces all its elements with [newValue]. By default, it modifies the sublist named `'checks'`,
  /// but a different sublist can be specified using [sublistName].
  ///
  /// The original list remains unchanged, and a new modified list is returned.
  ///
  /// Example:
  /// ```dart
  /// List<Map<String, dynamic>> tasks = [
  ///   {'name': 'Task 1', 'checks': [true, false, true]},
  ///   {'name': 'Task 2', 'checks': [false, false]}
  /// ];
  ///
  /// List<Map<String, dynamic>> updatedTasks = tasks.fillSublist(false);
  ///
  /// print(updatedTasks);
  /// // Output:
  /// // [
  /// //   {'name': 'Task 1', 'checks': [false, false, false]},
  /// //   {'name': 'Task 2', 'checks': [false, false]}
  /// // ]
  /// ```
  ///
  /// - [newValue] The value to replace all elements in the sublist.
  /// - [sublistName] (optional) The key name of the sublist to modify (default is `'checks'`).
  ///
  /// Returns a new list with the modified sublists.

  List<T> fillSublist(T newValue, [String sublistName = 'checks']) {
    List<T> parent = this.toList();

    for (dynamic entry in parent) {
      if (entry.containsKey(sublistName) && entry[sublistName] is List<T>) {
        entry[sublistName] = List.filled(entry[sublistName].length, newValue);
      }
    }

    return parent;
  }

  /// Returns a new list where the specified sublist in each entry is cleared.
  ///
  /// This method iterates through the list and, for each entry containing the specified sublist,
  /// replaces it with an empty list. By default, it clears the sublist named `'checks'`,
  /// but a different sublist can be specified using [sublistName].
  ///
  /// The original list remains unchanged, and a new modified list is returned.
  ///
  /// Example:
  /// ```dart
  /// List<Map<String, dynamic>> tasks = [
  ///   {'name': 'Task 1', 'checks': [true, false, true]},
  ///   {'name': 'Task 2', 'checks': [false, false]}
  /// ];
  ///
  /// List<Map<String, dynamic>> updatedTasks = tasks.clearSublist();
  ///
  /// print(updatedTasks);
  /// // Output:
  /// // [
  /// //   {'name': 'Task 1', 'checks': []},
  /// //   {'name': 'Task 2', 'checks': []}
  /// // ]
  /// ```
  ///
  /// - [sublistName] (optional) The key name of the sublist to clear (default is `'checks'`).
  ///
  /// Returns a new list with the specified sublists cleared.
  List<T> clearSublist([String sublistName = 'checks']) {
    List<T> parent = this.toList();

    for (dynamic entry in parent) {
      if (entry.containsKey(sublistName)) {
        entry[sublistName] = [];
      }
    }

    return parent;
  }

  /// Checks if any map in the list contains the specified [entity] key.
  ///
  /// The [entity] parameter represents a map with a single key.
  /// The function iterates through each item in the list, checking if any map
  /// contains the first key from the [entity] map.
  ///
  /// Returns true if any map in the list contains the specified [entity] key, false otherwise.
  ///
  /// Example:
  /// ```dart
  /// List<Map<String, dynamic>> maps = [
  ///   {'id': 1, 'name': 'Alice'},
  ///   {'id': 2, 'name': 'Bob'},
  ///   {'id': 3, 'name': 'Charlie'},
  /// ];
  ///
  /// Map<String, dynamic> entity = {'id': 2};
  /// bool containsKey = maps.containsMapKey(entity);
  /// print(containsKey); // Output: true
  /// ```
  bool containsMapKey(Map entity) {
    for (var item in this) {
      Map e = item as Map;

      if (e.containsKey(entity.keys.first)) {
        return true;
      }
    }

    return false;
  }

  /// Returns the first element that satisfies the given [test] function, or `null` if no element matches.
  ///
  /// Iterates through each element in the list, and applies the [test] function.
  /// If an element satisfies the [test], it is immediately returned, ending the iteration.
  /// If no element satisfies the [test], the function returns `null`.
  ///
  /// Example:
  /// ```dart
  /// List<int> numbers = [1, 3, 5, 7, 9];
  /// int? evenNumber = numbers.firstWhereOrNull((num) => num % 2 == 0);
  /// print(evenNumber); // Output: null
  /// ```
  ///
  /// [test]: The function to test each element for a condition.
  T? firstWhereOrNull(bool Function(T) test) {
    for (T element in this) {
      if (test(element)) return element;
    }

    return null;
  }

  ///
  /// Determines if the calling list contains any elements from the provided list.
  ///
  /// @param elements A list of elements to check against the calling list.
  /// @return bool Returns `true` if the calling list contains at least one element from the `elements` list, `false` otherwise.
  ///
  /// @example
  /// final myList = [1, 2, 3, 4, 5];
  /// bool result = myList.containsAny([0, 5]);  // true
  /// ```
  bool containsAny(List<T> elements) {
    for (T element in elements) {
      if (this.contains(element)) {
        return true;
      }
    }

    return false;
  }

  /// Returns a new list containing only the elements that are owned by the specified [uid].
  ///
  /// The [uid] parameter represents the unique identifier of the owner.
  /// The function filters the elements based on their `ownerUID` property, returning only the elements
  /// whose `ownerUID` matches the specified [uid].
  ///
  /// Returns a new list containing only the elements owned by the specified [uid].
  ///
  /// Example:
  /// ```dart
  /// class MyObject {
  ///   final String ownerUID;
  ///   final String name;
  ///
  ///   MyObject(this.ownerUID, this.name);
  /// }
  ///
  /// List<MyObject> objects = [
  ///   MyObject('user1', 'Object 1'),
  ///   MyObject('user2', 'Object 2'),
  ///   MyObject('user1', 'Object 3'),
  /// ];
  ///
  /// List<MyObject> ownedObjects = objects.onlyOwned('user1');
  /// print(ownedObjects.map((obj) => obj.name).toList()); // Output: [Object 1, Object 3]
  /// ```
  List<T> onlyOwned<T>(String uid) {
    Iterable<dynamic> objects = this;
    return List<T>.from(objects.where((element) => element.ownerUID == uid));
  }

  /// Returns a new list sorted based on the time extracted from the given [key] function.
  /// The [key] function should return a DateTime value from which the time is extracted
  /// (ignoring the date).
  List<T> sortedByTimeOnly(DateTime key(T e), {bool reversed = false}) {
    List<T> sortedList = List<T>.from(this);
    sortedList.sort((a, b) {
      final Duration timeA =
          Duration(hours: key(a).hour, minutes: key(a).minute, seconds: key(a).second);
      final Duration timeB =
          Duration(hours: key(b).hour, minutes: key(b).minute, seconds: key(b).second);

      return timeA.compareTo(timeB);
    });

    return reversed ? sortedList.reversed.toList() : sortedList;
  }

  /// Returns a new list sorted based on the values derived from the given [key] function.
  ///
  /// The [key] function is used to extract a comparable value from each element.
  /// The list is sorted in ascending order based on these derived values.
  ///
  /// By default, the list is returned in ascending order. Use the optional [reversed] parameter
  /// to specify whether the list should be returned in descending order.
  ///
  /// Returns a new list sorted based on the derived values.
  ///
  /// Example:
  /// ```dart
  /// class Person {
  ///   final String name;
  ///   final int age;
  ///
  ///   Person(this.name, this.age);
  /// }
  ///
  /// List<Person> persons = [
  ///   Person('Alice', 25),
  ///   Person('Bob', 30),
  ///   Person('Charlie', 20),
  /// ];
  ///
  /// List<Person> sortedList = persons.sortedByValue((person) => person.age);
  /// print(sortedList.map((person) => person.name).toList()); // Output: [Charlie, Alice, Bob]
  /// ```
  List<T> sortedByValue(Comparable key(T e), {bool reversed = false}) {
    Iterable<T> items = this.toList()..sort((a, b) => key(a).compareTo(key(b)));
    return reversed ? items.reversed.toList() : items.toList();
  }

  List<T> sortedByTime(Comparable key(T e), {bool reversed = false}) {
    // Sort with a custom comparison to handle "Anytime" items first
    List<T> sortedList = List<T>.from(this)
      ..sort((a, b) {
        final valueA = key(a);
        final valueB = key(b);

        // Check if either value is "Anytime", push those to the top
        if (valueA == 'Anytime') return 1;
        if (valueB == 'Anytime') return -1;

        // Otherwise, compare normally
        return valueA.compareTo(valueB);
      });

    // Reverse if needed
    return reversed ? sortedList.reversed.toList() : sortedList;
  }

  /// Calculates the sum of a list of objects based on a specific property value.
  ///
  /// The [selector] function retrieves the property value to be summed for each element.
  /// The property value can be either a string or a number.
  ///
  /// Returns the sum as a string representation.
  ///
  /// Example:
  /// ```dart
  /// List<MyObject> myList = [
  ///   MyObject(5),
  ///   MyObject(10),
  ///   MyObject(3),
  /// ];
  ///
  /// int sum = myList.sumByValue((obj) => obj.value);
  /// print(sum); // Output: 18
  ///
  double sumByValue(num Function(T) selector) {
    double total = 0;

    for (T e in this) {
      num value = selector(e);
      total += value;
    }

    return total;
  }

  /// Checks if any element in the list satisfies the given [predicate].
  ///
  /// The [predicate] function determines whether an element satisfies a condition.
  /// It should return true if the element satisfies the condition, or false otherwise.
  ///
  /// Returns true if at least one element satisfies the [predicate], false otherwise.
  ///
  /// Example:
  /// ```dart
  /// List<int> numbers = [1, 2, 3, 4, 5];
  /// bool hasEvenNumber = numbers.any((number) => number % 2 == 0);
  /// print(hasEvenNumber); // Output: true
  /// ```
  bool any(bool predicate(T element)) {
    if (this.isEmpty) return false;
    for (final element in this) {
      if (predicate(element)) return true;
    }

    return false;
  }

  /// Converts the current Set to a mutable Set.
  ///
  /// Returns a new mutable Set containing the same elements as the original Set.
  ///
  /// Example:
  /// ```dart
  /// Set<int> numbers = {1, 2, 3};
  /// Set<int> mutableNumbers = numbers.toMutableSet();
  /// mutableNumbers.add(4);
  /// print(mutableNumbers); // Output: {1, 2, 3, 4}
  /// ```
  Set<T> toMutableSet() => Set.from(this);

  /// Maps the current iterable to a Map where each key represents a unique date
  /// and the corresponding value is a List of elements assigned on that date.
  ///
  /// Returns a Map where each key is a DateTime representing a date,
  /// and the value is a List of elements assigned on that date.
  ///
  /// Example:
  /// ```dart
  /// class MyObject {
  ///   DateTime assignedAtDateOnly;
  ///
  ///   MyObject(this.assignedAtDateOnly);
  /// }
  ///
  /// List<MyObject> objects = [
  ///   MyObject(DateTime(2022, 1, 1)),
  ///   MyObject(DateTime(2022, 1, 1)),
  ///   MyObject(DateTime(2022, 1, 2)),
  /// ];
  ///
  /// Map<DateTime, List<MyObject>> mapped = objects.mapToAssigned();
  /// print(mapped);
  /// // Output: {2022-01-01: [Instance of 'MyObject', Instance of 'MyObject'], 2022-01-02: [Instance of 'MyObject']}
  /// ```
  Map<String, Map> mapToOptions<T>(String key, String title) {
    Map<String, Map> mapped = {};
    Iterable<dynamic> objects = this;

    for (var object in objects) {
      mapped[object[key]] = {'title': object[title]};
    }

    return mapped;
  }

  /// Groups the elements of the current Iterable by a key derived from each element.
  ///
  /// The function takes a [key] parameter, which represents a function that derives the key
  /// from each element in the Iterable. It creates a new Map with the derived keys as the keys
  /// and lists of elements as the values.
  ///
  /// If an [order] is provided, it orders the resulting Map based on the specified keys.
  ///
  /// Returns a new Map with the elements grouped by the derived keys.
  ///
  /// Example:
  /// ```dart
  /// List<String> names = ['Alice', 'Bob', 'Charlie', 'Alex', 'Brian', 'Chris'];
  /// final Map<String, List> scopes = widget.tasks.groupBy<Task, String>(
  ///         (entity) => entity.priority,
  ///         order: ['df', 'sc', 'de', 'dd'],
  ///       );
  /// print(grouped);
  /// // Output: {5: [Alice, Brian], 3: [Bob], 7: [Charlie], 4: [Alex, Chris]}
  /// ```
  Map<String, List<T>> groupBy<T, String>(String Function(T e) mapper,
      {Iterable order = const [], Iterable pinned = const []}) {
    final Map<String, List<T>> data = {};
    final Map<String, List<T>> ordered = {};

    for (final dynamic e in this) {
      final List<T> entities = data.putIfAbsent(mapper(e as T), () => []);
      entities.add(e);
    }

    if (order.isNotEmpty) {
      for (String e in order) {
        if (data[e] != null) {
          ordered[e] = data[e]!;
        }
      }
    } else {
      final List<String> dataKeys = data.keys.toList();
      final List<String> sortedKeys = dataKeys.sorted();

      for (String key in sortedKeys) {
        ordered[key] = data[key] ?? [];
      }
    }

    if (pinned.isNotEmpty) {
      final Map<String, List<T>> pinnedData = {};
      for (String p in pinned) {
        if (ordered.containsKey(p)) {
          pinnedData[p] = ordered.remove(p)!;
        }
      }

      pinnedData.addAll(ordered);
      return pinnedData;
    }

    return ordered;
  }

  /// Creates a new List containing only the elements that satisfy the given [test] function.
  ///
  /// The function takes a [test] parameter, which represents a function that tests each element
  /// in the Iterable. It creates a new List, `result`, and adds only the elements that are not null
  /// and satisfy the given [test] function.
  ///
  /// Returns a new List containing only the elements that satisfy the [test] function.
  ///
  /// Example:
  /// ```dart
  /// List<int> numbers = [1, 2, 3, 4, 5];
  /// List<int> evenNumbers = numbers.filter((number) => number % 2 == 0);
  /// print(evenNumbers); // Output: [2, 4]
  /// ```
  List<T> filter(bool test(T element)) {
    final result = <T>[];
    forEach((e) {
      if (e != null && test(e)) {
        result.add(e);
      }
    });

    return result;
  }

  /// Calculates and returns the half length of the current Iterable as an integer.
  ///
  /// The getter divides the length of the Iterable by 2 using the division operator `/`,
  /// and then floors the result using the `floor()` method to obtain an integer value.
  ///
  /// Returns the half length of the Iterable as an integer.
  ///
  /// Example:
  /// ```dart
  /// List<int> numbers = [1, 2, 3, 4, 5];
  /// int res = numbers.halfLength;
  /// print(res); // Output: 2
  /// ```
  int get halfLength => (this.length / 2).floor();

  /// Returns a list containing all elements except first [n] elements.
  List<T> drop(int n) {
    if (n == 0) return [];

    var list = [];
    var originalList = this.toList();

    final resultSize = this.length - n;
    if (resultSize <= 0) return [];
    if (resultSize == 1) return [this.last];

    originalList.removeRange(0, n);

    for (var element in originalList) {
      list.add(element);
    }

    return List<T>.from(list);
  }

  /// Applies the provided function [f] to each element in the current Iterable
  /// and returns a new List containing the transformed elements.
  ///
  /// The function takes a [f] parameter, which represents a function that will be applied
  /// to each element in the Iterable. It uses the `map` method to apply the function to each
  /// element and returns a new List containing the transformed elements.
  ///
  /// Returns a new List containing the transformed elements.
  ///
  /// Example:
  /// ```dart
  /// List<int> numbers = [1, 2, 3, 4, 5];
  /// List<String> transformedNumbers = numbers.mapList((number) => 'Number: $number');
  /// print(transformedNumbers); // Output: [Number: 1, Number: 2, Number: 3, Number: 4, Number: 5]
  /// ```
  List<T> mapList<T>(T f(doc)) => this.map(f).toList();

  /// Takes the first half of a list
  List<T> firstHalf() => take(halfLength).toList();

  /// Takes the second half of a list
  List<T> secondHalf() => drop(halfLength).toList();

  /// Creates a new List with the elements at positions [i] and [j] swapped.
  ///
  /// The function creates a new List by converting the current Iterable to a List.
  /// It then swaps the elements at the specified positions [i] and [j] by using a temporary variable.
  /// The function returns the new List with the swapped elements.
  ///
  /// Returns a new List with the elements at positions [i] and [j] swapped.
  ///
  /// Example:
  /// ```dart
  /// List<int> numbers = [1, 2, 3, 4, 5];
  /// List<int> swappedNumbers = numbers.swap(1, 3);
  /// print(swappedNumbers); // Output: [1, 4, 3, 2, 5]
  /// ```
  List<T> swap(int i, int j) {
    final list = this.toList();
    final aux = list[i];
    list[i] = list[j];
    list[j] = aux;
    return list;
  }

  /// Retrieves a random element from the current Iterable.
  ///
  /// The getter creates a `Random` generator to generate a random index within the range
  /// of the Iterable's length. It uses the `nextInt()` method of the generator to obtain
  /// a random integer index. It then retrieves the element at the generated index from
  /// the Iterable by converting it to a List using `toList()`.
  ///
  /// Returns a random element from the Iterable.
  ///
  /// Example:
  /// ```dart
  /// List<int> numbers = [1, 2, 3, 4, 5];
  /// int randomElement = numbers.getRandom;
  /// print(randomElement); // Output: Randomly selected number from the list
  /// ```
  dynamic get getRandom {
    Random generator = Random();
    final index = generator.nextInt(this.length);

    return this.toList()[index];
  }

  /// Retrieves a random value from an element in the current Iterable based on the specified [fieldname].
  ///
  /// The function creates a `Random` generator to generate a random index within the range of the Iterable's length.
  /// It uses the `nextInt()` method of the generator to obtain a random integer index.
  /// It then retrieves the element at the generated index from the Iterable by converting it to a List using `toList()`.
  /// The function assumes that the retrieved element is of type `T`.
  /// It accesses the value associated with the specified [fieldname] in the retrieved element, assuming the element is of type `Map`.
  ///
  /// Returns a random value associated with the specified [fieldname].
  ///
  /// Example:
  /// ```dart
  /// List<Map<String, dynamic>> data = [
  ///   {'name': 'Alice', 'age': 25},
  ///   {'name': 'Bob', 'age': 30},
  ///   {'name': 'Charlie', 'age': 35},
  /// ];
  ///
  /// String randomName = data.getRandomValueByFieldName('name');
  /// print(randomName); // Output: Randomly selected name from the list
  /// ```
  String getRandomValueByFieldName(String fieldname) {
    Random generator = Random();
    final index = generator.nextInt(this.length);
    T result = this.toList()[index];

    return (result as Map)[fieldname];
  }

  /// Counts the number of elements in the current Iterable that satisfy the given [predicate].
  ///
  /// The function takes an optional [predicate] parameter, which represents a function that tests
  /// each element in the Iterable. If the [predicate] is not provided, it returns the length of the Iterable.
  /// If the [predicate] is provided, it iterates over each element in the Iterable and counts the elements
  /// that satisfy the given [predicate].
  ///
  /// Returns the count of elements that satisfy the [predicate] function, or the length of the Iterable if no [predicate] is provided.
  ///
  /// Example:
  /// ```dart
  /// List<int> numbers = [1, 2, 3, 4, 5];
  /// int countAll = numbers.count(); // Count all elements in the list
  /// int countEven = numbers.count((number) => number % 2 == 0); // Count even numbers
  /// print(countAll); // Output: 5
  /// print(countEven); // Output: 2
  /// ```
  int count([bool predicate(T element)?]) {
    var count = 0;
    if (predicate == null) {
      return length;
    } else {
      for (var current in this) {
        if (predicate(current)) {
          count++;
        }
      }
    }

    return count;
  }

  /// Creates a new List containing distinct elements based on the result of the given [predicate].
  ///
  /// The function takes a [predicate] parameter, which represents a function that generates a unique key
  /// for each element in the Iterable. It creates a HashSet to keep track of the unique keys encountered.
  /// It then iterates over each element in the Iterable and checks if the key generated by the [predicate]
  /// has not been encountered before. If it hasn't, the element is added to the result List.
  ///
  /// Returns a new List containing distinct elements based on the result of the [predicate].
  ///
  /// Example:
  /// ```dart
  /// List<String> names = ['Alice', 'Bob', 'Charlie', 'Alice', 'Bob'];
  /// List<String> distinctNames = names.distinctBy((name) => name);
  /// print(distinctNames); // Output: [Alice, Bob, Charlie]
  /// ```
  List<T> distinctBy(predicate(T selector)) {
    final set = HashSet();
    final list = [];
    toList().forEach((e) {
      final key = predicate(e);
      if (set.add(key)) {
        list.add(e);
      }
    });

    return List<T>.from(list);
  }

  /// Creates a new Set that contains all the elements of the current Set except for the elements
  /// that are also present in the [other] Iterable.
  ///
  /// The function creates a new Set by converting the current Set to a Set using the `toSet()` method.
  /// It then removes all the elements present in the [other] Iterable using the `removeAll()` method of the Set.
  ///
  /// Returns a new Set that contains the elements of the current Set except for the elements in the [other] Iterable.
  ///
  /// Example:
  /// ```dart
  /// Set<int> set1 = {1, 2, 3, 4, 5};
  /// Set<int> set2 = {3, 4, 5, 6, 7};
  /// Set<int> difference = set1.subtract(set2);
  /// print(difference); // Output: {1, 2}
  /// ```
  subtract(Iterable<T> other) {
    final set = toSet();
    set.removeAll(other);
    return set;
  }

  /// Creates a new Map by associating each element in the Iterable with a key-value pair.
  ///
  /// The function takes a [key] parameter and a [value] parameter, both representing functions
  /// that define the key and value for each element in the Iterable. It uses the `fromIterable`
  /// constructor of the Map class to create a new Map by associating each element in the Iterable
  /// with the key-value pair generated by the [key] and [value] functions.
  ///
  /// Returns a new Map containing the associations between elements and key-value pairs.
  ///
  /// Example:
  /// ```dart
  /// List<String> names = ['Alice', 'Bob', 'Charlie'];
  /// Map<String, int> nameLengths = names.associate((name) => name, (name) => name.length);
  /// print(nameLengths); // Output: {Alice: 5, Bob: 3, Charlie: 7}
  /// ```
  Map<dynamic, dynamic> associate(key(element), value(element)) =>
      Map.fromIterable(this, key: key, value: value);

  /// Finds the first element in the Iterable that satisfies the given [predicate].
  ///
  /// The function iterates over each element in the Iterable and checks if the element satisfies the given [predicate].
  /// If a matching element is found, it is returned. If no matching element is found, the function returns `null`.
  ///
  /// Returns the first element that satisfies the [predicate], or `null` if no such element is found.
  ///
  /// Example:
  /// ```dart
  /// List<int> numbers = [1, 2, 3, 4, 5];
  /// int? evenNumber = numbers.find((number) => number % 2 == 0);
  /// print(evenNumber); // Output: 2
  /// ```
  T? find(predicate(T selector)) {
    for (final element in this) {
      if (predicate(element)) {
        return element;
      }
    }

    return null;
  }

  /// Second element.
  ///
  /// ```dart
  /// [1, 2, 3].second; // 2
  /// ```
  T get second => elementAt(1);

  /// Third element.
  ///
  /// ```dart
  /// [1, 2, 3].third; // 3
  /// ```
  T get third => elementAt(2);

  /// Fourth element.
  ///
  /// ```dart
  /// [1, 2, 3, 4].fourth; // 4
  /// ```
  T get fourth => elementAt(3);

  /// Returns an element at the given [index] or [defaultValue] if the [index]
  /// is out of bounds of this collection.
  ///
  /// ```dart
  /// var list = [1, 2, 3, 4];
  /// var first = list.elementAtOrDefault(0, -1); // 1
  /// var fifth = list.elementAtOrDefault(4, -1); // -1
  /// ```
  T elementAtOrDefault(int index, T defaultValue) {
    return elementAtOrElse(index, (_) => defaultValue);
  }

  /// Returns an element at the given [index] or the result of calling the
  /// [defaultValue] function if the [index] is out of bounds of this
  /// collection.
  ///
  /// ```dart
  /// var list = [1, 2, 3, 4];
  /// var first = list.elementAtOrElse(0); // 1
  /// var fifth = list.elementAtOrElse(4, -1); // -1
  /// ```
  T elementAtOrElse(int index, T defaultValue(int index)) {
    if (index < 0) return defaultValue(index);
    var count = 0;
    for (var element in this) {
      if (index == count++) return element;
    }
    return defaultValue(index);
  }

  /// Returns the last element matching the given [predicate], or `null` if no
  /// such element was found.
  T lastOrNullWhere(bool predicate(T element)) {
    return lastWhere(predicate);
  }

  /// Returns an original collection containing all the non-null elements,
  /// throwing an [StateError] if there are any null elements.
  void requireNoNulls() {
    if (any((element) => element == null)) {
      throw StateError('At least one element is null.');
    }
  }

  /// Returns true if all elements match the given [predicate] or if the
  /// collection is empty.
  bool all(bool predicate(T element)) {
    for (var element in this) {
      if (!predicate(element)) {
        return false;
      }
    }
    return true;
  }

  /// Returns true if no entries match the given [predicate] or if the
  /// collection is empty.
  bool none(bool predicate(T element)) => !any(predicate);

  /// Creates a slice of a list from `start` up to, but not including, `end`.
  ///
  /// This extension method works on iterables and returns a slice of the list.
  /// If `start` is negative, it is treated as `length + start` where `length` is the length of the list.
  /// If `end` is negative, it is treated as `length + end`.
  ///
  /// Parameters:
  ///   - start (int): The start position.
  ///   - end (int): The end position, defaults to -1, indicating the end of the list.
  ///
  /// Returns:
  ///   List<T>: A new list containing the slice of the original list from `start` to `end`.
  ///
  /// Throws:
  ///   - RangeError: If `start` or `end` is out of the bounds of the list length.
  ///
  /// Example:
  /// ```dart
  /// List<int> numbers = [1, 2, 3, 4, 5];
  /// var sliced = numbers.slice(1, 3); // Returns [2, 3, 4]
  /// ```
  List<T> slice(int start, [int end = -1]) {
    var list = this is List ? this as List<T> : toList();

    if (start < 0) {
      start = start + list.length;
    }
    if (end < 0) {
      end = end + list.length;
    }

    RangeError.checkValidRange(start, end, list.length);

    return list.sublist(start, end + 1);
  }

  /// Returns a new list containing all elements sorted in ascending order.
  ///
  /// This extension method works on an iterable that contains elements
  /// which are `Comparable`. The method creates a new list from the iterable,
  /// sorts it in ascending order, and then returns it.
  ///
  /// The sorting is done in-place on the newly created list.
  ///
  /// Returns:
  ///   List<T>: A new list containing the elements of the original iterable,
  ///            sorted in ascending order.
  ///
  /// Example:
  /// ```dart
  /// List<int> numbers = [3, 1, 4, 1, 5, 9, 2, 6, 5, 3, 5];
  /// var sortedNumbers = numbers.sorted(); // Returns [1, 1, 2, 3, 3, 4, 5, 5, 5, 6, 9]
  /// ```
  List<T> sorted() {
    var list = toList();
    list.sort();
    return list;
  }

  /// Creates a string from all the elements separated using [separator] and
  /// using the given [prefix] and [postfix] if supplied.
  ///
  /// If the collection could be huge, you can specify a non-negative value of
  /// [limit], in which case only the first [limit] elements will be appended,
  /// followed by the [truncated] string (which defaults to `'...'`).
  ///
  /// Parameters:
  ///   separator (String): The separator string to use between elements. Defaults to ', '.
  ///   transform (Function(T element)?): An optional function to transform each element to a string.
  ///   prefix (String): A prefix to add before each element. Defaults to an empty string.
  ///   postfix (String): A postfix to add after each element. Defaults to an empty string.
  ///   limit (int): The maximum number of elements to include in the result. Defaults to 0 (no limit).
  ///   truncated (String): A string to append after the last element if the limit is reached. Defaults to '...'.
  ///
  /// Returns:
  ///   String: A string representation of the elements, transformed and separated as specified.
  ///
  /// Example:
  /// ```dart
  /// List<int> numbers = [1, 2, 3, 4, 5];
  /// String result = numbers.joinToString(separator: "; ", prefix: "<", postfix: ">");
  /// // Output: "<1>; <2>; <3>; <4>; <5>"
  /// ```

  String joinToString({
    String separator = ', ',
    String Function(T element)? transform,
    String prefix = '',
    String postfix = '',
    int limit = 0,
    String truncated = '...',
  }) {
    var buffer = StringBuffer();
    var count = 0;
    for (var element in this) {
      if (limit > 0 && count >= limit) {
        buffer.write(truncated);
        break;
      }
      if (count > 0) {
        buffer.write(separator);
      }
      buffer.write(prefix);
      if (transform != null) {
        buffer.write(transform(element));
      } else {
        buffer.write(element.toString());
      }
      buffer.write(postfix);
      count++;
    }
    return buffer.toString();
  }

  /// Calculates the sum of the selected values from all elements in the collection.
  ///
  /// Applies the [selector] function to each element of the collection to obtain a numeric value
  /// and then sums these values to produce a cumulative result.
  ///
  /// Parameters:
  ///   selector (Function(T element)): A function that maps each element to a numeric value to be summed.
  ///
  /// Returns:
  ///   double: The sum of the selected values from all elements in the collection.
  ///
  /// Example:
  /// ```dart
  /// List<int> numbers = [1, 2, 3, 4, 5];
  /// double result = numbers.sumBy((n) => n * 2); // Output: 30.0, as it sums 2, 4, 6, 8, and 10
  /// ```

  double sumBy(num selector(T element)) {
    double sum = 0.0;
    for (var current in this) {
      sum += selector(current);
    }

    return sum;
  }

  /// Calculates the average of the selected values from all elements in the collection.
  ///
  /// Applies the [selector] function to each element of the collection to obtain a numeric value
  /// and then computes the average of these values.
  ///
  /// Parameters:
  ///   selector (Function(T element)): A function that maps each element to a numeric value for averaging.
  ///
  /// Returns:
  ///   double: The average of the selected values from all elements in the collection.
  ///
  /// Throws:
  ///   StateError: If the collection is empty.
  ///
  /// Example:
  /// ```dart
  /// List<int> numbers = [1, 2, 3, 4, 5];
  /// double result = numbers.averageBy((n) => n); // Output: 3.0
  /// ```
  ///
  /// Note:
  /// The function throws a StateError if called on an empty collection, as an average cannot be calculated in this case.

  double averageBy(num selector(T element)) {
    var count = 0;
    num sum = 0;

    for (var current in this) {
      sum += selector(current);
      count++;
    }

    if (count == 0) {
      throw StateError('No elements in collection');
    }

    return sum / count;
  }

  /// Returns the smallest element or `null` if there are no elements.
  ///
  /// All elements must be of type [Comparable].
  T min() => _minMax(-1);

  /// Returns the first element yielding the smallest value of the given
  /// [selector] or `null` if there are no elements.
  T minBy(Comparable selector(T element)) => _minMaxBy(-1, selector);

  /// Returns the first element having the smallest value according to the
  /// provided [comparator] or `null` if there are no elements.
  T minWith(Comparator<T> comparator) => _minMaxWith(-1, comparator);

  /// Returns the largest element or `null` if there are no elements.
  ///
  /// All elements must be of type [Comparable].
  T max() => _minMax(1);

  /// Returns the first element yielding the largest value of the given
  /// [selector] or `null` if there are no elements.
  T maxBy(Comparable selector(T element)) => _minMaxBy(1, selector);

  /// Returns the first element having the largest value according to the
  /// provided [comparator] or `null` if there are no elements.
  T maxWith(Comparator<T> comparator) => _minMaxWith(1, comparator);

  T _minMax(int order) {
    var it = iterator;
    it.moveNext();
    var currentMin = it.current;

    while (it.moveNext()) {
      if ((it.current as Comparable).compareTo(currentMin) == order) {
        currentMin = it.current;
      }
    }

    return currentMin;
  }

  T _minMaxBy(int order, Comparable selector(T element)) {
    var it = iterator;
    it.moveNext();

    var currentMin = it.current;
    var currentMinValue = selector(it.current);
    while (it.moveNext()) {
      var comp = selector(it.current);
      if (comp.compareTo(currentMinValue) == order) {
        currentMin = it.current;
        currentMinValue = comp;
      }
    }

    return currentMin;
  }

  T _minMaxWith(int order, Comparator<T> comparator) {
    var it = iterator;
    it.moveNext();
    var currentMin = it.current;

    while (it.moveNext()) {
      if (comparator(it.current, currentMin) == order) {
        currentMin = it.current;
      }
    }

    return currentMin;
  }

  /// Returns a new iterable with the elements of this iterable in reverse order.
  ///
  /// This getter checks if the current iterable is a list. If it is, it directly
  /// returns the reversed list. Otherwise, it converts the iterable to a list
  /// and then returns the reversed list.
  ///
  /// This approach avoids unnecessary list conversions if the iterable is already a list.
  ///
  /// Returns:
  ///   Iterable<T>: An iterable with the elements of the original iterable in reverse order.
  ///
  /// Example:
  /// ```dart
  /// List<int> numbers = [1, 2, 3, 4, 5];
  /// Iterable<int> reversedNumbers = numbers.reversed;
  /// print(reversedNumbers); // Output: (5, 4, 3, 2, 1)
  /// ```
  ///
  /// Note:
  /// The returned iterable is lazily evaluated, meaning it reverses the elements
  /// only when they are iterated over.

  Iterable<T> get reversed {
    return this is List<T> ? (this as List<T>).reversed : toList().reversed;
  }

  /// Returns a new list containing the first [n] elements from this iterable.
  ///
  /// This function checks if the current iterable is already a list. If it is, it operates directly on it.
  /// Otherwise, it converts the iterable to a list and then returns the first [n] elements.
  /// If [n] is greater than the length of the iterable, it returns as many elements as available.
  ///
  /// Parameters:
  ///   n (int): The number of elements to take from the beginning of the iterable.
  ///
  /// Returns:
  ///   List<T>: A new list containing the first [n] elements of the iterable.
  ///
  /// Throws:
  ///   ArgumentError: If [n] is negative.
  ///
  /// Example:
  /// ```dart
  /// List<int> numbers = [1, 2, 3, 4, 5];
  /// List<int> firstThree = numbers.takeFirst(3); // Returns [1, 2, 3]
  /// ```
  ///
  /// Note:
  /// If [n] is 0, an empty list is returned. If [n] is greater than the number of elements in the iterable,
  /// all elements are returned without causing an error.

  List<T> takeFirst(int n) {
    if (n < 0) {
      throw ArgumentError('Negative value not allowed for n: $n');
    }

    var list = this is List<T> ? this as List<T> : toList();
    int end = n < list.length ? n : list.length;
    return list.sublist(0, end);
  }

  /// Returns a new list containing the last [n] elements from this iterable.
  ///
  /// This function checks if the current iterable is already a list. If it is, it operates directly on it.
  /// Otherwise, it converts the iterable to a list and then returns the last [n] elements.
  /// If [n] is greater than the length of the iterable, it returns as many elements as available.
  ///
  /// Parameters:
  ///   n (int): The number of elements to take from the end of the iterable.
  ///
  /// Returns:
  ///   List<T>: A new list containing the last [n] elements of the iterable.
  ///
  /// Throws:
  ///   ArgumentError: If [n] is negative.
  ///
  /// Example:
  /// ```dart
  /// List<int> numbers = [1, 2, 3, 4, 5];
  /// List<int> lastTwo = numbers.takeLast(2); // Returns [4, 5]
  /// ```
  ///
  /// Note:
  /// If [n] is 0, an empty list is returned. If [n] is greater than the number of elements in the iterable,
  /// all elements are returned without causing an error.

  List<T> takeLast(int n) {
    if (n < 0) {
      throw ArgumentError('Negative value not allowed for n: $n');
    }

    var list = this is List<T> ? this as List<T> : toList();
    int start = n < list.length ? list.length - n : 0;
    return list.sublist(start);
  }

  /// Yields elements from the iterable as long as the [predicate] condition is met.
  ///
  /// This function iterates over the elements of the iterable. For each element,
  /// it checks the given [predicate] function. If the [predicate] returns `true`,
  /// the element is yielded. The iteration stops as soon as the [predicate] returns `false`.
  ///
  /// Parameters:
  ///   predicate (Function(T element)): A function that takes an element as input
  ///    and returns a boolean. If it returns `true`,
  ///    the element is included in the result.
  ///
  /// Returns:
  ///   Iterable<T>: An iterable containing the elements from the start of the original
  ///                iterable up to (but not including) the first element for which
  ///                the [predicate] returns `false`.
  ///
  /// Example:
  /// ```dart
  /// List<int> numbers = [1, 2, 3, 4, 5];
  /// Iterable<int> result = numbers.firstWhile((n) => n < 4); // Yields [1, 2, 3]
  /// ```
  ///
  /// Note:
  /// The returned iterable is lazy. Elements are only processed when they are
  /// iterated over.

  Iterable<T> firstWhile(bool predicate(T element)) sync* {
    for (var element in this) {
      if (!predicate(element)) break;
      yield element;
    }
  }

  /// Yields elements from the end of the iterable as long as the [predicate] condition is met.
  ///
  /// This function iterates over the elements of the iterable in reverse order. For each element,
  /// it checks the given [predicate] function. If the [predicate] returns `true`,
  /// the element is added to a queue. The iteration stops as soon as the [predicate] returns `false`.
  /// The elements are then returned in their original order.
  ///
  /// Parameters:
  ///   predicate (Function(T element)): A function that takes an element as input
  ///    and returns a boolean. If it returns `true`,
  ///    the element is included in the result.
  ///
  /// Returns:
  ///   Iterable<T>: An iterable containing the elements from the end of the original
  ///                iterable up to (but not including) the first element (from the end)
  ///                for which the [predicate] returns `false`.
  ///
  /// Example:
  /// ```dart
  /// List<int> numbers = [1, 2, 3, 4, 5];
  /// Iterable<int> result = numbers.lastWhile((n) => n > 2); // Yields [3, 4, 5]
  /// ```
  ///
  /// Note:
  /// The returned iterable is lazy in its reverse iteration, but the elements are stored
  /// in a `ListQueue` to preserve their original order when returned.

  Iterable<T> lastWhile(bool predicate(T element)) {
    var list = ListQueue<T>();
    for (var element in reversed) {
      if (!predicate(element)) break;
      list.addFirst(element);
    }
    return list;
  }

  /// Returns all elements that satisfy the given [predicate].
  Iterable<T> filterIndexed(bool predicate(T element, int index)) => whereIndexed(predicate);

  /// Appends all elements matching the given [predicate] to the given
  /// [destination].
  void filterTo(List<T> destination, bool predicate(T element)) =>
      whereTo(destination, predicate);

  /// Appends all elements matching the given [predicate] to the given
  /// [destination].
  void filterIndexedTo(List<T> destination, bool predicate(T element, int index)) =>
      whereIndexedTo(destination, predicate);

  /// Returns all elements not matching the given [predicate].
  Iterable<T> filterNotIndexed(bool predicate(T element, int index)) =>
      whereNotIndexed(predicate);

  /// Appends all elements not matching the given [predicate] to the given
  /// [destination].
  void filterNotTo(List<T> destination, bool predicate(T element)) =>
      whereNotTo(destination, predicate);

  /// Appends all elements not matching the given [predicate] to the given
  /// [destination].
  void filterNotToIndexed(List<T> destination, bool predicate(T element, int index)) =>
      whereNotToIndexed(destination, predicate);

  /// Returns a new lazy [Iterable] with all elements which are not null.
  Iterable<T> filterNotNull() => where((element) => element != null);

  /// Returns all elements that satisfy the given [predicate].
  Iterable<T> whereIndexed(bool predicate(T element, int index)) sync* {
    var index = 0;
    for (var element in this) {
      if (predicate(element, index++)) {
        yield element;
      }
    }
  }

  /// Appends all elements that satisfy the given [predicate] to the [destination] list.
  ///
  /// This function iterates over all elements in the iterable. For each element,
  /// it checks if it satisfies the provided [predicate] function. If it does, the element
  /// is added to the provided [destination] list.
  ///
  /// Parameters:
  ///   destination (List<T>): The list to which satisfying elements will be added.
  ///   predicate (Function(T element)): A function that takes an element as input
  ///    and returns a boolean. If it returns `true`,
  ///    the element is added to [destination].
  ///
  /// Example:
  /// ```dart
  /// List<int> numbers = [1, 2, 3, 4, 5];
  /// List<int> evenNumbers = [];
  /// numbers.whereTo(evenNumbers, (n) => n % 2 == 0);
  /// // evenNumbers list now contains [2, 4]
  /// ```
  ///
  /// Note:
  /// This function does not return a value. It modifies the [destination] list by adding
  /// elements to it. Ensure that the [destination] list is modifiable.

  void whereTo(List<T> destination, bool predicate(T element)) {
    for (var element in this) {
      if (predicate(element)) {
        destination.add(element);
      }
    }
  }

  /// Appends all elements that satisfy the given [predicate] (which includes the element's index)
  /// to the [destination] list.
  ///
  /// This function iterates over all elements in the iterable, alongside their indices. For each element,
  /// it checks if it satisfies the provided [predicate] function, which includes the element and its index.
  /// If it does, the element is added to the provided [destination] list.
  ///
  /// Parameters:
  ///   destination (List<T>): The list to which elements satisfying the predicate will be added.
  ///   predicate (Function(T element, int index)): A function that takes an element and its index as input
  ///    and returns a boolean. If it returns `true`,
  ///    the element is added to [destination].
  ///
  /// Example:
  /// ```dart
  /// List<String> words = ['apple', 'banana', 'apricot', 'avocado'];
  /// List<String> aWords = [];
  /// words.whereIndexedTo(aWords, (word, index) => word.startsWith('a') && index < 3);
  /// // aWords list now contains ['apple', 'apricot']
  /// ```
  ///
  /// Note:
  /// This function does not return a value. It modifies the [destination] list by adding
  /// elements to it. Ensure that the [destination] list is modifiable.

  void whereIndexedTo(List<T> destination, bool predicate(T element, int index)) {
    var index = 0;
    for (var element in this) {
      if (predicate(element, index++)) {
        destination.add(element);
      }
    }
  }

  /// Yields all elements of the iterable for which the [predicate] returns `false`.
  ///
  /// This function iterates over the elements of the iterable. For each element,
  /// it checks the given [predicate] function. If the [predicate] returns `false`,
  /// the element is yielded. Essentially, it filters out elements for which the
  /// [predicate] returns `true`.
  ///
  /// Parameters:
  ///   predicate (Function(T element)): A function that takes an element as input
  ///    and returns a boolean. If it returns `false`,
  ///    the element is included in the result.
  ///
  /// Returns:
  ///   Iterable<T>: An iterable containing elements for which the [predicate] returned `false`.
  ///
  /// Example:
  /// ```dart
  /// List<int> numbers = [1, 2, 3, 4, 5];
  /// Iterable<int> nonEvenNumbers = numbers.whereNot((n) => n % 2 == 0); // Yields [1, 3, 5]
  /// ```
  ///
  /// Note:
  /// The returned iterable is lazy. Elements are only processed when they are
  /// iterated over.

  Iterable<T> whereNot(bool predicate(T element)) sync* {
    for (var element in this) {
      if (!predicate(element)) {
        yield element;
      }
    }
  }

  /// Yields all elements of the iterable for which the [predicate] (including the element's index) returns `false`.
  ///
  /// This function iterates over the elements of the iterable, along with their indices. For each element,
  /// it checks the given [predicate] function. If the [predicate] returns `false`,
  /// the element is yielded. It effectively filters out elements for which the
  /// [predicate] (considering the element and its index) returns `true`.
  ///
  /// Parameters:
  ///   predicate (Function(T element, int index)):
  ///
  ///   A function that takes an element and its index as input
  ///   and returns a boolean. If it returns `false`,
  ///   the element is included in the result.
  ///
  /// Returns:
  ///   Iterable<T>: An iterable containing elements for which the [predicate] returned `false`.
  ///
  /// Example:
  /// ```dart
  /// List<int> numbers = [1, 2, 3, 4, 5];
  /// Iterable<int> nonEvenIndexedNumbers = numbers.whereNotIndexed((n, index) => index % 2 == 0); // Yields [2, 4]
  /// ```
  ///
  /// Note:
  /// The returned iterable is lazy. Elements are only processed when they are
  /// iterated over. This makes the function efficient for large iterables or when the full list of
  /// filtered elements is not needed all at once.

  Iterable<T> whereNotIndexed(bool predicate(T element, int index)) sync* {
    var index = 0;
    for (var element in this) {
      if (!predicate(element, index++)) {
        yield element;
      }
    }
  }

  /// Appends all elements not matching the given [predicate] to the given [destination].
  ///
  /// Iterates over the elements of the iterable and checks the [predicate] function for each element.
  /// If the [predicate] returns `false`, the element is added to the [destination] list.
  /// This is effectively the inverse of a filter operation, where elements that do not satisfy
  /// the predicate are collected.
  ///
  /// Parameters:
  ///   destination (List<T>): The list to which elements that do not match the predicate will be added.
  ///   predicate (Function(T element)): A function that takes an element as input and returns a boolean.
  ///   If it returns `false`, the element is added to [destination].
  ///
  /// Example:
  /// ```dart
  /// List<int> numbers = [1, 2, 3, 4, 5];
  /// List<int> nonEvenNumbers = [];
  /// numbers.whereNotTo(nonEvenNumbers, (n) => n % 2 == 0);
  /// // nonEvenNumbers now contains [1, 3, 5]
  /// ```
  ///
  /// Note:
  /// The function modifies the [destination] list in place, adding elements to it.
  /// Ensure that the [destination] list is modifiable and initialized.

  void whereNotTo(List<T> destination, bool predicate(T element)) {
    for (var element in this) {
      if (!predicate(element)) {
        destination.add(element);
      }
    }
  }

  /// Appends all elements not matching the given [predicate] (which includes the element's index)
  /// to the given [destination].
  ///
  /// Iterates over the elements of the iterable, alongside their indices. For each element,
  /// checks the [predicate] function, which includes the element and its index.
  /// If the [predicate] returns `false`, the element is added to the [destination] list.
  /// This method is the inverse of a filtered indexed collection operation,
  /// where elements that do not satisfy the predicate are collected.
  ///
  /// Parameters:
  ///   destination (List<T>): The list to which elements that do not match the predicate will be added.
  ///   predicate (Function(T element, int index)): A function that takes an element and its index as input
  ///    and returns a boolean. If it returns `false`,
  ///    the element is added to [destination].
  ///
  /// Example:
  /// ```dart
  /// List<String> words = ['apple', 'banana', 'cherry', 'date'];
  /// List<String> nonCherryWords = [];
  /// words.whereNotToIndexed(nonCherryWords, (word, index) => word == 'cherry' && index == 2);
  /// // nonCherryWords now contains ['apple', 'banana', 'date']
  /// ```
  ///
  /// Note:
  /// The function modifies the [destination] list in place by adding elements to it.
  /// Ensure that the [destination] list is modifiable and initialized.

  void whereNotToIndexed(List<T> destination, bool predicate(T element, int index)) {
    var index = 0;
    for (var element in this) {
      if (!predicate(element, index++)) {
        destination.add(element);
      }
    }
  }

  /// Returns a new lazy [Iterable] containing all elements of this collection
  /// that are not `null`.
  ///
  /// This method filters the elements of the collection and includes only those
  /// elements that are not `null` in the resulting iterable.
  ///
  /// - Returns: A new lazy [Iterable] containing all elements of this collection
  ///   that are not `null`.
  ///
  /// - Example:
  ///   ```dart
  ///   Iterable<String?> words = ['apple', null, 'banana', null, 'cherry'];
  ///   Iterable<String> nonNullWords = words.whereNotNull();
  ///
  ///   print(nonNullWords); // Output: ['apple', 'banana', 'cherry']
  ///   ```
  ///
  /// Note:
  /// This method creates a new lazy [Iterable] and does not modify the original
  /// collection. It allows you to filter out `null` elements from the collection.

  Iterable<T> whereNotNull() => where((element) => element != null);

  /// Returns a new lazy [Iterable] containing the non-null results of applying
  /// the given [transform] function to each element of this collection.
  ///
  /// The [transform] function is invoked for each element in the collection, and
  /// its result is included in the resulting iterable only if it is not `null`.
  ///
  /// - Parameters:
  ///   - transform: A function that takes an element of type [T] and returns a
  ///     result of type [R].
  ///
  /// - Returns: A new lazy [Iterable] containing the non-null results of applying
  ///   the [transform] function to each element of this collection.
  ///
  /// - Example:
  ///   ```dart
  ///   Iterable<String> words = ['apple', 'banana', 'cherry'];
  ///   Iterable<int> wordLengths = words.mapNotNull((word) {
  ///     if (word.length > 5) {
  ///       return word.length;
  ///     } else {
  ///       return null;
  ///     }
  ///   });
  ///
  ///   print(wordLengths); // Output: [6, 6]
  ///   ```
  ///
  /// Note:
  /// This method creates a new lazy [Iterable] and does not modify the original
  /// collection. It allows you to filter out `null` results from the transformation.

  Iterable<R> mapNotNull<R>(R transform(T element)) sync* {
    for (var element in this) {
      var result = transform(element);
      if (result != null) {
        yield result;
      }
    }
  }

  /// Returns a new lazy [Iterable] containing only the non-null results of
  /// applying the given [transform] function to each element in the original
  /// collection.

  /// Returns a new lazy [Iterable] containing the results of applying the given
  /// [transform] function to each element of this collection, where the function
  /// takes two arguments: the index of the current element and the element itself.
  ///
  /// The [transform] function is invoked for each element in the collection with
  /// two arguments: the index of the current element and the element itself.
  /// The result of the [transform] function is included in the resulting iterable.
  ///
  /// - Parameters:
  ///   - transform: A function that takes an integer index and an element of type
  ///     [T] and returns a result of type [R].
  ///
  /// - Returns: A new lazy [Iterable] containing the results of applying the
  ///   [transform] function to each element of this collection.
  ///
  /// - Example:
  ///   ```dart
  ///   Iterable<String> fruits = ['apple', 'banana', 'cherry'];
  ///   Iterable<String> upperCaseFruits = fruits.mapIndexed((index, fruit) {
  ///     return '$index: ${fruit.toUpperCase()}';
  ///   });
  ///
  ///   print(upperCaseFruits); // Output: ['0: APPLE', '1: BANANA', '2: CHERRY']
  ///   ```
  ///
  /// Note:
  /// This method creates a new lazy [Iterable] and does not modify the original
  /// collection. It allows you to transform elements based on their index within
  /// the collection.

  Iterable<R> mapIndexed<R>(R Function(int index, T) transform) sync* {
    var index = 0;
    for (var element in this) {
      yield transform(index++, element);
    }
  }

  /// Returns a new lazy [Iterable] containing the results of applying the given
  /// [transform] function to each element of this collection, where the function
  /// takes two arguments: the index of the current element and the element
  /// itself, and filters out the elements for which the [transform] function
  /// returns `null`.
  ///
  /// The [transform] function is invoked for each element in the collection with
  /// two arguments: the index of the current element and the element itself.
  /// If the result of the [transform] function is not `null`, it is included in
  /// the resulting iterable; otherwise, it is skipped.
  ///
  /// - Parameters:
  ///   - transform: A function that takes an integer index and an element of type
  ///     [T] and returns a result of type [R] or `null`.
  ///
  /// - Returns: A new lazy [Iterable] containing the non-null results of applying
  ///   the [transform] function to each element of this collection.
  ///
  /// - Example:
  ///   ```dart
  ///   Iterable<String?> words = ['apple', 'banana', 'cherry'];
  ///   Iterable<String> validWords = words.mapIndexedNotNull((index, word) {
  ///     if (index % 2 == 0) {
  ///       return word.toUpperCase();
  ///     } else {
  ///       return null;
  ///     }
  ///   });
  ///
  ///   print(validWords); // Output: [APPLE, CHERRY]
  ///   ```
  ///
  /// Note:
  /// This method creates a new lazy [Iterable] and does not modify the original
  /// collection. It allows you to transform and filter elements based on their
  /// index within the collection.

  Iterable<R> mapIndexedNotNull<R>(R Function(int index, T) transform) sync* {
    var index = 0;
    for (var element in this) {
      final result = transform(index++, element);
      if (result != null) {
        yield result;
      }
    }
  }

  /// Invokes the specified [action] for each element in the iterable and returns
  /// a new lazy iterable that yields the same elements.
  ///
  /// This method is useful for performing a side effect (such as printing or
  /// logging) for each element in the iterable while maintaining the original
  /// order of elements.
  ///
  /// - Parameters:
  ///   - action: The function to be invoked for each element in the iterable.
  ///
  /// - Returns: A new lazy [Iterable] that yields the same elements as the
  ///   original iterable, but with the specified [action] invoked for each
  ///   element.
  ///
  /// - Example:
  ///   ```dart
  ///   Iterable<int> numbers = [1, 2, 3, 4, 5];
  ///   Iterable<int> squaredNumbers = numbers.onEach((element) {
  ///     print('Processing: $element');
  ///   }).map((element) => element * element);
  ///   ```
  ///
  /// Note:
  /// This method does not modify the original iterable. It creates a new lazy
  /// iterable that applies the specified [action] to each element and yields the
  /// same elements as the original iterable.

  Iterable<T> onEach(void action(T element)) sync* {
    for (var element in this) {
      action(element);
      yield element;
    }
  }

  /// Returns a new lazy [Iterable] containing only distinct elements.
  ///
  /// This method filters the current iterable, ensuring that only unique elements
  /// are included in the resulting iterable. The order of elements is preserved.
  ///
  /// - Returns: A new lazy [Iterable] containing only distinct elements.
  ///
  /// - Examples:
  ///   ```dart
  ///   Iterable<int> numbers = [1, 2, 2, 3, 4, 4, 5];
  ///   Iterable<int> distinctNumbers = numbers.distinct();
  ///   print(distinctNumbers); // [1, 2, 3, 4, 5]
  ///   ```
  ///
  /// Note:
  /// This method does not modify the original iterable. It creates a new lazy
  /// iterable with distinct elements from the original iterable while preserving
  /// their order.

  Iterable<T> distinct() sync* {
    var existing = HashSet<T>();
    for (var current in this) {
      if (existing.add(current)) {
        yield current;
      }
    }
  }

  /// Returns a new lazy [Iterable] where elements are grouped into chunks of a
  /// specified [size].
  ///
  /// This method splits the current iterable into chunks, each containing up to
  /// [size] elements. The resulting iterable consists of lists, where each list
  /// represents a chunk of elements from the original iterable. If the last chunk
  /// contains fewer than [size] elements, it will be included as is.
  ///
  /// - Parameters:
  ///   - [size]: The maximum number of elements in each chunk. It should be greater
  ///     than or equal to 1.
  ///
  /// - Returns: A new lazy [Iterable] where elements are grouped into chunks of
  ///   the specified [size].
  ///
  /// - Throws:
  ///   - [ArgumentError]: If the requested [size] is less than 1.
  ///
  /// - Examples:
  ///   ```dart
  ///   Iterable<int> numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  ///   Iterable<List<int>> chunks = numbers.chunked(3);
  ///   print(chunks); // [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
  ///   ```
  ///
  /// Note:
  /// This method does not modify the original iterable. It creates a new lazy
  /// iterable with chunks of elements from the original iterable.

  Iterable<List<T>> chunked(int size) sync* {
    if (size < 1) {
      throw ArgumentError('Requested chunk size $size is less than one.');
    }

    var currentChunk = <T>[];
    for (var current in this) {
      currentChunk.add(current);
      if (currentChunk.length >= size) {
        yield currentChunk;
        currentChunk = <T>[];
      }
    }
    if (currentChunk.isNotEmpty) {
      yield currentChunk;
    }
  }

  /// Returns a new lazy [Iterable] containing elements yielded from the results
  /// of the [transform] function being invoked on each element of this collection.
  ///
  /// This method applies the [transform] function to each element of the current
  /// iterable and yields all the elements from the resulting iterables. The
  /// resulting iterable is a flat collection of all the elements produced by the
  /// [transform] function.
  ///
  /// - Parameters:
  ///   - [transform]: A function that takes an element of the collection and returns
  ///     an iterable of elements of type [R].
  ///
  /// - Returns: A new lazy [Iterable] with elements yielded from the [transform] function.
  ///
  /// - Examples:
  ///   ```dart
  ///   Iterable<String> words = ['hello', 'world'];
  ///   Iterable<String> letters = words.flatMap((word) => word.split(''));
  ///   print(letters); // ['h', 'e', 'l', 'l', 'o', 'w', 'o', 'r', 'l', 'd']
  ///   ```
  ///
  /// Note:
  /// This method does not modify the original iterable. It creates a new lazy iterable
  /// with the flattened elements produced by the [transform] function, leaving the
  /// original iterable unchanged.

  Iterable<R> flatMap<R>(Iterable<R> transform(T element)) sync* {
    for (var current in this) {
      yield* transform(current);
    }
  }

  /// Returns a new lazy [Iterable] where all elements of nested [Iterable]s are flattened.
  ///
  /// This method iterates over each element of the current iterable and flattens
  /// any nested [Iterable]s by yielding their individual elements. The resulting
  /// iterable contains all elements in a flat structure.
  ///
  /// - Returns: A new lazy [Iterable] with flattened elements.
  ///
  /// - Examples:
  ///   ```dart
  ///   Iterable<List<int>> nestedList = [[1, 2], [3, 4, 5], [6]];
  ///   Iterable<int> flattenedList = nestedList.flatten();
  ///   print(flattenedList); // [1, 2, 3, 4, 5, 6]
  ///   ```
  ///
  /// Note:
  /// This method does not modify the original iterable. It creates a new lazy iterable
  /// with the flattened elements, leaving the original iterable unchanged.

  Iterable<dynamic> flatten() sync* {
    for (var current in this) {
      yield* (current as Iterable);
    }
  }

  /// Creates an iterable that cycles through the elements of this iterable.
  ///
  /// If [n] is provided and greater than 0, the returned iterable cycles through
  /// the elements of this iterable [n] times. If [n] is 0 or not provided, the iterable
  /// cycles infinitely.
  ///
  /// Parameters:
  ///   n (int, optional): The number of times to cycle through the iterable. Defaults to 0,
  ///                      indicating an infinite cycle.
  ///
  /// Returns:
  ///   Iterable<T>: An iterable that cycles through the elements.
  ///
  /// Example:
  /// ```dart
  /// List<int> numbers = [1, 2, 3];
  /// Iterable<int> cycledNumbers = numbers.cycle(2); // Cycles through [1, 2, 3, 1, 2, 3]
  /// ```
  ///
  /// Note:
  /// The returned iterable is lazy. Elements are only processed as they are iterated over.

  Iterable<T> cycle([int n = 0]) sync* {
    if (isEmpty) return;

    if (n <= 0) {
      // Infinite cycle
      while (true) {
        for (var element in this) {
          yield element;
        }
      }
    } else {
      // Cycle n times
      for (int i = 0; i < n; i++) {
        for (var element in this) {
          yield element;
        }
      }
    }
  }

  /// Yields elements from this iterable that are not present in the [elements] iterable.
  ///
  /// Iterates over each element in the current iterable. If an element is not found
  /// in the provided [elements] iterable, it is yielded.
  ///
  /// Parameters:
  ///   elements (Iterable<T>): An iterable containing elements to be excluded.
  ///
  /// Returns:
  ///   Iterable<T>: An iterable containing elements from the current iterable that are
  ///                not in the [elements] iterable.
  ///
  /// Example:
  /// ```dart
  /// List<int> numbers = [1, 2, 3, 4, 5];
  /// List<int> exclude = [2, 3];
  /// Iterable<int> result = numbers.except(exclude); // Yields [1, 4, 5]
  /// ```
  ///
  /// Note:
  /// The returned iterable is lazy. Elements are only processed when they are
  /// iterated over.

  Iterable<T> except(Iterable<T> elements) sync* {
    for (var current in this) {
      if (!elements.contains(current)) {
        yield current;
      }
    }
  }

  /// Returns a new list of elements from this iterable with the elements from [elements] excluded.
  ///
  /// This operator method uses the `except` method to create an iterable that excludes
  /// elements found in the [elements] iterable, and then converts it to a list.
  ///
  /// Parameters:
  ///   elements (Iterable<T>): An iterable of elements to be excluded from the original iterable.
  ///
  /// Returns:
  ///   List<T>: A new list containing elements from the current iterable with the elements
  ///            from [elements] excluded.
  ///
  /// Example:
  /// ```dart
  /// List<int> numbers = [1, 2, 3, 4, 5];
  /// List<int> exclude = [2, 3];
  /// List<int> result = numbers - exclude; // Returns [1, 4, 5]
  /// ```
  ///
  /// Note:
  /// The returned list is a new instance and does not modify the original iterable.

  List<T> operator -(Iterable<T> elements) => except(elements).toList();

  /// Yields elements from this iterable that are not equal to the specified [element].
  ///
  /// Iterates over each element in the current iterable. If an element is not equal
  /// to the provided [element], it is yielded.
  ///
  /// Parameters:
  ///   element (T): An element to be excluded from the resulting iterable.
  ///
  /// Returns:
  ///   Iterable<T>: An iterable containing elements from the current iterable that are
  ///                not equal to the [element].
  ///
  /// Example:
  /// ```dart
  /// List<int> numbers = [1, 2, 3, 4, 5];
  /// Iterable<int> result = numbers.exceptElement(3); // Yields [1, 2, 4, 5]
  /// ```
  ///
  /// Note:
  /// The returned iterable is lazy. Elements are only processed when they are
  /// iterated over.

  Iterable<T> exceptElement(T element) sync* {
    for (var current in this) {
      if (element != current) {
        yield current;
      }
    }
  }

  /// Checks if the [index] is within the bounds of the iterable.
  ///
  /// This method verifies whether the iterable contains an element at the specified [index].
  /// It iterates over the iterable until it reaches the specified index or the end of the iterable,
  /// which is more efficient than converting the iterable to a list or map.
  ///
  /// This approach is particularly useful for large iterables as it avoids creating new collections.
  ///
  /// - Parameters:
  ///   - `index`: The index to check within the iterable.
  ///
  /// - Returns: A boolean value, `true` if the index is within the bounds of the iterable;
  ///            otherwise, `false`.
  ///
  /// - Examples:
  ///   ```dart
  ///   List<int> numbers = [10, 20, 30, 40, 50];
  ///   bool exists = numbers.keyInList(2); // true, since index 2 (element 30) exists
  ///   bool notExists = numbers.keyInList(5); // false, since index 5 does not exist
  ///   ```
  bool keyInList(int index) {
    int count = 0;
    for (var _ in this) {
      if (count == index) {
        return true;
      }
      count++;
    }
    return false;
  }

  /// Returns a new lazy [Iterable] that appends the given [elements] iterable to this iterable.
  ///
  /// The returned [Iterable] lazily yields all elements of this iterable first,
  /// followed by all elements of the [elements] iterable. This method allows for
  /// efficient concatenation of two iterables without eagerly evaluating them.
  ///
  /// - Parameters:
  ///   - `elements`: The iterable of elements to append to this iterable.
  ///
  /// - Returns: A new lazy [Iterable] that contains all elements of this iterable,
  ///            followed by all elements of the [elements] iterable.
  ///
  /// - Examples:
  ///   ```dart
  ///   List<int> firstList = [1, 2, 3];
  ///   List<int> secondList = [4, 5, 6];
  ///   Iterable<int> concatenated = firstList + secondList;
  ///   Iterable<int> concatenated = firstList.append(secondList);
  ///   print(concatenated.toList()); // [1, 2, 3, 4, 5, 6]
  ///   ```
  List<T> operator +(Iterable<T> elements) => append(elements).toList();
  Iterable<T> append(Iterable<T> elements) sync* {
    yield* this;
    yield* elements;
  }

  /// Returns a new lazy [Iterable] that represents the union of this iterable and the [other] iterable.
  ///
  /// The returned [Iterable] lazily yields unique elements from both iterables.
  /// It uses a [HashSet] to track existing elements and ensure each element is yielded only once,
  /// effectively removing duplicates.
  ///
  /// - Parameters:
  ///   - `other`: The iterable to be combined with this iterable.
  ///
  /// - Returns: A new lazy [Iterable] containing the unique elements from both this iterable and the [other] iterable.
  ///
  /// - Examples:
  ///   ```dart
  ///   List<int> firstList = [1, 2, 3];
  ///   List<int> secondList = [2, 3, 4];
  ///   Iterable<int> unionSet = firstList.union(secondList);
  ///   print(unionSet.toList()); // [1, 2, 3, 4]
  ///   ```
  ///
  /// Note:
  /// The function does not preserve the order of elements. Elements are yielded in the order they
  /// are encountered without duplicates.

  Iterable<T> union(Iterable<T> other) sync* {
    var existing = HashSet<T>();
    for (var element in this) {
      if (existing.add(element)) yield element;
    }

    for (var element in other) {
      if (existing.add(element)) yield element;
    }
  }

  /// Returns a new lazy [Iterable] containing all elements of this collection.
  ///
  /// This method uses a generator (`sync*`) to yield each element of the current collection.
  /// It's useful for converting collections like [Set] or [List] to [Iterable] with lazy evaluation.
  ///
  /// - Returns: A new lazy [Iterable] containing all elements of the current collection.
  ///
  /// - Examples:
  ///   ```dart
  ///   List<int> numbers = [1, 2, 3];
  ///   Iterable<int> iterableNumbers = numbers.toIterable();
  ///   print(iterableNumbers); // Iterable containing 1, 2, 3
  ///   ```
  ///
  /// Note:
  /// The returned [Iterable] is lazy, meaning it only processes elements as they are iterated over.
  /// This is useful for potentially large collections where you want to avoid immediate evaluation.

  Iterable<T> toIterable() sync* {
    yield* this;
  }

  /// Creates a new [HashSet] containing all the elements of this iterable.
  ///
  /// This method provides an easy way to convert an iterable into a [HashSet].
  /// A [HashSet] is a collection of unique items which does not preserve the order of elements.
  ///
  /// - Returns: A [HashSet] containing all the unique elements of this iterable.
  ///
  /// - Examples:
  ///   ```dart
  ///   List<int> numbers = [1, 2, 3, 2, 1];
  ///   HashSet<int> uniqueNumbers = numbers.toHashSet();
  ///   print(uniqueNumbers); // HashSet containing 1, 2, 3
  ///   ```
  ///
  /// Note:
  /// The [HashSet] will only contain unique elements. If the iterable has duplicates,
  /// they will be removed in the resulting [HashSet].

  HashSet<T> toHashSet() => HashSet.from(this);

  /// Creates an unmodifiable [List] containing all the elements of this iterable.
  ///
  /// This method wraps the elements of the current iterable in an [UnmodifiableListView],
  /// which prevents any modifications to the list such as adding, removing, or updating the elements.
  ///
  /// - Returns: An [UnmodifiableListView] containing all elements of this iterable.
  ///
  /// - Examples:
  ///   ```dart
  ///   List<int> numbers = [1, 2, 3];
  ///   List<int> unmodifiableNumbers = numbers.toUnmodifiable();
  ///   print(unmodifiableNumbers); // UnmodifiableListView containing 1, 2, 3
  ///   ```
  ///
  /// Note:
  /// The returned list is a view of the original iterable. Any changes to the underlying
  /// iterable are reflected in the unmodifiable list. However, the list itself cannot be modified.

  List<T> toUnmodifiable() => UnmodifiableListView(this);

  /// Returns a new [List] containing all elements of this iterable in a random order.
  ///
  /// This method creates a copy of the elements from the current iterable and shuffles them
  /// using the provided [random] object. The order of the elements in the returned list
  /// will be random.
  ///
  /// - Parameters:
  ///   - random: The [Random] object used to shuffle the elements.
  ///
  /// - Returns: A new [List] containing all elements of this iterable in a random order.
  ///
  /// - Examples:
  ///   ```dart
  ///   List<int> numbers = [1, 2, 3, 4, 5];
  ///   final random = Random();
  ///   List<int> shuffledNumbers = numbers.shuffled(random);
  ///   print(shuffledNumbers); // A random order of the elements in the list.
  ///   ```
  ///
  /// Note:
  /// This method does not modify the original iterable. It creates a shuffled copy
  /// of the elements, leaving the original iterable unchanged.

  List<T> shuffled(Random random) => toList()..shuffle(random);
}

![App Icon](https://raw.githubusercontent.com/pud-dev/octopus.extensions/main/platform.png)

**Boost your productivity with powerful and expressive Dart extensions.**

This lightweight package enriches core Dart types like `List`, `Map`, `String`, `num`, and `DateTime` with intuitive, time-saving methods — making your code cleaner, faster to write, and easier to maintain.

Whether you're building apps, scripts, or libraries, `extensions` gives you the fluent utility syntax you've always wanted — no clutter, just results.

> Stop repeating boilerplate logic. Start focusing on what matters.

## Features

- 🧠 Write cleaner and more expressive Dart code with minimal effort.
- 🧩 Dozens of handy extensions for `List`, `Map`, `String`, `DateTime`, `num`, and `Set`.
- 🚀 Reduce boilerplate with concise one-liners for common tasks.
- ✅ Improve readability and maintainability of your codebase.
- 🔄 Chain transformations and filters with fluent-like syntax.
- 🧪 Built-in null-safety and edge-case handling.
- ⚖️ Lightweight and fast — perfect for mobile, backend, or CLI tools.
- 🔧 Fully documented and production-ready.

## Getting started

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  extensions: ^latest
```

Then run:

```bash
flutter pub get
```

or

```bash
dart pub get
```

Import it in your Dart code:

```dart
import 'package:octopusllc/extensions.dart';
```

## Map Extensions

#### mergeWith

```dart
final Map<String, dynamic> settings = {
  'tasks': {'type': 'agent', 'icon': 'add'},
};

final Map<String, dynamic> i18n = {
  'tasks': {'title': 'Tasks'},
  'goals': {'title': 'Goals'},
};

final Map<String, dynamic> merged = settings.mergeWith(i18n);

/* RESULT
{
  'tasks': {'type': 'agent', 'icon': 'add', 'title': 'Tasks'},
  'goals': {'title': 'Goals'},
}
*/
```

#### getByField

```dart
final List<Map<String, dynamic>> users = [
  {'name': 'Alice'},
  {'name': 'Bob'},
  {'name': 'Charlie'},
];

final List<String> names = users.getByField<String>('name');

/* RESULT
[Alice, Bob, Charlie]
*/
```

#### filterByKeys

```dart
final Map<String, dynamic> data = {
  'a': {'value': 1},
  'b': {'value': 2},
};

final Map<String, dynamic> filtered = data.filterByKeys(['b']);

/* RESULT
{'b': {'value': 2'}}
*/
```

#### filterBy

```dart
final Map<String, Map<String, dynamic>> data = {
  'monday': {
    '1': {'type': 'workout'},
    '2': {'type': 'rest'},
  },
};

final Map<String, dynamic> result = data.filterBy('type', 'workout');

/* RESULT
{
  'monday': {
    '1': {'type': 'workout'}
  }
}
*/
```

#### countByField

```dart
final Map<String, Map<String, Map<String, dynamic>>> data = {
  'day1': {
    'e1': {'type': 'meeting'},
    'e2': {'type': 'call'},
  },
  'day2': {
    'e3': {'type': 'meeting'},
  },
};

final Map<String, int> counts = data.countByField('type');

/* RESULT
{'meeting': 2, 'call': 1}
*/
```

#### groupByChildField

```dart
final Map<String, Map<String, String>> colors = {
  'c1': {'group': 'spring'},
  'c2': {'group': 'summer'},
  'c3': {'group': 'spring'},
};

final Map<String, Map<String, Map<String, String>>> grouped = colors.groupByChildField('group');

/* RESULT
{
  'spring': {
    'c1': {'group': 'spring'},
    'c3': {'group': 'spring'}
  },
  'summer': {
    'c2': {'group': 'summer'}
  }
}
*/
```

#### filterByValue

```dart
final Map<String, Map<String, dynamic>> data = {
  '1': {'type': 'goal'},
  '2': {'type': 'task'},
};

final Map<String, Map<String, dynamic>> filtered = data.filterByValue('type', 'goal');

/* RESULT
{'1': {'type': 'goal'}}
*/
```

#### groupByField

```dart
final Map<String, Map<String, Map<String, dynamic>>> data = {
  '1': {
    'a': {'priority': 'high'},
    'b': {'priority': 'low'},
  },
};

final Map<String, List<Map<String, dynamic>>> grouped = data.groupByField('priority');

/* RESULT
{
  'high': [{'priority': 'high'}],
  'low': [{'priority': 'low'}]
}
*/
```

#### stringValuesOnly

```dart
final Map<String, dynamic> map = {
  'created': DateTime(2022, 1, 1),
  'name': 'Alice',
};

final Map<String, dynamic> result = map.stringValuesOnly;

/* RESULT
{created: 2022-01-01 00:00:00.000, name: Alice}
*/
```

#### convertAllValuesToString

```dart
final Map<String, dynamic> data = {
  'name': 'Alice',
  'details': {
    'birthday': DateTime(1990, 1, 1),
  },
};

final Map<String, dynamic> result = data.convertAllValuesToString();

/* RESULT
{
  name: Alice,
  details: {birthday: 1990-01-01T00:00:00.000}
}
*/
```

#### getOptionsAsList

```dart
final Map<String, Map<String, dynamic>> strategies = {
  's1': {'type': 'growth'},
  's2': {'type': 'risk'},
};

final Map<String, List<Map<String, dynamic>>> grouped = strategies.getOptionsAsList(byField: 'type');

/* RESULT
{
  'growth': [{'strategy': 's1'}],
  'risk': [{'strategy': 's2'}]
}
*/
```

#### getBoolList

```dart
final List<int> list = [0, 1, 2];

final List<bool> result = list.getBoolList;

/* RESULT
[true, false, false]
*/
```

#### toBoolList

```dart
final List<int> list = [0, 1, 2];

final List<bool> result = list.toBoolList(trueAtIndex: 1);

/* RESULT
[false, true, false]
*/
```

#### calculateAvarage

```dart
final Map<String, int> data = {'10': 2, '20': 4};

final double average = data.calculateAvarage;

/* RESULT
16.666666666666668
*/
```

#### sumValues

```dart
final Map<String, num> data = {'a': 5, 'b': 10};

final double sum = data.sumValues;

/* RESULT
15.0
*/
```

#### randomEntryByField

```dart
final Map<String, Map<String, dynamic>> data = {
  'x': {'title': 'Alpha'},
  'y': {'title': 'Beta'},
};

final String randomTitle = data.randomEntryByField('title');

/* RESULT
Alpha // or Beta (random)
*/
```

#### reversedKeys

```dart
final Map<String, dynamic> original = {'a': 1, 'b': 2};

final Map<String, dynamic> reversed = original.reversedKeys;

/* RESULT
{'b': 2, 'a': 1}
*/
```

## List Extensions

#### random

```dart
final List<String> greetings = ["Hello!", "Hi!", "Welcome!"];
final String randomGreeting = greetings.random;

/* RESULT
"Hello!" // or "Hi!" or "Welcome!"
*/
```

#### withoutDups

```dart
final List<int> numbers = [1, 2, 3, 1, 4, 2, 5];
final List<int> uniqueNumbers = numbers.withoutDups;

/* RESULT
[1, 2, 3, 4, 5]
*/
```

#### clearSublist

```dart
final List<Map<String, dynamic>> tasks = [
  {'name': 'Task 1', 'checks': [true, false]},
  {'name': 'Task 2', 'checks': [false]}
];

final List<Map<String, dynamic>> cleared = tasks.clearSublist();

/* RESULT
[
  {'name': 'Task 1', 'checks': []},
  {'name': 'Task 2', 'checks': []}
]
*/
```

#### containsMapKey

```dart
final List<Map<String, dynamic>> items = [
  {'id': 1},
  {'name': 'Test'}
];

final bool hasKey = items.containsMapKey({'id': 5});

/* RESULT
true
*/
```

#### firstWhereOrNull

```dart
final List<int> numbers = [1, 3, 5];
final int? even = numbers.firstWhereOrNull((e) => e % 2 == 0);

/* RESULT
null
*/
```

#### containsAny

```dart
final List<int> list = [1, 2, 3];
final bool result = list.containsAny([0, 2]);

/* RESULT
true
*/
```

#### onlyOwned

```dart
class Obj {
  final String ownerUID;
  final String title;
  Obj(this.ownerUID, this.title);
}

final List<Obj> data = [
  Obj('u1', 'A'),
  Obj('u2', 'B'),
  Obj('u1', 'C'),
];

final List<Obj> owned = data.onlyOwned<Obj>('u1');

/* RESULT
[A, C]
*/
```

#### sortedByTimeOnly

```dart
final List<DateTime> times = [
  DateTime(2024, 1, 1, 15),
  DateTime(2024, 1, 1, 9),
];

final List<DateTime> sorted = times.sortedByTimeOnly((t) => t);

/* RESULT
[2024-01-01 09:00:00.000, 2024-01-01 15:00:00.000]
*/
```

#### sumByValue

```dart
final List<Map<String, dynamic>> data = [
  {'value': 5},
  {'value': 10}
];

final double total = data.sumByValue((e) => e['value']);

/* RESULT
15.0
*/
```

#### sortedByValue

```dart
final List<Map<String, dynamic>> data = [
  {'priority': 3},
  {'priority': 1},
];

final sorted = data.sortedByValue((e) => e['priority']);

/* RESULT
[{'priority': 1}, {'priority': 3}]
*/
```

#### groupBy

```dart
final List<Map<String, dynamic>> items = [
  {'type': 'a'},
  {'type': 'b'},
  {'type': 'a'},
];

final grouped = items.groupBy((e) => e['type']);

/* RESULT
{
  'a': [{'type': 'a'}, {'type': 'a'}],
  'b': [{'type': 'b'}]
}
*/
```

#### mapToOptions

```dart
final List<Map<String, dynamic>> items = [
  {'id': 't1', 'title': 'Task'},
  {'id': 't2', 'title': 'Goal'}
];

final mapped = items.mapToOptions('id', 'title');

/* RESULT
{
  't1': {'title': 'Task'},
  't2': {'title': 'Goal'}
}
*/
```

#### slice

```dart
final List<int> nums = [10, 20, 30, 40, 50];
final List<int> mid = nums.slice(1, 3);

/* RESULT
[20, 30, 40]
*/
```

#### takeFirst / takeLast

```dart
final list = [1, 2, 3, 4, 5];
final start = list.takeFirst(2);

/* RESULT
[1, 2]
*/

final end = list.takeLast(2);

/* RESULT
[4, 5]
*/
```

#### second / third / fourth

```dart
final list = [1, 2, 3, 4];

// list.second; /* RESULT 2 */
// list.third;  /* RESULT 3 */
// list.fourth; /* RESULT 4 */
```

#### joinToString

```dart
final list = [1, 2, 3];
final str = list.joinToString(separator: '-', prefix: '[', postfix: ']');

/* RESULT
[1]-[2]-[3]
*/
```

#### flatten

```dart
final list = [
  [1, 2],
  [3],
];

final flat = list.flatten();

/* RESULT
[1, 2, 3]
*/
```

#### chunked

```dart
final list = [1, 2, 3, 4, 5];
final chunks = list.chunked(2);

/* RESULT
[[1, 2], [3, 4], [5]]
*/
```

#### shuffled

```dart
final list = [1, 2, 3];
final result = list.shuffled(Random());

/* RESULT
random order of [1, 2, 3]
*/
```

#### distinctBy

```dart
final list = ['apple', 'banana', 'apple'];
final result = list.distinctBy((e) => e);

/* RESULT
['apple', 'banana']
*/
```

#### min / max

```dart
final list = [5, 2, 9];
final minVal = list.min(); /* RESULT 2 */
final maxVal = list.max(); /* RESULT 9 */
```

#### filterNotNull / mapNotNull

```dart
final list = ['A', null, 'B'];
final filtered = list.filterNotNull();

/* RESULT
['A', 'B']
*/
```

#### toHashSet

```dart
final list = [1, 2, 2, 3];
final set = list.toHashSet();

/* RESULT
{1, 2, 3}
*/
```

#### + and - operators

```dart
final a = [1, 2];
final b = [2, 3];

final union = a + b;

/* RESULT
[1, 2, 2, 3]
*/

final diff = a - b;

/* RESULT
[1]
*/
```



import 'package:coore/src/local_storage/nosql_database/nosql_database_imp.dart';
import 'package:coore/src/local_storage/nosql_database/nosql_database_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import 'path_provider_mock.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Setup mock path provider
  PathProviderPlatform.instance = FakePathProviderPlatform();

  late NoSqlDatabaseInterface db;
  const testBoxName = 'test_box';

  setUp(() async {
    // Initialize Hive with temp directory
    Hive.init('./test_hive');
    db = HiveNoSqlDatabase(testBoxName);
    await db.initialize();
  });

  tearDown(() async {
    await db.close();
    await Hive.deleteBoxFromDisk(testBoxName);
  });

  group('Lifecycle Management', () {
    test('initialize should open box and return success', () async {
      final newDb = HiveNoSqlDatabase('new_test_box');
      final result = await newDb.initialize();

      expect(result.isRight(), isTrue);
      await newDb.close();
      await Hive.deleteBoxFromDisk('new_test_box');
    });

    test(
      'initialize should return same result if called multiple times',
      () async {
        final newDb = HiveNoSqlDatabase('multi_init_box');
        final result1 = await newDb.initialize();
        final result2 = await newDb.initialize();

        expect(result1, equals(result2));
        await newDb.close();
        await Hive.deleteBoxFromDisk('multi_init_box');
      },
    );

    test('close should close box and return success', () async {
      final result = await db.close();
      expect(result.isRight(), isTrue);
    });

    test('deleteFromDisk should delete box from disk', () async {
      final newDb = HiveNoSqlDatabase('delete_test_box');
      await newDb.initialize();
      await newDb.close();

      final result = await newDb.deleteFromDisk();

      expect(result.isRight(), isTrue);
      expect(await Hive.boxExists('delete_test_box'), isFalse);
    });
  });

  group('Write Operations', () {
    test('save should store value and return success', () async {
      final result = await db.save<String>('testKey', 'testValue');

      expect(result.isRight(), isTrue);

      final getValue = await db.get<String>('testKey');
      getValue.fold(
        (failure) => fail('Expected success'),
        (value) => expect(value, equals('testValue')),
      );
    });

    test('save should overwrite existing value', () async {
      await db.save<String>('key', 'value1');
      final result = await db.save<String>('key', 'value2');

      expect(result.isRight(), isTrue);

      final getValue = await db.get<String>('key');
      getValue.fold(
        (failure) => fail('Expected success'),
        (value) => expect(value, equals('value2')),
      );
    });

    test('save should work with different types', () async {
      await db.save<int>('intKey', 42);
      await db.save<bool>('boolKey', true);
      await db.save<double>('doubleKey', 3.14);

      final intResult = await db.get<int>('intKey');
      final boolResult = await db.get<bool>('boolKey');
      final doubleResult = await db.get<double>('doubleKey');

      intResult.fold(
        (failure) => fail('Expected success'),
        (value) => expect(value, equals(42)),
      );
      boolResult.fold(
        (failure) => fail('Expected success'),
        (value) => expect(value, equals(true)),
      );
      doubleResult.fold(
        (failure) => fail('Expected success'),
        (value) => expect(value, equals(3.14)),
      );
    });

    test('saveAll should store multiple entries', () async {
      final entries = <String, String>{
        'key1': 'value1',
        'key2': 'value2',
        'key3': 'value3',
      };

      final result = await db.saveAll<String>(entries);

      expect(result.isRight(), isTrue);

      for (final entry in entries.entries) {
        final getValue = await db.get<String>(entry.key);
        getValue.fold(
          (failure) => fail('Expected success'),
          (value) => expect(value, equals(entry.value)),
        );
      }
    });
  });

  group('Read Operations', () {
    test('get should return value if exists', () async {
      await db.save<String>('existingKey', 'existingValue');

      final result = await db.get<String>('existingKey');

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected success'),
        (value) => expect(value, equals('existingValue')),
      );
    });

    test('get should return null if key does not exist', () async {
      final result = await db.get<String>('nonExistentKey');

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected success'),
        (value) => expect(value, isNull),
      );
    });

    test('getOrDefault should return value if exists', () async {
      await db.save<String>('key', 'actualValue');

      final result = await db.getOrDefault<String>('key', 'defaultValue');

      result.fold(
        (failure) => fail('Expected success'),
        (value) => expect(value, equals('actualValue')),
      );
    });

    test('getOrDefault should return default if key does not exist', () async {
      final result = await db.getOrDefault<String>(
        'nonExistentKey',
        'defaultValue',
      );

      result.fold(
        (failure) => fail('Expected success'),
        (value) => expect(value, equals('defaultValue')),
      );
    });

    test('getAll should return all entries', () async {
      await db.save<String>('key1', 'value1');
      await db.save<String>('key2', 'value2');

      final result = await db.getAll<String>();

      expect(result.isRight(), isTrue);
      result.fold((failure) => fail('Expected success'), (map) {
        expect(map.length, equals(2));
        expect(map['key1'], equals('value1'));
        expect(map['key2'], equals('value2'));
      });
    });

    test('getKeys should return all keys', () async {
      await db.save<String>('key1', 'value1');
      await db.save<String>('key2', 'value2');

      final result = await db.getKeys();

      result.fold((failure) => fail('Expected success'), (keys) {
        expect(keys.length, equals(2));
        expect(keys, contains('key1'));
        expect(keys, contains('key2'));
      });
    });

    test('getValues should return all values', () async {
      await db.save<String>('key1', 'value1');
      await db.save<String>('key2', 'value2');

      final result = await db.getValues<String>();

      result.fold((failure) => fail('Expected success'), (values) {
        expect(values.length, equals(2));
        expect(values, contains('value1'));
        expect(values, contains('value2'));
      });
    });

    test('getAt should return value at index', () async {
      await db.save<String>('key1', 'value1');
      await db.save<String>('key2', 'value2');

      final result = await db.getAt<String>(0);

      result.fold(
        (failure) => fail('Expected success'),
        (value) => expect(value, isA<String>()),
      );
    });
  });

  group('Delete Operations', () {
    test('delete should remove entry and return success', () async {
      await db.save<String>('deleteKey', 'deleteValue');

      final result = await db.delete('deleteKey');

      expect(result.isRight(), isTrue);

      final getValue = await db.get<String>('deleteKey');
      getValue.fold(
        (failure) => fail('Expected success'),
        (value) => expect(value, isNull),
      );
    });

    test('delete should return success even if key does not exist', () async {
      final result = await db.delete('nonExistentKey');

      expect(result.isRight(), isTrue);
    });

    test('deleteAll should remove multiple entries', () async {
      await db.save<String>('key1', 'value1');
      await db.save<String>('key2', 'value2');
      await db.save<String>('key3', 'value3');

      final result = await db.deleteAll(['key1', 'key2']);

      expect(result.isRight(), isTrue);

      final key1Exists = await db.contains('key1');
      final key2Exists = await db.contains('key2');
      final key3Exists = await db.contains('key3');

      key1Exists.fold(
        (failure) => fail('Expected success'),
        (exists) => expect(exists, isFalse),
      );
      key2Exists.fold(
        (failure) => fail('Expected success'),
        (exists) => expect(exists, isFalse),
      );
      key3Exists.fold(
        (failure) => fail('Expected success'),
        (exists) => expect(exists, isTrue),
      );
    });

    test('clear should remove all entries', () async {
      await db.save<String>('key1', 'value1');
      await db.save<String>('key2', 'value2');

      final result = await db.clear();

      expect(result.isRight(), isTrue);

      final isEmpty = await db.isEmpty();
      isEmpty.fold(
        (failure) => fail('Expected success'),
        (empty) => expect(empty, isTrue),
      );
    });

    test('deleteAt should remove entry at index', () async {
      await db.save<String>('key1', 'value1');
      await db.save<String>('key2', 'value2');

      final countBefore = await db.count();
      final result = await db.deleteAt(0);

      expect(result.isRight(), isTrue);

      final countAfter = await db.count();
      countBefore.fold((failure) => fail('Expected success'), (before) {
        countAfter.fold(
          (failure) => fail('Expected success'),
          (after) => expect(after, equals(before - 1)),
        );
      });
    });
  });

  group('Query Operations', () {
    test('contains should return true if key exists', () async {
      await db.save<String>('existingKey', 'value');

      final result = await db.contains('existingKey');

      result.fold(
        (failure) => fail('Expected success'),
        (exists) => expect(exists, isTrue),
      );
    });

    test('contains should return false if key does not exist', () async {
      final result = await db.contains('nonExistentKey');

      result.fold(
        (failure) => fail('Expected success'),
        (exists) => expect(exists, isFalse),
      );
    });

    test('count should return number of entries', () async {
      await db.save<String>('key1', 'value1');
      await db.save<String>('key2', 'value2');
      await db.save<String>('key3', 'value3');

      final result = await db.count();

      result.fold(
        (failure) => fail('Expected success'),
        (count) => expect(count, equals(3)),
      );
    });

    test('isEmpty should return true for empty database', () async {
      final result = await db.isEmpty();

      result.fold(
        (failure) => fail('Expected success'),
        (empty) => expect(empty, isTrue),
      );
    });

    test('isEmpty should return false for non-empty database', () async {
      await db.save<String>('key', 'value');

      final result = await db.isEmpty();

      result.fold(
        (failure) => fail('Expected success'),
        (empty) => expect(empty, isFalse),
      );
    });
  });

  group('Reactive Updates', () {
    test('watch should return stream that emits current value', () async {
      await db.save<String>('watchKey', 'initialValue');

      final stream = db.watch<String>('watchKey');

      expect(stream, isA<Stream<String?>>());
      await expectLater(stream.first, completion(equals('initialValue')));
    });

    test('watchKeys should return stream that emits current values', () async {
      await db.save<String>('key1', 'value1');
      await db.save<String>('key2', 'value2');

      final stream = db.watchKeys<String>(['key1', 'key2']);

      expect(stream, isA<Stream<Map<String, String>>>());
      await expectLater(
        stream.first,
        completion(equals({'key1': 'value1', 'key2': 'value2'})),
      );
    });

    test('watchAll should return stream that emits all entries', () async {
      await db.save<String>('key1', 'value1');
      await db.save<String>('key2', 'value2');

      final stream = db.watchAll<String>();

      expect(stream, isA<Stream<Map<String, String>>>());
      await expectLater(
        stream.first,
        completion(equals({'key1': 'value1', 'key2': 'value2'})),
      );
    });
  });

  group('Type Safety', () {
    test('should maintain type safety across operations', () async {
      // Save typed data
      await db.save<int>('age', 25);
      await db.save<String>('name', 'John');
      await db.save<bool>('active', true);

      // Get typed data
      final ageResult = await db.get<int>('age');
      final nameResult = await db.get<String>('name');
      final activeResult = await db.get<bool>('active');

      ageResult.fold((failure) => fail('Expected success'), (value) {
        expect(value, isA<int>());
        expect(value, equals(25));
      });

      nameResult.fold((failure) => fail('Expected success'), (value) {
        expect(value, isA<String>());
        expect(value, equals('John'));
      });

      activeResult.fold((failure) => fail('Expected success'), (value) {
        expect(value, isA<bool>());
        expect(value, equals(true));
      });
    });

    test('saveAll should maintain type safety', () async {
      final intEntries = <String, int>{'a': 1, 'b': 2, 'c': 3};
      await db.saveAll<int>(intEntries);

      final values = await db.getValues<int>();
      values.fold((failure) => fail('Expected success'), (list) {
        expect(list, everyElement(isA<int>()));
      });
    });

    test('getAll should return type-safe map', () async {
      await db.save<int>('num1', 10);
      await db.save<int>('num2', 20);

      final result = await db.getAll<int>();

      result.fold((failure) => fail('Expected success'), (map) {
        expect(map, isA<Map<String, int>>());
        expect(map.values, everyElement(isA<int>()));
      });
    });
  });

  group('Error Handling', () {
    test(
      'operations on uninitialized database should handle gracefully',
      () async {
        final uninitializedDb = HiveNoSqlDatabase('uninitialized_box');

        // Should auto-initialize and succeed
        final result = await uninitializedDb.save<String>('key', 'value');
        expect(result.isRight(), isTrue);

        await uninitializedDb.close();
        await Hive.deleteBoxFromDisk('uninitialized_box');
      },
    );
  });

  group('Edge Cases', () {
    test('should handle empty string keys', () async {
      final result = await db.save<String>('', 'emptyKeyValue');
      expect(result.isRight(), isTrue);

      final getValue = await db.get<String>('');
      getValue.fold(
        (failure) => fail('Expected success'),
        (value) => expect(value, equals('emptyKeyValue')),
      );
    });

    test('should handle null values', () async {
      final result = await db.save<String?>('nullKey', null);
      expect(result.isRight(), isTrue);

      final getValue = await db.get<String?>('nullKey');
      getValue.fold(
        (failure) => fail('Expected success'),
        (value) => expect(value, isNull),
      );
    });

    test('should handle large batch operations', () async {
      final largeMap = <String, int>{};
      for (int i = 0; i < 1000; i++) {
        largeMap['key$i'] = i;
      }

      final result = await db.saveAll<int>(largeMap);
      expect(result.isRight(), isTrue);

      final count = await db.count();
      count.fold(
        (failure) => fail('Expected success'),
        (c) => expect(c, equals(1000)),
      );
    });

    test('deleteAt with invalid index should return error', () async {
      final result = await db.deleteAt(999);

      // Should return error for invalid index
      expect(result.isLeft(), isTrue);
    });
  });
}

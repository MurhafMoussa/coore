import 'package:coore/src/error_handling/failures/cache_failure.dart';
import 'package:coore/src/local_storage/nosql_database/nosql_database_interface.dart';
import 'package:coore/src/typedefs/core_typedefs.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hive_ce/hive.dart';

/// Hive-based implementation of [NoSqlDatabaseInterface].
///
/// This implementation uses Hive CE for local NoSQL storage, leveraging
/// Hive's native methods for all operations.
class HiveNoSqlDatabase implements NoSqlDatabaseInterface {
  HiveNoSqlDatabase(this._boxName);

  final String _boxName;

  late Box _box;
  bool _isInitialized = false;
  ResultFuture<Unit>? _initialization;

  @override
  ResultFuture<Unit> initialize() async {
    if (_initialization != null) return _initialization!;
    _initialization = _initializeBox();
    return _initialization!;
  }

  ResultFuture<Unit> _initializeBox() async {
    try {
      _box = await Hive.openBox(_boxName);
      _isInitialized = true;
      return right(unit);
    } catch (e, stackTrace) {
      return left(CacheFailure(message: e.toString(), stackTrace: stackTrace));
    }
  }

  ResultFuture<Unit> _ensureInitialized() async {
    if (!_isInitialized) {
      final result = await initialize();
      if (result.isLeft()) return result;
    }
    return right(unit);
  }

  @override
  ResultFuture<Unit> close() async {
    try {
      await _box.close();
      _isInitialized = false;
      return right(unit);
    } catch (e, stackTrace) {
      return left(CacheFailure(message: e.toString(), stackTrace: stackTrace));
    }
  }

  @override
  ResultFuture<Unit> deleteFromDisk() async {
    try {
      if (_isInitialized) {
        await close();
      }
      await Hive.deleteBoxFromDisk(_boxName);
      return right(unit);
    } catch (e, stackTrace) {
      return left(CacheFailure(message: e.toString(), stackTrace: stackTrace));
    }
  }

  // ============================================================================
  // Write Operations
  // ============================================================================

  @override
  ResultFuture<Unit> save<T>(String key, T value) async {
    try {
      final initResult = await _ensureInitialized();
      return initResult.fold((l) => left(l), (r) async {
        await _box.put(key, value);
        return right(unit);
      });
    } catch (e, stackTrace) {
      return left(CacheFailure(message: e.toString(), stackTrace: stackTrace));
    }
  }

  @override
  ResultFuture<Unit> saveAll<T>(Map<String, T> entries) async {
    try {
      final initResult = await _ensureInitialized();
      return initResult.fold((l) => left(l), (r) async {
        await _box.putAll(entries);
        return right(unit);
      });
    } catch (e, stackTrace) {
      return left(CacheFailure(message: e.toString(), stackTrace: stackTrace));
    }
  }

  // ============================================================================
  // Read Operations
  // ============================================================================

  @override
  ResultFuture<T?> get<T>(String key) async {
    try {
      final initResult = await _ensureInitialized();
      return initResult.fold((l) => left(l), (r) => right(_box.get(key) as T?));
    } catch (e, stackTrace) {
      return left(CacheFailure(message: e.toString(), stackTrace: stackTrace));
    }
  }

  @override
  ResultFuture<T> getOrDefault<T>(String key, T defaultValue) async {
    try {
      final initResult = await _ensureInitialized();
      return initResult.fold(
        (l) => left(l),
        (r) => right(_box.get(key, defaultValue: defaultValue) as T),
      );
    } catch (e, stackTrace) {
      return left(CacheFailure(message: e.toString(), stackTrace: stackTrace));
    }
  }

  @override
  ResultFuture<Map<String, T>> getAll<T>() async {
    try {
      final initResult = await _ensureInitialized();
      return initResult.fold(
        (l) => left(l),
        (r) => right(_box.toMap().cast<String, T>()),
      );
    } catch (e, stackTrace) {
      return left(CacheFailure(message: e.toString(), stackTrace: stackTrace));
    }
  }

  @override
  ResultFuture<List<String>> getKeys() async {
    try {
      final initResult = await _ensureInitialized();
      return initResult.fold(
        (l) => left(l),
        (r) => right(_box.keys.map((key) => key.toString()).toList()),
      );
    } catch (e, stackTrace) {
      return left(CacheFailure(message: e.toString(), stackTrace: stackTrace));
    }
  }

  @override
  ResultFuture<List<T>> getValues<T>() async {
    try {
      final initResult = await _ensureInitialized();
      return initResult.fold(
        (l) => left(l),
        (r) => right(_box.values.cast<T>().toList()),
      );
    } catch (e, stackTrace) {
      return left(CacheFailure(message: e.toString(), stackTrace: stackTrace));
    }
  }

  @override
  ResultFuture<T> getAt<T>(int index) async {
    try {
      final initResult = await _ensureInitialized();
      return initResult.fold(
        (l) => left(l),
        (r) => right(_box.getAt(index) as T),
      );
    } catch (e, stackTrace) {
      return left(CacheFailure(message: e.toString(), stackTrace: stackTrace));
    }
  }

  // ============================================================================
  // Delete Operations
  // ============================================================================

  @override
  ResultFuture<Unit> delete(String key) async {
    try {
      final initResult = await _ensureInitialized();
      return initResult.fold((l) => left(l), (r) async {
        await _box.delete(key);
        return right(unit);
      });
    } catch (e, stackTrace) {
      return left(CacheFailure(message: e.toString(), stackTrace: stackTrace));
    }
  }

  @override
  ResultFuture<Unit> deleteAll(Iterable<String> keys) async {
    try {
      final initResult = await _ensureInitialized();
      return initResult.fold((l) => left(l), (r) async {
        await _box.deleteAll(keys);
        return right(unit);
      });
    } catch (e, stackTrace) {
      return left(CacheFailure(message: e.toString(), stackTrace: stackTrace));
    }
  }

  @override
  ResultFuture<Unit> clear() async {
    try {
      final initResult = await _ensureInitialized();
      return initResult.fold((l) => left(l), (r) async {
        await _box.clear();
        return right(unit);
      });
    } catch (e, stackTrace) {
      return left(CacheFailure(message: e.toString(), stackTrace: stackTrace));
    }
  }

  @override
  ResultFuture<Unit> deleteAt(int index) async {
    try {
      final initResult = await _ensureInitialized();
      return initResult.fold((l) => left(l), (r) async {
        // Check if index is valid
        if (index < 0 || index >= _box.length) {
          return left(
            CacheFailure(
              message:
                  'Index out of range: $index (box length: ${_box.length})',
            ),
          );
        }
        await _box.deleteAt(index);
        return right(unit);
      });
    } catch (e, stackTrace) {
      return left(CacheFailure(message: e.toString(), stackTrace: stackTrace));
    }
  }

  // ============================================================================
  // Query Operations
  // ============================================================================

  @override
  ResultFuture<bool> contains(String key) async {
    try {
      final initResult = await _ensureInitialized();
      return initResult.fold(
        (l) => left(l),
        (r) => right(_box.containsKey(key)),
      );
    } catch (e, stackTrace) {
      return left(CacheFailure(message: e.toString(), stackTrace: stackTrace));
    }
  }

  @override
  ResultFuture<int> count() async {
    try {
      final initResult = await _ensureInitialized();
      return initResult.fold((l) => left(l), (r) => right(_box.length));
    } catch (e, stackTrace) {
      return left(CacheFailure(message: e.toString(), stackTrace: stackTrace));
    }
  }

  @override
  ResultFuture<bool> isEmpty() async {
    try {
      final initResult = await _ensureInitialized();
      return initResult.fold((l) => left(l), (r) => right(_box.isEmpty));
    } catch (e, stackTrace) {
      return left(CacheFailure(message: e.toString(), stackTrace: stackTrace));
    }
  }

  // ============================================================================
  // Reactive Updates (Hive's native watch)
  // ============================================================================

  @override
  ResultStream<T?> watch<T>(String key) async* {
    if (!_isInitialized) {
      throw StateError('Database must be initialized before calling watch()');
    }

    // Emit current value immediately
    yield right(_box.get(key) as T?);

    // Use Hive's native watch method to listen for changes to this specific key
    await for (final event in _box.watch(key: key)) {
      yield right(event.value as T?);
    }
  }

  @override
  ResultStream<Map<String, T>> watchKeys<T>(List<String> keys) async* {
    if (!_isInitialized) {
      throw StateError(
        'Database must be initialized before calling watchKeys()',
      );
    }

    // Helper to get current values for the keys
    Map<String, T> getCurrentValues() {
      final result = <String, T>{};
      for (final key in keys) {
        if (_box.containsKey(key)) {
          result[key] = _box.get(key) as T;
        }
      }
      return result;
    }

    // Emit current values immediately
    yield right(getCurrentValues());

    // Use Hive's native watch to listen for changes to any key
    await for (final event in _box.watch()) {
      // Only emit if the changed key is in our watch list
      if (keys.contains(event.key)) {
        yield right(getCurrentValues());
      }
    }
  }

  @override
  ResultStream<Map<String, T>> watchAll<T>() async* {
    if (!_isInitialized) {
      throw StateError(
        'Database must be initialized before calling watchAll()',
      );
    }

    // Emit current state immediately
    yield right(_box.toMap().cast<String, T>());

    // Use Hive's native watch to listen for all changes
    await for (final _ in _box.watch()) {
      yield right(_box.toMap().cast<String, T>());
    }
  }
}

import 'package:coore/coore.dart';
import 'package:coore/src/error_handling/failures/cache_failure.dart';
import 'package:coore/src/local_storage/nosql_database/nosql_database_interface.dart';
import 'package:coore/src/typedefs/core_typedefs.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hive_ce/hive.dart';

/// Hive-based implementation of [NoSqlDatabaseInterface].
class HiveNoSqlDatabase implements NoSqlDatabaseInterface {
  HiveNoSqlDatabase(this._boxName);

  final String _boxName;

  late Box _box;

  // Memoize the initialization future to prevent concurrent open attempts
  ResultFuture<Unit>? _initialization;

  /// Ensures the box is open. Returns existing future if pending.
  @override
  ResultFuture<Unit> initialize() async {
    // If we have a pending or completed future, return it.
    if (_initialization != null) return _initialization!;

    // Create a new initialization future
    _initialization = _openBoxInternal();

    final result = await _initialization!;

    // CRITICAL FIX: If initialization failed, reset the future to null.
    // This allows the app to retry initialization later instead of caching the failure forever.
    if (result.isLeft()) {
      _initialization = null;
    }

    return result;
  }

  Future<Either<Failure, Unit>> _openBoxInternal() async {
    try {
      if (!Hive.isBoxOpen(_boxName)) {
        _box = await Hive.openBox(_boxName);
      } else {
        _box = Hive.box(_boxName);
      }
      return right(unit);
    } catch (e, stackTrace) {
      if (e.toString().contains('HiveError') ||
          e.toString().contains('typeId')) {
        try {
          getIt<CoreLogger>().warning(
            '⚠️ Database $_boxName is corrupted or missing adapters. Deleting and recreating...',
          );
          // 1. Force delete the corrupted file from disk
          await Hive.deleteBoxFromDisk(_boxName);

          // 2. Try opening it again (this creates a fresh, empty box)
          _box = await Hive.openBox(_boxName);

          return right(unit);
        } catch (recoveryError) {
          // If recovery fails, then we really have a problem.
          return left(
            CacheFailure(
              message: 'Failed to recover corrupt DB: $recoveryError',
              stackTrace: stackTrace,
            ),
          );
        }
      }

      return left(CacheFailure(message: e.toString(), stackTrace: stackTrace));
    }
  }

  /// Helper to ensure the DB is ready before any operation.
  /// This minimizes boilerplate in every method.
  ResultFuture<Unit> _ensureInitialized() async {
    if (_initialization != null) {
      // Wait for the pending initialization to finish
      final result = await _initialization!;
      // If it was successful and box is technically open, we are good.
      if (result.isRight() && _box.isOpen) return right(unit);
    }
    return initialize();
  }

  @override
  ResultFuture<Unit> close() async {
    try {
      if (_initialization != null && _box.isOpen) {
        await _box.close();
      }
      // CRITICAL FIX: Reset initialization so it can be re-opened later.
      _initialization = null;
      return right(unit);
    } catch (e, stackTrace) {
      return left(CacheFailure(message: e.toString(), stackTrace: stackTrace));
    }
  }

  @override
  ResultFuture<Unit> deleteFromDisk() async {
    try {
      // Ensure it is closed first to avoid lock contention
      if (_initialization != null && _box.isOpen) {
        await _box.close();
      }
      await Hive.deleteBoxFromDisk(_boxName);

      // CRITICAL FIX: Reset initialization state
      _initialization = null;
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
    final init = await _ensureInitialized();
    return init.fold(left, (r) async {
      try {
        await _box.put(key, value);
        return right(unit);
      } catch (e, s) {
        return left(CacheFailure(message: e.toString(), stackTrace: s));
      }
    });
  }

  @override
  ResultFuture<Unit> saveAll<T>(Map<String, T> entries) async {
    final init = await _ensureInitialized();
    return init.fold(left, (r) async {
      try {
        await _box.putAll(entries);
        return right(unit);
      } catch (e, s) {
        return left(CacheFailure(message: e.toString(), stackTrace: s));
      }
    });
  }

  // ============================================================================
  // Read Operations
  // ============================================================================

  @override
  ResultFuture<T?> get<T>(String key) async {
    final init = await _ensureInitialized();
    return init.fold(left, (r) {
      try {
        return right(_box.get(key) as T?);
      } catch (e, s) {
        return left(CacheFailure(message: e.toString(), stackTrace: s));
      }
    });
  }

  @override
  ResultFuture<T> getOrDefault<T>(String key, T defaultValue) async {
    final init = await _ensureInitialized();
    return init.fold(left, (r) {
      try {
        return right(_box.get(key, defaultValue: defaultValue) as T);
      } catch (e, s) {
        return left(CacheFailure(message: e.toString(), stackTrace: s));
      }
    });
  }

  @override
  ResultFuture<Map<String, T>> getAll<T>() async {
    final init = await _ensureInitialized();
    return init.fold(left, (r) {
      try {
        return right(_box.toMap().cast<String, T>());
      } catch (e, s) {
        return left(CacheFailure(message: e.toString(), stackTrace: s));
      }
    });
  }

  @override
  ResultFuture<List<String>> getKeys() async {
    final init = await _ensureInitialized();
    return init.fold(left, (r) {
      try {
        // Hive keys can be int or string, safe conversion to String
        return right(_box.keys.map((e) => e.toString()).toList());
      } catch (e, s) {
        return left(CacheFailure(message: e.toString(), stackTrace: s));
      }
    });
  }

  @override
  ResultFuture<List<T>> getValues<T>() async {
    final init = await _ensureInitialized();
    return init.fold(left, (r) {
      try {
        return right(_box.values.cast<T>().toList());
      } catch (e, s) {
        return left(CacheFailure(message: e.toString(), stackTrace: s));
      }
    });
  }

  @override
  ResultFuture<T> getAt<T>(int index) async {
    final init = await _ensureInitialized();
    return init.fold(left, (r) {
      try {
        return right(_box.getAt(index) as T);
      } catch (e, s) {
        return left(CacheFailure(message: e.toString(), stackTrace: s));
      }
    });
  }

  // ============================================================================
  // Delete Operations
  // ============================================================================

  @override
  ResultFuture<Unit> delete(String key) async {
    final init = await _ensureInitialized();
    return init.fold(left, (r) async {
      try {
        await _box.delete(key);
        return right(unit);
      } catch (e, s) {
        return left(CacheFailure(message: e.toString(), stackTrace: s));
      }
    });
  }

  @override
  ResultFuture<Unit> deleteAll(Iterable<String> keys) async {
    final init = await _ensureInitialized();
    return init.fold(left, (r) async {
      try {
        await _box.deleteAll(keys);
        return right(unit);
      } catch (e, s) {
        return left(CacheFailure(message: e.toString(), stackTrace: s));
      }
    });
  }

  @override
  ResultFuture<Unit> clear() async {
    final init = await _ensureInitialized();
    return init.fold(left, (r) async {
      try {
        await _box.clear();
        return right(unit);
      } catch (e, s) {
        return left(CacheFailure(message: e.toString(), stackTrace: s));
      }
    });
  }

  @override
  ResultFuture<Unit> deleteAt(int index) async {
    final init = await _ensureInitialized();
    return init.fold(left, (r) async {
      try {
        if (index < 0 || index >= _box.length) {
          return left(
            CacheFailure(
              message: 'Index out of range: $index (length: ${_box.length})',
            ),
          );
        }
        await _box.deleteAt(index);
        return right(unit);
      } catch (e, s) {
        return left(CacheFailure(message: e.toString(), stackTrace: s));
      }
    });
  }

  // ============================================================================
  // Query Operations
  // ============================================================================

  @override
  ResultFuture<bool> contains(String key) async {
    final init = await _ensureInitialized();
    return init.fold(left, (r) => right(_box.containsKey(key)));
  }

  @override
  ResultFuture<int> count() async {
    final init = await _ensureInitialized();
    return init.fold(left, (r) => right(_box.length));
  }

  @override
  ResultFuture<bool> isEmpty() async {
    final init = await _ensureInitialized();
    return init.fold(left, (r) => right(_box.isEmpty));
  }

  // ============================================================================
  // Reactive Updates
  // ============================================================================

  @override
  ResultStream<T?> watch<T>(String key) async* {
    final init = await _ensureInitialized();

    // If initialization fails, emit the failure and stop
    if (init.isLeft()) {
      yield left(init.getLeft().toNullable()!);
      return;
    }

    try {
      // Emit current value immediately
      yield right(_box.get(key) as T?);

      // Watch for changes
      await for (final event in _box.watch(key: key)) {
        yield right(event.value as T?);
      }
    } catch (e, s) {
      yield left(CacheFailure(message: e.toString(), stackTrace: s));
    }
  }

  @override
  ResultStream<Map<String, T>> watchKeys<T>(List<String> keys) async* {
    final init = await _ensureInitialized();

    if (init.isLeft()) {
      yield left(init.getLeft().toNullable()!);
      return;
    }

    Map<String, T> getCurrentValues() {
      final result = <String, T>{};
      for (final key in keys) {
        if (_box.containsKey(key)) {
          result[key] = _box.get(key) as T;
        }
      }
      return result;
    }

    try {
      yield right(getCurrentValues());

      await for (final event in _box.watch()) {
        // Filter: Only emit if the changed key is one we care about
        if (keys.contains(event.key)) {
          yield right(getCurrentValues());
        }
      }
    } catch (e, s) {
      yield left(CacheFailure(message: e.toString(), stackTrace: s));
    }
  }

  @override
  ResultStream<Map<String, T>> watchAll<T>() async* {
    final init = await _ensureInitialized();

    if (init.isLeft()) {
      yield left(init.getLeft().toNullable()!);
      return;
    }

    try {
      yield right(_box.toMap().cast<String, T>());

      await for (final _ in _box.watch()) {
        yield right(_box.toMap().cast<String, T>());
      }
    } catch (e, s) {
      yield left(CacheFailure(message: e.toString(), stackTrace: s));
    }
  }
}

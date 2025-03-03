// hive_local_database.dart
import 'package:coore/src/error_handling/failures/cache_failure.dart';
import 'package:coore/src/local_database/local_database_interface.dart';
import 'package:coore/src/typedefs/core_typedefs.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hive_ce/hive.dart';

class HiveLocalDatabase implements LocalDatabaseInterface {

  HiveLocalDatabase(this._boxName) {
    initialize();
  }
  final String _boxName;

  late Box _box;

  @override
  CacheResponse<Unit> initialize() {
    return TaskEither.tryCatch(() async {
      _box = await Hive.openBox(_boxName);
      return unit;
    }, (error, stackTrace) => CacheInitializationFailure(stackTrace),);
  }

  @override
  CacheResponse<Unit> close() {
    return TaskEither.tryCatch(() async {
      await _box.close();
      return unit;
    }, (error, stackTrace) => CacheCorruptedFailure(stackTrace),);
  }

  @override
  CacheResponse<Unit> save<T>(String key, T value) {
    return TaskEither.tryCatch(() async {
      await _box.put(key, value);
      return unit;
    }, (error, stackTrace) => CacheWriteFailure(stackTrace),);
  }

  @override
  CacheResponse<T?> get<T>(String key) {
    return TaskEither.tryCatch(() async {
      return _box.get(key) as T?;
    }, (error, stackTrace) => CacheReadFailure(stackTrace),);
  }

  @override
  CacheResponse<Unit> delete(String key) {
    return TaskEither.tryCatch(() async {
      await _box.delete(key);
      return unit;
    }, (error, stackTrace) => CacheDeleteFailure(stackTrace),);
  }
}

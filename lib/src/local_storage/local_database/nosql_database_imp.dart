// hive_local_database.dart
import 'package:coore/src/error_handling/failures/cache_failure.dart';
import 'package:coore/src/local_storage/local_database/local_database_interface.dart';
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
  CacheResponse<Unit> initialize() async {
    try {
      _box = await Hive.openBox(_boxName);
      return right(unit);
    } catch (e, stackTrace) {
      return left(CacheInitializationFailure(stackTrace));
    }
  }

  @override
  CacheResponse<Unit> close() async {
    try {
      await _box.close();
      return right(unit);
    } catch (e, stackTrace) {
      return left(CacheCorruptedFailure(stackTrace));
    }
  }

  @override
  CacheResponse<Unit> save<T>(String key, T value) async {
    try {
      await _box.close();
      return right(unit);
    } catch (e, stackTrace) {
      return left(CacheWriteFailure(stackTrace));
    }
  }

  @override
  CacheResponse<T?> get<T>(String key) async {
    try {
      await _box.close();
      return right(_box.get(key) as T?);
    } catch (e, stackTrace) {
      return left(CacheReadFailure(stackTrace));
    }
  }

  @override
  CacheResponse<Unit> delete(String key) async {
    try {
      await _box.delete(key);
      return right(unit);
    } catch (e, stackTrace) {
      return left(CacheDeleteFailure(stackTrace));
    }
  }
}

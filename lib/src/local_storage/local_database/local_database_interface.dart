import 'package:coore/src/typedefs/core_typedefs.dart';
import 'package:fpdart/fpdart.dart';

abstract class LocalDatabaseInterface {
  CacheResponse<Unit> initialize();

  CacheResponse<Unit> close();

  CacheResponse<Unit> save<T>(String key, T value);

  CacheResponse<T?> get<T>(String key);

  CacheResponse<Unit> delete(String key);
}

import 'package:coore/src/src.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class SecureDatabaseInterface {
  CacheResponse<Unit> initialize();
  CacheResponse<String?> read(String key);
  CacheResponse<Map<String, String>> readAll();
  CacheResponse<Unit> write(String key, String value);
  CacheResponse<Unit> delete(String key);
  CacheResponse<Unit> deleteAll();
}

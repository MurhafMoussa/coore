import 'package:coore/src/src.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class SecureDatabaseInterface {
  ResultFuture<Unit> initialize();
  ResultFuture<String?> read(String key);
  ResultFuture<Map<String, String>> readAll();
  ResultFuture<Unit> write(String key, String value);
  ResultFuture<Unit> delete(String key);
  ResultFuture<Unit> deleteAll();
}

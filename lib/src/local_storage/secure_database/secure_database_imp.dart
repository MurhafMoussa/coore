import 'package:coore/lib.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fpdart/fpdart.dart';

class SecureDatabaseImp implements SecureDatabaseInterface {
  SecureDatabaseImp(this._flutterSecureStorage);

  final FlutterSecureStorage _flutterSecureStorage;

  @override
  ResultFuture<Unit> delete(String key) async {
    try {
      await _flutterSecureStorage.delete(key: key);
      return right(unit);
    } catch (e, stackTrace) {
      return left(CacheFailure(message: e.toString(), stackTrace: stackTrace));
    }
  }

  @override
  ResultFuture<Unit> deleteAll() async {
    try {
      await _flutterSecureStorage.deleteAll();
      return right(unit);
    } catch (e, stackTrace) {
      return left(CacheFailure(message: e.toString(), stackTrace: stackTrace));
    }
  }

  @override
  ResultFuture<Unit> initialize() async {
    try {
      return right(unit);
    } catch (e, stackTrace) {
      return left(CacheFailure(message: e.toString(), stackTrace: stackTrace));
    }
  }

  @override
  ResultFuture<String?> read(String key) async {
    try {
      final value = await _flutterSecureStorage.read(key: key);
      return right(value);
    } catch (e, stackTrace) {
      return left(CacheFailure(message: e.toString(), stackTrace: stackTrace));
    }
  }

  @override
  ResultFuture<Map<String, String>> readAll() async {
    try {
      final value = await _flutterSecureStorage.readAll();
      return right(value);
    } catch (e, stackTrace) {
      return left(CacheFailure(message: e.toString(), stackTrace: stackTrace));
    }
  }

  @override
  ResultFuture<Unit> write(String key, String value) async {
    try {
      await _flutterSecureStorage.write(key: key, value: value);
      return right(unit);
    } catch (e, stackTrace) {
      return left(CacheFailure(message: e.toString(), stackTrace: stackTrace));
    }
  }
}

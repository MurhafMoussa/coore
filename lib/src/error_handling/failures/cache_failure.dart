import 'package:coore/coore.dart';

/// Local storage issues (Database, SecureStorage, FileSystem).
class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
    super.code = 'CACHE_ERR',
    super.stackTrace,
    super.originalException,
  });
}

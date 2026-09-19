import 'failure.dart';

/// Represents local storage operation failures (read, save, delete, clear).
class StorageFailure extends Failure {
  const StorageFailure({
    required super.message,
    super.code = 'STORAGE_ERR',
    super.stackTrace,
    super.originalException,
  });
}

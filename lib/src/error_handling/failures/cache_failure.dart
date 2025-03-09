import 'package:coore/src/error_handling/failures/failure.dart';

/// Abstract class for cache related failures.
abstract class CacheFailure extends Failure {
  const CacheFailure(super.message, [super.stackTrace]);
}

/// Failure when a cache lookup fails because the key is not found.
class CacheNotFoundFailure extends CacheFailure {
  const CacheNotFoundFailure(Object e, [StackTrace? stackTrace])
    : super('Cache entry not found: cause is $e', stackTrace);
}

/// Failure when the cache data is found but is corrupted.
class CacheCorruptedFailure extends CacheFailure {
  const CacheCorruptedFailure(Object e, [StackTrace? stackTrace])
    : super('Cache data is corrupted: cause is $e', stackTrace);
}

/// Failure when there is an error writing data to the cache.
class CacheWriteFailure extends CacheFailure {
  const CacheWriteFailure(Object e, [StackTrace? stackTrace])
    : super('Failed to write to cache: cause is $e', stackTrace);
}

/// Failure when there is an error reading data from the cache.
class CacheReadFailure extends CacheFailure {
  const CacheReadFailure(Object e, [StackTrace? stackTrace])
    : super('Failed to read from cache: cause is $e', stackTrace);
}

/// Failure when there is an error deleting data from the cache.
class CacheDeleteFailure extends CacheFailure {
  const CacheDeleteFailure(Object e, [StackTrace? stackTrace])
    : super('Failed to delete from cache: cause is $e', stackTrace);
}

/// Failure when initializing the cache storage fails.
class CacheInitializationFailure extends CacheFailure {
  const CacheInitializationFailure(Object e, [StackTrace? stackTrace])
    : super('Cache initialization failed: cause is $e', stackTrace);
}

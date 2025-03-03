import 'package:coore/src/error_handling/failures/failure.dart';

/// Abstract class for cache related failures.
abstract class CacheFailure extends Failure {
  const CacheFailure(super.message, [super.stackTrace]);
}

/// Failure when a cache lookup fails because the key is not found.
class CacheNotFoundFailure extends CacheFailure {
  const CacheNotFoundFailure([StackTrace? stackTrace])
    : super('Cache entry not found', stackTrace);
}

/// Failure when the cache data is found but is corrupted.
class CacheCorruptedFailure extends CacheFailure {
  const CacheCorruptedFailure([StackTrace? stackTrace])
    : super('Cache data is corrupted', stackTrace);
}

/// Failure when there is an error writing data to the cache.
class CacheWriteFailure extends CacheFailure {
  const CacheWriteFailure([StackTrace? stackTrace])
    : super('Failed to write to cache', stackTrace);
}

/// Failure when there is an error reading data from the cache.
class CacheReadFailure extends CacheFailure {
  const CacheReadFailure([StackTrace? stackTrace])
    : super('Failed to read from cache', stackTrace);
}

/// Failure when there is an error deleting data from the cache.
class CacheDeleteFailure extends CacheFailure {
  const CacheDeleteFailure([StackTrace? stackTrace])
    : super('Failed to delete from cache', stackTrace);
}

/// Failure when initializing the cache storage fails.
class CacheInitializationFailure extends CacheFailure {
  const CacheInitializationFailure([StackTrace? stackTrace])
    : super('Cache initialization failed', stackTrace);
}

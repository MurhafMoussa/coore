import 'package:coore/src/error_handling/failures/cache_failure.dart';
import 'package:coore/src/error_handling/failures/failure.dart' show Failure;
import 'package:coore/src/error_handling/failures/network_failure.dart';
import 'package:fpdart/fpdart.dart';

typedef ApiResponse = TaskEither<NetworkFailure, Map<String, dynamic>>;
typedef CacheResponse<T> = TaskEither<CacheFailure, T>;
typedef RepositoryFutureResponse<T> = TaskEither<Failure, T>;
typedef RepositoryStreamResponse<T> = Stream<Either<Failure, T>>;

/// A callback used to track the download or upload progress

typedef ProgressTrackerCallback = void Function(double progress);

/// The core id that will be used in all entities
typedef Id = int;

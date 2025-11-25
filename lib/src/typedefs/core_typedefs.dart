import 'package:coore/lib.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

/// A typedef for a cache response
typedef CacheResponse<T> = Future<Either<CacheFailure, T>>;

/// A typedef for a use case future response
typedef UseCaseFutureResponse<T> = Future<Either<Failure, T>>;

/// A typedef for a use case stream response
typedef UseCaseStreamResponse<T> = Stream<Either<Failure, T>>;

/// A typedef for a no meta pagination response
typedef NoMetaPaginationResponse<T> = PaginationResponseModel<T, NoMetaModel>;

/// A typedef for a error model parser
typedef ErrorModelParser = BaseErrorResponseModel Function(Response? response);

/// A typedef for a failure builder
typedef FailureBuilder =
    NetworkFailure Function(
      BaseErrorResponseModel error,
      StackTrace? stackTrace,
    );

/// A callback used to track the download or upload progress

typedef ProgressTrackerCallback = void Function(double progress);

/// The core id that will be used in all entities
typedef Id = String;

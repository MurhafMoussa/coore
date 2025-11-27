import 'package:coore/lib.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

// ==============================================================================
// 1. CORE RESPONSES (Layer Agnostic)
// ==============================================================================

/// Standard Async Response: Use this for Repositories, DataSources, AND UseCases.
/// Replaces: RemoteResponse, CacheResponse, UseCaseFutureResponse
typedef ResultFuture<T> = Future<Either<Failure, T>>;

/// Standard Stream Response: Use for real-time data (WebSockets, Firestore).
typedef ResultStream<T> = Stream<Either<Failure, T>>;



// ==============================================================================
// 2. HELPER TYPEDEFS
// ==============================================================================

/// Helper for paginated lists that don't use metadata
typedef NoMetaPaginationModel<T> = PaginationResponseModel<T, NoMetaModel>;

/// Parses the 'data' field from a Dio response into a specific error model
typedef ErrorModelParser = BaseErrorResponseModel Function(Response? response);

/// Callback for upload/download progress (0.0 to 1.0)
typedef ProgressTrackerCallback = void Function(double progress);

/// Standard ID type (makes refactoring String <-> int IDs easier later)
typedef Id = String;

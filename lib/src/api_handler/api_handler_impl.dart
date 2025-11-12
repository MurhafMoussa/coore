import 'package:async/async.dart';
import 'package:coore/lib.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:fpdart/fpdart.dart';

/// An API handler implementation using Dio.
///
/// The [DioApiHandler] accepts a Dio instance via constructor injection.
/// It wraps HTTP calls in a common response handler that returns a
/// [RemoteCancelableResponse] (a [CancelableOperation]). This allows the API
/// layer to use functional error handling and provide clear, user-friendly errors
/// via [NetworkFailure]. The returned [CancelableOperation] enables request
/// cancellation. Additional options for caching and authorization are
/// included in the request options. Responses are parsed from JSON using the
/// provided parser function into the specified type [T].
class DioApiHandler implements ApiHandlerInterface {
  /// Creates a new instance of [DioApiHandler] with the provided Dio instance
  /// and [NetworkExceptionMapper].
  ///
  /// [dio]: The Dio instance to be used for HTTP calls.
  /// [exceptionMapper]: A mapper to convert Network exceptions into [NetworkFailure] instances.
  DioApiHandler(this._dio, this._exceptionMapper);
  final Dio _dio;
  final NetworkExceptionMapper _exceptionMapper;

  /// Builds Dio [Options] with authorization and optional caching.
  Options _buildOptions({
    required bool isAuthorized,
    bool shouldCache = false, // The forceRefresh parameter is removed
    bool isFormData = false,
  }) {
    final extra = <String, dynamic>{'isAuthorized': isAuthorized};

    // If shouldCache is true, add the cache policy to the extra map.
    // The interceptor will pick this up.
    if (shouldCache) {
      extra.addAll(
        CacheOptions(
          policy: CachePolicy.forceCache,
          store: getIt<CacheStore>(),
        ).toExtra(),
      );
    }

    return Options(
      extra: extra,
      contentType: isFormData
          ? Headers.multipartFormDataContentType
          : Headers.jsonContentType,
    );
  }

  /// A common method for handling API responses.
  ///
  /// This method takes a [dioMethod] function that returns a [Future<Response>],
  /// then wraps the call in a [CancelableOperation]. On success, it parses the response data
  /// from JSON using the provided [parser] function and returns the parsed value
  /// of type [T]. On error, if the error is a [DioException], it is mapped to a
  /// [NetworkFailure] using the exception mapper; otherwise, a [NoInternetConnectionFailure]
  /// is returned.
  ///
  /// The returned [CancelableOperation] allows the caller to cancel the request
  /// by calling [CancelableOperation.cancel]. When cancelled, the underlying
  /// Dio request will also be cancelled via the [CancelToken].
  RemoteCancelableResponse<T> _handleResponse<T>({
    required Future<Response> Function(CancelToken cancelToken) dioMethod,
    required T Function(Map<String, dynamic> json) parser,
  }) {
    // 1. Create the token *here*
    final cancelToken = CancelToken();

    // 2. Create the future
    final future = Future<Either<NetworkFailure, T>>(() async {
      try {
        final response = await dioMethod(cancelToken);
        return right<NetworkFailure, T>(
          parser(response.data as Map<String, dynamic>),
        );
      } on DioException catch (error, stackTrace) {
        if (error.type == DioExceptionType.cancel) {

          rethrow;
        }
        return left<NetworkFailure, T>(
          _exceptionMapper.mapException(error, stackTrace),
        );
      } on Exception catch (error, stackTrace) {
        return left<NetworkFailure, T>(
          NoInternetConnectionFailure(error.toString(), stackTrace: stackTrace),
        );
      }
    });

    // 3. Return the operation, linking it to the token
    return CancelableOperation.fromFuture(
      future,
      onCancel: () {
        if (!cancelToken.isCancelled) {
          cancelToken.cancel('Request cancelled by user');
        }
      },
    );
  }

  /// Sends an HTTP GET request to the specified [path].
  ///
  /// [path]: The endpoint URL path.
  /// [parser]: A function to parse the JSON response into type [T].
  /// [queryParameters]: Optional query parameters to append to the URL.
  /// [onReceiveProgress]: Optional callback to monitor the progress of the data being received.
  /// [shouldCache]: Indicates whether the response should be cached.
  /// [isAuthorized]: Indicates whether the request requires authorization.
  ///
  /// Returns a [RemoteCancelableResponse] (a [CancelableOperation]) containing either a
  /// [NetworkFailure] on error or a value of type [T] on success. The operation can be
  /// cancelled by calling [CancelableOperation.cancel].
  @override
  RemoteCancelableResponse<T> get<T>(
    String path, {
    required T Function(Map<String, dynamic> json) parser,
    Map<String, dynamic>? queryParameters,
    ProgressTrackerCallback? onReceiveProgress,
    bool shouldCache = false,
    bool isAuthorized = true,
  }) {
    return _handleResponse(
      dioMethod: (CancelToken cancelToken) => _dio.get(
        path,
        queryParameters: queryParameters,
        options: _buildOptions(
          isAuthorized: isAuthorized,
          shouldCache: shouldCache,
        ),
        onReceiveProgress: onReceiveProgress != null
            ? (count, total) => onReceiveProgress(count / total)
            : null,
        cancelToken: cancelToken,
      ),
      parser: parser,
    );
  }

  /// Sends an HTTP POST request to the specified [path].
  ///
  /// [path]: The endpoint URL path.
  /// [parser]: A function to parse the JSON response into type [T].
  /// [body]: The request payload as a map.
  /// [formData]: Optional adapter for creating multipart form data.
  /// [queryParameters]: Optional query parameters to append to the URL.
  /// [onSendProgress]: Optional callback to track the progress of the data being sent.
  /// [onReceiveProgress]: Optional callback to track the progress of the data being received.
  /// [isAuthorized]: Indicates whether the request requires authorization.
  ///
  /// Returns a [RemoteCancelableResponse] (a [CancelableOperation]) containing either a
  /// [NetworkFailure] on error or a value of type [T] on success. The operation can be
  /// cancelled by calling [CancelableOperation.cancel].
  @override
  RemoteCancelableResponse<T> post<T>(
    String path, {
    required T Function(Map<String, dynamic> json) parser,
    Map<String, dynamic>? body,
    FormDataAdapter? formData,
    Map<String, dynamic>? queryParameters,
    ProgressTrackerCallback? onSendProgress,
    ProgressTrackerCallback? onReceiveProgress,
    bool isAuthorized = true,
  }) {
    return _handleResponse(
      dioMethod: (CancelToken cancelToken) {
        return _dio.post(
          path,
          data: formData != null ? formData.create() : body,
          queryParameters: queryParameters,
          options: _buildOptions(
            isAuthorized: isAuthorized,
            isFormData: formData != null,
          ),
          onSendProgress: onSendProgress != null
              ? (count, total) => onSendProgress(count / total)
              : null,
          onReceiveProgress: onReceiveProgress != null
              ? (count, total) => onReceiveProgress(count / total)
              : null,
          cancelToken: cancelToken,
        );
      },
      parser: parser,
    );
  }

  /// Sends an HTTP DELETE request to the specified [path].
  ///
  /// [path]: The endpoint URL path.
  /// [parser]: A function to parse the JSON response into type [T].
  /// [queryParameters]: Optional query parameters to append to the URL.
  /// [isAuthorized]: Indicates whether the request requires authorization.
  ///
  /// Returns a [RemoteCancelableResponse] (a [CancelableOperation]) containing either a
  /// [NetworkFailure] on error or a value of type [T] on success. The operation can be
  /// cancelled by calling [CancelableOperation.cancel].
  @override
  RemoteCancelableResponse<T> delete<T>(
    String path, {
    required T Function(Map<String, dynamic> json) parser,
    Map<String, dynamic>? queryParameters,

    bool isAuthorized = true,
  }) {
    return _handleResponse(
      dioMethod: (CancelToken cancelToken) => _dio.delete(
        path,
        queryParameters: queryParameters,
        options: _buildOptions(isAuthorized: isAuthorized),
        cancelToken: cancelToken,
      ),
      parser: parser,
    );
  }

  /// Sends an HTTP PUT request to the specified [path].
  ///
  /// [path]: The endpoint URL path.
  /// [parser]: A function to parse the JSON response into type [T].
  /// [body]: The request payload as a map.
  /// [queryParameters]: Optional query parameters to append to the URL.
  /// [formData]: Optional adapter for creating multipart form data.
  /// [onSendProgress]: Optional callback to track the progress of the data being sent.
  /// [onReceiveProgress]: Optional callback to track the progress of the data being received.
  /// [isAuthorized]: Indicates whether the request requires authorization.
  ///
  /// Returns a [RemoteCancelableResponse] (a [CancelableOperation]) containing either a
  /// [NetworkFailure] on error or a value of type [T] on success. The operation can be
  /// cancelled by calling [CancelableOperation.cancel].
  @override
  RemoteCancelableResponse<T> put<T>(
    String path, {
    required T Function(Map<String, dynamic> json) parser,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    FormDataAdapter? formData,
    ProgressTrackerCallback? onSendProgress,
    ProgressTrackerCallback? onReceiveProgress,
    bool isAuthorized = true,
  }) {
    return _handleResponse(
      dioMethod: (CancelToken cancelToken) {
        final data = formData != null ? formData.create() : body;
        return _dio.put(
          path,
          data: data,
          queryParameters: queryParameters,
          options: _buildOptions(
            isAuthorized: isAuthorized,
            isFormData: formData != null,
          ),
          onSendProgress: onSendProgress != null
              ? (count, total) => onSendProgress(count / total)
              : null,
          onReceiveProgress: onReceiveProgress != null
              ? (count, total) => onReceiveProgress(count / total)
              : null,
          cancelToken: cancelToken,
        );
      },
      parser: parser,
    );
  }

  /// Sends an HTTP PATCH request to the specified [path].
  ///
  /// [path]: The endpoint URL path.
  /// [parser]: A function to parse the JSON response into type [T].
  /// [body]: The request payload as a map.
  /// [queryParameters]: Optional query parameters to append to the URL.
  /// [formData]: Optional adapter for creating multipart form data.
  /// [onSendProgress]: Optional callback to track the progress of the data being sent.
  /// [onReceiveProgress]: Optional callback to track the progress of the data being received.
  /// [isAuthorized]: Indicates whether the request requires authorization.
  ///
  /// Returns a [RemoteCancelableResponse] (a [CancelableOperation]) containing either a
  /// [NetworkFailure] on error or a value of type [T] on success. The operation can be
  /// cancelled by calling [CancelableOperation.cancel].
  @override
  RemoteCancelableResponse<T> patch<T>(
    String path, {
    required T Function(Map<String, dynamic> json) parser,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    FormDataAdapter? formData,
    ProgressTrackerCallback? onSendProgress,
    ProgressTrackerCallback? onReceiveProgress,
    bool isAuthorized = true,
  }) {
    return _handleResponse(
      dioMethod: (CancelToken cancelToken) {
        final data = formData != null ? formData.create() : body;
        return _dio.patch(
          path,
          data: data,
          queryParameters: queryParameters,
          options: _buildOptions(
            isAuthorized: isAuthorized,
            isFormData: formData != null,
          ),
          onSendProgress: onSendProgress != null
              ? (count, total) => onSendProgress(count / total)
              : null,
          onReceiveProgress: onReceiveProgress != null
              ? (count, total) => onReceiveProgress(count / total)
              : null,
          cancelToken: cancelToken,
        );
      },
      parser: parser,
    );
  }

  /// Downloads a file from the specified [url] and saves it to the [downloadDestinationPath].
  ///
  /// [url]: The URL from which to download the file.
  /// [downloadDestinationPath]: The local file path where the file should be saved.
  /// [parser]: A function to parse the JSON response into type [T].
  /// [onReceiveProgress]: Optional callback to track the progress of the download.
  /// [queryParameters]: Optional query parameters to append to the URL.
  /// [isAuthorized]: Indicates whether the download request requires authorization.
  ///
  /// Returns a [RemoteCancelableResponse] (a [CancelableOperation]) containing either a
  /// [NetworkFailure] on error or a value of type [T] on success. The operation can be
  /// cancelled by calling [CancelableOperation.cancel].
  @override
  RemoteCancelableResponse<T> download<T>(
    String url,
    String downloadDestinationPath, {
    ProgressTrackerCallback? onReceiveProgress,
    required T Function(Map<String, dynamic> json) parser,

    Map<String, dynamic>? queryParameters,
    bool isAuthorized = true,
  }) {
    return _handleResponse(
      dioMethod: (CancelToken cancelToken) => _dio.download(
        url,
        downloadDestinationPath,
        queryParameters: queryParameters,
        options: _buildOptions(
          isAuthorized: isAuthorized,
        ).copyWith(responseType: ResponseType.stream),
        onReceiveProgress: onReceiveProgress != null
            ? (count, total) => onReceiveProgress(count / total)
            : null,
        cancelToken: cancelToken,
      ),
      parser: parser,
    );
  }
}

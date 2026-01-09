import 'package:coore/lib.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:fpdart/fpdart.dart';

/// An API handler implementation using Dio.
///
/// The [DioApiHandler] accepts a Dio instance and [NetworkExceptionMapper] via constructor injection.
/// It wraps HTTP calls in a common response handler that returns a [Future] with [Either].
/// This allows the API layer to use functional error handling and provide clear, user-friendly errors
/// via [Failure].
///
/// **Request Cancellation:**
/// Request cancellation is supported through [CancelRequestManager] by providing an optional static
/// [requestId] string identifier. The same [requestId] must be used in both [ApiStateHandler.handleApiCall]
/// and when calling these methods.
///
/// **Retry Configuration:**
/// Each method supports per-request retry configuration via [enableRetry], [maxRetryAttempts], and
/// [retryDelay] parameters. Per-request settings take precedence over global settings from
/// [NetworkConfigEntity]. This allows fine-grained control over retry behavior for individual requests.
///
/// Additional options for caching and authorization are included in the request options.
/// Responses are parsed from JSON using the provided parser function into the specified type [T].
class DioApiHandler implements ApiHandlerInterface {
  /// Creates a new instance of [DioApiHandler] with the provided Dio instance
  /// and [NetworkExceptionMapper].
  ///
  /// [dio]: The Dio instance to be used for HTTP calls.
  /// [exceptionMapper]: A mapper to convert Network exceptions into [Failure] instances.
  DioApiHandler(this._dio, this._exceptionMapper);
  final Dio _dio;
  final NetworkExceptionMapper _exceptionMapper;

  /// Builds Dio [Options] with authorization, optional caching, and per-request retry settings.
  Options _buildOptions({
    required bool isAuthorized,
    bool shouldCache = false, // The forceRefresh parameter is removed
    bool isFormData = false,
    bool enableRetry = true,
    int? maxRetryAttempts,
    Duration? retryDelay,
  }) {
    final extra = <String, dynamic>{'isAuthorized': isAuthorized};

    // Add per-request retry settings to extra map for RetryInterceptor
    extra['enableRetry'] = enableRetry;
    if (maxRetryAttempts != null) {
      extra['maxRetryAttempts'] = maxRetryAttempts;
    }
    if (retryDelay != null) {
      extra['retryDelay'] = retryDelay.inMilliseconds;
    }

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
  /// This method takes a [dioMethod] function that returns a [Future<Response>].
  /// On success, it parses the response data from JSON using the provided [parser] function
  /// and returns the parsed value of type [T]. On error, if the error is a [DioException],
  /// it is mapped to a [Failure] using the exception mapper; otherwise, an
  /// [UnknownFailure] is returned.
  ///
  /// If a [requestId] is provided, the cancel token is retrieved from [CancelRequestManager]
  /// using the same static identifier that was registered in [ApiStateHandler.handleApiCall].
  /// The request can be cancelled by calling [CancelRequestManager.cancelRequest] with the
  /// same [requestId]. The request is automatically unregistered after completion.
  ResultFuture<T> _handleResponse<T>({
    required Future<Response> Function(CancelToken? cancelToken) dioMethod,
    required T Function(Map<String, dynamic> json) parser,
    String? requestId,
  }) async {
    // Get cancel token from CancelRequestManager if requestId provided, otherwise create new one
    CancelToken? cancelToken;
    if (requestId != null) {
      cancelToken = getIt<CancelRequestManager>().getCancelToken(requestId);
    }

    try {
      final response = await dioMethod(cancelToken);
      if (response.data is List<dynamic>) {
        final formattedMap = {'data': response.data};
        final parsedData = parser(formattedMap);

        return right(parsedData);
      } else if (response.data is Map<String, dynamic>) {
        final parsedData = parser(response.data as Map<String, dynamic>);
        return right(parsedData);
      } else if (response.data is String) {
        final formattedMap = {'data': response.data};
        final parsedData = parser(formattedMap);
        return right(parsedData);
      } else {
        return left<FormatFailure, T>(
          const FormatFailure(message: 'Invalid response data'),
        );
      }
    } on DioException catch (error, stackTrace) {
      if (error.type == DioExceptionType.cancel) {
        rethrow;
      }
      return left<Failure, T>(_exceptionMapper.mapException(error, stackTrace));
    } on Exception catch (error, stackTrace) {
      return left<Failure, T>(
        UnknownFailure(
          message: error.toString(),
          stackTrace: stackTrace,
          originalException: error,
        ),
      );
    } finally {
      // Cleanup if requestId was provided
      if (requestId != null) {
        getIt<CancelRequestManager>().unregisterRequest(requestId);
      }
    }
  }

  /// Sends an HTTP GET request to the specified [path].
  ///
  /// [path]: The endpoint URL path.
  /// [parser]: A function to parse the JSON response into type [T].
  /// [queryParameters]: Optional query parameters to append to the URL.
  /// [onReceiveProgress]: Optional callback to monitor the progress of the data being received.
  /// [shouldCache]: Indicates whether the response should be cached.
  /// [isAuthorized]: Indicates whether the request requires authorization.
  /// [requestId]: Optional static request ID for cancellation support. Use a consistent
  ///              string identifier for each request type (e.g., "get_user", "fetch_posts").
  ///              The same [requestId] must be used in [ApiStateHandler.handleApiCall].
  ///
  /// Returns a [Future] containing either a [Failure] on error or a value of type [T] on success.
  @override
  ResultFuture<T> get<T>(
    String path, {
    required T Function(Map<String, dynamic> json) parser,
    Map<String, dynamic>? queryParameters,
    ProgressTrackerCallback? onReceiveProgress,
    bool shouldCache = false,
    bool isAuthorized = true,
    bool enableRetry = true,
    int? maxRetryAttempts,
    Duration? retryDelay,
    String? requestId,
  }) {
    return _handleResponse(
      dioMethod: (CancelToken? cancelToken) => _dio.get(
        path,
        queryParameters: queryParameters,
        options: _buildOptions(
          isAuthorized: isAuthorized,
          shouldCache: shouldCache,
          enableRetry: enableRetry,
          maxRetryAttempts: maxRetryAttempts,
          retryDelay: retryDelay,
        ),
        onReceiveProgress: onReceiveProgress != null
            ? (count, total) => onReceiveProgress(count / total)
            : null,
        cancelToken: cancelToken,
      ),
      parser: parser,
      requestId: requestId,
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
  /// [requestId]: Optional static request ID for cancellation support. Use a consistent
  ///              string identifier for each request type (e.g., "get_user", "fetch_posts").
  ///              The same [requestId] must be used in [ApiStateHandler.handleApiCall].
  ///
  /// Returns a [Future] containing either a [Failure] on error or a value of type [T] on success.
  @override
  ResultFuture<T> post<T>(
    String path, {
    required T Function(Map<String, dynamic> json) parser,
    Map<String, dynamic>? body,
    FormDataAdapter? formData,
    Map<String, dynamic>? queryParameters,
    ProgressTrackerCallback? onSendProgress,
    ProgressTrackerCallback? onReceiveProgress,
    bool isAuthorized = true,
    bool enableRetry = true,
    int? maxRetryAttempts,
    Duration? retryDelay,
    String? requestId,
  }) {
    return _handleResponse(
      dioMethod: (CancelToken? cancelToken) {
        return _dio.post(
          path,
          data: formData != null ? formData.create() : body,
          queryParameters: queryParameters,
          options: _buildOptions(
            isAuthorized: isAuthorized,
            isFormData: formData != null,
            enableRetry: enableRetry,
            maxRetryAttempts: maxRetryAttempts,
            retryDelay: retryDelay,
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
      requestId: requestId,
    );
  }

  /// Sends an HTTP DELETE request to the specified [path].
  ///
  /// [path]: The endpoint URL path.
  /// [parser]: A function to parse the JSON response into type [T].
  /// [queryParameters]: Optional query parameters to append to the URL.
  /// [isAuthorized]: Indicates whether the request requires authorization.
  /// [requestId]: Optional static request ID for cancellation support. Use a consistent
  ///              string identifier for each request type (e.g., "get_user", "fetch_posts").
  ///              The same [requestId] must be used in [ApiStateHandler.handleApiCall].
  ///
  /// Returns a [Future] containing either a [Failure] on error or a value of type [T] on success.
  @override
  ResultFuture<T> delete<T>(
    String path, {
    required T Function(Map<String, dynamic> json) parser,
    Map<String, dynamic>? queryParameters,
    bool isAuthorized = true,
    bool enableRetry = true,
    int? maxRetryAttempts,
    Duration? retryDelay,
    String? requestId,
  }) {
    return _handleResponse(
      dioMethod: (CancelToken? cancelToken) => _dio.delete(
        path,
        queryParameters: queryParameters,
        options: _buildOptions(
          isAuthorized: isAuthorized,
          enableRetry: enableRetry,
          maxRetryAttempts: maxRetryAttempts,
          retryDelay: retryDelay,
        ),
        cancelToken: cancelToken,
      ),
      parser: parser,
      requestId: requestId,
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
  /// [requestId]: Optional static request ID for cancellation support. Use a consistent
  ///              string identifier for each request type (e.g., "get_user", "fetch_posts").
  ///              The same [requestId] must be used in [ApiStateHandler.handleApiCall].
  ///
  /// Returns a [Future] containing either a [Failure] on error or a value of type [T] on success.
  @override
  ResultFuture<T> put<T>(
    String path, {
    required T Function(Map<String, dynamic> json) parser,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    FormDataAdapter? formData,
    ProgressTrackerCallback? onSendProgress,
    ProgressTrackerCallback? onReceiveProgress,
    bool isAuthorized = true,
    bool enableRetry = true,
    int? maxRetryAttempts,
    Duration? retryDelay,
    String? requestId,
  }) {
    return _handleResponse(
      dioMethod: (CancelToken? cancelToken) {
        final data = formData != null ? formData.create() : body;
        return _dio.put(
          path,
          data: data,
          queryParameters: queryParameters,
          options: _buildOptions(
            isAuthorized: isAuthorized,
            isFormData: formData != null,
            enableRetry: enableRetry,
            maxRetryAttempts: maxRetryAttempts,
            retryDelay: retryDelay,
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
      requestId: requestId,
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
  /// [requestId]: Optional static request ID for cancellation support. Use a consistent
  ///              string identifier for each request type (e.g., "get_user", "fetch_posts").
  ///              The same [requestId] must be used in [ApiStateHandler.handleApiCall].
  ///
  /// Returns a [Future] containing either a [Failure] on error or a value of type [T] on success.
  @override
  ResultFuture<T> patch<T>(
    String path, {
    required T Function(Map<String, dynamic> json) parser,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    FormDataAdapter? formData,
    ProgressTrackerCallback? onSendProgress,
    ProgressTrackerCallback? onReceiveProgress,
    bool isAuthorized = true,
    bool enableRetry = true,
    int? maxRetryAttempts,
    Duration? retryDelay,
    String? requestId,
  }) {
    return _handleResponse(
      dioMethod: (CancelToken? cancelToken) {
        final data = formData != null ? formData.create() : body;
        return _dio.patch(
          path,
          data: data,
          queryParameters: queryParameters,
          options: _buildOptions(
            isAuthorized: isAuthorized,
            isFormData: formData != null,
            enableRetry: enableRetry,
            maxRetryAttempts: maxRetryAttempts,
            retryDelay: retryDelay,
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
      requestId: requestId,
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
  /// [requestId]: Optional static request ID for cancellation support. Use a consistent
  ///              string identifier for each request type (e.g., "get_user", "fetch_posts").
  ///              The same [requestId] must be used in [ApiStateHandler.handleApiCall].
  ///
  /// Returns a [Future] containing either a [Failure] on error or a value of type [T] on success.
  @override
  ResultFuture<T> download<T>(
    String url,
    String downloadDestinationPath, {
    ProgressTrackerCallback? onReceiveProgress,
    required T Function(Map<String, dynamic> json) parser,
    Map<String, dynamic>? queryParameters,
    bool isAuthorized = true,
    String? requestId,
    bool enableRetry = true,
    int? maxRetryAttempts,
    Duration? retryDelay,
  }) {
    return _handleResponse(
      dioMethod: (CancelToken? cancelToken) => _dio.download(
        url,
        downloadDestinationPath,
        queryParameters: queryParameters,
        options: _buildOptions(
          isAuthorized: isAuthorized,
          enableRetry: enableRetry,
          maxRetryAttempts: maxRetryAttempts,
          retryDelay: retryDelay,
        ).copyWith(responseType: ResponseType.stream),
        onReceiveProgress: onReceiveProgress != null
            ? (count, total) => onReceiveProgress(count / total)
            : null,
        cancelToken: cancelToken,
      ),
      parser: parser,
      requestId: requestId,
    );
  }
}

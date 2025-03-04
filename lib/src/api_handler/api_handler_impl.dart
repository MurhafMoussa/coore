import 'package:coore/src/api_handler/api_handler_interface.dart';
import 'package:coore/src/api_handler/cancel_request_adapter.dart';
import 'package:coore/src/api_handler/form_data_adapter.dart';
import 'package:coore/src/error_handling/exception_mapper/network_exception_mapper.dart';
import 'package:coore/src/error_handling/failures/network_failure.dart';
import 'package:coore/src/typedefs/core_typedefs.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

/// An API handler implementation using Dio.
///
/// The [DioApiHandler] accepts a Dio instance via constructor injection.
/// It wraps HTTP calls in a common response handler that returns a
/// [ApiHandlerResponse]. This allows the API
/// layer to use functional error handling and provide clear, user-friendly errors
/// via [NetworkFailure]. Additional options for caching and authorization are
/// included in the request options.
class DioApiHandler implements ApiHandlerInterface {
  /// Creates a new instance of [DioApiHandler] with the provided Dio instance
  /// and [NetworkExceptionMapper].
  ///
  /// [dio]: The Dio instance to be used for HTTP calls.
  /// [exceptionMapper]: A mapper to convert Network exceptions into [NetworkFailure] instances.
  DioApiHandler(this._dio, this._exceptionMapper);
  final Dio _dio;
  final NetworkExceptionMapper _exceptionMapper;

  /// Builds Dio [Options] with extra headers based on [isAuthorized] and [shouldCache].
  ///
  /// If [isAuthorized] is true, an "Authorization" header is added (in production,
  /// replace with a real token). If [shouldCache] is true, a "Cache-Control" header
  /// is added. The headers are stored in the [extra] field of the options.
  Options _buildOptions(bool isAuthorized, [bool shouldCache = false]) {
    final headers = <String, dynamic>{
      'isAuthorized': isAuthorized,
      'shouldCache': shouldCache,
    };

    return Options(extra: headers);
  }

  /// A common method for handling API responses.
  ///
  /// This method takes a [dioMethod] function that returns a [Future<Response>],
  /// then wraps the call in a [TaskEither.tryCatch]. On success, it returns the
  /// response data as a [Map<String, dynamic>]. On error, if the error is a [DioException],
  /// it is mapped to a [NetworkFailure] using the exception mapper; otherwise,
  /// the error is thrown.
  ApiHandlerResponse _handleResponse(
    Future<Response> Function() dioMethod,
  ) async {
    try {
      final response = await dioMethod();
      return response.data;
    } catch (error, stackTrace) {
      if (error is DioException) {
        return left(_exceptionMapper.mapException(error, stackTrace));
      }
      rethrow;
    }
  }

  /// Sends an HTTP GET request to the specified [path].
  ///
  /// [path]: The endpoint URL path.
  /// [queryParameters]: Optional query parameters to append to the URL.
  /// [cancelRequestAdapter]: Optional adapter to cancel the request.
  /// [shouldCache]: Indicates whether the response should be cached.
  /// [isAuthorized]: Indicates whether the request requires authorization.
  ///
  /// Returns a [TaskEither] containing either a [NetworkFailure] on error or a
  /// [Map<String, dynamic>] with the response data.
  @override
  ApiHandlerResponse get(
    String path, {
    Map<String, dynamic>? queryParameters,
    CancelRequestAdapter? cancelRequestAdapter,
    bool shouldCache = false,
    bool isAuthorized = true,
  }) {
    return _handleResponse(
      () => _dio.get(
        path,
        queryParameters: queryParameters,
        options: _buildOptions(isAuthorized, shouldCache),
        cancelToken: _cancelToken(cancelRequestAdapter),
      ),
    );
  }

  /// Sends an HTTP POST request to the specified [path].
  ///
  /// [path]: The endpoint URL path.
  /// [body]: The request payload as a map.
  /// [formData]: Optional adapter for creating multipart form data.
  /// [queryParameters]: Optional query parameters to append to the URL.
  /// [onSendProgress]: Optional callback to track the progress of the request.
  /// [cancelRequestAdapter]: Optional adapter to cancel the request.
  /// [isAuthorized]: Indicates whether the request requires authorization.
  ///
  /// Returns a [TaskEither] containing either a [NetworkFailure] on error or a
  /// [Map<String, dynamic>] with the response data.
  @override
  ApiHandlerResponse post(
    String path, {
    Map<String, dynamic>? body,
    FormDataAdapter? formData,
    Map<String, dynamic>? queryParameters,
    ProgressTrackerCallback? onSendProgress,
    CancelRequestAdapter? cancelRequestAdapter,
    bool isAuthorized = true,
  }) {
    return _handleResponse(() {
      final data =
          (formData != null && body != null)
              ? formData.createFormData(body)
              : body;
      return _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: _buildOptions(isAuthorized),
        onSendProgress:
            onSendProgress != null
                ? (count, total) => onSendProgress(count / total)
                : null,
        cancelToken: _cancelToken(cancelRequestAdapter),
      );
    });
  }

  /// Sends an HTTP DELETE request to the specified [path].
  ///
  /// [path]: The endpoint URL path.
  /// [queryParameters]: Optional query parameters to append to the URL.
  /// [cancelRequestAdapter]: Optional adapter to cancel the request.
  /// [isAuthorized]: Indicates whether the request requires authorization.
  ///
  /// Returns a [TaskEither] containing either a [NetworkFailure] on error or a
  /// [Map<String, dynamic>] with the response data.
  @override
  ApiHandlerResponse delete(
    String path, {
    Map<String, dynamic>? queryParameters,
    CancelRequestAdapter? cancelRequestAdapter,
    bool isAuthorized = true,
  }) {
    return _handleResponse(
      () => _dio.delete(
        path,
        queryParameters: queryParameters,
        options: _buildOptions(isAuthorized),
        cancelToken: _cancelToken(cancelRequestAdapter),
      ),
    );
  }

  /// Sends an HTTP PUT request to the specified [path].
  ///
  /// [path]: The endpoint URL path.
  /// [body]: The request payload as a map.
  /// [queryParameters]: Optional query parameters to append to the URL.
  /// [formData]: Optional adapter for creating multipart form data.
  /// [cancelRequestAdapter]: Optional adapter to cancel the request.
  /// [isAuthorized]: Indicates whether the request requires authorization.
  ///
  /// Returns a [TaskEither] containing either a [NetworkFailure] on error or a
  /// [Map<String, dynamic>] with the response data.
  @override
  ApiHandlerResponse put(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    FormDataAdapter? formData,
    CancelRequestAdapter? cancelRequestAdapter,
    bool isAuthorized = true,
  }) {
    return _handleResponse(() {
      final data =
          (formData != null && body != null)
              ? formData.createFormData(body)
              : body;
      return _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: _buildOptions(isAuthorized),
        cancelToken: _cancelToken(cancelRequestAdapter),
      );
    });
  }

  /// Sends an HTTP PATCH request to the specified [path].
  ///
  /// [path]: The endpoint URL path.
  /// [body]: The request payload as a map.
  /// [queryParameters]: Optional query parameters to append to the URL.
  /// [formData]: Optional adapter for creating multipart form data.
  /// [cancelRequestAdapter]: Optional adapter to cancel the request.
  /// [isAuthorized]: Indicates whether the request requires authorization.
  ///
  /// Returns a [TaskEither] containing either a [NetworkFailure] on error or a
  /// [Map<String, dynamic>] with the response data.
  @override
  ApiHandlerResponse patch(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    FormDataAdapter? formData,
    CancelRequestAdapter? cancelRequestAdapter,
    bool isAuthorized = true,
  }) {
    return _handleResponse(() {
      final data =
          (formData != null && body != null)
              ? formData.createFormData(body)
              : body;
      return _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: _buildOptions(isAuthorized),
        cancelToken: _cancelToken(cancelRequestAdapter),
      );
    });
  }

  /// Downloads a file from the specified [url] and saves it to the [downloadDestinationPath].
  ///
  /// [url]: The URL from which to download the file.
  /// [downloadDestinationPath]: The local file path where the file should be saved.
  /// [onReceiveProgress]: Optional callback to track the progress of the download.
  /// [cancelRequestAdapter]: Optional adapter to cancel the download request.
  /// [queryParameters]: Optional query parameters to append to the URL.
  /// [isAuthorized]: Indicates whether the download request requires authorization.
  ///
  /// Returns a [TaskEither] containing either a [NetworkFailure] on error or a
  /// [Map<String, dynamic>] with the response data.
  @override
  ApiHandlerResponse download(
    String url,
    String downloadDestinationPath, {
    ProgressTrackerCallback? onReceiveProgress,
    CancelRequestAdapter? cancelRequestAdapter,
    Map<String, dynamic>? queryParameters,
    bool isAuthorized = true,
  }) {
    return _handleResponse(
      () => _dio.download(
        url,
        downloadDestinationPath,
        queryParameters: queryParameters,
        options: _buildOptions(isAuthorized),
        onReceiveProgress:
            onReceiveProgress != null
                ? (count, total) => onReceiveProgress(count / total)
                : null,
        cancelToken: _cancelToken(cancelRequestAdapter),
      ),
    );
  }

  /// Extracts the cancel token from [cancelRequestAdapter] if it is of type [DioCancelRequestAdapter].
  ///
  /// If the provided [cancelRequestAdapter] is not a [DioCancelRequestAdapter],
  /// this method returns `null`.
  dynamic _cancelToken(CancelRequestAdapter? cancelRequestAdapter) {
    if (cancelRequestAdapter == null ||
        cancelRequestAdapter is! DioCancelRequestAdapter) {
      return null;
    }
    return cancelRequestAdapter.cancelToken;
  }
}

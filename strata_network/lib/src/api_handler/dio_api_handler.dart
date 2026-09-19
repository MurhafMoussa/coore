import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';
import 'package:strata_core/strata_core.dart';

import '../error_handling/network_exception_mapper_interface.dart';
import 'api_handler_interface.dart';
import 'cancel_request_manager_interface.dart';
import 'form_data_adapter.dart';

/// Dio implementation of [ApiHandlerInterface].
class DioApiHandler(
  final Dio _dio,
  final NetworkExceptionMapperInterface _exceptionMapper, {
  final CancelRequestManagerInterface? cancelRequestManager,
}) implements ApiHandlerInterface {
  this : _cancelRequestManager = cancelRequestManager;

  final CancelRequestManagerInterface? _cancelRequestManager;

  CancelRequestManagerInterface get _effectiveCancelRequestManager {
    final manager = _cancelRequestManager;
    if (manager != null) {
      return manager;
    }
    return GetIt.instance<CancelRequestManagerInterface>();
  }

  Options _buildOptions({
    required bool isAuthorized,
    bool shouldCache = false,
    bool isFormData = false,
    bool enableRetry = true,
    int? maxRetryAttempts,
    Duration? retryDelay,
  }) {
    final extra = <String, dynamic>{'isAuthorized': isAuthorized};

    extra['enableRetry'] = enableRetry;
    if (maxRetryAttempts != null) {
      extra['maxRetryAttempts'] = maxRetryAttempts;
    }
    if (retryDelay != null) {
      extra['retryDelay'] = retryDelay.inMilliseconds;
    }

    if (shouldCache) {
      extra['shouldCache'] = true;
    }

    return Options(
      extra: extra,
      contentType: isFormData
          ? Headers.multipartFormDataContentType
          : Headers.jsonContentType,
    );
  }

  ResultFuture<T> _handleResponse<T>({
    required Future<Response<dynamic>> Function(CancelToken? cancelToken) dioMethod,
    required T Function(Map<String, dynamic> json) parser,
    String? requestId,
  }) async {
    CancelToken? cancelToken;
    if (requestId != null) {
      cancelToken = _effectiveCancelRequestManager.registerRequest(requestId);
    }

    try {
      final response = await dioMethod(cancelToken);
      if (response.data is List<dynamic>) {
        final formattedMap = {'data': response.data};
        final parsedData = parser(formattedMap);
        return right<Failure, T>(parsedData);
      } else if (response.data is Map<String, dynamic>) {
        final parsedData = parser(response.data as Map<String, dynamic>);
        return right<Failure, T>(parsedData);
      } else if (response.data is String) {
        final formattedMap = {'data': response.data};
        final parsedData = parser(formattedMap);
        return right<Failure, T>(parsedData);
      } else {
        return left<Failure, T>(
          const UnknownFailure(message: 'Invalid response data'),
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
      if (requestId != null && cancelToken != null) {
        _effectiveCancelRequestManager.unregisterToken(requestId, cancelToken);
      }
    }
  }

  @override
  ResultFuture<T> get<T>(
    String path, {
    required T Function(Map<String, dynamic> json) parser,
    Map<String, dynamic>? queryParameters,
    ProgressTrackerCallback? onReceiveProgress,
    bool shouldCache = false,
    bool isAuthorized = false,
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

  @override
  ResultFuture<T> post<T>(
    String path, {
    required T Function(Map<String, dynamic> json) parser,
    Map<String, dynamic>? body,
    FormDataAdapter? formData,
    Map<String, dynamic>? queryParameters,
    ProgressTrackerCallback? onSendProgress,
    ProgressTrackerCallback? onReceiveProgress,
    bool isAuthorized = false,
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

  @override
  ResultFuture<T> delete<T>(
    String path, {
    required T Function(Map<String, dynamic> json) parser,
    Map<String, dynamic>? queryParameters,
    bool isAuthorized = false,
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

  @override
  ResultFuture<T> put<T>(
    String path, {
    required T Function(Map<String, dynamic> json) parser,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    FormDataAdapter? formData,
    ProgressTrackerCallback? onSendProgress,
    ProgressTrackerCallback? onReceiveProgress,
    bool isAuthorized = false,
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

  @override
  ResultFuture<T> patch<T>(
    String path, {
    required T Function(Map<String, dynamic> json) parser,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    FormDataAdapter? formData,
    ProgressTrackerCallback? onSendProgress,
    ProgressTrackerCallback? onReceiveProgress,
    bool isAuthorized = false,
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

  @override
  ResultFuture<T> download<T>(
    String url,
    String downloadDestinationPath, {
    required T Function(Map<String, dynamic> json) parser,
    ProgressTrackerCallback? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    bool isAuthorized = false,
    bool enableRetry = true,
    int? maxRetryAttempts,
    Duration? retryDelay,
    String? requestId,
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

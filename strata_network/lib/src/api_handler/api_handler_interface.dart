import 'package:strata_core/strata_core.dart';
import '../error_handling/network_exception_mapper_interface.dart';
import 'form_data_adapter.dart';

/// Abstract contract for handling API requests with functional programming [ResultFuture<T>].
abstract interface class ApiHandlerInterface {
  /// Sends an HTTP GET request to [path].
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
  });

  /// Sends an HTTP POST request to [path].
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
  });

  /// Sends an HTTP DELETE request to [path].
  ResultFuture<T> delete<T>(
    String path, {
    required T Function(Map<String, dynamic> json) parser,
    Map<String, dynamic>? queryParameters,
    bool isAuthorized = false,
    bool enableRetry = true,
    int? maxRetryAttempts,
    Duration? retryDelay,
    String? requestId,
  });

  /// Sends an HTTP PUT request to [path].
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
  });

  /// Sends an HTTP PATCH request to [path].
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
  });

  /// Downloads a file from [url] and saves it to [downloadDestinationPath].
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
  });
}

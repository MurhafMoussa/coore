import 'dart:io';

import 'package:coore/lib.dart';
import 'package:dio/dio.dart';

/// An interceptor that automatically retries failed HTTP requests.
///
/// This interceptor supports both global retry settings (from [NetworkConfigEntity])
/// and per-request retry configuration. Per-request settings take precedence over
/// global settings, allowing fine-grained control over retry behavior for individual requests.
///
/// **Per-Request Retry Configuration:**
/// Each API handler method (get, post, put, patch, delete, download) accepts optional
/// retry parameters:
/// - [enableRetry]: Disable retry for specific requests (defaults to true)
/// - [maxRetryAttempts]: Override max retries for specific requests (defaults to global setting)
/// - [retryDelay]: Override retry delay for specific requests (defaults to global setting)
///
/// **Retry Conditions:**
/// Requests are retried when:
/// - Connection timeout, send timeout, or receive timeout occurs
/// - SocketException (network connectivity issues)
/// - Server returns status codes configured in [NetworkConfigEntity.retryOnStatusCodes]
///   (typically 5xx server errors)
///
/// **Example:**
/// ```dart
/// // Disable retry for a specific request
/// apiHandler.get('/users', parser: User.fromJson, enableRetry: false);
///
/// // Custom retry settings for a specific request
/// apiHandler.post('/data',
///   parser: Data.fromJson,
///   maxRetryAttempts: 2,
///   retryDelay: Duration(seconds: 5),
/// );
/// ```
class RetryInterceptor extends Interceptor {
  final NetworkConfigEntity _networkConfigEntity;

  RetryInterceptor(this._networkConfigEntity);

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;

    // Safely retrieve retry count, defaulting to 0 if not present
    int currentRetry = options.extra['retry_count'] as int? ?? 0;

    // Get per-request retry settings, falling back to global settings
    final enableRetry =
        options.extra['enableRetry'] as bool? ??
        _networkConfigEntity.enableRetry;
    final maxRetryAttempts =
        options.extra['maxRetryAttempts'] as int? ??
        _networkConfigEntity.maxRetries;
    final retryDelayMs = options.extra['retryDelay'] as int?;
    final retryDelay = retryDelayMs != null
        ? Duration(milliseconds: retryDelayMs)
        : _networkConfigEntity.retryInterval;

    // 1. Check if the error is retryable
    final shouldRetry = _shouldRetry(
      err: err,
      currentRetry: currentRetry,
      enableRetry: enableRetry,
      maxRetryAttempts: maxRetryAttempts,
    );

    if (shouldRetry) {
      // Update the retry count for the next attempt
      options.extra['retry_count'] = currentRetry + 1;

      // Delay the next attempt (use per-request delay if provided, otherwise global)
      await Future<void>.delayed(retryDelay);

      try {
        // 2. Clone and resend the request
        final response = await getIt<Dio>().fetch<Map<String, dynamic>>(
          options,
        );

        // 3. Handle success of the retry
        handler.resolve(response);
      } on DioException catch (e) {
        // If retry fails, pass the new error down the chain
        handler.next(e);
      }
    } else {
      // 4. If not retryable, or max retries reached, pass the original error
      handler.next(err);
    }
  }

  bool _shouldRetry({
    required DioException err,
    required int currentRetry,
    required bool enableRetry,
    required int maxRetryAttempts,
  }) {
    // Check per-request enableRetry setting first
    if (!enableRetry) {
      return false;
    }
    // A request should only be retried if:
    // 1. We haven't reached the maximum number of retries.
    if (currentRetry >= maxRetryAttempts) {
      return false;
    }

    // 2. The error type is a timeout or a connectivity issue.
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.error is SocketException) {
      return true;
    }

    // 3. The status code indicates a transient server error (e.g., 5xx).
    if (err.response != null &&
        _networkConfigEntity.retryOnStatusCodes.contains(
          err.response!.statusCode,
        )) {
      return true;
    }

    return false;
  }
}

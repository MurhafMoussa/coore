import 'dart:io';

import 'package:coore/lib.dart';
import 'package:dio/dio.dart';

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

    // 1. Check if the error is retryable
    final shouldRetry = _shouldRetry(err, currentRetry);

    if (shouldRetry) {
      // Update the retry count for the next attempt
      options.extra['retry_count'] = currentRetry + 1;

      // Delay the next attempt
      await Future<void>.delayed(_networkConfigEntity.retryInterval);

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

  bool _shouldRetry(DioException err, int currentRetry) {
    // A request should only be retried if:
    // 1. We haven't reached the maximum number of retries.
    if (currentRetry >= _networkConfigEntity.maxRetries) {
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

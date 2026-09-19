import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../config/network_config_entity.dart';

/// Interceptor that automatically retries transient HTTP request failures.
class RetryInterceptor extends Interceptor {
  RetryInterceptor(this._networkConfigEntity);

  final NetworkConfigEntity _networkConfigEntity;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;

    final int currentRetry = options.extra['retry_count'] as int? ?? 0;
    final enableRetry = options.extra['enableRetry'] as bool? ??
        _networkConfigEntity.enableRetry;
    final maxRetryAttempts = options.extra['maxRetryAttempts'] as int? ??
        _networkConfigEntity.maxRetries;
    final retryDelayMs = options.extra['retryDelay'] as int?;
    final retryDelay = retryDelayMs != null
        ? Duration(milliseconds: retryDelayMs)
        : _networkConfigEntity.retryInterval;

    final shouldRetry = _shouldRetry(
      err: err,
      currentRetry: currentRetry,
      enableRetry: enableRetry,
      maxRetryAttempts: maxRetryAttempts,
    );

    if (shouldRetry) {
      options.extra['retry_count'] = currentRetry + 1;
      await Future<void>.delayed(retryDelay);

      try {
        final response = await GetIt.instance<Dio>().fetch<Map<String, dynamic>>(
          options,
        );
        handler.resolve(response);
      } on DioException catch (e) {
        handler.next(e);
      }
    } else {
      handler.next(err);
    }
  }

  bool _shouldRetry({
    required DioException err,
    required int currentRetry,
    required bool enableRetry,
    required int maxRetryAttempts,
  }) {
    if (!enableRetry) {
      return false;
    }
    if (currentRetry >= maxRetryAttempts) {
      return false;
    }

    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.error is SocketException) {
      return true;
    }

    if (err.response != null &&
        _networkConfigEntity.retryOnStatusCodes.contains(
          err.response!.statusCode,
        )) {
      return true;
    }

    return false;
  }
}

import 'package:dio/dio.dart';
import 'package:strata_core/strata_core.dart';

/// Interceptor logging HTTP requests and responses using [CoreLoggerInterface].
class LoggingInterceptor extends Interceptor {
  LoggingInterceptor({
    this.logger = const NoOpCoreLogger(),
  });

  final CoreLoggerInterface logger;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    logger.debug('HTTP ${options.method} Request: ${options.path}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    logger.debug(
      'HTTP Response [${response.statusCode}]: ${response.requestOptions.path}',
    );
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    logger.error(
      'HTTP Error [${err.response?.statusCode}]: ${err.requestOptions.path}',
      err,
      err.stackTrace,
    );
    super.onError(err, handler);
  }
}

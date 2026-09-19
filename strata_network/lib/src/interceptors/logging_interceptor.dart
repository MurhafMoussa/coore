import 'package:dio/dio.dart';
import 'package:strata_core/strata_core.dart';

/// Interceptor logging HTTP requests and responses using [CoreLoggerInterface].
class LoggingInterceptor extends Interceptor {
  LoggingInterceptor({
    CoreLoggerInterface logger = const NoOpCoreLogger(),
  }) : _logger = logger;

  final CoreLoggerInterface _logger;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logger.debug('HTTP GET/POST Request: ${options.method} ${options.path}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    _logger.debug(
      'HTTP Response [${response.statusCode}]: ${response.requestOptions.path}',
    );
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.error(
      'HTTP Error [${err.response?.statusCode}]: ${err.requestOptions.path}',
      err,
      err.stackTrace,
    );
    super.onError(err, handler);
  }
}

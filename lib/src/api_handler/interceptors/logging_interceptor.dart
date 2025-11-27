import 'package:dio/dio.dart';
import 'package:talker/talker.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

/// Dio interceptor that uses TalkerDioLogger for logging HTTP requests/responses.
///
/// This class wraps [TalkerDioLogger] to maintain backward compatibility
/// with the existing [LoggingInterceptor] API while using Talker's powerful
/// logging capabilities under the hood.
class LoggingInterceptor extends Interceptor {
  /// Creates a [LoggingInterceptor] that uses TalkerDioLogger.
  ///
  /// [talker] - The Talker instance to use for logging
  /// [settings] - Optional settings to customize logging behavior
  LoggingInterceptor({
    required Talker talker,
    TalkerDioLoggerSettings? settings,
  }) : _talkerDioLogger = TalkerDioLogger(
         talker: talker,
         settings: settings ?? const TalkerDioLoggerSettings(),
       );

  final TalkerDioLogger _talkerDioLogger;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _talkerDioLogger.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _talkerDioLogger.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _talkerDioLogger.onError(err, handler);
  }
}

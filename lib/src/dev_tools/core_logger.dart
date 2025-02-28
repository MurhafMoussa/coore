import 'package:logger/logger.dart';

/// Abstract logging interface for application-wide logging
abstract interface class CoreLogger {
  /// Log verbose message for detailed diagnostics
  void verbose(dynamic message, [dynamic error, StackTrace? stackTrace]);

  /// Log debug information for development-time analysis
  void debug(dynamic message, [dynamic error, StackTrace? stackTrace]);

  /// Log informational messages about application operation
  void info(dynamic message, [dynamic error, StackTrace? stackTrace]);

  /// Log non-critical issues that might require attention
  void warning(dynamic message, [dynamic error, StackTrace? stackTrace]);

  /// Log critical errors that need immediate investigation
  void error(dynamic message, [dynamic error, StackTrace? stackTrace]);
}

/// Concrete implementation using the logger package
class CoreLoggerImpl implements CoreLogger {
  final Logger _logger;

  CoreLoggerImpl(this._logger);

  @override
  void debug(message, [error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  @override
  void error(message, [error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  @override
  void info(message, [error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  @override
  void verbose(message, [error, StackTrace? stackTrace]) {
    _logger.t(message, error: error, stackTrace: stackTrace);
  }

  @override
  void warning(message, [error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }
}

import 'dart:core';

import 'package:logger/logger.dart';

/// Abstract logging interface for application-wide logging
abstract interface class CoreLogger {
  /// Log verbose message for detailed diagnostics
  void verbose(dynamic message, [Object? error, StackTrace? stackTrace]);

  /// Log debug information for development-time analysis
  void debug(dynamic message, [Object? error, StackTrace? stackTrace]);

  /// Log informational messages about application operation
  void info(dynamic message, [Object? error, StackTrace? stackTrace]);

  /// Log non-critical issues that might require attention
  void warning(dynamic message, [Object? error, StackTrace? stackTrace]);

  /// Log critical errors that need immediate investigation
  void error(dynamic message, [Object? error, StackTrace? stackTrace]);
}

/// Concrete implementation using the logger package
class CoreLoggerImpl implements CoreLogger {
  CoreLoggerImpl(this._logger, {required this.shouldLog});
  final Logger _logger;
  final bool shouldLog;
  @override
  void debug(dynamic message, [Object? error, StackTrace? stackTrace]) {
    if (shouldLog) {
      _logger.d(message, error: error, stackTrace: stackTrace);
    }
  }

  @override
  void error(dynamic message, [Object? error, StackTrace? stackTrace]) {
    if (shouldLog) {
      _logger.e(message, error: error, stackTrace: stackTrace);
    }
  }

  @override
  void info(dynamic message, [Object? error, StackTrace? stackTrace]) {
    if (shouldLog) {
      _logger.i(message, error: error, stackTrace: stackTrace);
    }
  }

  @override
  void verbose(dynamic message, [Object? error, StackTrace? stackTrace]) {
    if (shouldLog) {
      _logger.t(message, error: error, stackTrace: stackTrace);
    }
  }

  @override
  void warning(dynamic message, [Object? error, StackTrace? stackTrace]) {
    if (shouldLog) {
      _logger.w(message, error: error, stackTrace: stackTrace);
    }
  }
}

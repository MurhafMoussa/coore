import 'dart:core';

import 'package:talker_flutter/talker_flutter.dart';



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

/// Concrete implementation using the Talker package
class CoreLoggerImpl implements CoreLogger {
  CoreLoggerImpl(this._talker, {required this.shouldLog});
  final Talker _talker;
  final bool shouldLog;

  @override
  void debug(dynamic message, [Object? error, StackTrace? stackTrace]) {
    if (shouldLog) {
      if (error != null && stackTrace != null) {
        _talker.debug(message, error, stackTrace);
      } else if (error != null) {
        _talker.debug(message, error);
      } else {
        _talker.debug(message);
      }
    }
  }

  @override
  void error(dynamic message, [Object? error, StackTrace? stackTrace]) {
    if (shouldLog) {
      if (error != null && stackTrace != null) {
        _talker.error(message, error, stackTrace);
      } else if (error != null) {
        _talker.error(message, error);
      } else {
        _talker.error(message);
      }
    }
  }

  @override
  void info(dynamic message, [Object? error, StackTrace? stackTrace]) {
    if (shouldLog) {
      if (error != null && stackTrace != null) {
        _talker.info(message, error, stackTrace);
      } else if (error != null) {
        _talker.info(message, error);
      } else {
        _talker.info(message);
      }
    }
  }

  @override
  void verbose(dynamic message, [Object? error, StackTrace? stackTrace]) {
    if (shouldLog) {
      if (error != null && stackTrace != null) {
        _talker.verbose(message, error, stackTrace);
      } else if (error != null) {
        _talker.verbose(message, error);
      } else {
        _talker.verbose(message);
      }
    }
  }

  @override
  void warning(dynamic message, [Object? error, StackTrace? stackTrace]) {
    if (shouldLog) {
      if (error != null && stackTrace != null) {
        _talker.warning(message, error, stackTrace);
      } else if (error != null) {
        _talker.warning(message, error);
      } else {
        _talker.warning(message);
      }
    }
  }
}

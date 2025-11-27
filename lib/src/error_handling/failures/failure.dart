import 'package:equatable/equatable.dart';
/// Base class for all failures in the application.
///
/// Designed for Enterprise observability:
/// - [message]: User-friendly message (safe to show in UI).
/// - [code]: Stable error code for analytics or logic (e.g., 'AUTH_001').
/// - [stackTrace]: For reporting to Crashlytics/Sentry.
/// - [originalException]: The raw exception for debugging.
abstract class Failure extends Equatable implements Exception {
  const Failure({
    required this.message,
    this.code,
    this.stackTrace,
    this.originalException,
  });

  final String message;
  final String? code;
  final StackTrace? stackTrace;
  final Object? originalException;

  @override
  List<Object?> get props => [message, code, stackTrace, originalException];

  @override
  bool get stringify => true;
}

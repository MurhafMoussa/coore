import 'package:equatable/equatable.dart';

/// Base class for all failures in the application.
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

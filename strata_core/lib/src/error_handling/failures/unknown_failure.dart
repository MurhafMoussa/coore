import 'failure.dart';

/// Unexpected/unhandled failures.
class UnknownFailure extends Failure {
  const UnknownFailure({
    required super.message,
    super.code = 'UNKNOWN',
    super.stackTrace,
    super.originalException,
  });
}

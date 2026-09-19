import 'failure.dart';

/// Client-side data validation failure.
class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.code = 'VALIDATION_ERR',
    super.stackTrace,
    super.originalException,
  });
}

import 'failure.dart';

/// Business rule violation failure.
class BusinessFailure extends Failure {
  const BusinessFailure({
    required super.message,
    super.code = 'BIZ_RULE',
    super.stackTrace,
    super.originalException,
  });
}

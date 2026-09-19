import 'failure.dart';

/// Authorization issues (401/403).
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    super.message = 'Access denied',
    super.code = 'ACCESS_DENIED',
    super.stackTrace,
    super.originalException,
  });
}

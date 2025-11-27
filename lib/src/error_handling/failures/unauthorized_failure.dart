import 'package:coore/coore.dart';

/// Authorization issues (403).
/// The user is logged in but doesn't have the right role/scope.
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    super.message = 'Access denied',
    super.code = 'ACCESS_DENIED',
    super.stackTrace,
    super.originalException,
  });
}

import 'package:coore/coore.dart';

/// Authentication issues (401).
/// Used to trigger auto-logout or refresh token flows.
class AuthFailure extends Failure {
  const AuthFailure({
    super.message = 'Session expired',
    super.code = 'AUTH_ERR',
    super.stackTrace,
    super.originalException,
  });
}

import 'failure.dart';

/// Network connectivity issues.
class ConnectionFailure extends Failure {
  const ConnectionFailure({
    super.message = 'No internet connection',
    super.code = 'NO_INTERNET',
    super.stackTrace,
    super.originalException,
  });
}

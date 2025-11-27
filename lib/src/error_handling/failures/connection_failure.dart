import 'package:coore/coore.dart';

/// Network level issues (Timeout, DNS, SSL Handshake, No Internet).
/// Distinct from [ServerFailure] because the request never reached the server.
class ConnectionFailure extends Failure {
  const ConnectionFailure({
    super.message = 'No internet connection',
    super.code = 'CONN_ERR',
    super.stackTrace,
    super.originalException,
  });
}

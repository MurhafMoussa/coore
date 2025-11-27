import 'package:coore/coore.dart';

/// Represents HTTP 4xx/5xx errors from the backend.
class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    required this.statusCode,
    this.requestId,
    super.code = 'SERVER_ERR',
    super.stackTrace,
    super.originalException,
  });

  /// HTTP Status Code (e.g., 404, 500).
  final int statusCode;

  /// Trace ID from the backend (e.g., 'x-request-id' header) for log correlation.
  final String? requestId;

  @override
  List<Object?> get props => [...super.props, statusCode, requestId];
}

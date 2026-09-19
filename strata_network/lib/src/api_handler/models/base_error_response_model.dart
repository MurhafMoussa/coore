/// Abstract contract for structured backend error response models.
abstract class BaseErrorResponseModel {
  const BaseErrorResponseModel({
    required this.status,
    required this.developerMessage,
    required this.timestamp,
    this.traceId,
    this.path,
  });

  /// The HTTP status code (e.g. 400, 401, 500).
  final int status;

  /// Raw technical message from backend.
  final String developerMessage;

  /// Correlation/trace ID for request tracking.
  final String? traceId;

  /// API endpoint path.
  final String? path;

  /// Timestamp of when error occurred.
  final DateTime timestamp;

  /// Returns a map of field names to error messages for validation failures.
  Map<String, String> get validationErrors;
}

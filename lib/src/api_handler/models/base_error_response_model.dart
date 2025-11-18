abstract class BaseErrorResponseModel {
  /// The HTTP status code. (e.g., 404, 500)
  final int status;

  /// The raw, technical error message from the API. (For logging)
  final String developerMessage;

  /// A unique ID to correlate this client error with server logs.
  final String? traceId;

  /// The API endpoint path that was called. (e.g., "/v1/users/register")
  final String? path;

  /// The timestamp of when the error occurred.
  final DateTime timestamp;

  // Note: We remove 'details' and 'errorCode' as concrete
  // implementations will define their own specific properties.

  const BaseErrorResponseModel({
    required this.status,
    required this.developerMessage,
    required this.timestamp,
    this.traceId,
    this.path,
  });
}

import 'package:coore/src/api_handler/api_handler.dart';
import 'package:coore/src/error_handling/failures/failure.dart';

abstract class NetworkFailure extends Failure {
  const NetworkFailure(super.message, {super.stackTrace});
}

/// 400 Bad Request Failure: The server cannot process the request due to a client error (e.g., invalid syntax).
class BadRequestFailure extends NetworkFailure {
  /// This is used when the client sends a request with invalid or malformed data.
  const BadRequestFailure(super.message, {super.stackTrace});
}

/// 401 Unauthorized Failure: The request lacks valid authentication credentials.
class UnauthorizedRequestFailure extends NetworkFailure {
  /// This is used when the user needs to authenticate to access the requested resource.
  const UnauthorizedRequestFailure(super.message, {super.stackTrace});
}

/// 403 Forbidden Failure: The server understands the request but refuses to authorize it.
class ForbiddenFailure extends NetworkFailure {
  /// This is used when the user is not allowed to access the resource, even with proper credentials.
  const ForbiddenFailure(super.message, {super.stackTrace});
}

/// 404 Not Found Failure: The server cannot find the requested resource.
class NotFoundFailure extends NetworkFailure {
  /// This is used when the requested resource cannot be found on the server.
  const NotFoundFailure(super.message, {super.stackTrace});
}

/// 405 Method Not Allowed Failure: The request method is not allowed for the requested resource.
class MethodNotAllowedFailure extends NetworkFailure {
  /// This is used when the HTTP method (GET, POST, PUT, DELETE, etc.) used is not allowed for the endpoint.
  const MethodNotAllowedFailure(super.message, {super.stackTrace});
}

/// 406 Not Acceptable Failure: The resource is not capable of generating content acceptable according to the Accept headers sent in the request.
class NotAcceptableFailure extends NetworkFailure {
  /// This is used when the requested resource cannot provide the appropriate content type as per the client's request.
  const NotAcceptableFailure(super.message, {super.stackTrace});
}

/// 409 Conflict Failure: The request could not be completed due to a conflict with the current state of the resource.
class ConflictFailure extends NetworkFailure {
  /// This is used when there is a conflict, such as trying to create a resource that already exists.
  const ConflictFailure(super.message, {super.stackTrace});
}

/// 413 Payload Too Large Failure: The request is larger than the server is willing or able to process.
class PayloadTooLargeFailure extends NetworkFailure {
  /// This is used when the request body is too large for the server to process.
  const PayloadTooLargeFailure(super.message, {super.stackTrace});
}

/// 422 Validation Failure: When the user submits a request with invalid data.
class ValidationFailure extends NetworkFailure {
  final List<ErrorDetail> errors;

  /// This is used when the server cannot process the entity due to semantic errors in the request.
  const ValidationFailure({
    required String message,
    required this.errors,
    StackTrace? stackTrace,
  }) : super(message, stackTrace: stackTrace);
}

/// 429 Too Many Requests Failure: The user has sent too many requests in a given amount of time.
class TooManyRequestsFailure extends NetworkFailure {
  /// This is used when the server throttles requests to prevent overloading.
  const TooManyRequestsFailure(super.message, {super.stackTrace});
}

/// 418 I'm a teapot Failure: The server refuses to brew coffee because it is a teapot (a fun HTTP status code).
class TeapotFailure extends NetworkFailure {
  /// This is a playful, non-standard HTTP status code, used in some fun error-handling situations.
  const TeapotFailure(super.message, {super.stackTrace});
}

/// 451 Unavailable For Legal Reasons Failure: The resource is unavailable due to legal reasons.
class UnavailableForLegalReasonsFailure extends NetworkFailure {
  /// This is used when access to the resource is restricted for legal reasons.
  const UnavailableForLegalReasonsFailure(super.message, {super.stackTrace});
}

/// 500 Internal Server Error Failure: The server encountered an unexpected condition that prevented it from fulfilling the request.
class InternalServerErrorFailure extends NetworkFailure {
  /// This is used for any unexpected server error that does not fit into other categories.
  const InternalServerErrorFailure(super.message, {super.stackTrace});
}

/// 502 Bad Gateway Failure: The server, while acting as a gateway or proxy, received an invalid response from the upstream server.
class BadGatewayFailure extends NetworkFailure {
  /// This is used when the server acts as a gateway and receives an invalid response from an upstream server.
  const BadGatewayFailure(super.message, {super.stackTrace});
}

/// 503 Service Unavailable Failure: The server is currently unable to handle the request due to a temporary overloading or maintenance of the server.
class ServiceUnavailableFailure extends NetworkFailure {
  /// This is used when the server is temporarily unavailable, often due to maintenance or overload.
  const ServiceUnavailableFailure(super.message, {super.stackTrace});
}

/// 504 Gateway Timeout Failure: The server, while acting as a gateway or proxy, did not receive a timely response from the upstream server.
class GatewayTimeoutFailure extends NetworkFailure {
  /// This is used when the gateway server does not get a timely response from an upstream server.
  const GatewayTimeoutFailure(super.message, {super.stackTrace});
}

/// 505 HTTP Version Not Supported Failure: The server does not support the HTTP protocol version that was used in the request.
class HttpVersionNotSupportedFailure extends NetworkFailure {
  /// This is used when the client request uses an unsupported HTTP version.
  const HttpVersionNotSupportedFailure(super.message, {super.stackTrace});
}

/// RequestCancelled failure is triggered when the request is cancelled.
/// Typically used when the user cancels an ongoing request.
class RequestCancelledFailure extends NetworkFailure {
  const RequestCancelledFailure(super.message, {super.stackTrace});
}

/// RequestTimeout failure is triggered when the request exceeds the specified timeout.
/// This can happen if the request took too long to get a response from the server.
class RequestTimeoutFailure extends NetworkFailure {
  const RequestTimeoutFailure(super.message, {super.stackTrace});
}

/// NoInternetConnection failure is triggered when there is no active internet connection.
/// This is useful when the device has lost network connectivity.
class NoInternetConnectionFailure extends NetworkFailure {
  const NoInternetConnectionFailure(super.message, {super.stackTrace});
}

/// UnableToProcess failure occurs when the server returns a bad certificate.
/// This can happen if the server uses an invalid or expired SSL certificate.
class UnableToProcessFailure extends NetworkFailure {
  const UnableToProcessFailure(super.message, {super.stackTrace});
}

/// ConnectionError failure is triggered when there is a connection error while trying to reach the server.
/// This can occur if the server is unreachable or there are issues in the network connection.
class ConnectionErrorFailure extends NetworkFailure {
  const ConnectionErrorFailure(super.message, {super.stackTrace});
}

/// ConnectionError failure is triggered when the received status code for the request is not handled
class InvalidStatusCodeFailure extends NetworkFailure {
  const InvalidStatusCodeFailure(super.message, {super.stackTrace});
}

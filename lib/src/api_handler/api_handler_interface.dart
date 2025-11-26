import 'package:coore/src/api_handler/form_data_adapter.dart';
import 'package:coore/src/error_handling/failures/network_failure.dart';
import 'package:coore/src/typedefs/core_typedefs.dart';
import 'package:fpdart/fpdart.dart';

/// An abstract interface for handling API requests using a functional
/// programming style with [Either].
///
/// Returns a [Future] that resolves to either a [NetworkFailure] on error or a value
/// of type [T] on success. The response is parsed from JSON using the provided
/// [parser] function. Requests can be cancelled by providing a [requestId] and
/// using [CancelRequestManager] to cancel them. This pattern helps in creating
/// robust error handling mechanisms in the API layer.
abstract interface class ApiHandlerInterface {
  /// Sends an HTTP GET request to the specified [path].
  ///
  /// - [path]: The endpoint URL path.
  /// - [parser]: A function to parse the JSON response into type [T].
  /// - [queryParameters]: Optional map of query parameters to append to the URL.
  /// - [onReceiveProgress]: Optional callback to monitor the progress of the data being received.
  /// - [shouldCache]: Indicates if the response should be cached. Defaults to false.
  /// - [isAuthorized]: Indicates if the request requires authorization. Defaults to false.
  /// - [requestId]: Optional request ID for cancellation support. If provided, the request
  ///                can be cancelled via [CancelRequestManager].
  ///
  /// Returns a [Future] that resolves to either a [NetworkFailure] on error, or a value
  /// of type [T] on success.
  RemoteResponse<T> get<T>(
    String path, {
    required T Function(Map<String, dynamic> json) parser,
    Map<String, dynamic>? queryParameters,
    ProgressTrackerCallback? onReceiveProgress,
    bool shouldCache = false,
    bool isAuthorized = false,
    String? requestId,
  });

  /// Sends an HTTP POST request to the specified [path].
  ///
  /// - [path]: The endpoint URL path.
  /// - [parser]: A function to parse the JSON response into type [T].
  /// - [body]: The request payload as a JSON-like map.
  /// - [formData]: An optional adapter for constructing multipart/form-data,
  ///   useful for file uploads.
  /// - [queryParameters]: Optional query parameters to append to the URL.
  /// - [onSendProgress]: Optional callback to monitor the progress of the data being sent.
  /// - [onReceiveProgress]: Optional callback to monitor the progress of the data being received.
  /// - [isAuthorized]: Indicates if the request requires authorization. Defaults to false.
  /// - [requestId]: Optional request ID for cancellation support. If provided, the request
  ///                can be cancelled via [CancelRequestManager].
  ///
  /// Returns a [Future] that resolves to either a [NetworkFailure] on error, or a value
  /// of type [T] on success.
  RemoteResponse<T> post<T>(
    String path, {
    required T Function(Map<String, dynamic> json) parser,
    Map<String, dynamic>? body,
    FormDataAdapter? formData,
    Map<String, dynamic>? queryParameters,
    ProgressTrackerCallback? onSendProgress,
    ProgressTrackerCallback? onReceiveProgress,
    bool isAuthorized = false,
    String? requestId,
  });

  /// Sends an HTTP DELETE request to the specified [path].
  ///
  /// - [path]: The endpoint URL path.
  /// - [parser]: A function to parse the JSON response into type [T].
  /// - [queryParameters]: Optional query parameters to append to the URL.
  /// - [isAuthorized]: Indicates if the request requires authorization. Defaults to false.
  /// - [requestId]: Optional request ID for cancellation support. If provided, the request
  ///                can be cancelled via [CancelRequestManager].
  ///
  /// Returns a [Future] that resolves to either a [NetworkFailure] on error, or a value
  /// of type [T] on success.
  RemoteResponse<T> delete<T>(
    String path, {
    required T Function(Map<String, dynamic> json) parser,
    Map<String, dynamic>? queryParameters,
    bool isAuthorized = false,
    String? requestId,
  });

  /// Sends an HTTP PUT request to the specified [path].
  ///
  /// - [path]: The endpoint URL path.
  /// - [parser]: A function to parse the JSON response into type [T].
  /// - [body]: The request payload as a JSON-like map.
  /// - [queryParameters]: Optional query parameters to append to the URL.
  /// - [formData]: An optional adapter for constructing multipart/form-data,
  ///   useful for file uploads.
  /// - [onSendProgress]: Optional callback to monitor the progress of the data being sent.
  /// - [onReceiveProgress]: Optional callback to monitor the progress of the data being received.
  /// - [isAuthorized]: Indicates if the request requires authorization. Defaults to false.
  /// - [requestId]: Optional request ID for cancellation support. If provided, the request
  ///                can be cancelled via [CancelRequestManager].
  ///
  /// Returns a [Future] that resolves to either a [NetworkFailure] on error, or a value
  /// of type [T] on success.
  RemoteResponse<T> put<T>(
    String path, {
    required T Function(Map<String, dynamic> json) parser,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    FormDataAdapter? formData,
    ProgressTrackerCallback? onSendProgress,
    ProgressTrackerCallback? onReceiveProgress,
    bool isAuthorized = false,
    String? requestId,
  });

  /// Sends an HTTP PATCH request to the specified [path].
  ///
  /// - [path]: The endpoint URL path.
  /// - [parser]: A function to parse the JSON response into type [T].
  /// - [body]: The partial request payload as a JSON-like map.
  /// - [queryParameters]: Optional query parameters to append to the URL.
  /// - [formData]: An optional adapter for constructing multipart/form-data,
  ///   useful for file uploads.
  /// - [onSendProgress]: Optional callback to monitor the progress of the data being sent.
  /// - [onReceiveProgress]: Optional callback to monitor the progress of the data being received.
  /// - [isAuthorized]: Indicates if the request requires authorization. Defaults to false.
  /// - [requestId]: Optional request ID for cancellation support. If provided, the request
  ///                can be cancelled via [CancelRequestManager].
  ///
  /// Returns a [Future] that resolves to either a [NetworkFailure] on error, or a value
  /// of type [T] on success.
  RemoteResponse<T> patch<T>(
    String path, {
    required T Function(Map<String, dynamic> json) parser,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    FormDataAdapter? formData,
    ProgressTrackerCallback? onSendProgress,
    ProgressTrackerCallback? onReceiveProgress,
    bool isAuthorized = false,
    String? requestId,
  });

  /// Downloads a file from the given [url] and saves it to the [downloadDestinationPath].
  ///
  /// - [url]: The URL from which to download the file.
  /// - [downloadDestinationPath]: The local file path where the file should be saved.
  /// - [parser]: A function to parse the JSON response into type [T].
  /// - [onReceiveProgress]: Optional callback to monitor the progress of the download.
  /// - [queryParameters]: Optional query parameters to append to the URL.
  /// - [isAuthorized]: Indicates if the download request requires authorization. Defaults to false.
  /// - [requestId]: Optional request ID for cancellation support. If provided, the request
  ///                can be cancelled via [CancelRequestManager].
  ///
  /// Returns a [Future] that resolves to either a [NetworkFailure] on error, or a value
  /// of type [T] on success, which could be the file path or a success message.
  RemoteResponse<T> download<T>(
    String url,
    String downloadDestinationPath, {
    ProgressTrackerCallback? onReceiveProgress,
    required T Function(Map<String, dynamic> json) parser,
    Map<String, dynamic>? queryParameters,
    bool isAuthorized = false,
    String? requestId,
  });
}

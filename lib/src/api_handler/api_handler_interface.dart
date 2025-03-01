import 'package:coore/src/api_handler/cancel_request_adapter.dart';
import 'package:coore/src/error_handling/failures/network_failure.dart';
import 'package:fpdart/fpdart.dart';

import '../typedefs/core_typedefs.dart';
import 'form_data_adapter.dart';

/// An abstract interface for handling API requests using a functional
/// programming style with [TaskEither].
///
/// The type [TaskEither<NetworkFailure, Map<String,dynamic>>] represents an asynchronous
/// computation that can either yield a [NetworkFailure] on error or a value
/// of type Map<String,dynamic> on success. This pattern helps in creating robust error
/// handling mechanisms in the API layer.
abstract interface class ApiHandlerInterface {
  /// Sends an HTTP GET request to the specified [path].
  ///
  /// - [path]: The endpoint URL path.
  /// - [queryParameters]: Optional map of query parameters to append to the URL.
  /// - [cancelRequestAdapter]: Optional adapter for request cancellation.
  /// - [shouldCache]: Indicates if the response should be cached. Defaults to false.
  /// - [isAuthorized]: Indicates if the request requires authorization. Defaults to true.
  ///
  /// Returns a [TaskEither] that resolves to either a [NetworkFailure] on error,
  /// or a value of type Map<String,dynamic> on success.
  ApiResponse get(
    String path, {
    Map<String, dynamic>? queryParameters,
    CancelRequestAdapter? cancelRequestAdapter,
    bool shouldCache = false,
    bool isAuthorized = true,
  });

  /// Sends an HTTP POST request to the specified [path].
  ///
  /// - [path]: The endpoint URL path.
  /// - [body]: The request payload as a JSON-like map.
  /// - [formData]: An optional adapter for constructing multipart/form-data,
  ///   useful for file uploads.
  /// - [queryParameters]: Optional query parameters to append to the URL.
  /// - [onSendProgress]: Optional callback to monitor the progress of the data being sent.
  /// - [cancelRequestAdapter]: Optional adapter for request cancellation.
  /// - [isAuthorized]: Indicates if the request requires authorization. Defaults to true.
  ///
  /// Returns a [TaskEither] that resolves to either a [NetworkFailure] on error,
  /// or a value of type Map<String,dynamic> on success.
  ApiResponse post(
    String path, {
    Map<String, dynamic>? body,
    FormDataAdapter? formData,
    Map<String, dynamic>? queryParameters,
    ProgressTrackerCallback? onSendProgress,
    CancelRequestAdapter? cancelRequestAdapter,
    bool isAuthorized = true,
  });

  /// Sends an HTTP DELETE request to the specified [path].
  ///
  /// - [path]: The endpoint URL path.
  /// - [queryParameters]: Optional query parameters to append to the URL.
  /// - [cancelRequestAdapter]: Optional adapter for request cancellation.
  /// - [isAuthorized]: Indicates if the request requires authorization. Defaults to true.
  ///
  /// Returns a [TaskEither] that resolves to either a [NetworkFailure] on error,
  /// or a value of type Map<String,dynamic> on success.
  ApiResponse delete(
    String path, {
    Map<String, dynamic>? queryParameters,
    CancelRequestAdapter? cancelRequestAdapter,
    bool isAuthorized = true,
  });

  /// Sends an HTTP PUT request to the specified [path].
  ///
  /// - [path]: The endpoint URL path.
  /// - [body]: The request payload as a JSON-like map.
  /// - [queryParameters]: Optional query parameters to append to the URL.
  /// - [formData]: An optional adapter for constructing multipart/form-data,
  ///   useful for file uploads.
  /// - [cancelRequestAdapter]: Optional adapter for request cancellation.
  /// - [isAuthorized]: Indicates if the request requires authorization. Defaults to true.
  ///
  /// Returns a [TaskEither] that resolves to either a [NetworkFailure] on error,
  /// or a value of type Map<String,dynamic> on success.
  ApiResponse put(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    FormDataAdapter? formData,
    CancelRequestAdapter? cancelRequestAdapter,
    bool isAuthorized = true,
  });

  /// Sends an HTTP PATCH request to the specified [path].
  ///
  /// - [path]: The endpoint URL path.
  /// - [body]: The partial request payload as a JSON-like map.
  /// - [queryParameters]: Optional query parameters to append to the URL.
  /// - [formData]: An optional adapter for constructing multipart/form-data,
  ///   useful for file uploads.
  /// - [cancelRequestAdapter]: Optional adapter for request cancellation.
  /// - [isAuthorized]: Indicates if the request requires authorization. Defaults to true.
  ///
  /// Returns a [TaskEither] that resolves to either a [NetworkFailure] on error,
  /// or a value of type Map<String,dynamic> on success.
  ApiResponse patch(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    FormDataAdapter? formData,
    CancelRequestAdapter? cancelRequestAdapter,
    bool isAuthorized = true,
  });

  /// Downloads a file from the given [url] and saves it to the [downloadDestinationPath].
  ///
  /// - [url]: The URL from which to download the file.
  /// - [downloadDestinationPath]: The local file path where the file should be saved.
  /// - [onReceiveProgress]: Optional callback to monitor the progress of the download.
  /// - [cancelRequestAdapter]: Optional adapter for request cancellation.
  /// - [queryParameters]: Optional query parameters to append to the URL.
  /// - [isAuthorized]: Indicates if the download request requires authorization. Defaults to true.
  ///
  /// Returns a [TaskEither] that resolves to either a [NetworkFailure] on error,
  /// or a value of type Map<String,dynamic> on success, which could be the file path or a success message.
  ApiResponse download(
    String url,
    String downloadDestinationPath, {
    ProgressTrackerCallback? onReceiveProgress,
    CancelRequestAdapter? cancelRequestAdapter,
    Map<String, dynamic>? queryParameters,
    bool isAuthorized = true,
  });
}

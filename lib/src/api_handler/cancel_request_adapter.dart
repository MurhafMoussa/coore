import 'package:dio/dio.dart';

/// An interface for canceling asynchronous operations.
///
/// Implementations of this interface provide mechanisms to
/// signal and check the cancellation status of operations,
/// such as HTTP requests or long-running tasks.
abstract interface class CancelRequestAdapter {
  /// Cancels the ongoing operation.
  ///
  /// Optionally, a [reason] can be provided to specify why
  /// the operation was canceled. This reason can be useful
  /// for logging or debugging purposes.
  void cancelRequest([Object? reason]);

  /// Indicates whether the operation has been canceled.
  ///
  /// Returns `true` if the operation was canceled; otherwise,
  /// returns `false`.
  bool get isCancelled;
}

/// An implementation of [CancelRequestAdapter] using Dio's [CancelToken].
///
/// This adapter facilitates the cancellation of HTTP requests by
/// leveraging Dio's built-in cancellation mechanism.
class DioCancelRequestAdapter implements CancelRequestAdapter {
  /// The [CancelToken] instance used to manage request cancellation.
  final CancelToken _cancelToken = CancelToken();

  /// Cancels the ongoing HTTP request.
  ///
  /// An optional [reason] can be provided to specify why the request
  /// was canceled. This reason is propagated through Dio's cancellation
  /// mechanism and can be useful for logging or debugging purposes.
  @override
  void cancelRequest([Object? reason]) {
    if (isCancelled) {
      return;
    }
    _cancelToken.cancel(reason);
  }

  /// Indicates whether the HTTP request has been canceled.
  ///
  /// Returns `true` if the request was canceled; otherwise, returns `false`.
  @override
  bool get isCancelled => _cancelToken.isCancelled;

  /// Provides access to the underlying [CancelToken].
  ///
  /// This getter allows the [CancelToken] to be passed to Dio's request
  /// methods, enabling cancellation support for those requests.
  CancelToken get cancelToken => _cancelToken;
}

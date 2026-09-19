import 'package:dio/dio.dart';

/// Abstract contract for managing request cancellation tokens.
abstract class CancelRequestManagerInterface {
  /// Registers a new request under [requestId], returning a distinct [CancelToken].
  CancelToken registerRequest(String requestId);

  /// Cancels a specific [CancelToken] instance.
  void cancelToken(CancelToken token, {String? reason});

  /// Cancels all active tokens associated with [requestId].
  void cancelRequest(String requestId, {String? reason});

  /// Unregisters a specific [CancelToken] for [requestId].
  void unregisterToken(String requestId, CancelToken token);

  /// Cancels all active requests across all registered request IDs.
  void cancelAll({String? reason});

  /// Total count of active cancel tokens currently tracked.
  int get activeRequestCount;

  /// Returns `true` if there are active request tokens tracked.
  bool get hasActiveRequests;
}

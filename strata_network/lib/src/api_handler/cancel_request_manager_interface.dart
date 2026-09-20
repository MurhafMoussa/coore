import 'package:dio/dio.dart';
import 'params/params.dart';

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

/// Extension methods on [CancelRequestManagerInterface] for paginated request cancellation.
///
/// `@example`
/// ```dart
/// final manager = DefaultCancelRequestManager();
/// const params = DefaultPaginationParams(page: 1, limit: 20);
/// final token = manager.registerPaginationRequest(params);
/// manager.cancelPaginationRequest(params, reason: 'Page refreshed');
/// ```
extension PaginatedCancelRequestManagerX on CancelRequestManagerInterface {
  /// Registers a new paginated request under [params.requestId].
  CancelToken registerPaginationRequest(PaginationParams params) {
    return registerRequest(params.requestId);
  }

  /// Cancels all active network requests keying off [params.requestId].
  void cancelPaginationRequest(PaginationParams params, {String? reason}) {
    cancelRequest(params.requestId, reason: reason);
  }
}

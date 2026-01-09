import 'package:coore/src/api_handler/cancel_request_manager.dart';
import 'package:dio/dio.dart';

/// Default implementation of [CancelRequestManager].
class CancelRequestManagerImpl implements CancelRequestManager {
  /// Map of request IDs to their cancel tokens
  final Map<String, CancelToken> _activeRequests = {};

  @override
  void registerRequest(String requestId) {
    _activeRequests[requestId] = CancelToken();
  }

  @override
  CancelToken? getCancelToken(String requestId) {
    return _activeRequests[requestId];
  }

  @override
  void cancelRequest(String requestId, {String? reason}) {
    final token = _activeRequests[requestId];
    if (token != null && !token.isCancelled) {
      token.cancel(reason ?? 'Request cancelled');
    }
    // Note: We don't remove it here - let unregisterRequest handle cleanup
  }

  @override
  void unregisterRequest(String requestId) {
    _activeRequests.remove(requestId);
  }

  @override
  void cancelAll({String? reason}) {
    for (final token in _activeRequests.values) {
      if (!token.isCancelled) {
        token.cancel(reason ?? 'All requests cancelled');
      }
    }
    _activeRequests.clear();
  }

  @override
  int get activeRequestCount => _activeRequests.length;

  @override
  bool get hasActiveRequests => _activeRequests.isNotEmpty;
}

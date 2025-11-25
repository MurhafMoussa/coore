import 'package:dio/dio.dart';

/// An abstract interface for managing request cancellation tokens.
///
/// This service allows any layer in your application to register requests
/// with unique IDs and cancel them later, without prop drilling cancel tokens.
///
/// Usage:
/// ```dart
/// final cancelManager = getIt<CancelRequestManager>();
///
/// // Register a request
/// final requestId = cancelManager.registerRequest();
///
/// // Use the requestId in your API call
/// final result = await apiHandler.get('/users', requestId: requestId);
///
/// // Cancel if needed (from any layer)
/// cancelManager.cancelRequest(requestId);
///
/// // Cleanup after completion
/// cancelManager.unregisterRequest(requestId);
/// ```
abstract class CancelRequestManager {
  /// Generates a unique request ID and creates a cancel token for it.
  ///
  /// Returns the request ID that can be used to cancel the request later.
  String registerRequest();

  /// Gets the cancel token for a given request ID.
  ///
  /// Returns `null` if the request ID doesn't exist.
  CancelToken? getCancelToken(String requestId);

  /// Gets or creates a cancel token for a given request ID.
  ///
  /// If the request ID doesn't exist, creates a new cancel token for it.
  /// Useful when you want to ensure a token exists before making the request.
  CancelToken getOrCreateCancelToken(String requestId);

  /// Cancels a specific request by its ID.
  ///
  /// Does nothing if the request ID doesn't exist or is already cancelled.
  void cancelRequest(String requestId, {String? reason});

  /// Unregisters a request ID and removes its cancel token.
  ///
  /// Call this after a request completes (success or failure) to clean up.
  void unregisterRequest(String requestId);

  /// Cancels all active requests.
  ///
  /// Useful for cleanup scenarios (e.g., when user logs out, app closes, etc.)
  void cancelAll({String? reason});

  /// Returns the number of active requests.
  int get activeRequestCount;

  /// Returns `true` if there are any active requests.
  bool get hasActiveRequests;
}

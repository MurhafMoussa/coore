import 'package:dio/dio.dart';

/// An abstract interface for managing request cancellation tokens.
///
/// This service allows any layer in your application to register requests
/// with static IDs and cancel them later, without prop drilling cancel tokens.
///
/// **Usage Pattern:**
/// Use static string identifiers for each request type. The same [requestId] must be used
/// in both [ApiStateHandler.handleApiCall] and when calling API handler methods.
///
/// ```dart
/// // In your Cubit/Bloc
/// await handler.handleApiCall(
///   apiCall: (params) => getUserUseCase(params),
///   params: GetUserParams(id: userId),
///   requestId: "get_user", // Static ID for this request type
/// );
///
/// // In your UseCase
/// ResultFuture<User> call(GetUserParams params) {
///   return _apiHandler.get(
///     '/users/${params.id}',
///     parser: User.fromJson,
///     requestId: "get_user", // Same static ID
///   );
/// }
///
/// // Cancel if needed (from any layer)
/// getIt<CancelRequestManager>().cancelRequest("get_user");
/// ```
abstract class CancelRequestManager {
  /// Registers a request with the given [requestId] and creates a cancel token for it.
  ///
  /// The [requestId] should be a static string identifier for the request type
  /// (e.g., "get_user", "fetch_posts"). The same ID must be used when calling
  /// API handler methods to enable cancellation.
  ///
  /// This is typically called automatically by [ApiStateHandler] when a [requestId]
  /// is provided. The token is automatically unregistered when the request completes.
  void registerRequest(String requestId);

  /// Gets the cancel token for a given request ID.
  ///
  /// Returns `null` if the request ID doesn't exist.
  CancelToken? getCancelToken(String requestId);

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

import 'dart:collection';

import 'package:coore/lib.dart';
import 'package:dio/dio.dart';
import 'package:mutex/mutex.dart';

/// ---------------------------------------------------------------------------
/// AuthInterceptor
/// ---------------------------------------------------------------------------
///
/// Base abstract authentication interceptor that handles common behavior for
/// authorized requests, including adding credentials to requests and handling
/// 401 errors by triggering a refresh of tokens or cookies. Subclasses must
/// implement [handleRefresh] to perform the refresh logic (e.g., calling the
/// appropriate refresh endpoint).
///
/// Key features:
/// - Checks if a request is marked as authorized and adds credentials accordingly.
/// - Intercepts 401 errors (unauthorized) and queues the request for retry after a
///   successful refresh.
/// - Uses a mutex (_refreshMutex) to ensure that only one refresh attempt occurs
///   at a time.
/// - Pending requests that encountered a 401 are stored in a queue and retried once
///   the refresh completes successfully.
///
abstract class AuthInterceptor extends Interceptor {
  /// Creates an instance of AuthInterceptor.
  ///
  /// [tokenManager] is used to manage tokens or cookies.
  AuthInterceptor(this._tokenManager);

  /// The token manager which handles storage and retrieval of tokens or cookies.
  final AuthTokenManager _tokenManager;

  /// Intercepts outgoing requests.
  ///
  /// If a request is marked as authorized (via `options.extra['isAuthorized']`),
  /// it will call [handleAuthorization] to add necessary credentials (e.g., an
  /// access token or setting cookie options).
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      // Determine if this request requires authorization.
      final isAuthorized = options.extra['isAuthorized'] as bool? ?? false;
      if (isAuthorized) {
        // Add authorization credentials.
        await handleAuthorization(options);
      }
      // Pass the request on.
      handler.next(options);
    } on DioException catch (e) {
      // If a DioException occurs, reject the request.
      handler.reject(e);
    } catch (e) {
      // Catch any other errors and wrap them in a DioException.
      handler.reject(
        DioException(requestOptions: options, error: 'Auth setup failed: $e'),
      );
    }
  }

  /// Intercepts errors from responses.
  ///
  /// For 401 errors (unauthorized) on authorized requests (but not on the refresh
  /// endpoint itself), the interceptor queues the request and attempts to refresh
  /// the credentials by calling [handleRefresh]. If the refresh is successful, the
  /// original requests are retried.
  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Check if this error should trigger a refresh.
    if (_shouldHandleError(err)) {
      await _handle401(err, handler);
    } else {
      // Otherwise, reject the error.
      handler.reject(err);
    }
  }

  /// Determines whether the error should trigger the refresh flow.
  ///
  /// The refresh flow is triggered when:
  /// - The response status code is 401 (unauthorized),
  /// - The request was marked as authorized, and
  /// - The request path does not contain 'auth/refresh' (to avoid infinite loops).
  bool _shouldHandleError(DioException err) {
    final isAuthorized =
        err.requestOptions.extra['isAuthorized'] as bool? ?? false;
    return err.response?.statusCode == 401 &&
        isAuthorized &&
        !err.requestOptions.path.contains('auth/refresh');
  }

  /// Retries the original request after a successful refresh.
  ///
  /// Uses a fresh Dio instance (obtained via [getIt]) to ensure that updated
  /// tokens or cookies are applied to the retried request.
  Future<void> retryRequest(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Get a fresh Dio instance.
    final retryDio = getIt<Dio>();
    try {
      // Re-execute the original request.
      final response = await retryDio.fetch<Map<String, dynamic>>(
        err.requestOptions,
      );
      handler.resolve(response);
    } on DioException catch (e) {
      // Reject if an error occurs during retry.
      handler.reject(e);
    }
  }

  /// Handles authorization for outgoing requests.
  ///
  /// In a token-based flow, this method adds the 'Authorization' header. For
  /// cookie-based flows, subclasses may override this to set cookie-related flags.
  Future<void> handleAuthorization(RequestOptions options) async {
    // Retrieve the access token.
    final accessToken = await _tokenManager.accessToken;
    if (accessToken.isNotEmpty) {
      // Add the access token to the headers.
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
  }

  /// Abstract method for refreshing credentials.
  ///
  /// Subclasses must implement this method to perform the refresh, for example
  /// by calling the refresh endpoint with a refresh token or by issuing a cookie
  /// refresh request.
  Future<bool> handleRefresh(DioException err);

  // --- Internal refresh logic for handling 401 errors ---

  /// Mutex to ensure only one refresh call occurs at a time.
  final Mutex _refreshMutex = Mutex();

  /// Queue of pending error handlers waiting for a refresh to complete.
  final Queue<ErrorInterceptorHandler> _pendingHandlers = Queue();

  /// Internal helper that queues pending requests and executes the refresh logic.
  ///
  /// When a 401 error is intercepted, the corresponding [ErrorInterceptorHandler]
  /// is added to [_pendingHandlers]. The mutex ensures that only one refresh
  /// operation is active at a time. After the refresh completes, all queued requests
  /// are either retried (if refresh succeeded) or rejected (if refresh failed).
  Future<void> _handle401(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Add the current request's handler to the pending queue.
    _pendingHandlers.add(handler);

    // Only proceed with a refresh if one is not already in progress.
    if (!_refreshMutex.isLocked) {
      await _refreshMutex.protect(() async {
        bool refreshSuccess = false;
        try {
          // Attempt to refresh credentials.
          refreshSuccess = await handleRefresh(err);
        } catch (e) {
          // If an error occurs during refresh, treat it as a failure.
          refreshSuccess = false;
        }

        // Process all pending requests.
        while (_pendingHandlers.isNotEmpty) {
          final pendingHandler = _pendingHandlers.removeFirst();
          if (refreshSuccess) {
            // If refresh succeeded, retry the request.
            await retryRequest(err, pendingHandler);
          } else {
            // Otherwise, reject the request.
            pendingHandler.reject(err);
          }
        }
      });
    }
  }
}

/// ---------------------------------------------------------------------------
/// TokenAuthInterceptor
/// ---------------------------------------------------------------------------
///
/// A concrete implementation of [AuthInterceptor] for token-based authentication.
///
/// This interceptor implements the [handleRefresh] method by using a refresh token
/// to request new access and refresh tokens from the server.
///
class TokenAuthInterceptor extends AuthInterceptor {
  /// Creates an instance of TokenAuthInterceptor.
  TokenAuthInterceptor(super.tokenManager);

  @override
  Future<bool> handleRefresh(DioException err) async {
    // Retrieve the refresh token from the token manager.
    try {
      final refreshToken = await _tokenManager.refreshToken;
      if (refreshToken.isEmpty) return false;

      // Get an instance of the API handler.
      final refreshDio = getIt<ApiHandlerInterface>();

      // Make a refresh call with the refresh token.
      final response = await refreshDio.post(
        'auth/refresh',
        body: {'refresh_token': refreshToken},
        isAuthorized: true,
      );

      // Process the response.
      return response.fold((l) => false, (r) async {
        // On success, update the tokens in the token manager.
        await _tokenManager.setTokens(
          accessToken: r['data']['access_token'] as String?,
          refreshToken: r['data']['refresh_token'] as String?,
        );
        return true;
      });
    } catch (e) {
      // In case of an error during refresh, clear tokens and rethrow the error.
      await _tokenManager.clearTokens();
      rethrow;
    }
  }
}

/// ---------------------------------------------------------------------------
/// CookieAuthInterceptor
/// ---------------------------------------------------------------------------
///
/// A concrete implementation of [AuthInterceptor] for cookie-based authentication.
///
/// This interceptor ensures that cookies are sent with requests by setting the
/// appropriate flag. It implements [handleRefresh] by issuing a refresh request
/// that relies on the browser/server to update cookies. If the refresh is successful,
/// the new cookies will be applied automatically to retried requests.
///
class CookieAuthInterceptor extends AuthInterceptor {
  /// Creates an instance of CookieAuthInterceptor.
  CookieAuthInterceptor(super.tokenManager);

  @override
  Future<void> handleAuthorization(RequestOptions options) async {
    // Set withCredentials to true so that cookies are included in the request.
    options.extra['withCredentials'] = true;

    // Call the base implementation in case token-based authorization is also needed.
    await super.handleAuthorization(options);
  }

  @override
  Future<bool> handleRefresh(DioException err) async {
    // Retrieve an instance of the API handler.
    final refreshDio = getIt<ApiHandlerInterface>();

    try {
      // Issue a refresh call. For cookie-based auth, the server will update cookies.
      final response = await refreshDio.post(
        'auth/refresh',
        isAuthorized: true,
      );

      // Process the response.
      return response.fold((l) => false, (r) async {
        // Update access token if necessary. Typically, for cookies, the server will
        // set new cookies via headers. In some cases, you might also update a token.
        await _tokenManager.setTokens(
          accessToken: r['data']['access_token'] as String?,
        );
        return true;
      });
    } catch (e) {
      // In case of an error during refresh, clear tokens and rethrow the error.
      await _tokenManager.clearTokens();
      rethrow;
    }
  }
}

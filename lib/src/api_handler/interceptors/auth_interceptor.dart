import 'dart:collection';

import 'package:coore/lib.dart';
import 'package:dio/dio.dart';
import 'package:mutex/mutex.dart';

/// ---------------------------------------------------------------------------
/// AuthInterceptor
/// ---------------------------------------------------------------------------
///
/// Base abstract authentication interceptor that handles common behavior for
/// authorized requests:
///  - Adds credentials to outgoing requests marked `isAuthorized`.
///  - Intercepts 401 responses (excluding refresh calls and retries),
///    triggers a single shared refresh, and then replays all queued requests.
///  - Uses a mutex to ensure only one refresh attempt at a time.
///  - Queues pending `(RequestOptions, ErrorInterceptorHandler)` entries for replay.
///
/// Subclasses must implement [handleRefresh] to perform the refresh logic
/// (e.g. calling your server’s `auth/refresh` endpoint).
abstract class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._tokenManager);

  final AuthTokenManager _tokenManager;

  /// Intercepts outgoing requests.
  ///
  /// If `options.extra['isAuthorized']==true`, calls [handleAuthorization]
  /// to inject the latest credentials (header or cookies).
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final isAuthorized = options.extra['isAuthorized'] as bool? ?? false;
      if (isAuthorized) {
        await handleAuthorization(options);
      }
      handler.next(options);
    } on DioException catch (e) {
      handler.reject(e);
    } catch (e) {
      handler.reject(
        DioException(requestOptions: options, error: 'Auth setup failed: $e'),
      );
    }
  }

  /// Intercepts errors from responses.
  ///
  /// For 401 errors on authorized requests (but not on a retry or on the
  /// `auth/refresh` path), calls [_handle401] to queue and then refresh+
  /// replay all pending requests.
  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (_shouldHandleError(err)) {
      await _handle401(err, handler);
    } else {
      handler.reject(err);
    }
  }

  /// Returns true when:
  ///  - status == 401,
  ///  - request marked `isAuthorized`,
  ///  - not already a retry (`extra['isRetry'] != true`),
  ///  - and not the refresh endpoint itself.
  bool _shouldHandleError(DioException err) {
    final isAuthorized =
        err.requestOptions.extra['isAuthorized'] as bool? ?? false;
    final isRetry = err.requestOptions.extra['isRetry'] as bool? ?? false;

    return err.response?.statusCode == 401 &&
        isAuthorized &&
        !isRetry &&
        !err.requestOptions.path.contains('auth/refresh');
  }

  /// Retries one of the original requests after a successful refresh.
  ///
  /// - Takes the original [RequestOptions] (not a DioException).
  /// - Marks `options.extra['isRetry']=true` before firing.
  /// - Uses a fresh Dio from your IOC container so interceptors will
  ///   add updated tokens/cookies again.
  Future<void> retryRequest(
    RequestOptions requestOptions,
    ErrorInterceptorHandler handler,
  ) async {
    final retryDio = getIt<Dio>();
    requestOptions.extra['isRetry'] = true;

    try {
      final response = await retryDio.fetch<Map<String, dynamic>>(
        requestOptions,
      );
      handler.resolve(response);
    } on DioException catch (e) {
      handler.reject(e);
    }
  }

  /// Injects credentials into [`options`]. By default adds:
  ///   `Authorization: Bearer <accessToken>`
  /// override in subclasses if you need cookies instead.
  Future<void> handleAuthorization(RequestOptions options) async {
    final accessToken = await _tokenManager.accessToken;
    if (accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
  }

  /// Subclasses must implement your “call the refresh endpoint” logic.
  /// Return `true` on success, `false` otherwise.
  Future<bool> handleRefresh(DioException err);

  // --- internal single‐refresh logic ---

  final Mutex _refreshMutex = Mutex();

  /// Queue of pending requests + their handlers to replay after a refresh.
  final Queue<MapEntry<RequestOptions, ErrorInterceptorHandler>> _pending =
      Queue();

  Future<void> _handle401(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // queue up the original request
    _pending.add(MapEntry(err.requestOptions, handler));

    // only one refresh at a time
    if (!_refreshMutex.isLocked) {
      await _refreshMutex.protect(() async {
        bool refreshSuccess = false;
        try {
          refreshSuccess = await handleRefresh(err);
        } catch (_) {
          refreshSuccess = false;
        }

        // drain the queue
        while (_pending.isNotEmpty) {
          final entry = _pending.removeFirst();
          if (refreshSuccess) {
            await retryRequest(entry.key, entry.value);
          } else {
            entry.value.reject(
              DioException(
                requestOptions: entry.key,
                error: 'Token refresh failed',
              ),
            );
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
/// Concrete interceptor that implements [handleRefresh] via your refresh-token
/// endpoint, storing new access/refresh tokens back into [_tokenManager].
class TokenAuthInterceptor extends AuthInterceptor {
  TokenAuthInterceptor(super.tokenManager);

  @override
  Future<bool> handleRefresh(DioException err) async {
    try {
      final refreshToken = await _tokenManager.refreshToken;
      if (refreshToken.isEmpty) return false;

      final refreshDio = getIt<ApiHandlerInterface>();
      final response = await refreshDio.post(
        'auth/refresh',
        body: {'refresh_token': refreshToken},
        isAuthorized: true,
      );

      return response.fold((l) => false, (r) async {
        await _tokenManager.setTokens(
          accessToken: r['data']['access_token'] as String?,
          refreshToken: r['data']['refresh_token'] as String?,
        );
        return true;
      });
    } catch (e) {
      await _tokenManager.clearTokens();
      rethrow;
    }
  }
}

/// ---------------------------------------------------------------------------
/// CookieAuthInterceptor
/// ---------------------------------------------------------------------------
///
/// Concrete interceptor for cookie-based auth:
///   - sets `options.extra['withCredentials']=true`
///   - refreshes by hitting `auth/refresh`, letting the browser/server
///     reset cookies automatically.
class CookieAuthInterceptor extends AuthInterceptor {
  CookieAuthInterceptor(super.tokenManager);

  @override
  Future<void> handleAuthorization(RequestOptions options) async {
    options.extra['withCredentials'] = true;
    await super.handleAuthorization(options);
  }

  @override
  Future<bool> handleRefresh(DioException err) async {
    final refreshDio = getIt<ApiHandlerInterface>();
    try {
      final response = await refreshDio.post(
        'auth/refresh',
        isAuthorized: true,
      );

      return response.fold((l) => false, (r) async {
        await _tokenManager.setTokens(
          accessToken: r['data']['access_token'] as String?,
        );
        return true;
      });
    } catch (e) {
      await _tokenManager.clearTokens();
      rethrow;
    }
  }
}

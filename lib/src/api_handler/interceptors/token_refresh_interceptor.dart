import 'dart:collection';

import 'package:coore/lib.dart';
import 'package:dio/dio.dart';
import 'package:mutex/mutex.dart';

/// ---------------------------------------------------------------------------
/// TokenRefreshInterceptor
/// ---------------------------------------------------------------------------
/// Interceptor responsible for handling token refresh on 401 errors.
///
/// This interceptor:
///  • Detects 401 errors on authorized requests
///  • Queues pending requests during refresh
///  • Performs a single token refresh operation
///  • Retries all pending requests after successful refresh
///  • Clears tokens and rejects requests on refresh failure
abstract class TokenRefreshInterceptor extends Interceptor {
  TokenRefreshInterceptor(
    this._tokenManager,
    this._networkConfigEntity,
  );

  final AuthTokenManager _tokenManager;
  final NetworkConfigEntity _networkConfigEntity;

  final Mutex _refreshMutex = Mutex();
  final Queue<MapEntry<RequestOptions, ErrorInterceptorHandler>> _pending =
      Queue();

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (_shouldHandle401(err)) {
      await _queueAndRefresh(err, handler);
    } else {
      handler.reject(err);
    }
  }

  bool _shouldHandle401(DioException err) {
    if (!_networkConfigEntity.enableRefreshTokenBehavior) {
      return false;
    }
    final requestOptions = err.requestOptions;
    final isUnauthorized = err.response?.statusCode == 401;
    final requiresAuthorization = requestOptions.extra['isAuthorized'] == true;
    final isNotRetryAttempt = requestOptions.extra['isRetry'] != true;
    final isNotRefreshTokenPath = !requestOptions.path.contains(
      _networkConfigEntity.refreshTokenApiEndpoint,
    );
    final isNotExcludedPath = !_networkConfigEntity.excludedPaths.any(
      (path) => requestOptions.path.contains(path),
    );
    return isUnauthorized &&
        requiresAuthorization &&
        isNotRetryAttempt &&
        isNotRefreshTokenPath &&
        isNotExcludedPath;
  }

  Future<void> _queueAndRefresh(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    _pending.add(MapEntry(err.requestOptions, handler));

    if (!_refreshMutex.isLocked) {
      await _refreshMutex.protect(() async {
        bool success = false;
        try {
          success = await handleRefresh(err);
        } catch (_) {
          success = false;
        }

        while (_pending.isNotEmpty) {
          final entry = _pending.removeFirst();
          if (success) {
            await _retry(entry.key, entry.value);
          } else {
            entry.value.reject(_makeRefreshFailure(entry.key, err));
          }
        }
      });
    }
  }

  Future<void> _retry(
    RequestOptions requestOptions,
    ErrorInterceptorHandler handler,
  ) async {
    final dio = getIt<Dio>();
    requestOptions.extra['isRetry'] = true;
    try {
      final resp = await dio.fetch<Map<String, dynamic>>(requestOptions);
      handler.resolve(resp);
    } on DioException catch (e) {
      handler.reject(e);
    }
  }

  DioException _makeRefreshFailure(RequestOptions opts, DioException err) {
    final statusCode = err.response?.statusCode ?? 401;
    return DioException.badResponse(
      statusCode: statusCode,
      requestOptions: opts,
      response: Response(
        requestOptions: opts,
        statusCode: statusCode,
        data: err.response?.data ??
            {
              'error': {
                'status': statusCode,
                'message': 'Token refresh failed',
              },
            },
      ),
    );
  }

  Future<Never> _clearTokensAndThrowException({
    required DioException err,
    required Object exception,
  }) async {
    await _tokenManager.clearTokens();

    // This new logic inspects the error 'e' from the refresh call
    Map<String, dynamic>? responseData;
    int statusCode = 401;

    if (exception is DioException && exception.response?.data != null) {
      // If the refresh call failed with a specific response from the backend, use it
      statusCode = exception.response!.statusCode ?? 401;
    } else {
      // Otherwise, fall back to a generic message
      responseData = {
        'error': {
          'status': 401,
          'message': 'Token refresh failed: ${exception.toString()}',
        },
      };
    }

    throw DioException.badResponse(
      statusCode: statusCode,
      requestOptions: err.requestOptions,
      response: Response(
        requestOptions: err.requestOptions,
        statusCode: statusCode,
        data: responseData,
      ),
    );
  }

  /// Subclasses implement this to actually call your `auth/refresh` endpoint.
  /// Throw or return false on failure.
  Future<bool> handleRefresh(DioException err);

  /// Helper function to extract nested values from a map using dot notation.
  /// Example: 'data.user.token' will extract data['user']['token']
  dynamic getNestedValue(Map<String, dynamic>? data, String path) {
    // Split the path by the separator
    List<String> keys = path.split('.');

    // Start with the full map
    dynamic currentValue = data;

    // Loop through the keys
    for (String key in keys) {
      // Check if the current value is a Map and has the key
      if (currentValue is Map<String, dynamic> &&
          currentValue.containsKey(key)) {
        // Go one level deeper
        currentValue = currentValue[key];
      } else {
        // A key was missing, so the path is invalid
        return null;
      }
    }

    // Return the final value found
    return currentValue;
  }
}

/// ---------------------------------------------------------------------------
/// BearerTokenRefreshInterceptor
/// ---------------------------------------------------------------------------
/// Handles token refresh for Bearer token authentication.
class BearerTokenRefreshInterceptor extends TokenRefreshInterceptor {
  BearerTokenRefreshInterceptor(super.tokenManager, super.networkConfigEntity);

  @override
  Future<bool> handleRefresh(DioException err) async {
    try {
      final rt = await _tokenManager.refreshToken;
      if (rt.isEmpty) return false;

      final api = getIt<ApiHandlerInterface>();
      final result = await api.post(
        _networkConfigEntity.refreshTokenApiEndpoint,
        parser: (json) => json,
        body: {_networkConfigEntity.refreshTokenKey: rt},
      );

      return result.fold((l) => false, (data) async {
        final accessToken =
            getNestedValue(data, _networkConfigEntity.accessTokenKey)
                as String?;
        final refreshToken =
            getNestedValue(data, _networkConfigEntity.refreshTokenKey)
                as String?;
        await _tokenManager.setTokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
        return true;
      });
    } catch (e) {
      await _clearTokensAndThrowException(err: err, exception: e);
    }
  }
}

/// ---------------------------------------------------------------------------
/// CookieTokenRefreshInterceptor
/// ---------------------------------------------------------------------------
/// Handles token refresh for cookie-based authentication.
class CookieTokenRefreshInterceptor extends TokenRefreshInterceptor {
  CookieTokenRefreshInterceptor(super.tokenManager, super.networkConfigEntity);

  @override
  Future<bool> handleRefresh(DioException err) async {
    try {
      final api = getIt<ApiHandlerInterface>();
      final result = await api.post(
        _networkConfigEntity.refreshTokenApiEndpoint,
        parser: (json) => json,
      );

      return result.fold((l) => false, (data) async {
        /// extract access token from data
        final refreshToken =
            getNestedValue(data, _networkConfigEntity.refreshTokenKey)
                as String?;
        final accessToken =
            getNestedValue(data, _networkConfigEntity.accessTokenKey)
                as String?;
        // Server set new cookie; optionally update tokens too
        await _tokenManager.setTokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
        return true;
      });
    } catch (e) {
      await _clearTokensAndThrowException(err: err, exception: e);
    }
  }
}


import 'dart:collection';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:mutex/mutex.dart';

import '../api_handler/api_handler_interface.dart';
import '../auth/token_manager_interface.dart';
import '../config/network_config_entity.dart';

/// Abstract interceptor responsible for handling token refresh on 401 errors.
abstract class TokenRefreshInterceptorInterface extends Interceptor {
  TokenRefreshInterceptorInterface(
    this._tokenManager,
    this._networkConfigEntity, {
    this.onUnauthenticated,
  });

  final TokenManagerInterface _tokenManager;
  final NetworkConfigEntity _networkConfigEntity;
  final void Function()? onUnauthenticated;

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

        if (!success) {
          await _tokenManager.clearTokens();
          onUnauthenticated?.call();
          _tokenManager.notifyUnauthenticated();
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
    final dio = GetIt.instance<Dio>();
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

  /// Implemented by subclasses to execute the refresh request.
  Future<bool> handleRefresh(DioException err);

  /// Helper to extract nested JSON values via dot notation (e.g. `data.token`).
  dynamic getNestedValue(Map<String, dynamic>? data, String path) {
    if (data == null) return null;
    final List<String> keys = path.split('.');
    dynamic currentValue = data;
    for (final String key in keys) {
      if (currentValue is Map<String, dynamic> &&
          currentValue.containsKey(key)) {
        currentValue = currentValue[key];
      } else {
        return null;
      }
    }
    return currentValue;
  }
}

/// Token refresh interceptor for Bearer token authorization headers.
class BearerTokenRefreshInterceptor extends TokenRefreshInterceptorInterface {
  BearerTokenRefreshInterceptor(
    super.tokenManager,
    super.networkConfigEntity, {
    super.onUnauthenticated,
  });

  @override
  Future<bool> handleRefresh(DioException err) async {
    final rt = await _tokenManager.refreshToken;
    if (rt.isEmpty) return false;

    final api = GetIt.instance<ApiHandlerInterface>();
    final result = await api.post(
      _networkConfigEntity.refreshTokenApiEndpoint,
      parser: (json) => json,
      body: {_networkConfigEntity.refreshTokenKey: rt},
    );

    return result.fold(
      (failure) => false,
      (Map<String, dynamic> data) async {
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
      },
    );
  }
}

/// Token refresh interceptor for cookie-based authorization.
class CookieTokenRefreshInterceptor extends TokenRefreshInterceptorInterface {
  CookieTokenRefreshInterceptor(
    super.tokenManager,
    super.networkConfigEntity, {
    super.onUnauthenticated,
  });

  @override
  Future<bool> handleRefresh(DioException err) async {
    final api = GetIt.instance<ApiHandlerInterface>();
    final result = await api.post(
      _networkConfigEntity.refreshTokenApiEndpoint,
      parser: (json) => json,
    );

    return result.fold(
      (failure) => false,
      (Map<String, dynamic> data) async {
        final refreshToken =
            getNestedValue(data, _networkConfigEntity.refreshTokenKey)
                as String?;
        final accessToken =
            getNestedValue(data, _networkConfigEntity.accessTokenKey)
                as String?;
        await _tokenManager.setTokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
        return true;
      },
    );
  }
}

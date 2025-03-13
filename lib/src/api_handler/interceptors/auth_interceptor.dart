import 'package:coore/lib.dart';
import 'package:dio/dio.dart';

abstract class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._tokenManager);

  final AuthTokenManager _tokenManager;
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final isAuthorized = options.extra['isAuthorized'] as bool;
      if (isAuthorized) {
        await handleAuthorization(options); // Implemented in subclasses
      }
      handler.next(options);
    } on DioException catch (e) {
      handler.reject(e, true);
    } catch (e) {
      handler.reject(
        DioException(requestOptions: options, error: 'Auth setup failed: $e'),
        true,
      );
    }
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      try {
        final success = await handleRefresh(err); // Implemented in subclasses
        if (success) {
          await retryRequest(err, handler); // Shared retry logic
        } else {
          handler.reject(err);
        }
      } catch (e) {
        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: 'Refresh failed: $e',
          ),
        );
      }
    } else {
      handler.next(err);
    }
  }

  // Shared retry logic
  Future<void> retryRequest(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final retryDio = getIt<Dio>();
    final clonedRequest = await retryDio.fetch(err.requestOptions);
    handler.resolve(clonedRequest);
  }

  // Abstract methods for subclasses to implement
  Future<void> handleAuthorization(RequestOptions options) async {
    final accessToken = await _tokenManager.accessToken;
    if (accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
  }

  Future<bool> handleRefresh(DioException err);
}

class TokenAuthInterceptor extends AuthInterceptor {
  TokenAuthInterceptor(super.tokenManager);

  @override
  Future<bool> handleRefresh(DioException err) async {
    final refreshToken = await _tokenManager.refreshToken;
    if (refreshToken.isEmpty) return false;

    final refreshDio = getIt<Dio>();
    final response = await refreshDio.post(
      'auth/refresh',
      data: {'refresh_token': refreshToken},
    );

    // Update tokens
    _tokenManager.setTokens(
      accessToken: response.data['data']['access_token'],
      refreshToken: response.data['data']['refresh_token'],
    );
    return true;
  }
}

class CookieAuthInterceptor extends AuthInterceptor {
  CookieAuthInterceptor(super.tokenManager);

  @override
  Future<void> handleAuthorization(RequestOptions options) async {
    options.extra['withCredentials'] = true;
    super.handleAuthorization(options);
  }

  @override
  Future<bool> handleRefresh(DioException err) async {
    final refreshDio = getIt<Dio>();
    refreshDio.options.extra['withCredentials'] = true; // Cookies for refresh
    try {
      final response = await refreshDio.post('auth/refresh');
      _tokenManager.setTokens(
        accessToken: response.data['data']['access_token'],
      );
      return true;
    } catch (_) {
      return false;
    }
  }
}

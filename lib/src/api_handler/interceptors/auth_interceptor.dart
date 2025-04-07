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
        await handleAuthorization(options); 
      }
      handler.next(options);
    } on DioException catch (e) {
      handler.reject(e,);
    } catch (e) {
      handler.reject(
        DioException(requestOptions: options, error: 'Auth setup failed: $e'),
       
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
        final success = await handleRefresh(err);
        if (success) {
          await retryRequest(err, handler); 
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
      handler.reject(err);
    }
  }


  Future<void> retryRequest(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final retryDio = getIt<Dio>();
    final clonedRequest = await retryDio.fetch(err.requestOptions);
    handler.resolve(clonedRequest);
  }

 
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

    final refreshDio = getIt<ApiHandlerInterface>();
    final response = await refreshDio.post(
      'auth/refresh',
      body: {'refresh_token': refreshToken},
      isAuthorized: true,
    );
    return response.fold((l) => false, (r) {
      _tokenManager.setTokens(
        accessToken: r['data']['access_token'],
        refreshToken: r['data']['refresh_token'],
      );
      return true;
    });
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
    final refreshDio = getIt<ApiHandlerInterface>();

    final response = await refreshDio.post('auth/refresh', isAuthorized: true);
    return response.fold((l) => false, (r) {
      _tokenManager.setTokens(
        accessToken: r['data']['access_token'],
      
      );
      return true;
    });
  }
}

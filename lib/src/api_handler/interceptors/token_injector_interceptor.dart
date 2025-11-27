import 'dart:io';

import 'package:coore/lib.dart';
import 'package:dio/dio.dart';

/// ---------------------------------------------------------------------------
/// TokenInjectorInterceptor
/// ---------------------------------------------------------------------------
/// Interceptor responsible for injecting authentication tokens into requests.
///
/// This interceptor:
///  • Adds Bearer tokens to requests marked `isAuthorized`
///  • Supports both token-based and cookie-based authentication
abstract class TokenInjectorInterceptor extends Interceptor {
  TokenInjectorInterceptor(AuthTokenManager tokenManager)
    : _tokenManager = tokenManager;

  final AuthTokenManager _tokenManager;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      if (options.extra['isAuthorized'] == true) {
        await _injectToken(options);
      }
      handler.next(options);
    } on DioException catch (e) {
      handler.reject(e);
    } catch (e) {
      handler.reject(
        DioException.badResponse(
          statusCode: 401,
          requestOptions: options,
          response: Response(
            requestOptions: options,
            statusCode: 401,
            data: {
              'error': {'status': 401, 'message': 'Auth setup failed: $e'},
            },
          ),
        ),
      );
    }
  }

  /// Subclasses implement this to inject the appropriate token format.
  Future<void> _injectToken(RequestOptions options) async {
    final token = await _tokenManager.accessToken;
    if (token.isNotEmpty) {
      options.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
    }
  }
}

/// ---------------------------------------------------------------------------
/// BearerTokenInjectorInterceptor
/// ---------------------------------------------------------------------------
/// Injects Bearer tokens into requests.
class BearerTokenInjectorInterceptor extends TokenInjectorInterceptor {
  BearerTokenInjectorInterceptor(super.tokenManager);
}

/// ---------------------------------------------------------------------------
/// CookieTokenInjectorInterceptor
/// ---------------------------------------------------------------------------
/// Injects Bearer tokens and enables cookie credentials for requests.
class CookieTokenInjectorInterceptor extends TokenInjectorInterceptor {
  CookieTokenInjectorInterceptor(super.tokenManager);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.extra['withCredentials'] = true;
    return super.onRequest(options, handler);
  }
}

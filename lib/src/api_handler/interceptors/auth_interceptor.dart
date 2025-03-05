import 'package:coore/src/local_storage/secure_database/secure_database.dart';
import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._secureStorage);
  final SecureDatabaseInterface _secureStorage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      // Check if authorization is required for this request
      final isAuthorized = options.extra['isAuthorized'] as bool;

      if (isAuthorized) {
        // Get the access token from secure storage
        final tokenEither = await _secureStorage.read('accessToken');
        tokenEither.fold(
          (l) {
            throw DioException(
              requestOptions: options,
              error: 'Authorization token not found',
            );
          },
          (accessToken) {
            options.headers.addAll({'Authorization': 'Bearer $accessToken'});
          },
        );
      }

      return handler.next(options);
    } on DioException catch (e) {
      return handler.reject(e);
    } catch (e) {
      return handler.reject(
        DioException(
          requestOptions: options,
          error: 'Authorization failed: $e',
        ),
      );
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    //todo: Handle 401 unauthorized errors
    if (err.response?.statusCode == 401) {}
    super.onError(err, handler);
  }
}

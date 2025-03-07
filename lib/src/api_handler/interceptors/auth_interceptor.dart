import 'package:coore/lib.dart';
import 'package:coore/src/api_handler/api_handler.dart';
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
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        // Retrieve the refresh token from secure storage.
        final refreshTokenEither = await _secureStorage.read('refreshToken');
        final refreshToken = await refreshTokenEither.fold((failure) async {
          // No refresh token found, propagate the error.
          return null;
        }, (token) async => token);

        if (refreshToken == null) {
          return handler.reject(err);
        }

        // Create a separate Dio instance for the token refresh call.
        final refreshDio = getIt<ApiHandlerInterface>();

        // Make a refresh token call.
        // NOTE: Replace the URL with your actual refresh endpoint.
        final refreshResponse = await refreshDio.post(
          'auth/refresh',
          body: {'refreshToken': refreshToken},
          isAuthorized: false,
        );
        refreshResponse.fold((l) => handler.reject(err), (data) async {
          // Extract new tokens from the refresh response.
          final newAccessToken = data['access_token'];
          final newRefreshToken = data['refresh_token'];

          // Save the new tokens.
          await _secureStorage.write('accessToken', newAccessToken);
          await _secureStorage.write('refreshToken', newRefreshToken);

          // Update the failed request's header with the new token.
          err.requestOptions.headers['Authorization'] =
              'Bearer $newAccessToken';

          // Retry the original request using a new Dio instance to avoid interceptor loops.
          final clonedRequest = await Dio().fetch(err.requestOptions);
          return handler.resolve(clonedRequest);
        });
      } catch (e) {
        return handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: 'Token refresh failed: $e',
          ),
        );
      }
    }
    return super.onError(err, handler);
  }
}

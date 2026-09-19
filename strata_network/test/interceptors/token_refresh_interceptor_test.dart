import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:strata_network/strata_network.dart';
import 'package:test/test.dart';

class MockTokenManager extends Mock implements TokenManagerInterface {}
class MockErrorInterceptorHandler extends Mock implements ErrorInterceptorHandler {}

class TestTokenRefreshInterceptor extends TokenRefreshInterceptorInterface {
  TestTokenRefreshInterceptor(
    super.tokenManager,
    super.networkConfigEntity, {
    super.onUnauthenticated,
    required this.refreshResultSupplier,
  });

  final Future<bool> Function() refreshResultSupplier;

  @override
  Future<bool> handleRefresh(DioException err) {
    return refreshResultSupplier();
  }
}

void main() {
  setUpAll(() {
    registerFallbackValue(
      DioException(requestOptions: RequestOptions(path: '')),
    );
  });

  group('TokenRefreshInterceptorInterface Tests', () {
    late MockTokenManager mockTokenManager;
    late MockErrorInterceptorHandler mockHandler;
    late NetworkConfigEntity config;

    setUp(() {
      mockTokenManager = MockTokenManager();
      mockHandler = MockErrorInterceptorHandler();

      config = const NetworkConfigEntity(
        baseUrl: 'https://api.example.com',
        excludedPaths: <String>[],
        refreshTokenApiEndpoint: '/auth/refresh',
        accessTokenKey: 'access_token',
        refreshTokenKey: 'refresh_token',
      );

      when(() => mockTokenManager.clearTokens()).thenAnswer((_) async {});
      when(() => mockTokenManager.notifyUnauthenticated()).thenAnswer((_) {});
    });

    test('clears tokens and emits onUnauthenticated on 401 refresh failure', () async {
      bool onUnauthCalled = false;

      final interceptor = TestTokenRefreshInterceptor(
        mockTokenManager,
        config,
        onUnauthenticated: () {
          onUnauthCalled = true;
        },
        refreshResultSupplier: () async => false, // Refresh returns false (failure)
      );

      final options = RequestOptions(
        path: '/user/profile',
        extra: {'isAuthorized': true},
      );
      final error = DioException(
        requestOptions: options,
        response: Response(statusCode: 401, requestOptions: options),
      );

      when(() => mockHandler.reject(any())).thenAnswer((_) {});

      await interceptor.onError(error, mockHandler);

      verify(() => mockTokenManager.clearTokens()).called(1);
      verify(() => mockTokenManager.notifyUnauthenticated()).called(1);
      expect(onUnauthCalled, isTrue);
      verify(() => mockHandler.reject(any())).called(1);
    });

    test('clears tokens and emits onUnauthenticated on 400 refresh exception', () async {
      bool onUnauthCalled = false;

      final interceptor = TestTokenRefreshInterceptor(
        mockTokenManager,
        config,
        onUnauthenticated: () {
          onUnauthCalled = true;
        },
        refreshResultSupplier: () async {
          throw DioException(
            requestOptions: RequestOptions(path: '/auth/refresh'),
            response: Response(
              statusCode: 400,
              requestOptions: RequestOptions(path: '/auth/refresh'),
            ),
          );
        },
      );

      final options = RequestOptions(
        path: '/user/profile',
        extra: {'isAuthorized': true},
      );
      final error = DioException(
        requestOptions: options,
        response: Response(statusCode: 401, requestOptions: options),
      );

      when(() => mockHandler.reject(any())).thenAnswer((_) {});

      await interceptor.onError(error, mockHandler);

      verify(() => mockTokenManager.clearTokens()).called(1);
      verify(() => mockTokenManager.notifyUnauthenticated()).called(1);
      expect(onUnauthCalled, isTrue);
      verify(() => mockHandler.reject(any())).called(1);
    });
  });
}

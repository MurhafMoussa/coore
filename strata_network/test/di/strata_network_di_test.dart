import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:get_it/get_it.dart';
import 'package:strata_network/strata_network.dart';
import 'package:test/test.dart';

class _TestErrorResponseModel extends BaseErrorResponseModel {
  _TestErrorResponseModel()
      : super(
          status: 500,
          developerMessage: 'Error',
          timestamp: DateTime.now(),
        );

  @override
  Map<String, String> get validationErrors => {};
}

void main() {
  group('StrataNetworkDiExtension Tests', () {
    late GetIt getIt;

    setUp(() {
      getIt = GetIt.asNewInstance();
    });

    test('registerStrataNetwork registers all network singletons correctly', () {
      const config = NetworkConfigEntity(
        baseUrl: 'https://api.example.com',
        excludedPaths: <String>[],
        refreshTokenApiEndpoint: '/refresh',
        accessTokenKey: 'access_token',
        refreshTokenKey: 'refresh_token',
        connectTimeout: Duration(seconds: 10),
        sendTimeout: Duration(seconds: 15),
        receiveTimeout: Duration(seconds: 20),
        staticHeaders: {'X-App-Version': '1.0.0'},
        defaultQueryParams: {'lang': 'en'},
        defaultContentType: 'application/json',
        followRedirects: false,
        maxRedirects: 3,
      );

      getIt.registerStrataNetwork(
        config: config,
        errorParser: (response) => _TestErrorResponseModel(),
      );

      expect(getIt.isRegistered<NetworkConfigEntity>(), isTrue);
      expect(getIt.isRegistered<CancelRequestManagerInterface>(), isTrue);
      expect(getIt.isRegistered<TokenManagerInterface>(), isTrue);
      expect(getIt.isRegistered<NetworkExceptionMapperInterface>(), isTrue);
      expect(getIt.isRegistered<Dio>(), isTrue);
      expect(getIt.isRegistered<ApiHandlerInterface>(), isTrue);

      expect(getIt<ApiHandlerInterface>(), isA<DioApiHandler>());
      expect(getIt<CancelRequestManagerInterface>(), isA<DefaultCancelRequestManager>());
      expect(getIt<TokenManagerInterface>(), isA<DefaultTokenManager>());

      final dio = getIt<Dio>();
      expect(dio.options.baseUrl, 'https://api.example.com');
      expect(dio.options.connectTimeout, const Duration(seconds: 10));
      expect(dio.options.sendTimeout, const Duration(seconds: 15));
      expect(dio.options.receiveTimeout, const Duration(seconds: 20));
      expect(dio.options.headers['X-App-Version'], '1.0.0');
      expect(dio.options.queryParameters['lang'], 'en');
      expect(dio.options.contentType, 'application/json');
      expect(dio.options.followRedirects, isFalse);
      expect(dio.options.maxRedirects, 3);
      expect(dio.options.validateStatus(200), isTrue);
      expect(dio.options.validateStatus(299), isTrue);
      expect(dio.options.validateStatus(400), isFalse);
      expect(dio.options.validateStatus(500), isFalse);
    });

    test('registerStrataNetwork registers CookieJar when cookieBased auth', () {
      const config = NetworkConfigEntity(
        baseUrl: 'https://api.example.com',
        authInterceptorType: AuthInterceptorType.cookieBased,
        refreshTokenApiEndpoint: '/refresh',
        excludedPaths: <String>[],
        accessTokenKey: 'access_token',
        refreshTokenKey: 'refresh_token',
      );

      getIt.registerStrataNetwork(
        config: config,
        errorParser: (response) => _TestErrorResponseModel(),
      );

      expect(getIt.isRegistered<CookieJar>(), isTrue);
      final dio = getIt<Dio>();
      expect(dio.interceptors.any((i) => i is CookieManager), isTrue);
    });
  });
}

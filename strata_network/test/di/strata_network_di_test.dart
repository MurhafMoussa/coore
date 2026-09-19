import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:strata_network/strata_network.dart';
import 'package:test/test.dart';

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
      );

      getIt.registerStrataNetwork(config: config);

      expect(getIt.isRegistered<NetworkConfigEntity>(), isTrue);
      expect(getIt.isRegistered<CancelRequestManagerInterface>(), isTrue);
      expect(getIt.isRegistered<TokenManagerInterface>(), isTrue);
      expect(getIt.isRegistered<NetworkExceptionMapperInterface>(), isTrue);
      expect(getIt.isRegistered<Dio>(), isTrue);
      expect(getIt.isRegistered<ApiHandlerInterface>(), isTrue);

      expect(getIt<ApiHandlerInterface>(), isA<DioApiHandler>());
      expect(getIt<CancelRequestManagerInterface>(), isA<DefaultCancelRequestManager>());
      expect(getIt<TokenManagerInterface>(), isA<DefaultTokenManager>());
    });
  });
}

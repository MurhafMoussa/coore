import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:strata/strata.dart';

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

_TestErrorResponseModel _testErrorParser(dynamic response) =>
    _TestErrorResponseModel();

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('StrataInitializer', () {
    late GetIt getIt;

    setUp(() async {
      getIt = GetIt.asNewInstance();
    });

    tearDown(() async {
      await StrataInitializer.reset(getIt: getIt);
    });

    test('initialize registers sub-package dependencies and awaits allReady', () async {
      const networkConfig = NetworkConfigEntity(
        baseUrl: 'https://api.example.com',
        excludedPaths: ['/login'],
        refreshTokenApiEndpoint: '/refresh',
        accessTokenKey: 'access_token',
        refreshTokenKey: 'refresh_token',
      );

      final navigationConfig = NavigationConfigEntity(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const Placeholder(),
          ),
        ],
      );

      final config = StrataConfigEntity(
        networkConfig: networkConfig,
        navigationConfig: navigationConfig,
        errorParser: _testErrorParser,
      );

      var isReadyResolved = false;

      // Register an async ready signal in getIt to test allReady awaiting
      getIt.registerSingletonAsync<bool>(() async {
        await Future<void>.delayed(const Duration(milliseconds: 50));
        isReadyResolved = true;
        return true;
      });

      await StrataInitializer.initialize(config, getIt: getIt);

      expect(isReadyResolved, isTrue);
      expect(getIt.isRegistered<SensitiveStorageInterface>(), isTrue);
      expect(getIt.isRegistered<NetworkConfigEntity>(), isTrue);
      expect(getIt.isRegistered<ApiHandlerInterface>(), isTrue);
      expect(getIt.isRegistered<CoreRouter>(), isTrue);
      expect(getIt.isRegistered<GoRouter>(), isTrue);
      expect(getIt.isRegistered<NavigationServiceInterface>(), isTrue);
    });

    test('initialize supports storage-only config without network or navigation', () async {
      final config = StrataConfigEntity(
        errorParser: _testErrorParser,
      );

      await StrataInitializer.initialize(config, getIt: getIt);

      expect(getIt.isRegistered<SensitiveStorageInterface>(), isTrue);
      expect(getIt.isRegistered<NetworkConfigEntity>(), isFalse);
      expect(getIt.isRegistered<CoreRouter>(), isFalse);
    });

    test('reset cleans up GetIt registrations between runs', () async {
      final config = StrataConfigEntity(
        errorParser: _testErrorParser,
      );

      await StrataInitializer.initialize(config, getIt: getIt);
      expect(getIt.isRegistered<SensitiveStorageInterface>(), isTrue);

      await StrataInitializer.reset(getIt: getIt);
      expect(getIt.isRegistered<SensitiveStorageInterface>(), isFalse);
    });

    test('StrataConfigEntity supports equality comparison', () {
      final config1 = StrataConfigEntity(
        errorParser: _testErrorParser,
        shouldLogNavigation: true,
      );
      final config2 = StrataConfigEntity(
        errorParser: _testErrorParser,
        shouldLogNavigation: true,
      );
      final config3 = StrataConfigEntity(
        errorParser: _testErrorParser,
        shouldLogNavigation: false,
      );

      expect(config1, equals(config2));
      expect(config1, isNot(equals(config3)));
    });
  });
}

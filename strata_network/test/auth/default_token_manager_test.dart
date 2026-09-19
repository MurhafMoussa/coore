import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:strata_core/strata_core.dart';
import 'package:strata_network/strata_network.dart';
import 'package:test/test.dart';

class MockSensitiveStorage extends Mock implements SensitiveStorageInterface {}

void main() {
  group('DefaultTokenManager Tests', () {
    late MockSensitiveStorage mockStorage;

    setUp(() {
      mockStorage = MockSensitiveStorage();
    });

    test('getters return set tokens in memory when secureStorageEnabled is false', () async {
      final manager = DefaultTokenManager(secureStorageEnabled: false);
      await manager.setTokens(accessToken: 'acc_123', refreshToken: 'ref_456');

      expect(await manager.accessToken, equals('acc_123'));
      expect(await manager.refreshToken, equals('ref_456'));
    });

    test('persists and retrieves tokens via SensitiveStorageInterface when secureStorageEnabled is true', () async {
      when(() => mockStorage.save('accessToken', 'acc_123'))
          .thenAnswer((_) async => const Right(unit));
      when(() => mockStorage.save('refreshToken', 'ref_456'))
          .thenAnswer((_) async => const Right(unit));
      when(() => mockStorage.read('accessToken'))
          .thenAnswer((_) async => const Right('acc_123'));
      when(() => mockStorage.read('refreshToken'))
          .thenAnswer((_) async => const Right('ref_456'));

      final manager = DefaultTokenManager(
        sensitiveStorage: mockStorage,
        secureStorageEnabled: true,
      );

      await manager.setTokens(accessToken: 'acc_123', refreshToken: 'ref_456');

      verify(() => mockStorage.save('accessToken', 'acc_123')).called(1);
      verify(() => mockStorage.save('refreshToken', 'ref_456')).called(1);

      expect(await manager.accessToken, equals('acc_123'));
      expect(await manager.refreshToken, equals('ref_456'));
    });

    test('clearTokens removes tokens in memory and storage', () async {
      when(() => mockStorage.delete('accessToken'))
          .thenAnswer((_) async => const Right(unit));
      when(() => mockStorage.delete('refreshToken'))
          .thenAnswer((_) async => const Right(unit));
      when(() => mockStorage.read('accessToken'))
          .thenAnswer((_) async => const Right(null));
      when(() => mockStorage.read('refreshToken'))
          .thenAnswer((_) async => const Right(null));

      final manager = DefaultTokenManager(
        sensitiveStorage: mockStorage,
        secureStorageEnabled: true,
      );

      await manager.clearTokens();

      verify(() => mockStorage.delete('accessToken')).called(1);
      verify(() => mockStorage.delete('refreshToken')).called(1);
      expect(await manager.accessToken, equals(''));
      expect(await manager.refreshToken, equals(''));
    });

    test('notifyUnauthenticated invokes onUnauthenticated callback', () {
      bool unauthCalled = false;
      final manager = DefaultTokenManager(
        onUnauthenticated: () {
          unauthCalled = true;
        },
      );

      manager.notifyUnauthenticated();
      expect(unauthCalled, isTrue);
    });
  });
}

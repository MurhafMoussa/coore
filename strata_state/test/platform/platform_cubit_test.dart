import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:strata_core/strata_core.dart';
import 'package:strata_state/strata_state.dart';

class MockStorage extends Mock implements Storage {}
class MockPlatformServiceInterface extends Mock implements PlatformServiceInterface {}

void main() {
  late Storage storage;
  late MockPlatformServiceInterface platformService;

  setUp(() {
    storage = MockStorage();
    when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
    when(() => storage.read(any())).thenReturn(null);
    when(() => storage.delete(any())).thenAnswer((_) async {});
    when(() => storage.clear()).thenAnswer((_) async {});
    HydratedBloc.storage = storage;

    platformService = MockPlatformServiceInterface();
  });

  group('PlatformCubit', () {
    const mockDeviceInfo = DeviceInfoEntity(
      deviceId: 'test_device_123',
      buildNumber: '10',
      versionNumber: '1.0.0',
      platform: PlatformType.android,
    );

    test('initializes and fetches device info from service', () async {
      when(() => platformService.getDeviceInfo()).thenReturn(mockDeviceInfo);

      final cubit = PlatformCubit(service: platformService);
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state, equals(mockDeviceInfo));
      expect(cubit.deviceId, equals('test_device_123'));
      expect(cubit.appVersion, equals('1.0.0'));
      expect(cubit.buildNumber, equals('10'));
      expect(cubit.isMobile, isTrue);
      expect(cubit.isDesktop, isFalse);
      expect(cubit.isWeb, isFalse);
    });

    test('toJson and fromJson for platform state persistence', () {
      when(() => platformService.getDeviceInfo()).thenReturn(mockDeviceInfo);
      final cubit = PlatformCubit(service: platformService);

      final json = cubit.toJson(mockDeviceInfo);
      final restored = cubit.fromJson(json!);

      expect(restored, equals(mockDeviceInfo));
    });
  });
}

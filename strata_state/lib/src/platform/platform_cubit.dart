import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:strata_core/strata_core.dart';

/// Hydrated Cubit for managing persistent platform and device information state.
class PlatformCubit extends HydratedCubit<DeviceInfoEntity> {
  PlatformCubit({required this.service}) : super(_initialState) {
    _initialize();
  }

  final PlatformServiceInterface service;

  static const DeviceInfoEntity _initialState = DeviceInfoEntity(
    deviceId: 'Unknown',
    buildNumber: 'Unknown',
    versionNumber: 'Unknown',
    platform: PlatformType.unknown,
  );

  Future<void> _initialize() async {
    await _fetchDeviceInfo();
  }

  Future<void> _fetchDeviceInfo() async {
    try {
      final deviceInfo = service.getDeviceInfo();
      emit(deviceInfo);
    } catch (_) {
      if (state == _initialState) {
        emit(_initialState);
      }
    }
  }

  Future<void> refreshDeviceInfo() async {
    await _fetchDeviceInfo();
  }

  PlatformType get currentPlatform => state.platform;
  String get deviceId => state.deviceId;
  String get appVersion => state.versionNumber;
  String get buildNumber => state.buildNumber;

  bool get isMobile =>
      state.platform == PlatformType.android ||
      state.platform == PlatformType.ios;

  bool get isDesktop =>
      state.platform == PlatformType.windows ||
      state.platform == PlatformType.macos ||
      state.platform == PlatformType.linux;

  bool get isWeb => state.platform == PlatformType.web;

  @override
  DeviceInfoEntity? fromJson(Map<String, dynamic> json) {
    try {
      return DeviceInfoEntity.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(DeviceInfoEntity state) {
    return state.toJson();
  }
}

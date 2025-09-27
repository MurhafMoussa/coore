import 'package:coore/src/platform/entities/device_info_entity.dart';
import 'package:coore/src/platform/enums/platform_enum.dart';
import 'package:coore/src/platform/service/platform_service_interface.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit for managing platform and device information state
class PlatformCubit extends Cubit<DeviceInfoEntity> {
  PlatformCubit({required this.service}) : super(_initialState) {
    _initialize();
  }

  final PlatformServiceInterface service;

  /// Initial state with unknown values
  static const DeviceInfoEntity _initialState = DeviceInfoEntity(
    deviceId: 'Unknown',
    buildNumber: 'Unknown',
    versionNumber: 'Unknown',
    platform: PlatformType.unknown,
  );

  /// Initialize the cubit by fetching device information
  Future<void> _initialize() async {
    await _fetchDeviceInfo();
  }

  /// Fetch device information from the platform service
  Future<void> _fetchDeviceInfo() async {
    try {
      final deviceInfo = service.getDeviceInfo();
      emit(deviceInfo);
    } catch (e) {
      // Emit initial state if fetching fails
      emit(_initialState);
    }
  }

  /// Refresh device information
  Future<void> refreshDeviceInfo() async {
    await _fetchDeviceInfo();
  }

  /// Get current platform type
  PlatformType get currentPlatform => state.platform;

  /// Get current device ID
  String get deviceId => state.deviceId;

  /// Get current app version
  String get appVersion => state.versionNumber;

  /// Get current build number
  String get buildNumber => state.buildNumber;

  /// Check if current platform is mobile
  bool get isMobile =>
      state.platform == PlatformType.android ||
      state.platform == PlatformType.ios;

  /// Check if current platform is desktop
  bool get isDesktop =>
      state.platform == PlatformType.windows ||
      state.platform == PlatformType.macos ||
      state.platform == PlatformType.linux;

  /// Check if current platform is web
  bool get isWeb => state.platform == PlatformType.web;
}

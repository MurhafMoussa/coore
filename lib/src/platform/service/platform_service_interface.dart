import 'package:coore/src/platform/entities/device_info_entity.dart';

/// Interface for platform service that provides device and platform information
abstract class PlatformServiceInterface {
  /// Get comprehensive device information
  DeviceInfoEntity getDeviceInfo();
}

import 'dart:io';

import 'package:coore/src/platform/entities/device_info_entity.dart';
import 'package:coore/src/platform/enums/platform_enum.dart';
import 'package:coore/src/platform/service/platform_service_interface.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Implementation of platform service that provides device and platform information
class PlatformServiceImpl implements PlatformServiceInterface {
  final BaseDeviceInfo _deviceInfo;
  final PackageInfo _packageInfo;
  PlatformServiceImpl(this._deviceInfo, this._packageInfo);
  @override
  DeviceInfoEntity getDeviceInfo() {
    try {
      return _collectDeviceInfo();
    } catch (e) {
      // Return fallback device info if collection fails
      return const DeviceInfoEntity(
        deviceId: 'Unknown',
        buildNumber: 'Unknown',
        versionNumber: 'Unknown',
        platform: PlatformType.unknown,
      );
    }
  }

  /// Collects device and application information based on the current platform.
  DeviceInfoEntity _collectDeviceInfo() {
    final platform = PlatformType.fromDartPlatform();
    String deviceId = 'Unknown';
    // App's version and build number are now fetched from PackageInfo.
    final String versionNumber = _packageInfo.version;
    final String buildNumber = _packageInfo.buildNumber;

    if (kIsWeb) {
      final webBrowserInfo = _deviceInfo as WebBrowserInfo;
      // Uses userAgent as a more descriptive identifier for web.
      deviceId = webBrowserInfo.userAgent ?? 'Unknown Web Browser';
    } else {
      // Handles all mobile and desktop platforms.
      switch (Platform.operatingSystem) {
        case 'android':
          final androidInfo = _deviceInfo as AndroidDeviceInfo;
          deviceId = androidInfo.id; // The Android ID.
          break;
        case 'ios':
          final iosInfo = _deviceInfo as IosDeviceInfo;
          // FIX: Use identifierForVendor for a unique ID on iOS.
          deviceId = iosInfo.identifierForVendor ?? 'Unknown iOS Device';
          break;
        case 'windows':
          final windowsInfo = _deviceInfo as WindowsDeviceInfo;
          deviceId = windowsInfo.deviceId;
          break;
        case 'macos':
          final macInfo = _deviceInfo as MacOsDeviceInfo;
          deviceId = macInfo.systemGUID ?? 'Unknown macOS Device';
          break;
        case 'linux':
          final linuxInfo = _deviceInfo as LinuxDeviceInfo;
          deviceId = linuxInfo.machineId ?? 'Unknown Linux Device';
          break;
      }
    }

    return DeviceInfoEntity(
      deviceId: deviceId,
      buildNumber: buildNumber,
      versionNumber: versionNumber,
      platform: platform,
    );
  }
 
}

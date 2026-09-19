import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:strata_core/strata_core.dart';

/// Implementation of platform service that provides device and platform information.
class PlatformServiceImpl(
  final BaseDeviceInfo _deviceInfo,
  final PackageInfo _packageInfo,
) implements PlatformServiceInterface {

  @override
  DeviceInfoEntity getDeviceInfo() {
    try {
      return _collectDeviceInfo();
    } catch (e) {
      return const DeviceInfoEntity(
        deviceId: 'Unknown',
        buildNumber: 'Unknown',
        versionNumber: 'Unknown',
        platform: PlatformType.unknown,
      );
    }
  }

  DeviceInfoEntity _collectDeviceInfo() {
    final platform = PlatformType.fromDartPlatform();
    String deviceId = 'Unknown';
    final String versionNumber = _packageInfo.version;
    final String buildNumber = _packageInfo.buildNumber;

    if (kIsWeb) {
      final webBrowserInfo = _deviceInfo as WebBrowserInfo;
      deviceId = webBrowserInfo.userAgent ?? 'Unknown Web Browser';
    } else {
      switch (Platform.operatingSystem) {
        case 'android':
          final androidInfo = _deviceInfo as AndroidDeviceInfo;
          deviceId = androidInfo.id;
          break;
        case 'ios':
          final iosInfo = _deviceInfo as IosDeviceInfo;
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

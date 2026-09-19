import 'dart:io';

import 'package:equatable/equatable.dart';

enum PlatformType {
  android,
  ios,
  web,
  macos,
  windows,
  linux,
  unknown;

  static PlatformType fromDartPlatform() {
    try {
      if (Platform.isAndroid) return PlatformType.android;
      if (Platform.isIOS) return PlatformType.ios;
      if (Platform.isWindows) return PlatformType.windows;
      if (Platform.isMacOS) return PlatformType.macos;
      if (Platform.isLinux) return PlatformType.linux;
    } catch (_) {
      return PlatformType.web;
    }
    return PlatformType.unknown;
  }
}

class const DeviceInfoEntity({
  required final String deviceId,
  required final String buildNumber,
  required final String versionNumber,
  required final PlatformType platform,
}) extends Equatable {
  Map<String, dynamic> toJson() => {
        'deviceId': deviceId,
        'buildNumber': buildNumber,
        'versionNumber': versionNumber,
        'platform': platform.name,
      };

  factory DeviceInfoEntity.fromJson(Map<String, dynamic> json) {
    return DeviceInfoEntity(
      deviceId: json['deviceId'] as String? ?? 'Unknown',
      buildNumber: json['buildNumber'] as String? ?? 'Unknown',
      versionNumber: json['versionNumber'] as String? ?? 'Unknown',
      platform: PlatformType.values.firstWhere(
        (e) => e.name == json['platform'],
        orElse: () => PlatformType.unknown,
      ),
    );
  }

  @override
  List<Object?> get props => [
        deviceId,
        buildNumber,
        versionNumber,
        platform,
      ];
}

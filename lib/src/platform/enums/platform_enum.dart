import 'dart:io';

import 'package:flutter/foundation.dart';

/// Platform enum for device information
enum PlatformType {
  android,
  ios,
  web,
  windows,
  macos,
  linux,
  unknown;

  /// Get platform from dart:io Platform
  static PlatformType fromDartPlatform() {
    if (Platform.isAndroid) return PlatformType.android;
    if (Platform.isIOS) return PlatformType.ios;
    if (Platform.isWindows) return PlatformType.windows;
    if (Platform.isMacOS) return PlatformType.macos;
    if (Platform.isLinux) return PlatformType.linux;
    if (kIsWeb) return PlatformType.web;
    return PlatformType.unknown;
  }

  /// Get platform from string
  static PlatformType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'android':
        return PlatformType.android;
      case 'ios':
        return PlatformType.ios;
      case 'web':
        return PlatformType.web;
      case 'windows':
        return PlatformType.windows;
      case 'macos':
        return PlatformType.macos;
      case 'linux':
        return PlatformType.linux;
      default:
        return PlatformType.unknown;
    }
  }

  /// Get string value
  String get value {
    switch (this) {
      case PlatformType.android:
        return 'android';
      case PlatformType.ios:
        return 'ios';
      case PlatformType.web:
        return 'web';
      case PlatformType.windows:
        return 'windows';
      case PlatformType.macos:
        return 'macos';
      case PlatformType.linux:
        return 'linux';
      case PlatformType.unknown:
        return 'unknown';
    }
  }
}

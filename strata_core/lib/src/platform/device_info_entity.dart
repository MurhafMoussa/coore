import 'package:equatable/equatable.dart';

enum PlatformType { android, ios, web, macos, windows, linux, unknown }

class DeviceInfoEntity extends Equatable {
  const DeviceInfoEntity({
    required this.deviceId,
    required this.buildNumber,
    required this.versionNumber,
    required this.platform,
  });

  final String deviceId;
  final String buildNumber;
  final String versionNumber;
  final PlatformType platform;

  @override
  List<Object?> get props => [
        deviceId,
        buildNumber,
        versionNumber,
        platform,
      ];
}

import 'package:coore/src/platform/enums/platform_enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_info_entity.freezed.dart';
part 'device_info_entity.g.dart';

/// Entity representing device information
@freezed
abstract class DeviceInfoEntity with _$DeviceInfoEntity {
  const factory DeviceInfoEntity({
    /// Device ID (unique identifier)
    required String deviceId,

    /// Device build number
    required String buildNumber,

    /// Device version number
    required String versionNumber,

    /// Current platform
    required PlatformType platform,
  }) = _DeviceInfoEntity;

  factory DeviceInfoEntity.fromJson(Map<String, dynamic> json) =>
      _$DeviceInfoEntityFromJson(json);
}

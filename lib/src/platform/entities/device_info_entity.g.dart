// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_info_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DeviceInfoEntity _$DeviceInfoEntityFromJson(Map<String, dynamic> json) =>
    _DeviceInfoEntity(
      deviceId: json['deviceId'] as String,
      buildNumber: json['buildNumber'] as String,
      versionNumber: json['versionNumber'] as String,
      platform: $enumDecode(_$PlatformTypeEnumMap, json['platform']),
    );

Map<String, dynamic> _$DeviceInfoEntityToJson(_DeviceInfoEntity instance) =>
    <String, dynamic>{
      'deviceId': instance.deviceId,
      'buildNumber': instance.buildNumber,
      'versionNumber': instance.versionNumber,
      'platform': _$PlatformTypeEnumMap[instance.platform]!,
    };

const _$PlatformTypeEnumMap = {
  PlatformType.android: 'android',
  PlatformType.ios: 'ios',
  PlatformType.web: 'web',
  PlatformType.windows: 'windows',
  PlatformType.macos: 'macos',
  PlatformType.linux: 'linux',
  PlatformType.unknown: 'unknown',
};

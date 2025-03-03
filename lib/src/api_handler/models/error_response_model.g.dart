// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ErrorResponseModel _$ErrorResponseModelFromJson(Map<String, dynamic> json) =>
    _ErrorResponseModel(
      error: Error.fromJson(json['error'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ErrorResponseModelToJson(_ErrorResponseModel instance) =>
    <String, dynamic>{'error': instance.error};

_Error _$ErrorFromJson(Map<String, dynamic> json) => _Error(
  status: (json['status'] as num).toInt(),
  message: json['message'] as String,
  details:
      (json['details'] as List<dynamic>?)
          ?.map((e) => Detail.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$ErrorToJson(_Error instance) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'details': instance.details,
};

_Detail _$DetailFromJson(Map<String, dynamic> json) =>
    _Detail(field: json['field'] as String, message: json['message'] as String);

Map<String, dynamic> _$DetailToJson(_Detail instance) => <String, dynamic>{
  'field': instance.field,
  'message': instance.message,
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ErrorResponseModel _$ErrorResponseModelFromJson(Map<String, dynamic> json) =>
    _ErrorResponseModel(
      error: ErrorModel.fromJson(json['error'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ErrorResponseModelToJson(_ErrorResponseModel instance) =>
    <String, dynamic>{'error': instance.error};

_ErrorModel _$ErrorModelFromJson(Map<String, dynamic> json) => _ErrorModel(
  status: (json['status'] as num).toInt(),
  message: json['message'] as String,
  details: (json['details'] as List<dynamic>?)
      ?.map((e) => ErrorDetail.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ErrorModelToJson(_ErrorModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'details': instance.details,
    };

_ErrorDetail _$ErrorDetailFromJson(Map<String, dynamic> json) => _ErrorDetail(
  field: json['field'] as String,
  message: json['message'] as String,
);

Map<String, dynamic> _$ErrorDetailToJson(_ErrorDetail instance) =>
    <String, dynamic>{'field': instance.field, 'message': instance.message};

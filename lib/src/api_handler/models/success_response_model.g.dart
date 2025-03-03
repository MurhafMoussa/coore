// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'success_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SuccessResponseModel<T> _$SuccessResponseModelFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => _SuccessResponseModel<T>(data: fromJsonT(json['data']));

Map<String, dynamic> _$SuccessResponseModelToJson<T>(
  _SuccessResponseModel<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{'data': toJsonT(instance.data)};

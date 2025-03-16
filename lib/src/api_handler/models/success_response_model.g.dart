// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'success_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SuccessResponseModel<T> _$SuccessResponseModelFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => _SuccessResponseModel<T>(data: fromJsonT(json['products']));

Map<String, dynamic> _$SuccessResponseModelToJson<T>(
  _SuccessResponseModel<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{'products': toJsonT(instance.data)};

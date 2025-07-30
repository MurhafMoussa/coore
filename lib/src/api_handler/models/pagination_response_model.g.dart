// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PaginationResponseModel<T, M>
_$PaginationResponseModelFromJson<T, M extends MetaModel>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
  M Function(Object? json) fromJsonM,
) => _PaginationResponseModel<T, M>(
  data: (json['data'] as List<dynamic>?)?.map(fromJsonT).toList() ?? const [],
  meta: _$nullableGenericFromJson(json['meta'], fromJsonM),
);

Map<String, dynamic> _$PaginationResponseModelToJson<T, M extends MetaModel>(
  _PaginationResponseModel<T, M> instance,
  Object? Function(T value) toJsonT,
  Object? Function(M value) toJsonM,
) => <String, dynamic>{
  'data': instance.data.map(toJsonT).toList(),
  'meta': _$nullableGenericToJson(instance.meta, toJsonM),
};

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) => input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) => input == null ? null : toJson(input);

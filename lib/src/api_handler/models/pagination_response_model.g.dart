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
);

Map<String, dynamic> _$PaginationResponseModelToJson<T, M extends MetaModel>(
  _PaginationResponseModel<T, M> instance,
  Object? Function(T value) toJsonT,
  Object? Function(M value) toJsonM,
) => <String, dynamic>{'data': instance.data.map(toJsonT).toList()};

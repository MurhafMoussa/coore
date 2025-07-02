// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PaginationResponseModel<T> _$PaginationResponseModelFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => _PaginationResponseModel<T>(
  data: (json['data'] as List<dynamic>?)?.map(fromJsonT).toList() ?? const [],
  meta:
      json['meta'] == null
          ? const MetaModel()
          : MetaModel.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PaginationResponseModelToJson<T>(
  _PaginationResponseModel<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'data': instance.data.map(toJsonT).toList(),
  'meta': instance.meta,
};

_MetaModel _$MetaModelFromJson(Map<String, dynamic> json) => _MetaModel(
  page: (json['page'] as num?)?.toInt() ?? 0,
  limit: (json['limit'] as num?)?.toInt() ?? 20,
  total: (json['total'] as num?)?.toInt() ?? 0,
  totalPages: (json['totalPages'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$MetaModelToJson(_MetaModel instance) =>
    <String, dynamic>{
      'page': instance.page,
      'limit': instance.limit,
      'total': instance.total,
      'totalPages': instance.totalPages,
    };

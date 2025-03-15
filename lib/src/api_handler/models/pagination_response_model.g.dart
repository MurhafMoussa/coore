// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PaginationResponseModel<T> _$PaginationResponseModelFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => _PaginationResponseModel<T>(
  products:
      (json['products'] as List<dynamic>?)?.map(fromJsonT).toList() ?? const [],
);

Map<String, dynamic> _$PaginationResponseModelToJson<T>(
  _PaginationResponseModel<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{'products': instance.products.map(toJsonT).toList()};

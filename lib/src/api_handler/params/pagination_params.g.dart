// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SkipPagingStrategyParams _$SkipPagingStrategyParamsFromJson(
  Map<String, dynamic> json,
) => _SkipPagingStrategyParams(
  take: (json['take'] as num).toInt(),
  skip: (json['skip'] as num).toInt(),
);

Map<String, dynamic> _$SkipPagingStrategyParamsToJson(
  _SkipPagingStrategyParams instance,
) => <String, dynamic>{'take': instance.take, 'skip': instance.skip};

_PagePaginationParams _$PagePaginationParamsFromJson(
  Map<String, dynamic> json,
) => _PagePaginationParams(
  batch: (json['batch'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
);

Map<String, dynamic> _$PagePaginationParamsToJson(
  _PagePaginationParams instance,
) => <String, dynamic>{'batch': instance.batch, 'limit': instance.limit};

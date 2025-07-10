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

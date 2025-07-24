import 'package:coore/lib.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination_params.freezed.dart';
part 'pagination_params.g.dart';

/// Abstract base for all pagination strategies
abstract class PaginationParams implements Cancelable {
  int get batch;

  int get limit;
}

@freezed
abstract class SkipPagingStrategyParams
    with _$SkipPagingStrategyParams
    implements PaginationParams, Cancelable {
  const SkipPagingStrategyParams._();

  const factory SkipPagingStrategyParams({
    required int take,
    required int skip,
    @JsonKey(includeToJson: false, includeFromJson: false)
    CancelRequestAdapter? cancelRequestAdapter,
  }) = _SkipPagingStrategyParams;

  factory SkipPagingStrategyParams.fromJson(Map<String, dynamic> json) =>
      _$SkipPagingStrategyParamsFromJson(json);

  @override
  int get batch => skip;

  @override
  int get limit => take;

  @override
  SkipPagingStrategyParams copyWithCancelRequest(CancelRequestAdapter adapter) {
    return copyWith(cancelRequestAdapter: adapter);
  }
}

@freezed
abstract class PagePaginationParams
    with _$PagePaginationParams
    implements PaginationParams, Cancelable {
  const PagePaginationParams._();

  const factory PagePaginationParams({
    required int page,
    required int limit,
    @JsonKey(includeToJson: false, includeFromJson: false)
    CancelRequestAdapter? cancelRequestAdapter,
  }) = _PagePaginationParams;

  @override
  int get batch => page;

  factory PagePaginationParams.fromJson(Map<String, dynamic> json) =>
      _$PagePaginationParamsFromJson(json);

  @override
  PagePaginationParams copyWithCancelRequest(CancelRequestAdapter adapter) {
    return copyWith(cancelRequestAdapter: adapter);
  }
}

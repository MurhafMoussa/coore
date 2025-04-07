import 'package:coore/src/api_handler/cancel_request_adapter.dart';

import 'package:coore/src/api_handler/params/base_params.dart';

abstract class PaginationParams extends BaseParams {
  const PaginationParams({
    required this.batch,
    required this.limit,
    super.cancelTokenAdapter,
  });
  final int batch;
  final int limit;
  @override
  List<Object> get props => [batch, limit];
}

class SkipPagingStrategyParams extends PaginationParams {
  const SkipPagingStrategyParams({
    required this.take,
    required this.skip,
    super.cancelTokenAdapter,
  }) : super(batch: skip, limit: take);
  final int take;
  final int skip;
  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{'skip': batch, 'take': limit};
  }

  @override
  BaseParams attachCancelToken({CancelRequestAdapter? cancelTokenAdapter}) {
    return SkipPagingStrategyParams(
      take: take,
      skip: skip,
      cancelTokenAdapter: cancelTokenAdapter ?? this.cancelTokenAdapter,
    );
  }
}

class PagePaginationParams extends PaginationParams {
  const PagePaginationParams({
    required super.limit,
    required super.batch,
    super.cancelTokenAdapter,
  }) ;



  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{'page': batch, 'limit': limit};
  }

  @override
  BaseParams attachCancelToken({CancelRequestAdapter? cancelTokenAdapter}) {
    return PagePaginationParams(
      batch: batch,
      limit: limit,
      cancelTokenAdapter: cancelTokenAdapter ?? this.cancelTokenAdapter,
    );
  }
}

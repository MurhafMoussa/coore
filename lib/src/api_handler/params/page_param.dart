import 'package:coore/src/api_handler/cancel_request_adapter.dart';

import 'base_params.dart';

class SkipPagingStrategyParam extends BaseParams {
  const SkipPagingStrategyParam({
    required this.skip,
    required this.take,
    super.cancelTokenAdapter,
  });

  final int skip;
  final int take;

  @override
  List<Object> get props => [skip, take];

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{'skip': skip, 'take': take};
  }

  @override
  SkipPagingStrategyParam attachCancelToken({
    CancelRequestAdapter? cancelTokenAdapter,
  }) {
    return SkipPagingStrategyParam(
      skip: skip,
      take: take,
      cancelTokenAdapter: cancelTokenAdapter ?? this.cancelTokenAdapter,
    );
  }
}

class OffsetPaginationParam extends BaseParams {
  const OffsetPaginationParam({
    required this.offset,
    required this.limit,
    super.cancelTokenAdapter,
  });

  final int offset;
  final int limit;

  @override
  List<Object> get props => [offset, limit];

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{'offset': offset, 'limit': limit};
  }

  @override
  OffsetPaginationParam attachCancelToken({
    CancelRequestAdapter? cancelTokenAdapter,
  }) {
    return OffsetPaginationParam(
      offset: offset,
      limit: limit,
      cancelTokenAdapter: cancelTokenAdapter ?? this.cancelTokenAdapter,
    );
  }
}

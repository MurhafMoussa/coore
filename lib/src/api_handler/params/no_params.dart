import 'package:coore/src/api_handler/cancel_request_adapter.dart';

import 'base_params.dart';

class NoParams extends BaseParams {
  const NoParams({super.cancelTokenAdapter});

  @override
  List<Object> get props => [];

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{};
  }

  @override
  NoParams attachCancelToken({CancelRequestAdapter? cancelTokenAdapter}) {
    return NoParams(
      cancelTokenAdapter: cancelTokenAdapter ?? this.cancelTokenAdapter,
    );
  }
}

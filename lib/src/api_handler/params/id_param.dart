import 'package:coore/src/api_handler/cancel_request_adapter.dart';

import 'package:coore/src/api_handler/params/base_params.dart';

class IdParam extends BaseParams {
  const IdParam({required this.id, super.cancelTokenAdapter});

  final int id;

  @override
  List<Object> get props => [id];

  @override
  Map<String, dynamic> toJson() => {'id': id};

  @override
  IdParam attachCancelToken({CancelRequestAdapter? cancelTokenAdapter}) {
    return IdParam(
      id: id,
      cancelTokenAdapter: cancelTokenAdapter ?? this.cancelTokenAdapter,
    );
  }
}

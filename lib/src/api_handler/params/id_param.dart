import 'package:coore/lib.dart';

class IdParam extends BaseParams {
  const IdParam({required this.id, super.cancelTokenAdapter});

  final Id id;

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

import 'package:coore/src/api_handler/cancel_request_adapter.dart';
import 'package:coore/src/api_handler/params/cancelable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'no_params.freezed.dart';
part 'no_params.g.dart';

@freezed
abstract class NoParams with _$NoParams implements Cancelable {
  const NoParams._();

  const factory NoParams({
    @JsonKey(includeToJson: false, includeFromJson: false)
    CancelRequestAdapter? cancelRequestAdapter,
  }) = _NoParams;

  factory NoParams.fromJson(Map<String, dynamic> json) =>
      _$NoParamsFromJson(json);

  @override
  NoParams copyWithCancelRequest(CancelRequestAdapter adapter) {
    return copyWith(cancelRequestAdapter: adapter);
  }
}

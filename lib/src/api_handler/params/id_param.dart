import 'package:coore/lib.dart';
import 'package:coore/src/api_handler/params/cancelable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'id_param.freezed.dart';
part 'id_param.g.dart';

@freezed
abstract class IdParam with _$IdParam implements Cancelable {
  const factory IdParam({
    required Id id,
    @JsonKey(includeFromJson: false) CancelRequestAdapter? cancelRequestAdapter,
  }) = _IdParam;

  factory IdParam.fromJson(Map<String, dynamic> json) =>
      _$IdParamFromJson(json);

  const IdParam._();

  @override
  Cancelable copyWithCancelRequest(CancelRequestAdapter cancelRequestAdapter) =>
      copyWith(cancelRequestAdapter: cancelRequestAdapter);
}

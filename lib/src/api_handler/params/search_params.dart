import 'package:coore/src/api_handler/cancel_request_adapter.dart';
import 'package:coore/src/api_handler/params/cancelable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_params.freezed.dart';
part 'search_params.g.dart';

@freezed
abstract class SearchParams with _$SearchParams implements Cancelable {
  const SearchParams._();

  const factory SearchParams({
    required String query,
    @JsonKey(includeFromJson: false) CancelRequestAdapter? cancelRequestAdapter,
  }) = _SearchParams;

  factory SearchParams.fromJson(Map<String, dynamic> json) =>
      _$SearchParamsFromJson(json);

  @override
  SearchParams copyWithCancelRequest(CancelRequestAdapter adapter) {
    return copyWith(cancelRequestAdapter: adapter);
  }
}

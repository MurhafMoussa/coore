import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination_response_model.freezed.dart';
part 'pagination_response_model.g.dart';

@Freezed(genericArgumentFactories: true)
abstract class PaginationResponseModel<T, M extends MetaModel>
    with _$PaginationResponseModel<T, M> {
  const factory PaginationResponseModel({
    @Default([]) List<T> data,
    @JsonKey(includeFromJson: false, includeToJson: false) M? meta,
  }) = _PaginationResponseModel<T, M>;

  factory PaginationResponseModel.fromJson(
    Map<String, Object?> json,
    T Function(Object? json) fromJsonT, {
    M Function(Object? json)? fromJsonM,
  }) => _$PaginationResponseModelFromJson(json, fromJsonT, (json) {
    return fromJsonM?.call(json) ?? const NoMetaModel() as M;
  });
}

abstract class MetaModel {
  const MetaModel();
}

// A concrete class for the default
class NoMetaModel extends MetaModel {
  const NoMetaModel();
}

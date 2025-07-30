import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination_response_model.freezed.dart';
part 'pagination_response_model.g.dart';

@Freezed(genericArgumentFactories: true)
abstract class PaginationResponseModel<T, M extends MetaModel>
    with _$PaginationResponseModel<T, M> {
  const factory PaginationResponseModel({@Default([]) List<T> data, M? meta}) =
      _PaginationResponseModel<T, M>;

  /// The generated one — always requires both callbacks.
  factory PaginationResponseModel.fromJson(
    Map<String, Object?> json,
    T Function(Object? json) fromJsonT,
    M Function(Object? json) fromJsonM,
  ) => _$PaginationResponseModelFromJson(json, fromJsonT, fromJsonM);

  /// A custom factory that makes your `fromJsonM` optional.
  factory PaginationResponseModel.fromJsonWithNullableMetaConverter(
    Map<String, Object?> json,
    T Function(Object? json) fromJsonT, [
    M Function(Object? json)? fromJsonM,
  ]) {
    return PaginationResponseModel(
      data: (json['data'] as List? ?? []).map(fromJsonT).toList(),
      meta: json['meta'] == null || fromJsonM == null
          ? null
          : fromJsonM(json['meta']!),
    );
  }
}

abstract class MetaModel {}

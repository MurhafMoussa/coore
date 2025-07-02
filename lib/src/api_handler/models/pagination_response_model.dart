import 'package:coore/src/api_handler/entities/paginatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination_response_model.freezed.dart';
part 'pagination_response_model.g.dart';

@Freezed(genericArgumentFactories: true)
abstract class PaginationResponseModel<T>
    with _$PaginationResponseModel<T>
    implements Paginatable<T> {
  const factory PaginationResponseModel({
    @Default([]) List<T> data,
    MetaModel? meta,
  }) = _PaginationResponseModel<T>;
  @override
  List<T> get items => data;
  factory PaginationResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) => _$PaginationResponseModelFromJson(json, fromJsonT);
}

@freezed
abstract class MetaModel with _$MetaModel {
  const factory MetaModel({
    @Default(0) int page,
    @Default(20) int limit,
    @Default(0) int total,
    @Default(0) int totalPages,
  }) = _MetaModel;

  factory MetaModel.fromJson(Map<String, dynamic> json) =>
      _$MetaModelFromJson(json);
}

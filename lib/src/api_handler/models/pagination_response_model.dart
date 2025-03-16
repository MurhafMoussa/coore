import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination_response_model.freezed.dart';
part 'pagination_response_model.g.dart';

@Freezed(genericArgumentFactories: true)
abstract class PaginationResponseModel<T> with _$PaginationResponseModel<T> {
  const factory PaginationResponseModel({
    @Default([]) List<T> data,
    // Add other pagination fields if needed
    // int? totalPages,
    // int? currentPage,
    // int? totalItems,
  }) = _PaginationResponseModel<T>;

  factory PaginationResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) => _$PaginationResponseModelFromJson(json, fromJsonT);
}

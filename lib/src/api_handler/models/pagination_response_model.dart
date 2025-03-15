import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination_response_model.freezed.dart';
part 'pagination_response_model.g.dart';

@Freezed(genericArgumentFactories: true)
abstract class PaginationResponseModel<T> with _$PaginationResponseModel<T> {
  const factory PaginationResponseModel({@Default([]) required List<T> data}) =
      _PaginationResponseModel<T>;

  PaginationResponseModel._();

  factory PaginationResponseModel.fromJson(
    Map<String, dynamic> response,
    T Function(Map<String, dynamic>) fromJson,
  ) => _$PaginationResponseModelFromJson(
    response,
    (json) => fromJson(json! as Map<String, dynamic>),
  );
}

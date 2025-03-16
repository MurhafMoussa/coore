import 'package:coore/src/api_handler/models/pagination_response_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'success_response_model.freezed.dart';
part 'success_response_model.g.dart';

@Freezed(genericArgumentFactories: true)
abstract class SuccessResponseModel<T> with _$SuccessResponseModel<T> {
  const factory SuccessResponseModel({
    @JsonKey(name: 'products')
    required T data, // Will be renamed to 'data' later
  }) = _SuccessResponseModel<T>;

  factory SuccessResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) => _$SuccessResponseModelFromJson(json, fromJsonT);

  static SuccessResponseModel<T> genericFromJson<T>(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) => SuccessResponseModel<T>.fromJson(json, fromJsonT);

  static T getData<T>(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) => genericFromJson(json, fromJsonT).data;

  static List<T> getList<T>(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) {
    final data = getData<List<dynamic>>(json, (list) {
      if (list is! List<dynamic>) return [];
      return list.map(fromJsonT).toList();
    });
    return data.cast<T>();
  }

  static List<T> getPaginatedList<T>(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) {
    final pagination = getData<PaginationResponseModel<T>>(
      json,
      (paginationJson) => PaginationResponseModel<T>.fromJson(
        paginationJson! as Map<String, dynamic>,
        fromJsonT,
      ),
    );
    return pagination.data;
  }
}

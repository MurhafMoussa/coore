import 'package:coore/src/api_handler/models/pagination_response_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'success_response_model.freezed.dart';

part 'success_response_model.g.dart';

@Freezed(genericArgumentFactories: true)
abstract class SuccessResponseModel<T> with _$SuccessResponseModel<T> {
  const factory SuccessResponseModel({required T products}) =
      _SuccessResponseModel<T>;

  factory SuccessResponseModel.fromJson(
    Map<String, dynamic> response,
    T Function(Map<String, dynamic>) fromJson,
  ) => _$SuccessResponseModelFromJson(
    response,
    (json) => fromJson(json != null ? json as Map<String, dynamic> : {}),
  );

  static List<T> extractListFromPaginatedSuccessResponse<T>(
    Map<String, dynamic> response,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    final successResponse =
        SuccessResponseModel<PaginationResponseModel<T>>.fromJson(
          response,
          (json) =>
              PaginationResponseModel<T>.fromJson(json, (js) => fromJsonT(js)),
        );
    return successResponse.products.data;
  }

  static T extractValueFromSuccessResponse<T>(
    Map<String, dynamic> response,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    final successResponse = SuccessResponseModel<T>.fromJson(
      response,
      (js) => fromJsonT(js),
    );
    return successResponse.products;
  }

  static List<T> extractListFromSuccessResponse<T>(
    Map<String, dynamic> response,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    final successResponse = SuccessResponseModel<List<T>>.fromJson(
      response,
      (js) =>
          js is List
              ? (js as List<Map<String, dynamic>>).map<T>(fromJsonT).toList()
              : <T>[],
    );
    return successResponse.products;
  }
}

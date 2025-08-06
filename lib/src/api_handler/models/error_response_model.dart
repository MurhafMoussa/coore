import 'package:freezed_annotation/freezed_annotation.dart';

part 'error_response_model.freezed.dart';
part 'error_response_model.g.dart';

@freezed
abstract class ErrorResponseModel with _$ErrorResponseModel {
  const factory ErrorResponseModel({required ErrorModel error}) =
      _ErrorResponseModel;

  factory ErrorResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ErrorResponseModelFromJson(json);
}

@freezed
abstract class ErrorModel with _$ErrorModel {
  const factory ErrorModel({
    required int status,
    required String message,
    List<ErrorDetail>? details,
  }) = _ErrorModel;

  factory ErrorModel.fromJson(Map<String, dynamic> json) =>
      _$ErrorModelFromJson(json);
}

@freezed
abstract class ErrorDetail with _$ErrorDetail {
  const factory ErrorDetail({required String field, required String message}) =
      _ErrorDetail;

  factory ErrorDetail.fromJson(Map<String, dynamic> json) =>
      _$ErrorDetailFromJson(json);
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'error_response_model.freezed.dart';
part 'error_response_model.g.dart';

@freezed
abstract class ErrorResponseModel with _$ErrorResponseModel {
  const factory ErrorResponseModel({required Error error}) =
      _ErrorResponseModel;

  factory ErrorResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ErrorResponseModelFromJson(json);
}

@freezed
abstract class Error with _$Error {
  const factory Error({
    required int status,
    required String message,
    List<Detail>? details,
  }) = _Error;

  factory Error.fromJson(Map<String, dynamic> json) => _$ErrorFromJson(json);
}

@freezed
abstract class Detail with _$Detail {
  const factory Detail({required String field, required String message}) =
      _Detail;

  factory Detail.fromJson(Map<String, dynamic> json) => _$DetailFromJson(json);
}

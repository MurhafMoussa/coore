import 'package:freezed_annotation/freezed_annotation.dart';

part 'success_response_model.freezed.dart';
part 'success_response_model.g.dart';

@Freezed(genericArgumentFactories: true)
abstract class SuccessResponseModel<T> with _$SuccessResponseModel<T> {
  const factory SuccessResponseModel({required T data}) =
      _SuccessResponseModel<T>;

  factory SuccessResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJson,
  ) => _$SuccessResponseModelFromJson(json, fromJson);
}

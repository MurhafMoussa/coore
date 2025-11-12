import 'package:freezed_annotation/freezed_annotation.dart';

part 'no_params.freezed.dart';
part 'no_params.g.dart';

@freezed
abstract class NoParams with _$NoParams {
  const factory NoParams() = _NoParams;

  factory NoParams.fromJson(Map<String, dynamic> json) =>
      _$NoParamsFromJson(json);
}

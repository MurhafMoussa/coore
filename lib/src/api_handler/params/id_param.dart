import 'package:coore/lib.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'id_param.freezed.dart';
part 'id_param.g.dart';

@freezed
abstract class IdParam with _$IdParam {
  const factory IdParam({
    required Id id,

  }) = _IdParam;

  factory IdParam.fromJson(Map<String, dynamic> json) =>
      _$IdParamFromJson(json);

  const IdParam._();

 
}

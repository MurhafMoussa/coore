// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'id_param.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$IdParam {

 Id get id;@JsonKey(includeToJson: false, includeFromJson: false) CancelRequestAdapter? get cancelRequestAdapter;
/// Create a copy of IdParam
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IdParamCopyWith<IdParam> get copyWith => _$IdParamCopyWithImpl<IdParam>(this as IdParam, _$identity);

  /// Serializes this IdParam to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IdParam&&(identical(other.id, id) || other.id == id)&&(identical(other.cancelRequestAdapter, cancelRequestAdapter) || other.cancelRequestAdapter == cancelRequestAdapter));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,cancelRequestAdapter);

@override
String toString() {
  return 'IdParam(id: $id, cancelRequestAdapter: $cancelRequestAdapter)';
}


}

/// @nodoc
abstract mixin class $IdParamCopyWith<$Res>  {
  factory $IdParamCopyWith(IdParam value, $Res Function(IdParam) _then) = _$IdParamCopyWithImpl;
@useResult
$Res call({
 Id id,@JsonKey(includeToJson: false, includeFromJson: false) CancelRequestAdapter? cancelRequestAdapter
});




}
/// @nodoc
class _$IdParamCopyWithImpl<$Res>
    implements $IdParamCopyWith<$Res> {
  _$IdParamCopyWithImpl(this._self, this._then);

  final IdParam _self;
  final $Res Function(IdParam) _then;

/// Create a copy of IdParam
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? cancelRequestAdapter = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as Id,cancelRequestAdapter: freezed == cancelRequestAdapter ? _self.cancelRequestAdapter : cancelRequestAdapter // ignore: cast_nullable_to_non_nullable
as CancelRequestAdapter?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _IdParam extends IdParam {
  const _IdParam({required this.id, @JsonKey(includeToJson: false, includeFromJson: false) this.cancelRequestAdapter}): super._();
  factory _IdParam.fromJson(Map<String, dynamic> json) => _$IdParamFromJson(json);

@override final  Id id;
@override@JsonKey(includeToJson: false, includeFromJson: false) final  CancelRequestAdapter? cancelRequestAdapter;

/// Create a copy of IdParam
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IdParamCopyWith<_IdParam> get copyWith => __$IdParamCopyWithImpl<_IdParam>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IdParamToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IdParam&&(identical(other.id, id) || other.id == id)&&(identical(other.cancelRequestAdapter, cancelRequestAdapter) || other.cancelRequestAdapter == cancelRequestAdapter));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,cancelRequestAdapter);

@override
String toString() {
  return 'IdParam(id: $id, cancelRequestAdapter: $cancelRequestAdapter)';
}


}

/// @nodoc
abstract mixin class _$IdParamCopyWith<$Res> implements $IdParamCopyWith<$Res> {
  factory _$IdParamCopyWith(_IdParam value, $Res Function(_IdParam) _then) = __$IdParamCopyWithImpl;
@override @useResult
$Res call({
 Id id,@JsonKey(includeToJson: false, includeFromJson: false) CancelRequestAdapter? cancelRequestAdapter
});




}
/// @nodoc
class __$IdParamCopyWithImpl<$Res>
    implements _$IdParamCopyWith<$Res> {
  __$IdParamCopyWithImpl(this._self, this._then);

  final _IdParam _self;
  final $Res Function(_IdParam) _then;

/// Create a copy of IdParam
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? cancelRequestAdapter = freezed,}) {
  return _then(_IdParam(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as Id,cancelRequestAdapter: freezed == cancelRequestAdapter ? _self.cancelRequestAdapter : cancelRequestAdapter // ignore: cast_nullable_to_non_nullable
as CancelRequestAdapter?,
  ));
}


}

// dart format on

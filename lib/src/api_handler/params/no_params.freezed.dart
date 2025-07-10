// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'no_params.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NoParams {

@JsonKey(includeFromJson: false) CancelRequestAdapter? get cancelRequestAdapter;
/// Create a copy of NoParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NoParamsCopyWith<NoParams> get copyWith => _$NoParamsCopyWithImpl<NoParams>(this as NoParams, _$identity);

  /// Serializes this NoParams to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NoParams&&(identical(other.cancelRequestAdapter, cancelRequestAdapter) || other.cancelRequestAdapter == cancelRequestAdapter));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,cancelRequestAdapter);

@override
String toString() {
  return 'NoParams(cancelRequestAdapter: $cancelRequestAdapter)';
}


}

/// @nodoc
abstract mixin class $NoParamsCopyWith<$Res>  {
  factory $NoParamsCopyWith(NoParams value, $Res Function(NoParams) _then) = _$NoParamsCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeFromJson: false) CancelRequestAdapter? cancelRequestAdapter
});




}
/// @nodoc
class _$NoParamsCopyWithImpl<$Res>
    implements $NoParamsCopyWith<$Res> {
  _$NoParamsCopyWithImpl(this._self, this._then);

  final NoParams _self;
  final $Res Function(NoParams) _then;

/// Create a copy of NoParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cancelRequestAdapter = freezed,}) {
  return _then(_self.copyWith(
cancelRequestAdapter: freezed == cancelRequestAdapter ? _self.cancelRequestAdapter : cancelRequestAdapter // ignore: cast_nullable_to_non_nullable
as CancelRequestAdapter?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _NoParams extends NoParams {
  const _NoParams({@JsonKey(includeFromJson: false) this.cancelRequestAdapter}): super._();
  factory _NoParams.fromJson(Map<String, dynamic> json) => _$NoParamsFromJson(json);

@override@JsonKey(includeFromJson: false) final  CancelRequestAdapter? cancelRequestAdapter;

/// Create a copy of NoParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NoParamsCopyWith<_NoParams> get copyWith => __$NoParamsCopyWithImpl<_NoParams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NoParamsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NoParams&&(identical(other.cancelRequestAdapter, cancelRequestAdapter) || other.cancelRequestAdapter == cancelRequestAdapter));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,cancelRequestAdapter);

@override
String toString() {
  return 'NoParams(cancelRequestAdapter: $cancelRequestAdapter)';
}


}

/// @nodoc
abstract mixin class _$NoParamsCopyWith<$Res> implements $NoParamsCopyWith<$Res> {
  factory _$NoParamsCopyWith(_NoParams value, $Res Function(_NoParams) _then) = __$NoParamsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeFromJson: false) CancelRequestAdapter? cancelRequestAdapter
});




}
/// @nodoc
class __$NoParamsCopyWithImpl<$Res>
    implements _$NoParamsCopyWith<$Res> {
  __$NoParamsCopyWithImpl(this._self, this._then);

  final _NoParams _self;
  final $Res Function(_NoParams) _then;

/// Create a copy of NoParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cancelRequestAdapter = freezed,}) {
  return _then(_NoParams(
cancelRequestAdapter: freezed == cancelRequestAdapter ? _self.cancelRequestAdapter : cancelRequestAdapter // ignore: cast_nullable_to_non_nullable
as CancelRequestAdapter?,
  ));
}


}

// dart format on

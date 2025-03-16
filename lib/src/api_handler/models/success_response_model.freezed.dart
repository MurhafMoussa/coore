// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'success_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SuccessResponseModel<T> {

@JsonKey(name: kDataKey) T get data;
/// Create a copy of SuccessResponseModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SuccessResponseModelCopyWith<T, SuccessResponseModel<T>> get copyWith => _$SuccessResponseModelCopyWithImpl<T, SuccessResponseModel<T>>(this as SuccessResponseModel<T>, _$identity);

  /// Serializes this SuccessResponseModel to a JSON map.
  Map<String, dynamic> toJson(Object? Function(T) toJsonT);


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SuccessResponseModel<T>&&const DeepCollectionEquality().equals(other.data, data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'SuccessResponseModel<$T>(data: $data)';
}


}

/// @nodoc
abstract mixin class $SuccessResponseModelCopyWith<T,$Res>  {
  factory $SuccessResponseModelCopyWith(SuccessResponseModel<T> value, $Res Function(SuccessResponseModel<T>) _then) = _$SuccessResponseModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: kDataKey) T data
});




}
/// @nodoc
class _$SuccessResponseModelCopyWithImpl<T,$Res>
    implements $SuccessResponseModelCopyWith<T, $Res> {
  _$SuccessResponseModelCopyWithImpl(this._self, this._then);

  final SuccessResponseModel<T> _self;
  final $Res Function(SuccessResponseModel<T>) _then;

/// Create a copy of SuccessResponseModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = freezed,}) {
  return _then(_self.copyWith(
data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as T,
  ));
}

}


/// @nodoc
@JsonSerializable(genericArgumentFactories: true)

class _SuccessResponseModel<T> implements SuccessResponseModel<T> {
  const _SuccessResponseModel({@JsonKey(name: kDataKey) required this.data});
  factory _SuccessResponseModel.fromJson(Map<String, dynamic> json,T Function(Object?) fromJsonT) => _$SuccessResponseModelFromJson(json,fromJsonT);

@override@JsonKey(name: kDataKey) final  T data;

/// Create a copy of SuccessResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SuccessResponseModelCopyWith<T, _SuccessResponseModel<T>> get copyWith => __$SuccessResponseModelCopyWithImpl<T, _SuccessResponseModel<T>>(this, _$identity);

@override
Map<String, dynamic> toJson(Object? Function(T) toJsonT) {
  return _$SuccessResponseModelToJson<T>(this, toJsonT);
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SuccessResponseModel<T>&&const DeepCollectionEquality().equals(other.data, data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'SuccessResponseModel<$T>(data: $data)';
}


}

/// @nodoc
abstract mixin class _$SuccessResponseModelCopyWith<T,$Res> implements $SuccessResponseModelCopyWith<T, $Res> {
  factory _$SuccessResponseModelCopyWith(_SuccessResponseModel<T> value, $Res Function(_SuccessResponseModel<T>) _then) = __$SuccessResponseModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: kDataKey) T data
});




}
/// @nodoc
class __$SuccessResponseModelCopyWithImpl<T,$Res>
    implements _$SuccessResponseModelCopyWith<T, $Res> {
  __$SuccessResponseModelCopyWithImpl(this._self, this._then);

  final _SuccessResponseModel<T> _self;
  final $Res Function(_SuccessResponseModel<T>) _then;

/// Create a copy of SuccessResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = freezed,}) {
  return _then(_SuccessResponseModel<T>(
data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as T,
  ));
}


}

// dart format on

// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pagination_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PaginationResponseModel<T> {

 List<T> get data;
/// Create a copy of PaginationResponseModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaginationResponseModelCopyWith<T, PaginationResponseModel<T>> get copyWith => _$PaginationResponseModelCopyWithImpl<T, PaginationResponseModel<T>>(this as PaginationResponseModel<T>, _$identity);

  /// Serializes this PaginationResponseModel to a JSON map.
  Map<String, dynamic> toJson(Object? Function(T) toJsonT);


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaginationResponseModel<T>&&const DeepCollectionEquality().equals(other.data, data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'PaginationResponseModel<$T>(data: $data)';
}


}

/// @nodoc
abstract mixin class $PaginationResponseModelCopyWith<T,$Res>  {
  factory $PaginationResponseModelCopyWith(PaginationResponseModel<T> value, $Res Function(PaginationResponseModel<T>) _then) = _$PaginationResponseModelCopyWithImpl;
@useResult
$Res call({
 List<T> data
});




}
/// @nodoc
class _$PaginationResponseModelCopyWithImpl<T,$Res>
    implements $PaginationResponseModelCopyWith<T, $Res> {
  _$PaginationResponseModelCopyWithImpl(this._self, this._then);

  final PaginationResponseModel<T> _self;
  final $Res Function(PaginationResponseModel<T>) _then;

/// Create a copy of PaginationResponseModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = null,}) {
  return _then(_self.copyWith(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<T>,
  ));
}

}


/// @nodoc
@JsonSerializable(genericArgumentFactories: true)

class _PaginationResponseModel<T> implements PaginationResponseModel<T> {
  const _PaginationResponseModel({final  List<T> data = const []}): _data = data;
  factory _PaginationResponseModel.fromJson(Map<String, dynamic> json,T Function(Object?) fromJsonT) => _$PaginationResponseModelFromJson(json,fromJsonT);

 final  List<T> _data;
@override@JsonKey() List<T> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}


/// Create a copy of PaginationResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaginationResponseModelCopyWith<T, _PaginationResponseModel<T>> get copyWith => __$PaginationResponseModelCopyWithImpl<T, _PaginationResponseModel<T>>(this, _$identity);

@override
Map<String, dynamic> toJson(Object? Function(T) toJsonT) {
  return _$PaginationResponseModelToJson<T>(this, toJsonT);
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaginationResponseModel<T>&&const DeepCollectionEquality().equals(other._data, _data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'PaginationResponseModel<$T>(data: $data)';
}


}

/// @nodoc
abstract mixin class _$PaginationResponseModelCopyWith<T,$Res> implements $PaginationResponseModelCopyWith<T, $Res> {
  factory _$PaginationResponseModelCopyWith(_PaginationResponseModel<T> value, $Res Function(_PaginationResponseModel<T>) _then) = __$PaginationResponseModelCopyWithImpl;
@override @useResult
$Res call({
 List<T> data
});




}
/// @nodoc
class __$PaginationResponseModelCopyWithImpl<T,$Res>
    implements _$PaginationResponseModelCopyWith<T, $Res> {
  __$PaginationResponseModelCopyWithImpl(this._self, this._then);

  final _PaginationResponseModel<T> _self;
  final $Res Function(_PaginationResponseModel<T>) _then;

/// Create a copy of PaginationResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(_PaginationResponseModel<T>(
data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<T>,
  ));
}


}

// dart format on

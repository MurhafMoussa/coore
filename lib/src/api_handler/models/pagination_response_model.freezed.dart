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
mixin _$PaginationResponseModel<T,M extends MetaModel> {

 List<T> get data; M? get meta;
/// Create a copy of PaginationResponseModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaginationResponseModelCopyWith<T, M, PaginationResponseModel<T, M>> get copyWith => _$PaginationResponseModelCopyWithImpl<T, M, PaginationResponseModel<T, M>>(this as PaginationResponseModel<T, M>, _$identity);

  /// Serializes this PaginationResponseModel to a JSON map.
  Map<String, dynamic> toJson(Object? Function(T) toJsonT,Object? Function(M) toJsonM);


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaginationResponseModel<T, M>&&const DeepCollectionEquality().equals(other.data, data)&&const DeepCollectionEquality().equals(other.meta, meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data),const DeepCollectionEquality().hash(meta));

@override
String toString() {
  return 'PaginationResponseModel<$T, $M>(data: $data, meta: $meta)';
}


}

/// @nodoc
abstract mixin class $PaginationResponseModelCopyWith<T,M extends MetaModel,$Res>  {
  factory $PaginationResponseModelCopyWith(PaginationResponseModel<T, M> value, $Res Function(PaginationResponseModel<T, M>) _then) = _$PaginationResponseModelCopyWithImpl;
@useResult
$Res call({
 List<T> data, M? meta
});




}
/// @nodoc
class _$PaginationResponseModelCopyWithImpl<T,M extends MetaModel,$Res>
    implements $PaginationResponseModelCopyWith<T, M, $Res> {
  _$PaginationResponseModelCopyWithImpl(this._self, this._then);

  final PaginationResponseModel<T, M> _self;
  final $Res Function(PaginationResponseModel<T, M>) _then;

/// Create a copy of PaginationResponseModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = null,Object? meta = freezed,}) {
  return _then(_self.copyWith(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<T>,meta: freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as M?,
  ));
}

}


/// @nodoc
@JsonSerializable(genericArgumentFactories: true)

class _PaginationResponseModel<T,M extends MetaModel> implements PaginationResponseModel<T, M> {
  const _PaginationResponseModel({final  List<T> data = const [], this.meta}): _data = data;
  factory _PaginationResponseModel.fromJson(Map<String, dynamic> json,T Function(Object?) fromJsonT,M Function(Object?) fromJsonM) => _$PaginationResponseModelFromJson(json,fromJsonT,fromJsonM);

 final  List<T> _data;
@override@JsonKey() List<T> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}

@override final  M? meta;

/// Create a copy of PaginationResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaginationResponseModelCopyWith<T, M, _PaginationResponseModel<T, M>> get copyWith => __$PaginationResponseModelCopyWithImpl<T, M, _PaginationResponseModel<T, M>>(this, _$identity);

@override
Map<String, dynamic> toJson(Object? Function(T) toJsonT,Object? Function(M) toJsonM) {
  return _$PaginationResponseModelToJson<T, M>(this, toJsonT,toJsonM);
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaginationResponseModel<T, M>&&const DeepCollectionEquality().equals(other._data, _data)&&const DeepCollectionEquality().equals(other.meta, meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_data),const DeepCollectionEquality().hash(meta));

@override
String toString() {
  return 'PaginationResponseModel<$T, $M>(data: $data, meta: $meta)';
}


}

/// @nodoc
abstract mixin class _$PaginationResponseModelCopyWith<T,M extends MetaModel,$Res> implements $PaginationResponseModelCopyWith<T, M, $Res> {
  factory _$PaginationResponseModelCopyWith(_PaginationResponseModel<T, M> value, $Res Function(_PaginationResponseModel<T, M>) _then) = __$PaginationResponseModelCopyWithImpl;
@override @useResult
$Res call({
 List<T> data, M? meta
});




}
/// @nodoc
class __$PaginationResponseModelCopyWithImpl<T,M extends MetaModel,$Res>
    implements _$PaginationResponseModelCopyWith<T, M, $Res> {
  __$PaginationResponseModelCopyWithImpl(this._self, this._then);

  final _PaginationResponseModel<T, M> _self;
  final $Res Function(_PaginationResponseModel<T, M>) _then;

/// Create a copy of PaginationResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = null,Object? meta = freezed,}) {
  return _then(_PaginationResponseModel<T, M>(
data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<T>,meta: freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as M?,
  ));
}


}

// dart format on

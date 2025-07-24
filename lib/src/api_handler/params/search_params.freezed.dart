// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_params.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SearchParams {

 String get query;@JsonKey(includeToJson: false, includeFromJson: false) CancelRequestAdapter? get cancelRequestAdapter;
/// Create a copy of SearchParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchParamsCopyWith<SearchParams> get copyWith => _$SearchParamsCopyWithImpl<SearchParams>(this as SearchParams, _$identity);

  /// Serializes this SearchParams to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchParams&&(identical(other.query, query) || other.query == query)&&(identical(other.cancelRequestAdapter, cancelRequestAdapter) || other.cancelRequestAdapter == cancelRequestAdapter));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,query,cancelRequestAdapter);

@override
String toString() {
  return 'SearchParams(query: $query, cancelRequestAdapter: $cancelRequestAdapter)';
}


}

/// @nodoc
abstract mixin class $SearchParamsCopyWith<$Res>  {
  factory $SearchParamsCopyWith(SearchParams value, $Res Function(SearchParams) _then) = _$SearchParamsCopyWithImpl;
@useResult
$Res call({
 String query,@JsonKey(includeToJson: false, includeFromJson: false) CancelRequestAdapter? cancelRequestAdapter
});




}
/// @nodoc
class _$SearchParamsCopyWithImpl<$Res>
    implements $SearchParamsCopyWith<$Res> {
  _$SearchParamsCopyWithImpl(this._self, this._then);

  final SearchParams _self;
  final $Res Function(SearchParams) _then;

/// Create a copy of SearchParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? query = null,Object? cancelRequestAdapter = freezed,}) {
  return _then(_self.copyWith(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,cancelRequestAdapter: freezed == cancelRequestAdapter ? _self.cancelRequestAdapter : cancelRequestAdapter // ignore: cast_nullable_to_non_nullable
as CancelRequestAdapter?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _SearchParams extends SearchParams {
  const _SearchParams({required this.query, @JsonKey(includeToJson: false, includeFromJson: false) this.cancelRequestAdapter}): super._();
  factory _SearchParams.fromJson(Map<String, dynamic> json) => _$SearchParamsFromJson(json);

@override final  String query;
@override@JsonKey(includeToJson: false, includeFromJson: false) final  CancelRequestAdapter? cancelRequestAdapter;

/// Create a copy of SearchParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchParamsCopyWith<_SearchParams> get copyWith => __$SearchParamsCopyWithImpl<_SearchParams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SearchParamsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchParams&&(identical(other.query, query) || other.query == query)&&(identical(other.cancelRequestAdapter, cancelRequestAdapter) || other.cancelRequestAdapter == cancelRequestAdapter));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,query,cancelRequestAdapter);

@override
String toString() {
  return 'SearchParams(query: $query, cancelRequestAdapter: $cancelRequestAdapter)';
}


}

/// @nodoc
abstract mixin class _$SearchParamsCopyWith<$Res> implements $SearchParamsCopyWith<$Res> {
  factory _$SearchParamsCopyWith(_SearchParams value, $Res Function(_SearchParams) _then) = __$SearchParamsCopyWithImpl;
@override @useResult
$Res call({
 String query,@JsonKey(includeToJson: false, includeFromJson: false) CancelRequestAdapter? cancelRequestAdapter
});




}
/// @nodoc
class __$SearchParamsCopyWithImpl<$Res>
    implements _$SearchParamsCopyWith<$Res> {
  __$SearchParamsCopyWithImpl(this._self, this._then);

  final _SearchParams _self;
  final $Res Function(_SearchParams) _then;

/// Create a copy of SearchParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? query = null,Object? cancelRequestAdapter = freezed,}) {
  return _then(_SearchParams(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,cancelRequestAdapter: freezed == cancelRequestAdapter ? _self.cancelRequestAdapter : cancelRequestAdapter // ignore: cast_nullable_to_non_nullable
as CancelRequestAdapter?,
  ));
}


}

// dart format on

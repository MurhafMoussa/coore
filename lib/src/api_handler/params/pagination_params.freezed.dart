// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pagination_params.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SkipPagingStrategyParams {

 int get take; int get skip;@JsonKey(includeToJson: false, includeFromJson: false) CancelRequestAdapter? get cancelRequestAdapter;
/// Create a copy of SkipPagingStrategyParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SkipPagingStrategyParamsCopyWith<SkipPagingStrategyParams> get copyWith => _$SkipPagingStrategyParamsCopyWithImpl<SkipPagingStrategyParams>(this as SkipPagingStrategyParams, _$identity);

  /// Serializes this SkipPagingStrategyParams to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SkipPagingStrategyParams&&(identical(other.take, take) || other.take == take)&&(identical(other.skip, skip) || other.skip == skip)&&(identical(other.cancelRequestAdapter, cancelRequestAdapter) || other.cancelRequestAdapter == cancelRequestAdapter));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,take,skip,cancelRequestAdapter);

@override
String toString() {
  return 'SkipPagingStrategyParams(take: $take, skip: $skip, cancelRequestAdapter: $cancelRequestAdapter)';
}


}

/// @nodoc
abstract mixin class $SkipPagingStrategyParamsCopyWith<$Res>  {
  factory $SkipPagingStrategyParamsCopyWith(SkipPagingStrategyParams value, $Res Function(SkipPagingStrategyParams) _then) = _$SkipPagingStrategyParamsCopyWithImpl;
@useResult
$Res call({
 int take, int skip,@JsonKey(includeToJson: false, includeFromJson: false) CancelRequestAdapter? cancelRequestAdapter
});




}
/// @nodoc
class _$SkipPagingStrategyParamsCopyWithImpl<$Res>
    implements $SkipPagingStrategyParamsCopyWith<$Res> {
  _$SkipPagingStrategyParamsCopyWithImpl(this._self, this._then);

  final SkipPagingStrategyParams _self;
  final $Res Function(SkipPagingStrategyParams) _then;

/// Create a copy of SkipPagingStrategyParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? take = null,Object? skip = null,Object? cancelRequestAdapter = freezed,}) {
  return _then(_self.copyWith(
take: null == take ? _self.take : take // ignore: cast_nullable_to_non_nullable
as int,skip: null == skip ? _self.skip : skip // ignore: cast_nullable_to_non_nullable
as int,cancelRequestAdapter: freezed == cancelRequestAdapter ? _self.cancelRequestAdapter : cancelRequestAdapter // ignore: cast_nullable_to_non_nullable
as CancelRequestAdapter?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _SkipPagingStrategyParams extends SkipPagingStrategyParams {
  const _SkipPagingStrategyParams({required this.take, required this.skip, @JsonKey(includeToJson: false, includeFromJson: false) this.cancelRequestAdapter}): super._();
  factory _SkipPagingStrategyParams.fromJson(Map<String, dynamic> json) => _$SkipPagingStrategyParamsFromJson(json);

@override final  int take;
@override final  int skip;
@override@JsonKey(includeToJson: false, includeFromJson: false) final  CancelRequestAdapter? cancelRequestAdapter;

/// Create a copy of SkipPagingStrategyParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SkipPagingStrategyParamsCopyWith<_SkipPagingStrategyParams> get copyWith => __$SkipPagingStrategyParamsCopyWithImpl<_SkipPagingStrategyParams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SkipPagingStrategyParamsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SkipPagingStrategyParams&&(identical(other.take, take) || other.take == take)&&(identical(other.skip, skip) || other.skip == skip)&&(identical(other.cancelRequestAdapter, cancelRequestAdapter) || other.cancelRequestAdapter == cancelRequestAdapter));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,take,skip,cancelRequestAdapter);

@override
String toString() {
  return 'SkipPagingStrategyParams(take: $take, skip: $skip, cancelRequestAdapter: $cancelRequestAdapter)';
}


}

/// @nodoc
abstract mixin class _$SkipPagingStrategyParamsCopyWith<$Res> implements $SkipPagingStrategyParamsCopyWith<$Res> {
  factory _$SkipPagingStrategyParamsCopyWith(_SkipPagingStrategyParams value, $Res Function(_SkipPagingStrategyParams) _then) = __$SkipPagingStrategyParamsCopyWithImpl;
@override @useResult
$Res call({
 int take, int skip,@JsonKey(includeToJson: false, includeFromJson: false) CancelRequestAdapter? cancelRequestAdapter
});




}
/// @nodoc
class __$SkipPagingStrategyParamsCopyWithImpl<$Res>
    implements _$SkipPagingStrategyParamsCopyWith<$Res> {
  __$SkipPagingStrategyParamsCopyWithImpl(this._self, this._then);

  final _SkipPagingStrategyParams _self;
  final $Res Function(_SkipPagingStrategyParams) _then;

/// Create a copy of SkipPagingStrategyParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? take = null,Object? skip = null,Object? cancelRequestAdapter = freezed,}) {
  return _then(_SkipPagingStrategyParams(
take: null == take ? _self.take : take // ignore: cast_nullable_to_non_nullable
as int,skip: null == skip ? _self.skip : skip // ignore: cast_nullable_to_non_nullable
as int,cancelRequestAdapter: freezed == cancelRequestAdapter ? _self.cancelRequestAdapter : cancelRequestAdapter // ignore: cast_nullable_to_non_nullable
as CancelRequestAdapter?,
  ));
}


}


/// @nodoc
mixin _$PagePaginationParams {

 int get page; int get limit;@JsonKey(includeToJson: false, includeFromJson: false) CancelRequestAdapter? get cancelRequestAdapter;
/// Create a copy of PagePaginationParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PagePaginationParamsCopyWith<PagePaginationParams> get copyWith => _$PagePaginationParamsCopyWithImpl<PagePaginationParams>(this as PagePaginationParams, _$identity);

  /// Serializes this PagePaginationParams to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PagePaginationParams&&(identical(other.page, page) || other.page == page)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.cancelRequestAdapter, cancelRequestAdapter) || other.cancelRequestAdapter == cancelRequestAdapter));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,page,limit,cancelRequestAdapter);

@override
String toString() {
  return 'PagePaginationParams(page: $page, limit: $limit, cancelRequestAdapter: $cancelRequestAdapter)';
}


}

/// @nodoc
abstract mixin class $PagePaginationParamsCopyWith<$Res>  {
  factory $PagePaginationParamsCopyWith(PagePaginationParams value, $Res Function(PagePaginationParams) _then) = _$PagePaginationParamsCopyWithImpl;
@useResult
$Res call({
 int page, int limit,@JsonKey(includeToJson: false, includeFromJson: false) CancelRequestAdapter? cancelRequestAdapter
});




}
/// @nodoc
class _$PagePaginationParamsCopyWithImpl<$Res>
    implements $PagePaginationParamsCopyWith<$Res> {
  _$PagePaginationParamsCopyWithImpl(this._self, this._then);

  final PagePaginationParams _self;
  final $Res Function(PagePaginationParams) _then;

/// Create a copy of PagePaginationParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? page = null,Object? limit = null,Object? cancelRequestAdapter = freezed,}) {
  return _then(_self.copyWith(
page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,cancelRequestAdapter: freezed == cancelRequestAdapter ? _self.cancelRequestAdapter : cancelRequestAdapter // ignore: cast_nullable_to_non_nullable
as CancelRequestAdapter?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _PagePaginationParams extends PagePaginationParams {
  const _PagePaginationParams({required this.page, required this.limit, @JsonKey(includeToJson: false, includeFromJson: false) this.cancelRequestAdapter}): super._();
  factory _PagePaginationParams.fromJson(Map<String, dynamic> json) => _$PagePaginationParamsFromJson(json);

@override final  int page;
@override final  int limit;
@override@JsonKey(includeToJson: false, includeFromJson: false) final  CancelRequestAdapter? cancelRequestAdapter;

/// Create a copy of PagePaginationParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PagePaginationParamsCopyWith<_PagePaginationParams> get copyWith => __$PagePaginationParamsCopyWithImpl<_PagePaginationParams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PagePaginationParamsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PagePaginationParams&&(identical(other.page, page) || other.page == page)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.cancelRequestAdapter, cancelRequestAdapter) || other.cancelRequestAdapter == cancelRequestAdapter));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,page,limit,cancelRequestAdapter);

@override
String toString() {
  return 'PagePaginationParams(page: $page, limit: $limit, cancelRequestAdapter: $cancelRequestAdapter)';
}


}

/// @nodoc
abstract mixin class _$PagePaginationParamsCopyWith<$Res> implements $PagePaginationParamsCopyWith<$Res> {
  factory _$PagePaginationParamsCopyWith(_PagePaginationParams value, $Res Function(_PagePaginationParams) _then) = __$PagePaginationParamsCopyWithImpl;
@override @useResult
$Res call({
 int page, int limit,@JsonKey(includeToJson: false, includeFromJson: false) CancelRequestAdapter? cancelRequestAdapter
});




}
/// @nodoc
class __$PagePaginationParamsCopyWithImpl<$Res>
    implements _$PagePaginationParamsCopyWith<$Res> {
  __$PagePaginationParamsCopyWithImpl(this._self, this._then);

  final _PagePaginationParams _self;
  final $Res Function(_PagePaginationParams) _then;

/// Create a copy of PagePaginationParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? page = null,Object? limit = null,Object? cancelRequestAdapter = freezed,}) {
  return _then(_PagePaginationParams(
page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,cancelRequestAdapter: freezed == cancelRequestAdapter ? _self.cancelRequestAdapter : cancelRequestAdapter // ignore: cast_nullable_to_non_nullable
as CancelRequestAdapter?,
  ));
}


}

// dart format on

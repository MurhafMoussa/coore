// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
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

 Id get id;
/// Create a copy of IdParam
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IdParamCopyWith<IdParam> get copyWith => _$IdParamCopyWithImpl<IdParam>(this as IdParam, _$identity);

  /// Serializes this IdParam to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IdParam&&(identical(other.id, id) || other.id == id));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'IdParam(id: $id)';
}


}

/// @nodoc
abstract mixin class $IdParamCopyWith<$Res>  {
  factory $IdParamCopyWith(IdParam value, $Res Function(IdParam) _then) = _$IdParamCopyWithImpl;
@useResult
$Res call({
 Id id
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as Id,
  ));
}

}


/// Adds pattern-matching-related methods to [IdParam].
extension IdParamPatterns on IdParam {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IdParam value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IdParam() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IdParam value)  $default,){
final _that = this;
switch (_that) {
case _IdParam():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IdParam value)?  $default,){
final _that = this;
switch (_that) {
case _IdParam() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Id id)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IdParam() when $default != null:
return $default(_that.id);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Id id)  $default,) {final _that = this;
switch (_that) {
case _IdParam():
return $default(_that.id);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Id id)?  $default,) {final _that = this;
switch (_that) {
case _IdParam() when $default != null:
return $default(_that.id);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _IdParam extends IdParam {
  const _IdParam({required this.id}): super._();
  factory _IdParam.fromJson(Map<String, dynamic> json) => _$IdParamFromJson(json);

@override final  Id id;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IdParam&&(identical(other.id, id) || other.id == id));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'IdParam(id: $id)';
}


}

/// @nodoc
abstract mixin class _$IdParamCopyWith<$Res> implements $IdParamCopyWith<$Res> {
  factory _$IdParamCopyWith(_IdParam value, $Res Function(_IdParam) _then) = __$IdParamCopyWithImpl;
@override @useResult
$Res call({
 Id id
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(_IdParam(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as Id,
  ));
}


}

// dart format on

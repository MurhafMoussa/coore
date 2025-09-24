// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'core_search_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CoreSearchState<T> {

 ApiState<List<T>> get apiState;
/// Create a copy of CoreSearchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoreSearchStateCopyWith<T, CoreSearchState<T>> get copyWith => _$CoreSearchStateCopyWithImpl<T, CoreSearchState<T>>(this as CoreSearchState<T>, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoreSearchState<T>&&(identical(other.apiState, apiState) || other.apiState == apiState));
}


@override
int get hashCode => Object.hash(runtimeType,apiState);

@override
String toString() {
  return 'CoreSearchState<$T>(apiState: $apiState)';
}


}

/// @nodoc
abstract mixin class $CoreSearchStateCopyWith<T,$Res>  {
  factory $CoreSearchStateCopyWith(CoreSearchState<T> value, $Res Function(CoreSearchState<T>) _then) = _$CoreSearchStateCopyWithImpl;
@useResult
$Res call({
 ApiState<List<T>> apiState
});


$ApiStateCopyWith<List<T>, $Res> get apiState;

}
/// @nodoc
class _$CoreSearchStateCopyWithImpl<T,$Res>
    implements $CoreSearchStateCopyWith<T, $Res> {
  _$CoreSearchStateCopyWithImpl(this._self, this._then);

  final CoreSearchState<T> _self;
  final $Res Function(CoreSearchState<T>) _then;

/// Create a copy of CoreSearchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? apiState = null,}) {
  return _then(_self.copyWith(
apiState: null == apiState ? _self.apiState : apiState // ignore: cast_nullable_to_non_nullable
as ApiState<List<T>>,
  ));
}
/// Create a copy of CoreSearchState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiStateCopyWith<List<T>, $Res> get apiState {
  
  return $ApiStateCopyWith<List<T>, $Res>(_self.apiState, (value) {
    return _then(_self.copyWith(apiState: value));
  });
}
}


/// Adds pattern-matching-related methods to [CoreSearchState].
extension CoreSearchStatePatterns<T> on CoreSearchState<T> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoreSearchState<T> value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoreSearchState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoreSearchState<T> value)  $default,){
final _that = this;
switch (_that) {
case _CoreSearchState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoreSearchState<T> value)?  $default,){
final _that = this;
switch (_that) {
case _CoreSearchState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ApiState<List<T>> apiState)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CoreSearchState() when $default != null:
return $default(_that.apiState);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ApiState<List<T>> apiState)  $default,) {final _that = this;
switch (_that) {
case _CoreSearchState():
return $default(_that.apiState);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ApiState<List<T>> apiState)?  $default,) {final _that = this;
switch (_that) {
case _CoreSearchState() when $default != null:
return $default(_that.apiState);case _:
  return null;

}
}

}

/// @nodoc


class _CoreSearchState<T> implements CoreSearchState<T> {
  const _CoreSearchState({required this.apiState});
  

@override final  ApiState<List<T>> apiState;

/// Create a copy of CoreSearchState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoreSearchStateCopyWith<T, _CoreSearchState<T>> get copyWith => __$CoreSearchStateCopyWithImpl<T, _CoreSearchState<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoreSearchState<T>&&(identical(other.apiState, apiState) || other.apiState == apiState));
}


@override
int get hashCode => Object.hash(runtimeType,apiState);

@override
String toString() {
  return 'CoreSearchState<$T>(apiState: $apiState)';
}


}

/// @nodoc
abstract mixin class _$CoreSearchStateCopyWith<T,$Res> implements $CoreSearchStateCopyWith<T, $Res> {
  factory _$CoreSearchStateCopyWith(_CoreSearchState<T> value, $Res Function(_CoreSearchState<T>) _then) = __$CoreSearchStateCopyWithImpl;
@override @useResult
$Res call({
 ApiState<List<T>> apiState
});


@override $ApiStateCopyWith<List<T>, $Res> get apiState;

}
/// @nodoc
class __$CoreSearchStateCopyWithImpl<T,$Res>
    implements _$CoreSearchStateCopyWith<T, $Res> {
  __$CoreSearchStateCopyWithImpl(this._self, this._then);

  final _CoreSearchState<T> _self;
  final $Res Function(_CoreSearchState<T>) _then;

/// Create a copy of CoreSearchState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? apiState = null,}) {
  return _then(_CoreSearchState<T>(
apiState: null == apiState ? _self.apiState : apiState // ignore: cast_nullable_to_non_nullable
as ApiState<List<T>>,
  ));
}

/// Create a copy of CoreSearchState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiStateCopyWith<List<T>, $Res> get apiState {
  
  return $ApiStateCopyWith<List<T>, $Res>(_self.apiState, (value) {
    return _then(_self.copyWith(apiState: value));
  });
}
}

// dart format on

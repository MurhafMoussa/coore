// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'core_form_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CoreFormState {

 Map<String, dynamic> get values; Map<String, String> get errors; bool get isValid; ValidationType get validationType;
/// Create a copy of CoreFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoreFormStateCopyWith<CoreFormState> get copyWith => _$CoreFormStateCopyWithImpl<CoreFormState>(this as CoreFormState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoreFormState&&const DeepCollectionEquality().equals(other.values, values)&&const DeepCollectionEquality().equals(other.errors, errors)&&(identical(other.isValid, isValid) || other.isValid == isValid)&&(identical(other.validationType, validationType) || other.validationType == validationType));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(values),const DeepCollectionEquality().hash(errors),isValid,validationType);

@override
String toString() {
  return 'CoreFormState(values: $values, errors: $errors, isValid: $isValid, validationType: $validationType)';
}


}

/// @nodoc
abstract mixin class $CoreFormStateCopyWith<$Res>  {
  factory $CoreFormStateCopyWith(CoreFormState value, $Res Function(CoreFormState) _then) = _$CoreFormStateCopyWithImpl;
@useResult
$Res call({
 Map<String, dynamic> values, Map<String, String> errors, bool isValid, ValidationType validationType
});




}
/// @nodoc
class _$CoreFormStateCopyWithImpl<$Res>
    implements $CoreFormStateCopyWith<$Res> {
  _$CoreFormStateCopyWithImpl(this._self, this._then);

  final CoreFormState _self;
  final $Res Function(CoreFormState) _then;

/// Create a copy of CoreFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? values = null,Object? errors = null,Object? isValid = null,Object? validationType = null,}) {
  return _then(_self.copyWith(
values: null == values ? _self.values : values // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,errors: null == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, String>,isValid: null == isValid ? _self.isValid : isValid // ignore: cast_nullable_to_non_nullable
as bool,validationType: null == validationType ? _self.validationType : validationType // ignore: cast_nullable_to_non_nullable
as ValidationType,
  ));
}

}


/// @nodoc


class _CoreFormState implements CoreFormState {
  const _CoreFormState({required final  Map<String, dynamic> values, required final  Map<String, String> errors, required this.isValid, this.validationType = ValidationType.fieldsBeingEdited}): _values = values,_errors = errors;
  

 final  Map<String, dynamic> _values;
@override Map<String, dynamic> get values {
  if (_values is EqualUnmodifiableMapView) return _values;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_values);
}

 final  Map<String, String> _errors;
@override Map<String, String> get errors {
  if (_errors is EqualUnmodifiableMapView) return _errors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_errors);
}

@override final  bool isValid;
@override@JsonKey() final  ValidationType validationType;

/// Create a copy of CoreFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoreFormStateCopyWith<_CoreFormState> get copyWith => __$CoreFormStateCopyWithImpl<_CoreFormState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoreFormState&&const DeepCollectionEquality().equals(other._values, _values)&&const DeepCollectionEquality().equals(other._errors, _errors)&&(identical(other.isValid, isValid) || other.isValid == isValid)&&(identical(other.validationType, validationType) || other.validationType == validationType));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_values),const DeepCollectionEquality().hash(_errors),isValid,validationType);

@override
String toString() {
  return 'CoreFormState(values: $values, errors: $errors, isValid: $isValid, validationType: $validationType)';
}


}

/// @nodoc
abstract mixin class _$CoreFormStateCopyWith<$Res> implements $CoreFormStateCopyWith<$Res> {
  factory _$CoreFormStateCopyWith(_CoreFormState value, $Res Function(_CoreFormState) _then) = __$CoreFormStateCopyWithImpl;
@override @useResult
$Res call({
 Map<String, dynamic> values, Map<String, String> errors, bool isValid, ValidationType validationType
});




}
/// @nodoc
class __$CoreFormStateCopyWithImpl<$Res>
    implements _$CoreFormStateCopyWith<$Res> {
  __$CoreFormStateCopyWithImpl(this._self, this._then);

  final _CoreFormState _self;
  final $Res Function(_CoreFormState) _then;

/// Create a copy of CoreFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? values = null,Object? errors = null,Object? isValid = null,Object? validationType = null,}) {
  return _then(_CoreFormState(
values: null == values ? _self._values : values // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,errors: null == errors ? _self._errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, String>,isValid: null == isValid ? _self.isValid : isValid // ignore: cast_nullable_to_non_nullable
as bool,validationType: null == validationType ? _self.validationType : validationType // ignore: cast_nullable_to_non_nullable
as ValidationType,
  ));
}


}

// dart format on

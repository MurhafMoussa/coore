// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ApiState<T> implements DiagnosticableTreeMixin {




@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ApiState<$T>'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiState<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ApiState<$T>()';
}


}

/// @nodoc
class $ApiStateCopyWith<T,$Res>  {
$ApiStateCopyWith(ApiState<T> _, $Res Function(ApiState<T>) __);
}


/// @nodoc


class Initial<T> extends ApiState<T> with DiagnosticableTreeMixin {
  const Initial(): super._();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ApiState<$T>.initial'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Initial<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ApiState<$T>.initial()';
}


}




/// @nodoc


class Loading<T> extends ApiState<T> with DiagnosticableTreeMixin {
  const Loading(): super._();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ApiState<$T>.loading'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Loading<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ApiState<$T>.loading()';
}


}




/// @nodoc


class Succeeded<T> extends ApiState<T> with DiagnosticableTreeMixin {
  const Succeeded(this.successValue): super._();
  

 final  T successValue;

/// Create a copy of ApiState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SucceededCopyWith<T, Succeeded<T>> get copyWith => _$SucceededCopyWithImpl<T, Succeeded<T>>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ApiState<$T>.succeeded'))
    ..add(DiagnosticsProperty('successValue', successValue));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Succeeded<T>&&const DeepCollectionEquality().equals(other.successValue, successValue));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(successValue));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ApiState<$T>.succeeded(successValue: $successValue)';
}


}

/// @nodoc
abstract mixin class $SucceededCopyWith<T,$Res> implements $ApiStateCopyWith<T, $Res> {
  factory $SucceededCopyWith(Succeeded<T> value, $Res Function(Succeeded<T>) _then) = _$SucceededCopyWithImpl;
@useResult
$Res call({
 T successValue
});




}
/// @nodoc
class _$SucceededCopyWithImpl<T,$Res>
    implements $SucceededCopyWith<T, $Res> {
  _$SucceededCopyWithImpl(this._self, this._then);

  final Succeeded<T> _self;
  final $Res Function(Succeeded<T>) _then;

/// Create a copy of ApiState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? successValue = freezed,}) {
  return _then(Succeeded<T>(
freezed == successValue ? _self.successValue : successValue // ignore: cast_nullable_to_non_nullable
as T,
  ));
}


}

/// @nodoc


class Failed<T> extends ApiState<T> with DiagnosticableTreeMixin {
  const Failed(this.failure, {this.retryFunction}): super._();
  

 final  Failure failure;
 final  VoidCallback? retryFunction;

/// Create a copy of ApiState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FailedCopyWith<T, Failed<T>> get copyWith => _$FailedCopyWithImpl<T, Failed<T>>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ApiState<$T>.failed'))
    ..add(DiagnosticsProperty('failure', failure))..add(DiagnosticsProperty('retryFunction', retryFunction));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Failed<T>&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.retryFunction, retryFunction) || other.retryFunction == retryFunction));
}


@override
int get hashCode => Object.hash(runtimeType,failure,retryFunction);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ApiState<$T>.failed(failure: $failure, retryFunction: $retryFunction)';
}


}

/// @nodoc
abstract mixin class $FailedCopyWith<T,$Res> implements $ApiStateCopyWith<T, $Res> {
  factory $FailedCopyWith(Failed<T> value, $Res Function(Failed<T>) _then) = _$FailedCopyWithImpl;
@useResult
$Res call({
 Failure failure, VoidCallback? retryFunction
});




}
/// @nodoc
class _$FailedCopyWithImpl<T,$Res>
    implements $FailedCopyWith<T, $Res> {
  _$FailedCopyWithImpl(this._self, this._then);

  final Failed<T> _self;
  final $Res Function(Failed<T>) _then;

/// Create a copy of ApiState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,Object? retryFunction = freezed,}) {
  return _then(Failed<T>(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,retryFunction: freezed == retryFunction ? _self.retryFunction : retryFunction // ignore: cast_nullable_to_non_nullable
as VoidCallback?,
  ));
}


}

// dart format on

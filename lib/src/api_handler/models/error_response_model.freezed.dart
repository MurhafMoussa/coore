// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'error_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ErrorResponseModel {

 Error get error;
/// Create a copy of ErrorResponseModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ErrorResponseModelCopyWith<ErrorResponseModel> get copyWith => _$ErrorResponseModelCopyWithImpl<ErrorResponseModel>(this as ErrorResponseModel, _$identity);

  /// Serializes this ErrorResponseModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ErrorResponseModel&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'ErrorResponseModel(error: $error)';
}


}

/// @nodoc
abstract mixin class $ErrorResponseModelCopyWith<$Res>  {
  factory $ErrorResponseModelCopyWith(ErrorResponseModel value, $Res Function(ErrorResponseModel) _then) = _$ErrorResponseModelCopyWithImpl;
@useResult
$Res call({
 Error error
});


$ErrorCopyWith<$Res> get error;

}
/// @nodoc
class _$ErrorResponseModelCopyWithImpl<$Res>
    implements $ErrorResponseModelCopyWith<$Res> {
  _$ErrorResponseModelCopyWithImpl(this._self, this._then);

  final ErrorResponseModel _self;
  final $Res Function(ErrorResponseModel) _then;

/// Create a copy of ErrorResponseModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? error = null,}) {
  return _then(_self.copyWith(
error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as Error,
  ));
}
/// Create a copy of ErrorResponseModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ErrorCopyWith<$Res> get error {
  
  return $ErrorCopyWith<$Res>(_self.error, (value) {
    return _then(_self.copyWith(error: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _ErrorResponseModel implements ErrorResponseModel {
  const _ErrorResponseModel({required this.error});
  factory _ErrorResponseModel.fromJson(Map<String, dynamic> json) => _$ErrorResponseModelFromJson(json);

@override final  Error error;

/// Create a copy of ErrorResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorResponseModelCopyWith<_ErrorResponseModel> get copyWith => __$ErrorResponseModelCopyWithImpl<_ErrorResponseModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ErrorResponseModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ErrorResponseModel&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'ErrorResponseModel(error: $error)';
}


}

/// @nodoc
abstract mixin class _$ErrorResponseModelCopyWith<$Res> implements $ErrorResponseModelCopyWith<$Res> {
  factory _$ErrorResponseModelCopyWith(_ErrorResponseModel value, $Res Function(_ErrorResponseModel) _then) = __$ErrorResponseModelCopyWithImpl;
@override @useResult
$Res call({
 Error error
});


@override $ErrorCopyWith<$Res> get error;

}
/// @nodoc
class __$ErrorResponseModelCopyWithImpl<$Res>
    implements _$ErrorResponseModelCopyWith<$Res> {
  __$ErrorResponseModelCopyWithImpl(this._self, this._then);

  final _ErrorResponseModel _self;
  final $Res Function(_ErrorResponseModel) _then;

/// Create a copy of ErrorResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(_ErrorResponseModel(
error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as Error,
  ));
}

/// Create a copy of ErrorResponseModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ErrorCopyWith<$Res> get error {
  
  return $ErrorCopyWith<$Res>(_self.error, (value) {
    return _then(_self.copyWith(error: value));
  });
}
}


/// @nodoc
mixin _$Error {

 int get status; String get message; List<Detail>? get details;
/// Create a copy of Error
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ErrorCopyWith<Error> get copyWith => _$ErrorCopyWithImpl<Error>(this as Error, _$identity);

  /// Serializes this Error to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Error&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.details, details));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,message,const DeepCollectionEquality().hash(details));

@override
String toString() {
  return 'Error(status: $status, message: $message, details: $details)';
}


}

/// @nodoc
abstract mixin class $ErrorCopyWith<$Res>  {
  factory $ErrorCopyWith(Error value, $Res Function(Error) _then) = _$ErrorCopyWithImpl;
@useResult
$Res call({
 int status, String message, List<Detail>? details
});




}
/// @nodoc
class _$ErrorCopyWithImpl<$Res>
    implements $ErrorCopyWith<$Res> {
  _$ErrorCopyWithImpl(this._self, this._then);

  final Error _self;
  final $Res Function(Error) _then;

/// Create a copy of Error
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? message = null,Object? details = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as List<Detail>?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _Error implements Error {
  const _Error({required this.status, required this.message, final  List<Detail>? details}): _details = details;
  factory _Error.fromJson(Map<String, dynamic> json) => _$ErrorFromJson(json);

@override final  int status;
@override final  String message;
 final  List<Detail>? _details;
@override List<Detail>? get details {
  final value = _details;
  if (value == null) return null;
  if (_details is EqualUnmodifiableListView) return _details;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of Error
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ErrorToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other._details, _details));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,message,const DeepCollectionEquality().hash(_details));

@override
String toString() {
  return 'Error(status: $status, message: $message, details: $details)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $ErrorCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@override @useResult
$Res call({
 int status, String message, List<Detail>? details
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of Error
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? message = null,Object? details = freezed,}) {
  return _then(_Error(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,details: freezed == details ? _self._details : details // ignore: cast_nullable_to_non_nullable
as List<Detail>?,
  ));
}


}


/// @nodoc
mixin _$Detail {

 String get field; String get message;
/// Create a copy of Detail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DetailCopyWith<Detail> get copyWith => _$DetailCopyWithImpl<Detail>(this as Detail, _$identity);

  /// Serializes this Detail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Detail&&(identical(other.field, field) || other.field == field)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,field,message);

@override
String toString() {
  return 'Detail(field: $field, message: $message)';
}


}

/// @nodoc
abstract mixin class $DetailCopyWith<$Res>  {
  factory $DetailCopyWith(Detail value, $Res Function(Detail) _then) = _$DetailCopyWithImpl;
@useResult
$Res call({
 String field, String message
});




}
/// @nodoc
class _$DetailCopyWithImpl<$Res>
    implements $DetailCopyWith<$Res> {
  _$DetailCopyWithImpl(this._self, this._then);

  final Detail _self;
  final $Res Function(Detail) _then;

/// Create a copy of Detail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? field = null,Object? message = null,}) {
  return _then(_self.copyWith(
field: null == field ? _self.field : field // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _Detail implements Detail {
  const _Detail({required this.field, required this.message});
  factory _Detail.fromJson(Map<String, dynamic> json) => _$DetailFromJson(json);

@override final  String field;
@override final  String message;

/// Create a copy of Detail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DetailCopyWith<_Detail> get copyWith => __$DetailCopyWithImpl<_Detail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Detail&&(identical(other.field, field) || other.field == field)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,field,message);

@override
String toString() {
  return 'Detail(field: $field, message: $message)';
}


}

/// @nodoc
abstract mixin class _$DetailCopyWith<$Res> implements $DetailCopyWith<$Res> {
  factory _$DetailCopyWith(_Detail value, $Res Function(_Detail) _then) = __$DetailCopyWithImpl;
@override @useResult
$Res call({
 String field, String message
});




}
/// @nodoc
class __$DetailCopyWithImpl<$Res>
    implements _$DetailCopyWith<$Res> {
  __$DetailCopyWithImpl(this._self, this._then);

  final _Detail _self;
  final $Res Function(_Detail) _then;

/// Create a copy of Detail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? field = null,Object? message = null,}) {
  return _then(_Detail(
field: null == field ? _self.field : field // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on

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

 ErrorModel get error;
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
 ErrorModel error
});


$ErrorModelCopyWith<$Res> get error;

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
as ErrorModel,
  ));
}
/// Create a copy of ErrorResponseModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ErrorModelCopyWith<$Res> get error {
  
  return $ErrorModelCopyWith<$Res>(_self.error, (value) {
    return _then(_self.copyWith(error: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _ErrorResponseModel implements ErrorResponseModel {
  const _ErrorResponseModel({required this.error});
  factory _ErrorResponseModel.fromJson(Map<String, dynamic> json) => _$ErrorResponseModelFromJson(json);

@override final  ErrorModel error;

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
 ErrorModel error
});


@override $ErrorModelCopyWith<$Res> get error;

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
as ErrorModel,
  ));
}

/// Create a copy of ErrorResponseModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ErrorModelCopyWith<$Res> get error {
  
  return $ErrorModelCopyWith<$Res>(_self.error, (value) {
    return _then(_self.copyWith(error: value));
  });
}
}


/// @nodoc
mixin _$ErrorModel {

 int get status; String get message; List<ErrorDetail>? get details;
/// Create a copy of ErrorModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ErrorModelCopyWith<ErrorModel> get copyWith => _$ErrorModelCopyWithImpl<ErrorModel>(this as ErrorModel, _$identity);

  /// Serializes this ErrorModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ErrorModel&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.details, details));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,message,const DeepCollectionEquality().hash(details));

@override
String toString() {
  return 'ErrorModel(status: $status, message: $message, details: $details)';
}


}

/// @nodoc
abstract mixin class $ErrorModelCopyWith<$Res>  {
  factory $ErrorModelCopyWith(ErrorModel value, $Res Function(ErrorModel) _then) = _$ErrorModelCopyWithImpl;
@useResult
$Res call({
 int status, String message, List<ErrorDetail>? details
});




}
/// @nodoc
class _$ErrorModelCopyWithImpl<$Res>
    implements $ErrorModelCopyWith<$Res> {
  _$ErrorModelCopyWithImpl(this._self, this._then);

  final ErrorModel _self;
  final $Res Function(ErrorModel) _then;

/// Create a copy of ErrorModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? message = null,Object? details = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as List<ErrorDetail>?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _ErrorModel implements ErrorModel {
  const _ErrorModel({required this.status, required this.message, final  List<ErrorDetail>? details}): _details = details;
  factory _ErrorModel.fromJson(Map<String, dynamic> json) => _$ErrorModelFromJson(json);

@override final  int status;
@override final  String message;
 final  List<ErrorDetail>? _details;
@override List<ErrorDetail>? get details {
  final value = _details;
  if (value == null) return null;
  if (_details is EqualUnmodifiableListView) return _details;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of ErrorModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorModelCopyWith<_ErrorModel> get copyWith => __$ErrorModelCopyWithImpl<_ErrorModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ErrorModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ErrorModel&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other._details, _details));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,message,const DeepCollectionEquality().hash(_details));

@override
String toString() {
  return 'ErrorModel(status: $status, message: $message, details: $details)';
}


}

/// @nodoc
abstract mixin class _$ErrorModelCopyWith<$Res> implements $ErrorModelCopyWith<$Res> {
  factory _$ErrorModelCopyWith(_ErrorModel value, $Res Function(_ErrorModel) _then) = __$ErrorModelCopyWithImpl;
@override @useResult
$Res call({
 int status, String message, List<ErrorDetail>? details
});




}
/// @nodoc
class __$ErrorModelCopyWithImpl<$Res>
    implements _$ErrorModelCopyWith<$Res> {
  __$ErrorModelCopyWithImpl(this._self, this._then);

  final _ErrorModel _self;
  final $Res Function(_ErrorModel) _then;

/// Create a copy of ErrorModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? message = null,Object? details = freezed,}) {
  return _then(_ErrorModel(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,details: freezed == details ? _self._details : details // ignore: cast_nullable_to_non_nullable
as List<ErrorDetail>?,
  ));
}


}


/// @nodoc
mixin _$ErrorDetail {

 String get field; String get message;
/// Create a copy of ErrorDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ErrorDetailCopyWith<ErrorDetail> get copyWith => _$ErrorDetailCopyWithImpl<ErrorDetail>(this as ErrorDetail, _$identity);

  /// Serializes this ErrorDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ErrorDetail&&(identical(other.field, field) || other.field == field)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,field,message);

@override
String toString() {
  return 'ErrorDetail(field: $field, message: $message)';
}


}

/// @nodoc
abstract mixin class $ErrorDetailCopyWith<$Res>  {
  factory $ErrorDetailCopyWith(ErrorDetail value, $Res Function(ErrorDetail) _then) = _$ErrorDetailCopyWithImpl;
@useResult
$Res call({
 String field, String message
});




}
/// @nodoc
class _$ErrorDetailCopyWithImpl<$Res>
    implements $ErrorDetailCopyWith<$Res> {
  _$ErrorDetailCopyWithImpl(this._self, this._then);

  final ErrorDetail _self;
  final $Res Function(ErrorDetail) _then;

/// Create a copy of ErrorDetail
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

class _ErrorDetail implements ErrorDetail {
  const _ErrorDetail({required this.field, required this.message});
  factory _ErrorDetail.fromJson(Map<String, dynamic> json) => _$ErrorDetailFromJson(json);

@override final  String field;
@override final  String message;

/// Create a copy of ErrorDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorDetailCopyWith<_ErrorDetail> get copyWith => __$ErrorDetailCopyWithImpl<_ErrorDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ErrorDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ErrorDetail&&(identical(other.field, field) || other.field == field)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,field,message);

@override
String toString() {
  return 'ErrorDetail(field: $field, message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorDetailCopyWith<$Res> implements $ErrorDetailCopyWith<$Res> {
  factory _$ErrorDetailCopyWith(_ErrorDetail value, $Res Function(_ErrorDetail) _then) = __$ErrorDetailCopyWithImpl;
@override @useResult
$Res call({
 String field, String message
});




}
/// @nodoc
class __$ErrorDetailCopyWithImpl<$Res>
    implements _$ErrorDetailCopyWith<$Res> {
  __$ErrorDetailCopyWithImpl(this._self, this._then);

  final _ErrorDetail _self;
  final $Res Function(_ErrorDetail) _then;

/// Create a copy of ErrorDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? field = null,Object? message = null,}) {
  return _then(_ErrorDetail(
field: null == field ? _self.field : field // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on

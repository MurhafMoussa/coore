// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'core_pagination_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CorePaginationState<T> implements DiagnosticableTreeMixin {




@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'CorePaginationState<$T>'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CorePaginationState<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'CorePaginationState<$T>()';
}


}

/// @nodoc
class $CorePaginationStateCopyWith<T,$Res>  {
$CorePaginationStateCopyWith(CorePaginationState<T> _, $Res Function(CorePaginationState<T>) __);
}


/// @nodoc


class PaginationInitial<T> extends CorePaginationState<T> with DiagnosticableTreeMixin {
  const PaginationInitial(): super._();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'CorePaginationState<$T>.initial'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaginationInitial<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'CorePaginationState<$T>.initial()';
}


}




/// @nodoc


class PaginationLoading<T> extends CorePaginationState<T> with DiagnosticableTreeMixin {
  const PaginationLoading(): super._();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'CorePaginationState<$T>.loading'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaginationLoading<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'CorePaginationState<$T>.loading()';
}


}




/// @nodoc


class PaginationSucceeded<T> extends CorePaginationState<T> with DiagnosticableTreeMixin {
  const PaginationSucceeded({required final  List<T> items, required this.hasReachedMax}): _items = items,super._();
  

 final  List<T> _items;
 List<T> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

 final  bool hasReachedMax;

/// Create a copy of CorePaginationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaginationSucceededCopyWith<T, PaginationSucceeded<T>> get copyWith => _$PaginationSucceededCopyWithImpl<T, PaginationSucceeded<T>>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'CorePaginationState<$T>.succeeded'))
    ..add(DiagnosticsProperty('items', items))..add(DiagnosticsProperty('hasReachedMax', hasReachedMax));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaginationSucceeded<T>&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.hasReachedMax, hasReachedMax) || other.hasReachedMax == hasReachedMax));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),hasReachedMax);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'CorePaginationState<$T>.succeeded(items: $items, hasReachedMax: $hasReachedMax)';
}


}

/// @nodoc
abstract mixin class $PaginationSucceededCopyWith<T,$Res> implements $CorePaginationStateCopyWith<T, $Res> {
  factory $PaginationSucceededCopyWith(PaginationSucceeded<T> value, $Res Function(PaginationSucceeded<T>) _then) = _$PaginationSucceededCopyWithImpl;
@useResult
$Res call({
 List<T> items, bool hasReachedMax
});




}
/// @nodoc
class _$PaginationSucceededCopyWithImpl<T,$Res>
    implements $PaginationSucceededCopyWith<T, $Res> {
  _$PaginationSucceededCopyWithImpl(this._self, this._then);

  final PaginationSucceeded<T> _self;
  final $Res Function(PaginationSucceeded<T>) _then;

/// Create a copy of CorePaginationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? items = null,Object? hasReachedMax = null,}) {
  return _then(PaginationSucceeded<T>(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<T>,hasReachedMax: null == hasReachedMax ? _self.hasReachedMax : hasReachedMax // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class PaginationRetryFailure<T> extends CorePaginationState<T> with DiagnosticableTreeMixin {
  const PaginationRetryFailure({required this.failure, required final  List<T> items}): _items = items,super._();
  

 final  Failure failure;
 final  List<T> _items;
 List<T> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of CorePaginationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaginationRetryFailureCopyWith<T, PaginationRetryFailure<T>> get copyWith => _$PaginationRetryFailureCopyWithImpl<T, PaginationRetryFailure<T>>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'CorePaginationState<$T>.retryFailure'))
    ..add(DiagnosticsProperty('failure', failure))..add(DiagnosticsProperty('items', items));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaginationRetryFailure<T>&&(identical(other.failure, failure) || other.failure == failure)&&const DeepCollectionEquality().equals(other._items, _items));
}


@override
int get hashCode => Object.hash(runtimeType,failure,const DeepCollectionEquality().hash(_items));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'CorePaginationState<$T>.retryFailure(failure: $failure, items: $items)';
}


}

/// @nodoc
abstract mixin class $PaginationRetryFailureCopyWith<T,$Res> implements $CorePaginationStateCopyWith<T, $Res> {
  factory $PaginationRetryFailureCopyWith(PaginationRetryFailure<T> value, $Res Function(PaginationRetryFailure<T>) _then) = _$PaginationRetryFailureCopyWithImpl;
@useResult
$Res call({
 Failure failure, List<T> items
});




}
/// @nodoc
class _$PaginationRetryFailureCopyWithImpl<T,$Res>
    implements $PaginationRetryFailureCopyWith<T, $Res> {
  _$PaginationRetryFailureCopyWithImpl(this._self, this._then);

  final PaginationRetryFailure<T> _self;
  final $Res Function(PaginationRetryFailure<T>) _then;

/// Create a copy of CorePaginationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,Object? items = null,}) {
  return _then(PaginationRetryFailure<T>(
failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<T>,
  ));
}


}

/// @nodoc


class PaginationFailed<T> extends CorePaginationState<T> with DiagnosticableTreeMixin {
  const PaginationFailed({required this.failure, required final  List<T> items, this.retryFunction}): _items = items,super._();
  

 final  Failure failure;
 final  List<T> _items;
 List<T> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

 final  VoidCallback? retryFunction;

/// Create a copy of CorePaginationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaginationFailedCopyWith<T, PaginationFailed<T>> get copyWith => _$PaginationFailedCopyWithImpl<T, PaginationFailed<T>>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'CorePaginationState<$T>.failed'))
    ..add(DiagnosticsProperty('failure', failure))..add(DiagnosticsProperty('items', items))..add(DiagnosticsProperty('retryFunction', retryFunction));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaginationFailed<T>&&(identical(other.failure, failure) || other.failure == failure)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.retryFunction, retryFunction) || other.retryFunction == retryFunction));
}


@override
int get hashCode => Object.hash(runtimeType,failure,const DeepCollectionEquality().hash(_items),retryFunction);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'CorePaginationState<$T>.failed(failure: $failure, items: $items, retryFunction: $retryFunction)';
}


}

/// @nodoc
abstract mixin class $PaginationFailedCopyWith<T,$Res> implements $CorePaginationStateCopyWith<T, $Res> {
  factory $PaginationFailedCopyWith(PaginationFailed<T> value, $Res Function(PaginationFailed<T>) _then) = _$PaginationFailedCopyWithImpl;
@useResult
$Res call({
 Failure failure, List<T> items, VoidCallback? retryFunction
});




}
/// @nodoc
class _$PaginationFailedCopyWithImpl<T,$Res>
    implements $PaginationFailedCopyWith<T, $Res> {
  _$PaginationFailedCopyWithImpl(this._self, this._then);

  final PaginationFailed<T> _self;
  final $Res Function(PaginationFailed<T>) _then;

/// Create a copy of CorePaginationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,Object? items = null,Object? retryFunction = freezed,}) {
  return _then(PaginationFailed<T>(
failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<T>,retryFunction: freezed == retryFunction ? _self.retryFunction : retryFunction // ignore: cast_nullable_to_non_nullable
as VoidCallback?,
  ));
}


}

// dart format on

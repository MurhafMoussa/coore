// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'core_pagination_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CorePaginationState<T extends Identifiable,M extends MetaModel> implements DiagnosticableTreeMixin {




@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'CorePaginationState<$T, $M>'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CorePaginationState<T, M>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'CorePaginationState<$T, $M>()';
}


}

/// @nodoc
class $CorePaginationStateCopyWith<T extends Identifiable,M extends MetaModel,$Res>  {
$CorePaginationStateCopyWith(CorePaginationState<T, M> _, $Res Function(CorePaginationState<T, M>) __);
}


/// Adds pattern-matching-related methods to [CorePaginationState].
extension CorePaginationStatePatterns<T extends Identifiable,M extends MetaModel> on CorePaginationState<T, M> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PaginationInitial<T, M> value)?  initial,TResult Function( PaginationLoading<T, M> value)?  loading,TResult Function( PaginationSucceeded<T, M> value)?  succeeded,TResult Function( PaginationRetryFailure<T, M> value)?  retryFailure,TResult Function( PaginationFailed<T, M> value)?  failed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PaginationInitial() when initial != null:
return initial(_that);case PaginationLoading() when loading != null:
return loading(_that);case PaginationSucceeded() when succeeded != null:
return succeeded(_that);case PaginationRetryFailure() when retryFailure != null:
return retryFailure(_that);case PaginationFailed() when failed != null:
return failed(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PaginationInitial<T, M> value)  initial,required TResult Function( PaginationLoading<T, M> value)  loading,required TResult Function( PaginationSucceeded<T, M> value)  succeeded,required TResult Function( PaginationRetryFailure<T, M> value)  retryFailure,required TResult Function( PaginationFailed<T, M> value)  failed,}){
final _that = this;
switch (_that) {
case PaginationInitial():
return initial(_that);case PaginationLoading():
return loading(_that);case PaginationSucceeded():
return succeeded(_that);case PaginationRetryFailure():
return retryFailure(_that);case PaginationFailed():
return failed(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PaginationInitial<T, M> value)?  initial,TResult? Function( PaginationLoading<T, M> value)?  loading,TResult? Function( PaginationSucceeded<T, M> value)?  succeeded,TResult? Function( PaginationRetryFailure<T, M> value)?  retryFailure,TResult? Function( PaginationFailed<T, M> value)?  failed,}){
final _that = this;
switch (_that) {
case PaginationInitial() when initial != null:
return initial(_that);case PaginationLoading() when loading != null:
return loading(_that);case PaginationSucceeded() when succeeded != null:
return succeeded(_that);case PaginationRetryFailure() when retryFailure != null:
return retryFailure(_that);case PaginationFailed() when failed != null:
return failed(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( PaginationResponseModel<T, M> paginatedResponseModel,  bool hasReachedMax)?  succeeded,TResult Function( Failure failure,  PaginationResponseModel<T, M> paginatedResponseModel)?  retryFailure,TResult Function( Failure failure,  PaginationResponseModel<T, M> paginatedResponseModel,  VoidCallback? retryFunction)?  failed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PaginationInitial() when initial != null:
return initial();case PaginationLoading() when loading != null:
return loading();case PaginationSucceeded() when succeeded != null:
return succeeded(_that.paginatedResponseModel,_that.hasReachedMax);case PaginationRetryFailure() when retryFailure != null:
return retryFailure(_that.failure,_that.paginatedResponseModel);case PaginationFailed() when failed != null:
return failed(_that.failure,_that.paginatedResponseModel,_that.retryFunction);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( PaginationResponseModel<T, M> paginatedResponseModel,  bool hasReachedMax)  succeeded,required TResult Function( Failure failure,  PaginationResponseModel<T, M> paginatedResponseModel)  retryFailure,required TResult Function( Failure failure,  PaginationResponseModel<T, M> paginatedResponseModel,  VoidCallback? retryFunction)  failed,}) {final _that = this;
switch (_that) {
case PaginationInitial():
return initial();case PaginationLoading():
return loading();case PaginationSucceeded():
return succeeded(_that.paginatedResponseModel,_that.hasReachedMax);case PaginationRetryFailure():
return retryFailure(_that.failure,_that.paginatedResponseModel);case PaginationFailed():
return failed(_that.failure,_that.paginatedResponseModel,_that.retryFunction);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( PaginationResponseModel<T, M> paginatedResponseModel,  bool hasReachedMax)?  succeeded,TResult? Function( Failure failure,  PaginationResponseModel<T, M> paginatedResponseModel)?  retryFailure,TResult? Function( Failure failure,  PaginationResponseModel<T, M> paginatedResponseModel,  VoidCallback? retryFunction)?  failed,}) {final _that = this;
switch (_that) {
case PaginationInitial() when initial != null:
return initial();case PaginationLoading() when loading != null:
return loading();case PaginationSucceeded() when succeeded != null:
return succeeded(_that.paginatedResponseModel,_that.hasReachedMax);case PaginationRetryFailure() when retryFailure != null:
return retryFailure(_that.failure,_that.paginatedResponseModel);case PaginationFailed() when failed != null:
return failed(_that.failure,_that.paginatedResponseModel,_that.retryFunction);case _:
  return null;

}
}

}

/// @nodoc


class PaginationInitial<T extends Identifiable,M extends MetaModel> extends CorePaginationState<T, M> with DiagnosticableTreeMixin {
  const PaginationInitial(): super._();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'CorePaginationState<$T, $M>.initial'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaginationInitial<T, M>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'CorePaginationState<$T, $M>.initial()';
}


}




/// @nodoc


class PaginationLoading<T extends Identifiable,M extends MetaModel> extends CorePaginationState<T, M> with DiagnosticableTreeMixin {
  const PaginationLoading(): super._();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'CorePaginationState<$T, $M>.loading'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaginationLoading<T, M>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'CorePaginationState<$T, $M>.loading()';
}


}




/// @nodoc


class PaginationSucceeded<T extends Identifiable,M extends MetaModel> extends CorePaginationState<T, M> with DiagnosticableTreeMixin {
  const PaginationSucceeded({required this.paginatedResponseModel, required this.hasReachedMax}): super._();
  

 final  PaginationResponseModel<T, M> paginatedResponseModel;
 final  bool hasReachedMax;

/// Create a copy of CorePaginationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaginationSucceededCopyWith<T, M, PaginationSucceeded<T, M>> get copyWith => _$PaginationSucceededCopyWithImpl<T, M, PaginationSucceeded<T, M>>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'CorePaginationState<$T, $M>.succeeded'))
    ..add(DiagnosticsProperty('paginatedResponseModel', paginatedResponseModel))..add(DiagnosticsProperty('hasReachedMax', hasReachedMax));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaginationSucceeded<T, M>&&(identical(other.paginatedResponseModel, paginatedResponseModel) || other.paginatedResponseModel == paginatedResponseModel)&&(identical(other.hasReachedMax, hasReachedMax) || other.hasReachedMax == hasReachedMax));
}


@override
int get hashCode => Object.hash(runtimeType,paginatedResponseModel,hasReachedMax);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'CorePaginationState<$T, $M>.succeeded(paginatedResponseModel: $paginatedResponseModel, hasReachedMax: $hasReachedMax)';
}


}

/// @nodoc
abstract mixin class $PaginationSucceededCopyWith<T extends Identifiable,M extends MetaModel,$Res> implements $CorePaginationStateCopyWith<T, M, $Res> {
  factory $PaginationSucceededCopyWith(PaginationSucceeded<T, M> value, $Res Function(PaginationSucceeded<T, M>) _then) = _$PaginationSucceededCopyWithImpl;
@useResult
$Res call({
 PaginationResponseModel<T, M> paginatedResponseModel, bool hasReachedMax
});


$PaginationResponseModelCopyWith<T, M, $Res> get paginatedResponseModel;

}
/// @nodoc
class _$PaginationSucceededCopyWithImpl<T extends Identifiable,M extends MetaModel,$Res>
    implements $PaginationSucceededCopyWith<T, M, $Res> {
  _$PaginationSucceededCopyWithImpl(this._self, this._then);

  final PaginationSucceeded<T, M> _self;
  final $Res Function(PaginationSucceeded<T, M>) _then;

/// Create a copy of CorePaginationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? paginatedResponseModel = null,Object? hasReachedMax = null,}) {
  return _then(PaginationSucceeded<T, M>(
paginatedResponseModel: null == paginatedResponseModel ? _self.paginatedResponseModel : paginatedResponseModel // ignore: cast_nullable_to_non_nullable
as PaginationResponseModel<T, M>,hasReachedMax: null == hasReachedMax ? _self.hasReachedMax : hasReachedMax // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of CorePaginationState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaginationResponseModelCopyWith<T, M, $Res> get paginatedResponseModel {
  
  return $PaginationResponseModelCopyWith<T, M, $Res>(_self.paginatedResponseModel, (value) {
    return _then(_self.copyWith(paginatedResponseModel: value));
  });
}
}

/// @nodoc


class PaginationRetryFailure<T extends Identifiable,M extends MetaModel> extends CorePaginationState<T, M> with DiagnosticableTreeMixin {
  const PaginationRetryFailure({required this.failure, required this.paginatedResponseModel}): super._();
  

 final  Failure failure;
 final  PaginationResponseModel<T, M> paginatedResponseModel;

/// Create a copy of CorePaginationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaginationRetryFailureCopyWith<T, M, PaginationRetryFailure<T, M>> get copyWith => _$PaginationRetryFailureCopyWithImpl<T, M, PaginationRetryFailure<T, M>>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'CorePaginationState<$T, $M>.retryFailure'))
    ..add(DiagnosticsProperty('failure', failure))..add(DiagnosticsProperty('paginatedResponseModel', paginatedResponseModel));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaginationRetryFailure<T, M>&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.paginatedResponseModel, paginatedResponseModel) || other.paginatedResponseModel == paginatedResponseModel));
}


@override
int get hashCode => Object.hash(runtimeType,failure,paginatedResponseModel);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'CorePaginationState<$T, $M>.retryFailure(failure: $failure, paginatedResponseModel: $paginatedResponseModel)';
}


}

/// @nodoc
abstract mixin class $PaginationRetryFailureCopyWith<T extends Identifiable,M extends MetaModel,$Res> implements $CorePaginationStateCopyWith<T, M, $Res> {
  factory $PaginationRetryFailureCopyWith(PaginationRetryFailure<T, M> value, $Res Function(PaginationRetryFailure<T, M>) _then) = _$PaginationRetryFailureCopyWithImpl;
@useResult
$Res call({
 Failure failure, PaginationResponseModel<T, M> paginatedResponseModel
});


$PaginationResponseModelCopyWith<T, M, $Res> get paginatedResponseModel;

}
/// @nodoc
class _$PaginationRetryFailureCopyWithImpl<T extends Identifiable,M extends MetaModel,$Res>
    implements $PaginationRetryFailureCopyWith<T, M, $Res> {
  _$PaginationRetryFailureCopyWithImpl(this._self, this._then);

  final PaginationRetryFailure<T, M> _self;
  final $Res Function(PaginationRetryFailure<T, M>) _then;

/// Create a copy of CorePaginationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,Object? paginatedResponseModel = null,}) {
  return _then(PaginationRetryFailure<T, M>(
failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,paginatedResponseModel: null == paginatedResponseModel ? _self.paginatedResponseModel : paginatedResponseModel // ignore: cast_nullable_to_non_nullable
as PaginationResponseModel<T, M>,
  ));
}

/// Create a copy of CorePaginationState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaginationResponseModelCopyWith<T, M, $Res> get paginatedResponseModel {
  
  return $PaginationResponseModelCopyWith<T, M, $Res>(_self.paginatedResponseModel, (value) {
    return _then(_self.copyWith(paginatedResponseModel: value));
  });
}
}

/// @nodoc


class PaginationFailed<T extends Identifiable,M extends MetaModel> extends CorePaginationState<T, M> with DiagnosticableTreeMixin {
  const PaginationFailed({required this.failure, required this.paginatedResponseModel, this.retryFunction}): super._();
  

 final  Failure failure;
 final  PaginationResponseModel<T, M> paginatedResponseModel;
 final  VoidCallback? retryFunction;

/// Create a copy of CorePaginationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaginationFailedCopyWith<T, M, PaginationFailed<T, M>> get copyWith => _$PaginationFailedCopyWithImpl<T, M, PaginationFailed<T, M>>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'CorePaginationState<$T, $M>.failed'))
    ..add(DiagnosticsProperty('failure', failure))..add(DiagnosticsProperty('paginatedResponseModel', paginatedResponseModel))..add(DiagnosticsProperty('retryFunction', retryFunction));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaginationFailed<T, M>&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.paginatedResponseModel, paginatedResponseModel) || other.paginatedResponseModel == paginatedResponseModel)&&(identical(other.retryFunction, retryFunction) || other.retryFunction == retryFunction));
}


@override
int get hashCode => Object.hash(runtimeType,failure,paginatedResponseModel,retryFunction);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'CorePaginationState<$T, $M>.failed(failure: $failure, paginatedResponseModel: $paginatedResponseModel, retryFunction: $retryFunction)';
}


}

/// @nodoc
abstract mixin class $PaginationFailedCopyWith<T extends Identifiable,M extends MetaModel,$Res> implements $CorePaginationStateCopyWith<T, M, $Res> {
  factory $PaginationFailedCopyWith(PaginationFailed<T, M> value, $Res Function(PaginationFailed<T, M>) _then) = _$PaginationFailedCopyWithImpl;
@useResult
$Res call({
 Failure failure, PaginationResponseModel<T, M> paginatedResponseModel, VoidCallback? retryFunction
});


$PaginationResponseModelCopyWith<T, M, $Res> get paginatedResponseModel;

}
/// @nodoc
class _$PaginationFailedCopyWithImpl<T extends Identifiable,M extends MetaModel,$Res>
    implements $PaginationFailedCopyWith<T, M, $Res> {
  _$PaginationFailedCopyWithImpl(this._self, this._then);

  final PaginationFailed<T, M> _self;
  final $Res Function(PaginationFailed<T, M>) _then;

/// Create a copy of CorePaginationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,Object? paginatedResponseModel = null,Object? retryFunction = freezed,}) {
  return _then(PaginationFailed<T, M>(
failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,paginatedResponseModel: null == paginatedResponseModel ? _self.paginatedResponseModel : paginatedResponseModel // ignore: cast_nullable_to_non_nullable
as PaginationResponseModel<T, M>,retryFunction: freezed == retryFunction ? _self.retryFunction : retryFunction // ignore: cast_nullable_to_non_nullable
as VoidCallback?,
  ));
}

/// Create a copy of CorePaginationState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaginationResponseModelCopyWith<T, M, $Res> get paginatedResponseModel {
  
  return $PaginationResponseModelCopyWith<T, M, $Res>(_self.paginatedResponseModel, (value) {
    return _then(_self.copyWith(paginatedResponseModel: value));
  });
}
}

// dart format on

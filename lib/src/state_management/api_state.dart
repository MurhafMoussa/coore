import 'package:coore/src/error_handling/failures/failure.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_state.freezed.dart';

@freezed
abstract class ApiState<T> with _$ApiState<T> {
  const ApiState._();

  const factory ApiState.initial() = _Initial;

  const factory ApiState.loading() = _Loading;

  const factory ApiState.success(T successValue) = _Success;

  const factory ApiState.failure(
    Failure failure, {
    VoidCallback? retryFunction,
  }) = _Failure;

  bool get isLoading => this is _Loading;
}

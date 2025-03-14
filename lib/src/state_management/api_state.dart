import 'package:coore/src/error_handling/failures/failure.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_state.freezed.dart';

@freezed
sealed class ApiState<T> with _$ApiState<T> {
  const ApiState._();

  const factory ApiState.initial() = Initial;

  const factory ApiState.loading() = Loading;

  const factory ApiState.succeeded(T successValue) = Succeeded;

  const factory ApiState.failed(
    Failure failure, {
    VoidCallback? retryFunction,
  }) = Failed;
  bool get isInitial => this is Initial<T>;
  bool get isLoading => this is Loading<T>;
  bool get isSuccess => this is Succeeded<T>;
  bool get isFailed => this is Failed<T>;
  Option<T> get data => switch (this) {
    Succeeded<T>(:final successValue) => some(successValue),
    _ => none(),
  };
  Option<Failure> get failureObject => switch (this) {
    Failed(:final failure) => some(failure),
    _ => none(),
  };
}

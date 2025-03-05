import 'package:coore/src/error_handling/failures/failure.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_state.freezed.dart';

@freezed
sealed class ApiState<T> with _$ApiState<T> {
  const ApiState._();

  const factory ApiState.initial() = Initial;

  const factory ApiState.loading() = Loading;

  const factory ApiState.success(T successValue) = Success;

  const factory ApiState.failure(
    Failure failure, {
    VoidCallback? retryFunction,
  }) = Failure;
  bool get isInitial => this is Initial<T>;
  bool get isLoading => this is Loading<T>;
  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;
  Option<T> get data => switch (this) {
    Success<T>(:final successValue) => some(successValue),
    _ => none(),
  };
  Option<Failure> get failureObject => switch (this) {
    Failure(:final failure) => some(failure),
    _ => none(),
  };
}

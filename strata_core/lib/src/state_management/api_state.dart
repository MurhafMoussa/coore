import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../error_handling/failures/failure.dart';

/// Pure functional API state representation for async workflows.
sealed class ApiState<T> extends Equatable {
  const ApiState();

  const factory ApiState.initial() = ApiStateInitial<T>;

  const factory ApiState.loading() = ApiStateLoading<T>;

  const factory ApiState.success(T data) = ApiStateSuccess<T>;

  const factory ApiState.failure(
    Failure failure, {
    void Function()? retryFunction,
  }) = ApiStateFailure<T>;

  bool get isInitial => this is ApiStateInitial<T>;
  bool get isLoading => this is ApiStateLoading<T>;
  bool get isSuccess => this is ApiStateSuccess<T>;
  bool get isFailure => this is ApiStateFailure<T>;

  Option<T> get data => switch (this) {
        ApiStateSuccess<T>(:final value) => some(value),
        _ => none(),
      };

  T? get dataOrNull => data.toNullable();

  Option<Failure> get failureObject => switch (this) {
        ApiStateFailure<T>(:final failure) => some(failure),
        _ => none(),
      };

  Failure? get failureOrNull => failureObject.toNullable();

  void Function()? get retryFunction => switch (this) {
        ApiStateFailure<T>(:final retryFunction) => retryFunction,
        _ => null,
      };

  /// Pattern matching helper
  R when<R>({
    required R Function() initial,
    required R Function() loading,
    required R Function(T data) success,
    required R Function(Failure failure, void Function()? retryFunction)
        failure,
  }) {
    final failureCb = failure;
    return switch (this) {
      ApiStateInitial<T>() => initial(),
      ApiStateLoading<T>() => loading(),
      ApiStateSuccess<T>(:final value) => success(value),
      ApiStateFailure<T>(failure: final f, retryFunction: final r) =>
        failureCb(f, r),
    };
  }

  /// Optional pattern matching helper
  R maybeWhen<R>({
    required R Function() orElse,
    R Function()? initial,
    R Function()? loading,
    R Function(T data)? success,
    R Function(Failure failure, void Function()? retryFunction)? failure,
  }) {
    final failureCb = failure;
    return switch (this) {
      ApiStateInitial<T>() => initial != null ? initial() : orElse(),
      ApiStateLoading<T>() => loading != null ? loading() : orElse(),
      ApiStateSuccess<T>(:final value) =>
        success != null ? success(value) : orElse(),
      ApiStateFailure<T>(failure: final f, retryFunction: final r) =>
        failureCb != null ? failureCb(f, r) : orElse(),
    };
  }
}

/// Initial state before any request has started.
final class ApiStateInitial<T> extends ApiState<T> {
  const ApiStateInitial();

  @override
  List<Object?> get props => [];
}

/// Loading state while the async request is executing.
final class ApiStateLoading<T> extends ApiState<T> {
  const ApiStateLoading();

  @override
  List<Object?> get props => [];
}

/// Success state containing the result [value].
final class ApiStateSuccess<T> extends ApiState<T> {
  const ApiStateSuccess(this.value);

  final T value;

  @override
  List<Object?> get props => [value];
}

/// Failure state containing the [failure] and optional [retryFunction].
final class ApiStateFailure<T> extends ApiState<T> {
  const ApiStateFailure(this.failure, {this.retryFunction});

  final Failure failure;
  @override
  final void Function()? retryFunction;

  @override
  List<Object?> get props => [failure, retryFunction];
}

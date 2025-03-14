part of 'core_pagination_cubit.dart';

@freezed
abstract class CorePaginationState<T> with _$CorePaginationState<T> {
  const CorePaginationState._();
  const factory CorePaginationState.initial() = PaginationInitial;

  const factory CorePaginationState.loading() = PaginationLoading;

  const factory CorePaginationState.succeeded({
    required List<T> items,
    required bool hasReachedMax,
  }) = PaginationSucceeded<T>;
  const factory CorePaginationState.retryFailure({
    required Failure failure,
    required List<T> items,
  }) = PaginationRetryFailure<T>;
  const factory CorePaginationState.failed({
    required Failure failure,
    required List<T> items,
    VoidCallback? retryFunction,
  }) = PaginationFailed<T>;
  List<T> get items => switch (this) {
    PaginationSucceeded(:final items) => items,
    PaginationFailed(:final items) => items,
    _ => [],
  };
  bool get hasReachedMax => switch (this) {
    PaginationSucceeded(:final hasReachedMax) => hasReachedMax,

    _ => false,
  };
  bool get isLoading => this is PaginationLoading;
}

part of 'core_pagination_cubit.dart';

@freezed
abstract class CorePaginationState<T> with _$CorePaginationState<T> {
  const CorePaginationState._();

  const factory CorePaginationState.initial() = PaginationInitial;

  const factory CorePaginationState.loading() = PaginationLoading;

  const factory CorePaginationState.succeeded({
    required PaginationResponseModel<T> paginatedResponseModel,
    required bool hasReachedMax,
  }) = PaginationSucceeded<T>;

  const factory CorePaginationState.retryFailure({
    required Failure failure,
    required PaginationResponseModel<T> paginatedResponseModel,
  }) = PaginationRetryFailure<T>;

  const factory CorePaginationState.failed({
    required Failure failure,
    required PaginationResponseModel<T> paginatedResponseModel,
    VoidCallback? retryFunction,
  }) = PaginationFailed<T>;

  PaginationResponseModel<T> get paginatedResponseModel => switch (this) {
    PaginationSucceeded(:final paginatedResponseModel) =>
      paginatedResponseModel,
    PaginationFailed(:final paginatedResponseModel) => paginatedResponseModel,
    _ => const PaginationResponseModel(),
  };

  bool get hasReachedMax => switch (this) {
    PaginationSucceeded(:final hasReachedMax) => hasReachedMax,

    _ => false,
  };

  bool get isLoading => this is PaginationLoading;
}

part of 'core_pagination_cubit.dart';

@freezed
abstract class CorePaginationState<T extends Identifiable, M extends MetaModel>
    with _$CorePaginationState<T, M> {
  const CorePaginationState._();

  const factory CorePaginationState.initial() = PaginationInitial;

  const factory CorePaginationState.loading() = PaginationLoading;

  const factory CorePaginationState.succeeded({
    required PaginationResponseModel<T, M> paginatedResponseModel,
    required bool hasReachedMax,
  }) = PaginationSucceeded<T, M>;

  const factory CorePaginationState.retryFailure({
    required Failure failure,
    required PaginationResponseModel<T, M> paginatedResponseModel,
  }) = PaginationRetryFailure<T, M>;

  const factory CorePaginationState.failed({
    required Failure failure,
    required PaginationResponseModel<T, M> paginatedResponseModel,
    VoidCallback? retryFunction,
  }) = PaginationFailed<T, M>;

  PaginationResponseModel<T, M> get paginatedResponseModel => switch (this) {
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

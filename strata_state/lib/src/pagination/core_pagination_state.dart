import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:strata_core/strata_core.dart';

sealed class CorePaginationState<T extends Identifiable, M extends MetaModel>
    extends Equatable {
  const CorePaginationState();

  const factory CorePaginationState.initial() = PaginationInitial<T, M>;
  const factory CorePaginationState.loading() = PaginationLoading<T, M>;
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
        PaginationSucceeded<T, M>(:final paginatedResponseModel) =>
          paginatedResponseModel,
        PaginationFailed<T, M>(:final paginatedResponseModel) =>
          paginatedResponseModel,
        _ => const PaginationResponseModel(),
      };

  bool get hasReachedMax => switch (this) {
        PaginationSucceeded<T, M>(:final hasReachedMax) => hasReachedMax,
        _ => false,
      };

  bool get isLoading => this is PaginationLoading<T, M>;
}

final class const PaginationInitial<T extends Identifiable, M extends MetaModel>()
    extends CorePaginationState<T, M> {
  @override
  List<Object?> get props => [];
}

final class const PaginationLoading<T extends Identifiable, M extends MetaModel>()
    extends CorePaginationState<T, M> {
  @override
  List<Object?> get props => [];
}

final class const PaginationSucceeded<T extends Identifiable, M extends MetaModel>({
  @override required final PaginationResponseModel<T, M> paginatedResponseModel,
  @override required final bool hasReachedMax,
}) extends CorePaginationState<T, M> {
  @override
  List<Object?> get props => [paginatedResponseModel, hasReachedMax];
}

final class const PaginationRetryFailure<T extends Identifiable, M extends MetaModel>({
  required final Failure failure,
  @override required final PaginationResponseModel<T, M> paginatedResponseModel,
}) extends CorePaginationState<T, M> {
  @override
  List<Object?> get props => [failure, paginatedResponseModel];
}

final class const PaginationFailed<T extends Identifiable, M extends MetaModel>({
  required final Failure failure,
  @override required final PaginationResponseModel<T, M> paginatedResponseModel,
  final VoidCallback? retryFunction,
}) extends CorePaginationState<T, M> {
  @override
  List<Object?> get props => [failure, paginatedResponseModel, retryFunction];
}

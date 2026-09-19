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

final class PaginationInitial<T extends Identifiable, M extends MetaModel>
    extends CorePaginationState<T, M> {
  const PaginationInitial();

  @override
  List<Object?> get props => [];
}

final class PaginationLoading<T extends Identifiable, M extends MetaModel>
    extends CorePaginationState<T, M> {
  const PaginationLoading();

  @override
  List<Object?> get props => [];
}

final class PaginationSucceeded<T extends Identifiable, M extends MetaModel>
    extends CorePaginationState<T, M> {
  const PaginationSucceeded({
    required this.paginatedResponseModel,
    required this.hasReachedMax,
  });

  @override
  final PaginationResponseModel<T, M> paginatedResponseModel;
  @override
  final bool hasReachedMax;

  @override
  List<Object?> get props => [paginatedResponseModel, hasReachedMax];
}

final class PaginationRetryFailure<T extends Identifiable, M extends MetaModel>
    extends CorePaginationState<T, M> {
  const PaginationRetryFailure({
    required this.failure,
    required this.paginatedResponseModel,
  });

  final Failure failure;
  @override
  final PaginationResponseModel<T, M> paginatedResponseModel;

  @override
  List<Object?> get props => [failure, paginatedResponseModel];
}

final class PaginationFailed<T extends Identifiable, M extends MetaModel>
    extends CorePaginationState<T, M> {
  const PaginationFailed({
    required this.failure,
    required this.paginatedResponseModel,
    this.retryFunction,
  });

  final Failure failure;
  @override
  final PaginationResponseModel<T, M> paginatedResponseModel;
  final VoidCallback? retryFunction;

  @override
  List<Object?> get props => [failure, paginatedResponseModel, retryFunction];
}

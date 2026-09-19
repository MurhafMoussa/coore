import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:strata_core/strata_core.dart';

import 'core_pagination_state.dart';

/// A generic pagination cubit that handles paginated data fetching and state management.
class CorePaginationCubit<T extends Identifiable, M extends MetaModel>
    extends Cubit<CorePaginationState<T, M>> {
  CorePaginationCubit({
    required ResultFuture<PaginationResponseModel<T, M>> Function(
      int batch,
      int limit, {
      String? requestId,
    })
    paginationFunction,
    required this.paginationStrategy,
    this.reverse = false,
  })  : _paginationFunction = paginationFunction,
        super(CorePaginationState<T, M>.loading());

  ResultFuture<PaginationResponseModel<T, M>> Function(
    int batch,
    int limit, {
    String? requestId,
  })
  _paginationFunction;

  final PaginationStrategy paginationStrategy;
  final bool reverse;

  @mustCallSuper
  Future<void> fetchInitialData() async {
    if (!isClosed) _resetState();
    await _fetchNetworkData(isInitial: true);
  }

  @mustCallSuper
  Future<void> fetchMoreData() async {
    if (_shouldBlockRequest) return;
    await _fetchNetworkData(isInitial: false);
  }

  bool get _shouldBlockRequest => state.isLoading || state.hasReachedMax;

  Future<void> _fetchNetworkData({
    required bool isInitial,
    String? requestId,
  }) async {
    try {
      final result = await _paginationFunction(
        paginationStrategy.nextBatch,
        paginationStrategy.limit,
        requestId: requestId,
      );

      if (!isClosed) {
        result.fold(
          (failure) => _handleFailure(failure, isInitial),
          (paginatedResponseModel) =>
              _handleSuccess(paginatedResponseModel, isInitial),
        );
      }
    } catch (e) {
      if (!isClosed) {
        _handleFailure(UnknownFailure(message: e.toString()), isInitial);
      }
    }
  }

  void _handleFailure(Failure failure, bool isInitial) {
    emit(
      CorePaginationState.failed(
        failure: failure,
        paginatedResponseModel: state.paginatedResponseModel,
        retryFunction: isInitial ? fetchInitialData : fetchMoreData,
      ),
    );
  }

  void _handleSuccess(
    PaginationResponseModel<T, M> paginatedResponseModel,
    bool isInitial,
  ) {
    final hasReachedMax =
        paginatedResponseModel.data.length < paginationStrategy.limit;

    emit(
      CorePaginationState.succeeded(
        paginatedResponseModel: isInitial
            ? paginatedResponseModel
            : state.paginatedResponseModel.copyWith(
                data: List<T>.from(state.paginatedResponseModel.data)
                  ..addAll(paginatedResponseModel.data),
              ),
        hasReachedMax: hasReachedMax,
      ),
    );

    _updatePaginationState(hasReachedMax);
  }

  void _updatePaginationState(bool hasReachedMax) {
    if (!hasReachedMax) {
      paginationStrategy.increment();
    }
  }

  void _resetState() {
    paginationStrategy.reset();
    emit(const CorePaginationState.loading());
  }

  void updatePaginationFunction(
    ResultFuture<PaginationResponseModel<T, M>> Function(
      int batch,
      int limit, {
      String? requestId,
    })
    paginationFunction,
  ) {
    _paginationFunction = paginationFunction;
    fetchInitialData();
  }

  void addLast(T item) {
    if (state is PaginationSucceeded<T, M>) {
      final currentState = state as PaginationSucceeded<T, M>;
      final updatedData = List<T>.from(currentState.paginatedResponseModel.data)
        ..add(item);
      if (isClosed) return;

      emit(
        CorePaginationState.succeeded(
          paginatedResponseModel: currentState.paginatedResponseModel.copyWith(
            data: updatedData,
          ),
          hasReachedMax: currentState.hasReachedMax,
        ),
      );
    }
  }

  void addFirst(T item) {
    if (state is PaginationSucceeded<T, M>) {
      final currentState = state as PaginationSucceeded<T, M>;
      final updatedData = List<T>.from(currentState.paginatedResponseModel.data)
        ..insert(0, item);
      if (isClosed) return;

      emit(
        CorePaginationState.succeeded(
          paginatedResponseModel: currentState.paginatedResponseModel.copyWith(
            data: updatedData,
          ),
          hasReachedMax: currentState.hasReachedMax,
        ),
      );
    }
  }

  void update(T item) {
    if (state is PaginationSucceeded<T, M>) {
      final currentState = state as PaginationSucceeded<T, M>;
      final updatedData = List<T>.from(
        currentState.paginatedResponseModel.data,
      );
      final index = updatedData.indexWhere((element) => element.id == item.id);
      if (index == -1 || isClosed) return;

      updatedData[index] = item;
      emit(
        CorePaginationState.succeeded(
          paginatedResponseModel: currentState.paginatedResponseModel.copyWith(
            data: updatedData,
          ),
          hasReachedMax: currentState.hasReachedMax,
        ),
      );
    }
  }

  void delete(String id) {
    if (state is PaginationSucceeded<T, M>) {
      final currentState = state as PaginationSucceeded<T, M>;
      final updatedData = List<T>.from(currentState.paginatedResponseModel.data)
        ..removeWhere((element) => element.id == id);
      if (isClosed) return;

      emit(
        CorePaginationState.succeeded(
          paginatedResponseModel: currentState.paginatedResponseModel.copyWith(
            data: updatedData,
          ),
          hasReachedMax: currentState.hasReachedMax,
        ),
      );
    }
  }

  T? findById(String id) {
    if (state is PaginationSucceeded<T, M>) {
      final currentState = state as PaginationSucceeded<T, M>;
      try {
        return currentState.paginatedResponseModel.data.firstWhere(
          (element) => element.id == id,
        );
      } catch (_) {
        return null;
      }
    }
    return null;
  }
}

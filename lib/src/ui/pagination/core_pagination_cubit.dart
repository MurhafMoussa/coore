import 'package:async/async.dart';
import 'package:bloc/bloc.dart';
import 'package:coore/lib.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

part 'core_pagination_cubit.freezed.dart';
part 'core_pagination_state.dart';

/// A generic pagination cubit that handles paginated data fetching and state management.
///
/// Manages:
/// - Pagination state (loading/success/error)
/// - Automatic batch fetching
/// - Refresh control
/// - Pagination strategy (page/skip/cursor)
/// - Error handling with retry capabilities
///
class CorePaginationCubit<T extends Identifiable, M extends MetaModel>
    extends Cubit<CorePaginationState<T, M>> {
  /// {@macro core_pagination_cubit}
  CorePaginationCubit({
    /// Async function that fetches paginated data from usecase
    required UseCaseCancelableFutureResponse<PaginationResponseModel<T, M>>
    Function(int, int)
    paginationFunction,

    /// Pagination strategy implementation (Page/Skip)
    required this.paginationStrategy,

    /// Reverse order loading (for chat-like timelines)
    this.reverse = false,
  }) : _paginationFunction = paginationFunction,
       super(CorePaginationState<T, M>.loading()) {
    _refreshController = RefreshController();
    _paginationFunction = paginationFunction;
  }

  /// The currently active, cancelable API operation.
  CancelableOperation<Either<Failure, PaginationResponseModel<T, M>>>?
  _cancelableOperation;

  /// The data fetching function signature:
  /// - batch: Current pagination index (page number/skip value)
  /// - limit: Number of items per page
  UseCaseCancelableFutureResponse<PaginationResponseModel<T, M>> Function(
    int,
    int,
  )
  _paginationFunction;

  /// Active pagination strategy implementation
  final PaginationStrategy paginationStrategy;

  /// Reverse loading order (useful for chat/messaging interfaces)
  final bool reverse;

  late final RefreshController _refreshController;

  /// Exposed refresh controller for integration with pull-to-refresh widgets
  RefreshController get refreshController => _refreshController;

  /// Fetches the first page of data:
  /// - Resets pagination state
  /// - Handles initial loading state

  @mustCallSuper
  Future<void> fetchInitialData() async {
    if (!isClosed) _resetState();

    await _fetchNetworkData(isInitial: true);
  }

  /// Fetches subsequent pages of data:
  /// - Handles pagination increment
  /// - Manages loading states
  /// - Blocks duplicate/concurrent requests
  @mustCallSuper
  Future<void> fetchMoreData() async {
    if (_shouldBlockRequest) return;

    await _fetchNetworkData(isInitial: false);
  }

  /// Request blocking logic for subsequent requests
  bool get _shouldBlockRequest => state.isLoading || state.hasReachedMax;

  /// Central data fetching method:
  /// - Executes pagination function
  /// - Routes to success/error handlers
  /// - Maintains initial/non-initial context
  Future<void> _fetchNetworkData({required bool isInitial}) async {
    _cancelableOperation = _paginationFunction(
      paginationStrategy.nextBatch,
      paginationStrategy.limit,
    );
    final result = await _cancelableOperation?.value;
    _cancelableOperation = null;
    if (!isClosed && result != null) {
      result.fold(
        (failure) => _handleFailure(failure, isInitial),
        (paginatedResponseModel) =>
            _handleSuccess(paginatedResponseModel, isInitial),
      );
    }
  }

  /// Error handling pipeline:
  /// - Updates state with error details
  /// - Provides retry function in state
  /// - Manages refresh controller state
  void _handleFailure(Failure failure, bool isInitial) {
    emit(
      CorePaginationState.failed(
        failure: failure,
        paginatedResponseModel: state.paginatedResponseModel,
        retryFunction: isInitial ? fetchInitialData : fetchMoreData,
      ),
    );

    _refreshController.loadFailed();
  }

  /// Success handling pipeline:
  /// - Merges new items with existing state
  /// - Determines pagination completion
  /// - Updates refresh controller
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
                data: [
                  ...state.paginatedResponseModel.data,
                  ...paginatedResponseModel.data,
                ],
              ),
        hasReachedMax: hasReachedMax,
      ),
    );

    _updatePaginationState(hasReachedMax);
  }

  /// Post-success state updates:
  /// - Updates refresh controller status
  /// - Increments pagination strategy
  /// - Handles end-of-list detection
  void _updatePaginationState(bool hasReachedMax) {
    _refreshController.refreshCompleted();
    if (hasReachedMax) {
      _refreshController.loadNoData();
    } else {
      _refreshController.loadComplete();
      paginationStrategy.increment();
    }
  }

  /// State reset logic:
  /// - Resets pagination strategy
  /// - Returns to initial loading state
  void _resetState() {
    paginationStrategy.reset();
    emit(CorePaginationState.loading());
  }

  @override
  Future<void> close() {
    _refreshController.dispose();
    _cancelableOperation?.cancel();
    return super.close();
  }

  void updatePaginationFunction(
    UseCaseCancelableFutureResponse<PaginationResponseModel<T, M>> Function(
      int batch,
      int limit,
    )
    paginationFunction,
  ) {
    _paginationFunction = paginationFunction;
    fetchInitialData();
  }

  /// Adds an item to the end of the list.
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

  /// Adds an item to the beginning of the list.
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

  /// Updates an existing item in the list.
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

  /// Deletes an item from the list by its ID.
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

  /// Adds a list of items to the end of the list.
  void bulkAdd(List<T> items) {
    if (state is PaginationSucceeded<T, M>) {
      final currentState = state as PaginationSucceeded<T, M>;
      final updatedData = List<T>.from(currentState.paginatedResponseModel.data)
        ..addAll(items);
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

  /// Updates multiple items in the list.
  void bulkUpdate(List<T> items) {
    if (state is PaginationSucceeded<T, M>) {
      final currentState = state as PaginationSucceeded<T, M>;
      final updatedData = List<T>.from(
        currentState.paginatedResponseModel.data,
      );
      for (final item in items) {
        final index = updatedData.indexWhere(
          (element) => element.id == item.id,
        );
        if (index != -1) {
          updatedData[index] = item;
        }
      }
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

  /// Deletes multiple items from the list by their IDs.
  void bulkDelete(List<String> ids) {
    if (state is PaginationSucceeded<T, M>) {
      final currentState = state as PaginationSucceeded<T, M>;
      final updatedData = List<T>.from(currentState.paginatedResponseModel.data)
        ..removeWhere((element) => ids.contains(element.id));
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

  /// Finds an item by its ID.
  T? findById(String id) {
    if (state is PaginationSucceeded<T, M>) {
      final currentState = state as PaginationSucceeded<T, M>;
      try {
        return currentState.paginatedResponseModel.data.firstWhere(
          (element) => element.id == id,
        );
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  /// Checks if the list contains a specific item.
  bool contains(T item) {
    if (state is PaginationSucceeded<T, M>) {
      final currentState = state as PaginationSucceeded<T, M>;
      return currentState.paginatedResponseModel.data.any(
        (element) => element.id == item.id,
      );
    }
    return false;
  }

  /// Checks if the list contains all items from a given list.
  bool containsAll(List<T> items) {
    if (state is PaginationSucceeded<T, M>) {
      final currentState = state as PaginationSucceeded<T, M>;
      return items.every(
        (item) => currentState.paginatedResponseModel.data.any(
          (element) => element.id == item.id,
        ),
      );
    }
    return false;
  }
}

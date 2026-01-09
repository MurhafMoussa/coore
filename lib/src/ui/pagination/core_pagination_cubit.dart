import 'package:bloc/bloc.dart';
import 'package:coore/lib.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'core_pagination_cubit.freezed.dart';
part 'core_pagination_state.dart';

/// A generic pagination cubit that handles paginated data fetching and state management.
///
/// Manages:
/// - Pagination state (loading/success/error)
/// - Automatic batch fetching
/// - Pagination strategy (page/skip/cursor)
/// - Error handling with retry capabilities
///
class CorePaginationCubit<T extends Identifiable, M extends MetaModel>
    extends Cubit<CorePaginationState<T, M>> {
  /// {@macro core_pagination_cubit}
  CorePaginationCubit({
    /// Async function that fetches paginated data from usecase
    required ResultFuture<PaginationResponseModel<T, M>> Function(
      int batch,
      int limit, {
      String? requestId,
    })
    paginationFunction,

    /// Pagination strategy implementation (Page/Skip)
    required this.paginationStrategy,

    /// Reverse order loading (for chat-like timelines)
    this.reverse = false,
  }) : _paginationFunction = paginationFunction,
       super(CorePaginationState<T, M>.loading()) {
    _paginationFunction = paginationFunction;
  }

  /// The current request ID, if cancellation is enabled
  String? _currentRequestId;

  /// The data fetching function signature:
  /// - batch: Current pagination index (page number/skip value)
  /// - limit: Number of items per page
  /// - requestId: Optional static request ID for cancellation support. Use a consistent
  ///              string identifier for each pagination request type (e.g., "fetch_posts").
  ///              The same [requestId] must be used when calling API handler methods.
  ResultFuture<PaginationResponseModel<T, M>> Function(
    int batch,
    int limit, {
    String? requestId,
  })
  _paginationFunction;

  /// Active pagination strategy implementation
  final PaginationStrategy paginationStrategy;

  /// Reverse loading order (useful for chat/messaging interfaces)
  final bool reverse;

  /// Fetches the first page of data:
  /// - Resets pagination state
  /// - Handles initial loading state
  /// - Returns Future that completes when network request finishes
  @mustCallSuper
  Future<void> fetchInitialData() async {
    if (!isClosed) _resetState();

    await _fetchNetworkData(isInitial: true);
  }

  /// Fetches subsequent pages of data:
  /// - Handles pagination increment
  /// - Manages loading states
  /// - Blocks duplicate/concurrent requests
  /// - Returns Future that completes when network request finishes
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
  /// - Completes Future when done (for EasyRefresh)
  Future<void> _fetchNetworkData({
    required bool isInitial,
    String? requestId,
  }) async {
    // Register request for cancellation support
    if (requestId != null) {
      getIt<CancelRequestManager>().registerRequest(requestId);
      _currentRequestId = requestId;
    }

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
    } finally {
      // Cleanup request registration
      if (_currentRequestId != null) {
        getIt<CancelRequestManager>().unregisterRequest(_currentRequestId!);
        _currentRequestId = null;
      }
    }
  }

  /// Error handling pipeline:
  /// - Updates state with error details
  /// - Provides retry function in state
  void _handleFailure(Failure failure, bool isInitial) {
    emit(
      CorePaginationState.failed(
        failure: failure,
        paginatedResponseModel: state.paginatedResponseModel,
        retryFunction: isInitial ? fetchInitialData : fetchMoreData,
      ),
    );
  }

  /// Success handling pipeline:
  /// - Merges new items with existing state
  /// - Determines pagination completion
  /// - Updates pagination strategy
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
                // OPTIMIZATION: Use List.from()..addAll() for better performance with large lists
                data: List<T>.from(state.paginatedResponseModel.data)
                  ..addAll(paginatedResponseModel.data),
              ),
        hasReachedMax: hasReachedMax,
      ),
    );

    _updatePaginationState(hasReachedMax);
  }

  /// Post-success state updates:
  /// - Increments pagination strategy
  /// - Handles end-of-list detection
  void _updatePaginationState(bool hasReachedMax) {
    if (!hasReachedMax) {
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
    // Cancel ongoing request if exists
    if (_currentRequestId != null) {
      getIt<CancelRequestManager>().cancelRequest(_currentRequestId!);
      _currentRequestId = null;
    }
    return super.close();
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

import 'package:bloc/bloc.dart';
import 'package:coore/lib.dart';
import 'package:flutter/foundation.dart';
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
class CorePaginationCubit<T extends Identifiable>
    extends Cubit<CorePaginationState<T>> {
  /// {@macro core_pagination_cubit}
  CorePaginationCubit({
    /// Async function that fetches paginated data from usecase
    required this.paginationFunction,

    /// Pagination strategy implementation (Page/Skip)
    required this.paginationStrategy,

    /// Reverse order loading (for chat-like timelines)
    this.reverse = false,
  }) : super(CorePaginationState<T>.loading()) {
    _refreshController = RefreshController();
  }

  /// The data fetching function signature:
  /// - batch: Current pagination index (page number/skip value)
  /// - limit: Number of items per page
  final UseCaseFutureResponse<List<T>> Function(int batch, int limit)
  paginationFunction;

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
    _resetState();

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
    final result = await paginationFunction(
      paginationStrategy.nextBatch,
      paginationStrategy.limit,
    );

    result.fold(
      (failure) => _handleFailure(failure, isInitial),
      (items) => _handleSuccess(items, isInitial),
    );
  }

  /// Error handling pipeline:
  /// - Updates state with error details
  /// - Provides retry function in state
  /// - Manages refresh controller state
  void _handleFailure(Failure failure, bool isInitial) {
    emit(
      CorePaginationState.failed(
        failure: failure,
        items: state.items,
        retryFunction: isInitial ? fetchInitialData : fetchMoreData,
      ),
    );

    _refreshController.loadFailed();
  }

  /// Success handling pipeline:
  /// - Merges new items with existing state
  /// - Determines pagination completion
  /// - Updates refresh controller
  void _handleSuccess(List<T> items, bool isInitial) {
    final hasReachedMax = items.length < paginationStrategy.limit;

    emit(
      CorePaginationState.succeeded(
        items: isInitial ? items : [...state.items, ...items],
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
    return super.close();
  }
}

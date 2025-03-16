import 'package:coore/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// A configurable pagination widget that handles data loading, state management,
/// and UI presentation for paginated data sources.
///
/// ## Features
/// - Built-in loading, error, and empty states
/// - Pull-to-refresh and infinite scroll
/// - Customizable pagination strategies
/// - Skeleton loading animations
/// - Horizontal/vertical scrolling support
///
/// ## Usage
/// ```dart
/// CorePaginationWidget<Post>(
///   paginationFunction: (batch, limit) => repo.getPosts(batch, limit),
///   paginationStrategy: PageBasedStrategy(),
///   emptyEntity: Post.empty(),
///   scrollableBuilder: (context, items) => ListView.builder(
///     itemCount: items.length,
///     itemBuilder: (context, index) => PostItem(post: items[index]),
///   ),
/// )
/// ```
///
/// See also:
/// - [CorePaginationCubit] for state management logic
/// - [PaginationStrategy] for custom pagination implementations
class CorePaginationWidget<T extends BaseEntity> extends StatelessWidget {
  /// Creates a pagination widget with configurable behavior and UI.
  const CorePaginationWidget({
    super.key,
    required this.scrollableBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.emptyBuilder,
    this.scrollDirection = Axis.vertical,
    this.physics,
    this.padding,
    this.showRefreshIndicator = true,
    this.headerBuilder,
    this.footerBuilder,
    this.skeletonItemCount,
    required this.paginationFunction,
    required this.paginationStrategy,
    this.reverse = false,
    this.emptyEntity,
  }) : assert(
         emptyEntity != null || loadingBuilder != null,
         'You must provide either empty entity or a loading builder',
       );

  /// Builder for the main scrollable content area.
  /// Receives:
  /// - [BuildContext]
  /// - List of loaded items.
  final Widget Function(BuildContext context, List<T> items) scrollableBuilder;

  /// Custom loading state widget builder.
  /// If null, uses [Skeletonizer] with [emptyEntity].
  final Widget Function(BuildContext context)? loadingBuilder;

  /// Error state widget builder.
  /// Receives:
  /// - [BuildContext]
  /// - [Failure] encountered
  /// - Retry callback (may be null if items exist)
  /// - Already fetched items.
  final Widget Function(
    BuildContext context,
    Failure failure,
    VoidCallback? retry,
    List<T> alreadyFeatchedItems,
  )?
  errorBuilder;

  /// Data fetching function with pagination parameters.
  /// Must return a [RepositoryFutureResponse] with an item list.
  final RepositoryFutureResponse<List<T>> Function(int batch, int limit)
  paginationFunction;

  /// Pagination strategy implementation.
  /// Handles pagination math (page numbers, skip/limit), batch calculations, and max item tracking.
  final PaginationStrategy paginationStrategy;

  /// Reverse loading order (new items prepend instead of append).
  final bool reverse;

  /// Widget to display when no items are loaded.
  /// Defaults to a centered icon and text.
  final Widget Function(BuildContext context)? emptyBuilder;

  /// Scroll axis direction (defaults to vertical).
  final Axis scrollDirection;

  /// Scroll physics behavior.
  final ScrollPhysics? physics;

  /// Padding around scrollable content.
  final EdgeInsetsGeometry? padding;

  /// Toggles pull-to-refresh functionality.
  final bool showRefreshIndicator;

  /// Custom refresh header widget builder.
  /// Receives a refresh controller for completion control.
  /// Defaults to [ClassicHeader].
  final Widget Function(BuildContext context, RefreshController controller)?
  headerBuilder;

  /// Custom loading footer widget builder.
  /// Receives a refresh controller for completion control.
  /// Defaults to [ClassicFooter].
  final Widget Function(BuildContext context, RefreshController controller)?
  footerBuilder;

  /// Number of skeleton items to display during loading.
  /// Uses [PaginationStrategy.limit] if null.
  final int? skeletonItemCount;

  /// Entity instance for skeleton loading placeholders.
  /// Required when [loadingBuilder] is null.
  final T? emptyEntity;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CorePaginationCubit<T>>(
      create:
          (context) => CorePaginationCubit<T>(
            paginationFunction: paginationFunction,
            paginationStrategy: paginationStrategy,
            reverse: reverse,
          )..fetchInitialData(),
      child: Builder(
        builder: (context) {
          return BlocBuilder<CorePaginationCubit<T>, CorePaginationState<T>>(
            builder: (context, state) => _buildSmartRefresher(state, context),
          );
        },
      ),
    );
  }

  /// Builds the SmartRefresher widget with configured header/footer.
  Widget _buildSmartRefresher(
    CorePaginationState<T> state,
    BuildContext context,
  ) {
    final paginationCubit = context.read<CorePaginationCubit<T>>();
    return SmartRefresher(
      controller: paginationCubit.refreshController,
      scrollDirection: scrollDirection,
      physics: physics,
      enablePullUp: !state.hasReachedMax,
      enablePullDown: showRefreshIndicator,
      onRefresh: () async => paginationCubit.fetchInitialData(),
      onLoading: () async => paginationCubit.fetchMoreData(),
      header:
          headerBuilder?.call(context, paginationCubit.refreshController) ??
          const ClassicHeader(),
      footer:
          footerBuilder?.call(context, paginationCubit.refreshController) ??
          const ClassicFooter(),
      // Wrap content in a Padding widget if [padding] is provided.
      child:
          padding != null
              ? Padding(padding: padding!, child: _buildContent(state, context))
              : _buildContent(state, context),
    );
  }

  /// Selects the appropriate content based on the current state.
  Widget _buildContent(CorePaginationState<T> state, BuildContext context) {
    return switch (state) {
      PaginationSucceeded(:final items) => _buildSuccessState(items, context),
      PaginationFailed(:final failure, :final items, :final retryFunction) =>
        _buildErrorState(failure, items, retryFunction, context),
      _ => _buildLoadingState(context),
    };
  }

  /// Builds success state with items or displays an empty view.
  Widget _buildSuccessState(List<T> items, BuildContext context) {
    if (items.isEmpty) {
      return emptyBuilder?.call(context) ?? const _EmptyState();
    }
    final scrollableWidget = scrollableBuilder(context, items);
    assert(
      scrollableWidget is ScrollView,
      'Scrollable builder must return GridView, ListView, or Slivers',
    );
    return scrollableWidget;
  }

  /// Builds error state with optional retry and existing items.
  Widget _buildErrorState(
    Failure failure,
    List<T> items,
    VoidCallback? retry,
    BuildContext context,
  ) {
    // If a custom error builder is provided, use it.
    if (errorBuilder != null) {
      return errorBuilder!(context, failure, retry, items);
    }
    // If there are already fetched items, display them.
    if (items.isNotEmpty) {
      return scrollableBuilder(context, items);
    }
    // Otherwise, display a default error message with a retry button.
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(failure.message),
          const SizedBox(height: 16),
          FilledButton(onPressed: retry, child: const Text('Retry')),
        ],
      ),
    );
  }

  /// Builds loading state with a skeleton placeholder or custom loading UI.
  Widget _buildLoadingState(BuildContext context) {
    if (loadingBuilder != null) return loadingBuilder!(context);
    final cubit = context.read<CorePaginationCubit<T>>();
    return Skeletonizer(
      child: scrollableBuilder(
        context,
        List.generate(
          skeletonItemCount ?? cubit.paginationStrategy.limit,
          (index) => emptyEntity!,
        ),
      ),
    );
  }
}

/// Default empty state view.
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 64),
          SizedBox(height: 16),
          Text('No items found'),
        ],
      ),
    );
  }
}

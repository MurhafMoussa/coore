import 'package:coore/lib.dart';
import 'package:coore/src/ui/pagination/core_pagination_cubit.dart';
import 'package:coore/src/ui/pagination/pagination_strategy.dart';
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
/// CorePaginationWidget&lt;Post&gt;(
///   paginationFunction: (batch, limit) =&gt; repo.getPosts(batch, limit),
///   paginationStrategy: PageBasedStrategy(),
///   emptyEntity: Post.empty(),
///   scrollableBuilder: (context, items) =&gt; ListView.builder(
///     itemCount: items.length,
///     itemBuilder: (context, index) =&gt; PostItem(post: items[index]),
///   ),
/// )
/// ```
///
/// See also:
/// - [CorePaginationCubit] for state management logic
/// - [PaginationStrategy] for custom pagination implementations
class CorePaginationWidget<T extends BaseEntity> extends StatelessWidget {
  /// Creates a pagination widget with configurable behavior and UI
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

  /// {@template pagination_builder}
  /// Builder function for the main scrollable content area
  ///
  /// Receives:
  /// - Current build context
  /// - List of loaded items
  /// {@endtemplate}
  final Widget Function(BuildContext context, List<T> items) scrollableBuilder;

  /// {@template pagination_loader}
  /// Custom loading state widget builder
  ///
  /// If null, uses [Skeletonizer] with [emptyEntity]
  /// {@endtemplate}
  final Widget Function(BuildContext context)? loadingBuilder;

  /// {@template pagination_error}
  /// Error state widget builder
  ///
  /// Receives:
  /// - Build context
  /// - Encountered failure
  /// - Retry callback (may be null if items exist)
  /// {@endtemplate}
  final Widget Function(
    BuildContext context,
    Failure failure,
    VoidCallback? retry,
  )?
  errorBuilder;

  /// Data fetching function with pagination parameters
  ///
  /// Parameters:
  /// - [batch]: Current pagination index (page number or skip value)
  /// - [limit]: Number of items per page/batch
  ///
  /// Must return [RepositoryFutureResponse] with item list
  final RepositoryFutureResponse<List<T>> Function(int batch, int limit)
  paginationFunction;

  /// Pagination strategy implementation
  ///
  /// Handles:
  /// - Pagination math (page numbers, skip/limit)
  /// - Batch calculations
  /// - Max item tracking
  final PaginationStrategy paginationStrategy;

  /// Reverse loading order (new items prepend instead of append)
  final bool reverse;

  /// Widget to display when no items are loaded
  ///
  /// Defaults to centered icon and text
  final Widget Function(BuildContext context)? emptyBuilder;

  /// Scroll axis direction (defaults to vertical)
  final Axis scrollDirection;

  /// Scroll physics behavior
  final ScrollPhysics? physics;

  /// Padding around scrollable content
  final EdgeInsetsGeometry? padding;

  /// Toggles pull-to-refresh functionality
  final bool showRefreshIndicator;

  /// Custom refresh header widget builder
  ///
  /// Receives refresh controller for completion control
  /// Defaults to [ClassicHeader]
  final Widget Function(BuildContext context, RefreshController controller)?
  headerBuilder;

  /// Custom loading footer widget builder
  ///
  /// Receives refresh controller for completion control
  /// Defaults to [ClassicFooter]
  final Widget Function(BuildContext context, RefreshController controller)?
  footerBuilder;

  /// Number of skeleton items to display during loading
  ///
  /// Uses [PaginationStrategy.limit] if null
  final int? skeletonItemCount;

  /// Entity instance for skeleton loading placeholders
  ///
  /// Required when [loadingBuilder] is null
  final T? emptyEntity;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => CorePaginationCubit(
            paginationFunction: paginationFunction,
            paginationStrategy: paginationStrategy,
            reverse: reverse,
          )..fetchInitialData(),
      child: Builder(
        builder: (context) {
          return BlocBuilder<CorePaginationCubit<T>, CorePaginationState<T>>(
            builder: (ctx, state) {
              return _buildSmartRefresher(state, ctx);
            },
          );
        },
      ),
    );
  }

  /// Builds the SmartRefresher widget with configured header/footer
  Widget _buildSmartRefresher(
    CorePaginationState<T> state,
    BuildContext context,
  ) {
    final paginationCubit = context.read<CorePaginationCubit>();
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
      child: _buildContent(state, context),
    );
  }

  /// Selects appropriate content based on current state
  Widget _buildContent(CorePaginationState<T> state, BuildContext context) {
    return switch (state) {
      PaginationSucceeded(:final items) => _buildSuccessState(items, context),
      PaginationFailed(:final failure, :final items, :final retryFunction) =>
        _buildErrorState(failure, items, retryFunction, context),
      _ => _buildLoadingState(context),
    };
  }

  /// Builds success state with items or empty view
  Widget _buildSuccessState(List<T> items, BuildContext context) {
    if (items.isEmpty) {
      return emptyBuilder?.call(context) ?? const _EmptyState();
    }
    return scrollableBuilder(context, items);
  }

  /// Builds error state with optional retry and existing items
  Widget _buildErrorState(
    Failure failure,
    List<T> items,
    VoidCallback? retry,
    BuildContext context,
  ) {
    if (errorBuilder != null) {
      return errorBuilder!(context, failure, retry);
    }

    return Column(
      children: [
        Expanded(
          child:
              items.isNotEmpty
                  ? scrollableBuilder(context, items)
                  : Center(child: Text(failure.message)),
        ),
        _buildRetryButton(retry),
      ],
    );
  }

  /// Builds loading state with skeleton or custom UI
  Widget _buildLoadingState(BuildContext context) {
    if (loadingBuilder != null) return loadingBuilder!(context);

    return Skeletonizer(
      child: scrollableBuilder(
        context,
        List.generate(
          skeletonItemCount ??
              context.read<CorePaginationCubit>().paginationStrategy.limit,
          (index) => emptyEntity!,
        ),
      ),
    );
  }

  /// Generic retry button for error states
  Widget _buildRetryButton(VoidCallback? retry) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: FilledButton(onPressed: retry, child: const Text('Retry')),
    );
  }
}

/// Default empty state view
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

import 'package:coore/lib.dart';
import 'package:coore/src/api_handler/entities/paginatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:skeletonizer/skeletonizer.dart';

// =====================================================================================
// PAGINATION CONFIGURATION
// =====================================================================================

/// An inherited configuration widget that provides all pagination-related settings
/// to descendant widgets via [BuildContext].
///
/// Offers two mutually-exclusive builder callbacks:
/// 1. [scrollableBuilder]: returns a single [ScrollView] (e.g., [ListView], [GridView]).
/// 2. [sliversBuilder]: returns a list of [Sliver] widgets (e.g., [SliverList], [SliverGrid]).
///
/// Exactly one of these builders must be non-null, otherwise an assertion error is thrown.
class PaginationConfig<T extends Identifiable> extends InheritedWidget {
  /// Creates a pagination configuration. Supply either [scrollableBuilder] or [sliversBuilder].
  const PaginationConfig({
    super.key,
    this.scrollableBuilder,
    this.sliversBuilder,
    required this.paginationFunction,
    required this.paginationStrategy,
    required this.reverse,
    this.loadingBuilder,
    this.errorBuilder,
    this.emptyBuilder,
    this.scrollDirection = Axis.vertical,
    this.physics,
    this.showRefreshIndicator = true,
    this.headerBuilder,
    this.footerBuilder,
    this.skeletonItemCount,
    this.emptyEntity,
    this.enableScrollToTop = true,
    required super.child,
  }) : assert(
         (scrollableBuilder != null) ^ (sliversBuilder != null),
         'Provide exactly one of scrollableBuilder or sliversBuilder',
       );

  // ---------------------------------------------------------------------------------
  // BUILDERS
  // ---------------------------------------------------------------------------------

  /// Builder for classic ScrollView mode.
  final Widget Function(
    BuildContext context,
    List<T> items,
    ScrollController? controller,
  )?
  scrollableBuilder;

  /// Builder for Sliver mode.
  final List<Widget> Function(
    BuildContext context,
    List<T> items,
    ScrollController? controller,
  )?
  sliversBuilder;

  // ---------------------------------------------------------------------------------
  // PAGINATION DATA
  // ---------------------------------------------------------------------------------

  /// Function to fetch a page of data. [batch] is 1-based, [limit] is from strategy.
  final UseCaseFutureResponse<Paginatable<T>> Function(int batch, int limit)
  paginationFunction;

  /// Strategy defining page size and thresholds.
  final PaginationStrategy paginationStrategy;

  // ---------------------------------------------------------------------------------
  // SCROLL BEHAVIOUR
  // ---------------------------------------------------------------------------------

  /// Reverse scroll direction if true (e.g., chat timelines).
  final bool reverse;

  /// Axis of scrolling (vertical or horizontal).
  final Axis scrollDirection;

  /// Custom scroll physics (e.g., BouncingScrollPhysics).
  final ScrollPhysics? physics;

  // ---------------------------------------------------------------------------------
  // UI HOOKS
  // ---------------------------------------------------------------------------------

  /// Custom full-screen loading widget. If null, skeleton placeholders are used.
  final Widget Function(BuildContext context)? loadingBuilder;

  /// Custom empty state widget when no items found.
  final Widget Function(BuildContext context)? emptyBuilder;

  /// Custom error state builder.
  /// Parameters: [failure], [retry], [alreadyFetchedItemsWidget].
  final Widget Function(
    BuildContext context,
    Failure failure,
    VoidCallback? retry,
    Widget alreadyFetchedItemsWidget,
  )?
  errorBuilder;

  // ---------------------------------------------------------------------------------
  // PULL-TO-REFRESH
  // ---------------------------------------------------------------------------------

  /// Whether pull-down-to-refresh is enabled.
  final bool showRefreshIndicator;

  /// Custom header widget builder for refresh.
  final Widget Function(BuildContext context, RefreshController controller)?
  headerBuilder;

  /// Custom footer widget builder for load-more.
  final Widget Function(BuildContext context, RefreshController controller)?
  footerBuilder;

  // ---------------------------------------------------------------------------------
  // SKELETON LOADING
  // ---------------------------------------------------------------------------------

  /// Number of skeleton items to display. Defaults to strategy.limit.
  final int? skeletonItemCount;

  /// A prototype entity for skeleton placeholders. Required if [loadingBuilder] is null.
  final T? emptyEntity;

  // ---------------------------------------------------------------------------------
  // MISC
  // ---------------------------------------------------------------------------------

  /// Whether to show a floating button to scroll to top.
  final bool enableScrollToTop;

  /// Retrieves nearest [PaginationConfig] of type [T] from context.
  static PaginationConfig<T> of<T extends Identifiable>(BuildContext context) {
    final cfg = context
        .dependOnInheritedWidgetOfExactType<PaginationConfig<T>>();
    assert(cfg != null, 'No PaginationConfig<$T> found in context');
    return cfg!;
  }

  @override
  bool updateShouldNotify(covariant PaginationConfig<T> oldWidget) =>
      this != oldWidget;
}
// =====================================================================================
// CORE PAGINATION WIDGET
// =====================================================================================

/// A ready-to-use pagination widget that wires:
///  • [PaginationConfig] inheritance
///  • [CorePaginationCubit] state management
///  • Pull-to-refresh and load-more via [SmartRefresher]
///  • Skeleton loading or custom loader
///  • Error handling with retry
///  • Optional scroll-to-top FAB
///
/// Supply either [scrollableBuilder] or [sliversBuilder]. All other parameters are optional.
class CorePaginationWidget<T extends Identifiable> extends StatelessWidget {
  /// Creates a pagination wrapper. Exactly one builder must be provided.
  const CorePaginationWidget({
    super.key,
    this.scrollableBuilder,
    this.sliversBuilder,
    required this.paginationFunction,
    required this.paginationStrategy,
    this.reverse = false,
    this.loadingBuilder,
    this.errorBuilder,
    this.emptyBuilder,
    this.scrollDirection = Axis.vertical,
    this.physics,
    this.showRefreshIndicator = true,
    this.headerBuilder,
    this.footerBuilder,
    this.skeletonItemCount,
    this.emptyEntity,
    this.enableScrollToTop = true,
  }) : assert(
         (scrollableBuilder != null) ^ (sliversBuilder != null),
         'Provide exactly one of scrollableBuilder or sliversBuilder',
       );

  /// Builder for classic ScrollView mode.
  final Widget Function(BuildContext, List<T>, ScrollController?)?
  scrollableBuilder;

  /// Builder for Sliver mode.
  final List<Widget> Function(BuildContext, List<T>, ScrollController?)?
  sliversBuilder;

  /// Function to fetch data pages.
  final UseCaseFutureResponse<Paginatable<T>> Function(int batch, int limit)
  paginationFunction;

  /// Defines page size and thresholds.
  final PaginationStrategy paginationStrategy;

  /// Reverse scroll direction.
  final bool reverse;

  /// Custom loading widget.
  final Widget Function(BuildContext)? loadingBuilder;

  /// Custom error builder.
  final Widget Function(BuildContext, Failure, VoidCallback?, Widget)?
  errorBuilder;

  /// Custom empty state builder.
  final Widget Function(BuildContext)? emptyBuilder;

  /// Axis of scrolling.
  final Axis scrollDirection;

  /// Scroll physics.
  final ScrollPhysics? physics;

  /// Enable pull-to-refresh.
  final bool showRefreshIndicator;

  /// Custom refresh header.
  final Widget Function(BuildContext, RefreshController)? headerBuilder;

  /// Custom load-more footer.
  final Widget Function(BuildContext, RefreshController)? footerBuilder;

  /// Number of skeleton placeholders.
  final int? skeletonItemCount;

  /// Prototype entity for skeleton.
  final T? emptyEntity;

  /// Show scroll-to-top FAB.
  final bool enableScrollToTop;

  @override
  Widget build(BuildContext context) {
    return PaginationConfig<T>(
      scrollableBuilder: scrollableBuilder,
      sliversBuilder: sliversBuilder,
      paginationFunction: paginationFunction,
      paginationStrategy: paginationStrategy,
      reverse: reverse,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      emptyBuilder: emptyBuilder,
      scrollDirection: scrollDirection,
      physics: physics,
      showRefreshIndicator: showRefreshIndicator,
      headerBuilder: headerBuilder,
      footerBuilder: footerBuilder,
      skeletonItemCount: skeletonItemCount,
      emptyEntity: emptyEntity,
      enableScrollToTop: enableScrollToTop,
      child: Builder(
        builder: (context) {
          return BlocProvider<CorePaginationCubit<T>>(
            create: (context) {
              final element = context
                  .getElementForInheritedWidgetOfExactType<
                    PaginationConfig<T>
                  >();
              assert(element != null, 'No PaginationConfig found in context');
              final config = element!.widget as PaginationConfig<T>;

              return CorePaginationCubit<T>(
                paginationFunction: config.paginationFunction,
                paginationStrategy: config.paginationStrategy,
                reverse: config.reverse,
              )..fetchInitialData();
            },
            child: _PaginationContent<T>(),
          );
        },
      ),
    );
  }
}

class _PaginationContent<T extends Identifiable> extends StatelessWidget {
  const _PaginationContent();

  @override
  Widget build(BuildContext context) {
    final config = PaginationConfig.of<T>(context);
    return BlocBuilder<CorePaginationCubit<T>, CorePaginationState<T>>(
      builder: (context, state) {
        return config.enableScrollToTop
            ? CoreScrollableContentWithFab(
                scrollableBuilder: (controller) =>
                    _SmartRefresherWidget<T>(controller: controller),
              )
            : _SmartRefresherWidget<T>();
      },
    );
  }
}

class _SmartRefresherWidget<T extends Identifiable> extends StatelessWidget {
  const _SmartRefresherWidget({this.controller});

  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    final config = PaginationConfig.of<T>(context);
    final cubit = context.read<CorePaginationCubit<T>>();

    return SmartRefresher(
      controller: cubit.refreshController,
      scrollDirection: config.scrollDirection,
      physics: config.physics,
      enablePullUp: !cubit.state.hasReachedMax,
      enablePullDown: config.showRefreshIndicator,
      onRefresh: cubit.fetchInitialData,
      onLoading: cubit.fetchMoreData,
      header: config.headerBuilder?.call(context, cubit.refreshController),
      footer: config.footerBuilder?.call(context, cubit.refreshController),
      child: _contentBuilder(context),
    );
  }

  Widget _contentBuilder(BuildContext context) {
    final state = context.watch<CorePaginationCubit<T>>().state;
    return switch (state) {
      PaginationSucceeded<T>(:final items) => buildPaginated(
        context,
        items,
        controller,
      ),
      PaginationFailed<T>(:final failure, :final items, :final retryFunction) =>
        errorStateWidget(context, items, failure, retryFunction),
      _ => _LoadingStateWidget<T>(scrollController: controller),
    };
  }

  /// Builds the UI for a successful data load (or partial load with existing items).
  ///
  /// - If [items] is empty, renders [PaginationConfig.emptyBuilder] or default empty.
  /// - If [sliversBuilder] is provided, wraps slivers in a [CustomScrollView].
  /// - Otherwise uses [scrollableBuilder].
  Widget buildPaginated(
    BuildContext ctx,
    List<T> items,
    ScrollController? ctrl,
  ) {
    final cfg = PaginationConfig.of<T>(ctx);
    if (items.isEmpty) {
      return cfg.emptyBuilder?.call(ctx) ?? const _EmptyState();
    }
    if (cfg.sliversBuilder != null) {
      return CustomScrollView(
        scrollDirection: cfg.scrollDirection,
        reverse: cfg.reverse,
        physics: cfg.physics,
        controller: ctrl,
        slivers: cfg.sliversBuilder!(ctx, items, ctrl),
      );
    }
    return cfg.scrollableBuilder!(ctx, items, ctrl);
  }

  Widget errorStateWidget(
    BuildContext context,
    List<T> items,
    Failure failure,
    VoidCallback? retryFunction,
  ) {
    final config = PaginationConfig.of<T>(context);

    if (config.errorBuilder != null) {
      return config.errorBuilder!(
        context,
        failure,
        retryFunction,
        buildPaginated(context, items, controller),
      );
    }

    if (items.isNotEmpty) {
      return buildPaginated(context, items, controller);
    }

    return CoreDefaultErrorWidget(
      message: failure.message,
      onRetry: retryFunction,
    );
  }
}

class _LoadingStateWidget<T extends Identifiable> extends StatelessWidget {
  const _LoadingStateWidget({super.key, this.scrollController});

  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    final cfg = PaginationConfig.of<T>(context);
    final cubit = context.read<CorePaginationCubit<T>>();
    if (cfg.loadingBuilder != null) {
      return cfg.loadingBuilder!(context);
    }
    final placeholders = List<T>.generate(
      cfg.skeletonItemCount ?? cubit.paginationStrategy.limit,
      (_) => cfg.emptyEntity!,
    );
    Widget skeletonChild;
    if (cfg.sliversBuilder != null) {
      skeletonChild = CustomScrollView(
        scrollDirection: cfg.scrollDirection,
        reverse: cfg.reverse,
        physics: cfg.physics,
        slivers: cfg.sliversBuilder!(context, placeholders, scrollController),
      );
    } else {
      skeletonChild = cfg.scrollableBuilder!(
        context,
        placeholders,
        scrollController,
      );
    }
    return Skeletonizer(child: skeletonChild);
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: PaddingManager.paddingHorizontal20,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_outlined, size: 64),
            SizedBox(height: 16),
            Text('No items found'),
          ],
        ),
      ),
    );
  }
}

import 'package:coore/lib.dart';
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
    PaginationResponseModel<T> items,
    ScrollController? controller,
  )?
  scrollableBuilder;

  /// Builder for Sliver mode.
  final List<Widget> Function(
    BuildContext context,
    PaginationResponseModel<T> items,
    ScrollController? controller,
  )?
  sliversBuilder;

  // ---------------------------------------------------------------------------------
  // PAGINATION DATA
  // ---------------------------------------------------------------------------------

  /// Function to fetch a page of data. [batch] is 1-based, [limit] is from strategy.
  final UseCaseFutureResponse<PaginationResponseModel<T>> Function(
    int batch,
    int limit,
  )
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
class CorePaginationWidget<T extends Identifiable> extends StatefulWidget {
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
  final Widget Function(
    BuildContext,
    PaginationResponseModel<T>,
    ScrollController?,
  )?
  scrollableBuilder;

  /// Builder for Sliver mode.
  final List<Widget> Function(
    BuildContext,
    PaginationResponseModel<T>,
    ScrollController?,
  )?
  sliversBuilder;

  /// Function to fetch data pages.
  final UseCaseFutureResponse<PaginationResponseModel<T>> Function(
    int batch,
    int limit,
  )
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
  State<CorePaginationWidget<T>> createState() =>
      _CorePaginationWidgetState<T>();
}

class _CorePaginationWidgetState<T extends Identifiable>
    extends State<CorePaginationWidget<T>> {
  late final CorePaginationCubit<T> _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = CorePaginationCubit<T>(
      paginationFunction: widget.paginationFunction,
      paginationStrategy: widget.paginationStrategy,
      reverse: widget.reverse,
    )..fetchInitialData();
  }

  @override
  void didUpdateWidget(covariant CorePaginationWidget<T> old) {
    super.didUpdateWidget(old);

    if (old.paginationFunction != widget.paginationFunction) {
      _cubit.updatePaginationFunction(widget.paginationFunction);
    }
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PaginationConfig<T>(
      scrollableBuilder: widget.scrollableBuilder,
      sliversBuilder: widget.sliversBuilder,
      paginationFunction: widget.paginationFunction,
      paginationStrategy: widget.paginationStrategy,
      reverse: widget.reverse,
      loadingBuilder: widget.loadingBuilder,
      errorBuilder: widget.errorBuilder,
      emptyBuilder: widget.emptyBuilder,
      scrollDirection: widget.scrollDirection,
      physics: widget.physics,
      showRefreshIndicator: widget.showRefreshIndicator,
      headerBuilder: widget.headerBuilder,
      footerBuilder: widget.footerBuilder,
      skeletonItemCount: widget.skeletonItemCount,
      emptyEntity: widget.emptyEntity,
      enableScrollToTop: widget.enableScrollToTop,
      child: Builder(
        builder: (context) {
          return BlocProvider<CorePaginationCubit<T>>.value(
            value: _cubit,
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
      PaginationSucceeded<T>(paginatedResponseModel: final items) =>
        buildPaginated(context, items, controller),
      PaginationFailed<T>(
        :final failure,
        paginatedResponseModel: final items,
        :final retryFunction,
      ) =>
        errorStateWidget(context, items, failure, retryFunction),
      _ => _LoadingStateWidget<T>(scrollController: controller),
    };
  }

  /// Builds the UI for a successful data load (or partial load with existing items).
  ///
  /// - If [paginatedResponseModel] is empty, renders [PaginationConfig.emptyBuilder] or default empty.
  /// - If [sliversBuilder] is provided, wraps slivers in a [CustomScrollView].
  /// - Otherwise uses [scrollableBuilder].
  Widget buildPaginated(
    BuildContext ctx,
    PaginationResponseModel<T> model,
    ScrollController? ctrl,
  ) {
    final cfg = PaginationConfig.of<T>(ctx);
    if (model.data.isEmpty) {
      return cfg.emptyBuilder?.call(ctx) ?? const _EmptyState();
    }
    if (cfg.sliversBuilder != null) {
      return CustomScrollView(
        scrollDirection: cfg.scrollDirection,
        reverse: cfg.reverse,
        physics: cfg.physics,
        controller: ctrl,
        slivers: cfg.sliversBuilder!(ctx, model, ctrl),
      );
    }
    return cfg.scrollableBuilder!(ctx, model, ctrl);
  }

  Widget errorStateWidget(
    BuildContext context,
    PaginationResponseModel<T> model,
    Failure failure,
    VoidCallback? retryFunction,
  ) {
    final config = PaginationConfig.of<T>(context);

    if (config.errorBuilder != null) {
      return config.errorBuilder!(
        context,
        failure,
        retryFunction,
        buildPaginated(context, model, controller),
      );
    }

    if (model.data.isNotEmpty) {
      return buildPaginated(context, model, controller);
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
    final placeholders = PaginationResponseModel(
      data: List<T>.generate(
        cfg.skeletonItemCount ?? cubit.paginationStrategy.limit,
        (_) => cfg.emptyEntity!,
      ),
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

import 'package:coore/lib.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
class PaginationConfig<T extends Identifiable, M extends MetaModel>
    extends InheritedWidget {
  /// Creates a pagination configuration. Supply either [scrollableBuilder] or [sliversBuilder].
  const PaginationConfig({
    super.key,
    this.scrollableBuilder,
    this.sliversBuilder,
    this.paginationFunction,
    this.paginationStrategy,
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
    PaginationResponseModel<T, M> items,
    ScrollController? controller,
  )?
  scrollableBuilder;

  /// Builder for Sliver mode.
  final List<Widget> Function(
    BuildContext context,
    PaginationResponseModel<T, M> items,
    ScrollController? controller,
  )?
  sliversBuilder;

  // ---------------------------------------------------------------------------------
  // PAGINATION DATA
  // ---------------------------------------------------------------------------------

  /// Function to fetch a page of data. [batch] is 1-based, [limit] is from strategy.
  final UseCaseFutureResponse<PaginationResponseModel<T, M>> Function(
    int batch,
    int limit, {
    String? requestId,
  })?
  paginationFunction;

  /// Strategy defining page size and thresholds.
  final PaginationStrategy? paginationStrategy;

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
  /// Takes BuildContext only (EasyRefresh handles state internally).
  /// Must return a Header widget (e.g., MaterialHeader, ClassicHeader).
  final Header Function(BuildContext context)? headerBuilder;

  /// Custom footer widget builder for load-more.
  /// Takes BuildContext only (EasyRefresh handles state internally).
  /// Must return a Footer widget (e.g., MaterialFooter, ClassicFooter).
  final Footer Function(BuildContext context)? footerBuilder;

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
  static PaginationConfig<T, M> of<T extends Identifiable, M extends MetaModel>(
    BuildContext context,
  ) {
    final cfg = context
        .dependOnInheritedWidgetOfExactType<PaginationConfig<T, M>>();
    assert(cfg != null, 'No PaginationConfig<$T> found in context');
    return cfg!;
  }

  @override
  bool updateShouldNotify(covariant PaginationConfig<T, M> oldWidget) =>
      this != oldWidget;
}
// =====================================================================================
// CORE PAGINATION WIDGET
// =====================================================================================

/// A ready-to-use pagination widget that wires:
///  • [PaginationConfig] inheritance
///  • [CorePaginationCubit] state management
///  • Pull-to-refresh and load-more via [EasyRefresh]
///  • Skeleton loading or custom loader
///  • Error handling with retry
///  • Optional scroll-to-top FAB
///
/// Supply either [scrollableBuilder] or [sliversBuilder]. All other parameters are optional.
class CorePaginationWidget<T extends Identifiable, M extends MetaModel>
    extends StatefulWidget {
  /// Creates a pagination wrapper. Exactly one builder must be provided.
  const CorePaginationWidget({
    super.key,
    this.scrollableBuilder,
    this.sliversBuilder,
    this.paginationFunction,
    this.paginationStrategy,
    this.paginationCubit,
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
       ),
       assert(
         (paginationCubit != null) ||
             (paginationFunction != null && paginationStrategy != null),
         'Either paginationCubit or both paginationFunction and paginationStrategy must be provided',
       ),
       assert(
         loadingBuilder != null || emptyEntity != null,
         'If loadingBuilder is not provided, emptyEntity MUST be provided for Skeletonizer.',
       );

  final CorePaginationCubit<T, M>? paginationCubit;

  /// Builder for classic ScrollView mode.
  final Widget Function(
    BuildContext,
    PaginationResponseModel<T, M>,
    ScrollController?,
  )?
  scrollableBuilder;

  /// Builder for Sliver mode.
  final List<Widget> Function(
    BuildContext,
    PaginationResponseModel<T, M>,
    ScrollController?,
  )?
  sliversBuilder;

  /// Function to fetch data pages.
  final UseCaseFutureResponse<PaginationResponseModel<T, M>> Function(
    int batch,
    int limit, {
    String? requestId,
  })?
  paginationFunction;

  /// Defines page size and thresholds.
  final PaginationStrategy? paginationStrategy;

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
  /// Takes BuildContext only (EasyRefresh handles state internally).
  /// Must return a Header widget (e.g., MaterialHeader, ClassicHeader).
  final Header Function(BuildContext)? headerBuilder;

  /// Custom load-more footer.
  /// Takes BuildContext only (EasyRefresh handles state internally).
  /// Must return a Footer widget (e.g., MaterialFooter, ClassicFooter).
  final Footer Function(BuildContext)? footerBuilder;

  /// Number of skeleton placeholders.
  final int? skeletonItemCount;

  /// Prototype entity for skeleton.
  final T? emptyEntity;

  /// Show scroll-to-top FAB.
  final bool enableScrollToTop;

  @override
  State<CorePaginationWidget<T, M>> createState() =>
      _CorePaginationWidgetState<T, M>();
}

class _CorePaginationWidgetState<T extends Identifiable, M extends MetaModel>
    extends State<CorePaginationWidget<T, M>> {
  late final CorePaginationCubit<T, M> _cubit;

  @override
  void initState() {
    super.initState();
    if (widget.paginationCubit != null) {
      _cubit = widget.paginationCubit!;
    } else {
      if (widget.paginationFunction == null ||
          widget.paginationStrategy == null) {
        throw FlutterError(
          'Either paginationCubit or both paginationFunction and paginationStrategy must be provided.',
        );
      }
      _cubit = CorePaginationCubit<T, M>(
        paginationFunction: widget.paginationFunction!,
        paginationStrategy: widget.paginationStrategy!,
        reverse: widget.reverse,
      );
    }
    _cubit.fetchInitialData();
  }

  @override
  void didUpdateWidget(covariant CorePaginationWidget<T, M> old) {
    super.didUpdateWidget(old);

    if (old.paginationFunction != widget.paginationFunction &&
        widget.paginationFunction != null) {
      _cubit.updatePaginationFunction(widget.paginationFunction!);
    }
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PaginationConfig<T, M>(
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
          return BlocProvider<CorePaginationCubit<T, M>>.value(
            value: _cubit,
            child: _PaginationContent<T, M>(),
          );
        },
      ),
    );
  }
}

class _PaginationContent<T extends Identifiable, M extends MetaModel>
    extends StatelessWidget {
  const _PaginationContent();

  @override
  Widget build(BuildContext context) {
    // OPTIMIZATION: Removed redundant BlocBuilder - enableScrollToTop is static config
    // Children handle their own state listening
    final config = PaginationConfig.of<T, M>(context);
    return config.enableScrollToTop
        ? CoreScrollableContentWithFab(
            scrollableBuilder: (controller) =>
                _EasyRefreshWidget<T, M>(controller: controller),
          )
        : _EasyRefreshWidget<T, M>();
  }
}

/// EasyRefresh wrapper widget with optimized rebuilds.
///
/// Uses BlocSelector to only rebuild when hasReachedMax changes,
/// which affects whether load-more is enabled.
class _EasyRefreshWidget<T extends Identifiable, M extends MetaModel>
    extends StatelessWidget {
  const _EasyRefreshWidget({this.controller});

  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    final config = PaginationConfig.of<T, M>(context);
    final cubit = context.read<CorePaginationCubit<T, M>>();

    // OPTIMIZATION: BlocSelector prevents rebuilds on every state change
    // Only rebuilds when hasReachedMax changes (affects enableLoadMore)
    return BlocSelector<
      CorePaginationCubit<T, M>,
      CorePaginationState<T, M>,
      bool
    >(
      selector: (state) => state.hasReachedMax,
      builder: (context, hasReachedMax) {
        return EasyRefresh(
          onRefresh: config.showRefreshIndicator
              ? () async => await cubit.fetchInitialData()
              : null,
          onLoad: hasReachedMax
              ? null // Passing null automatically disables the footer
              : () async => await cubit.fetchMoreData(),
          header: config.headerBuilder?.call(context) ?? const MaterialHeader(),
          footer: config.footerBuilder?.call(context) ?? const MaterialFooter(),
          // EasyRefresh doesn't require direct ScrollView child - can wrap any widget
          child: _PaginationBody<T, M>(controller: controller),
        );
      },
    );
  }
}

/// Extracted widget to isolate state listening and prevent unnecessary rebuilds.
class _PaginationBody<T extends Identifiable, M extends MetaModel>
    extends StatelessWidget {
  const _PaginationBody({this.controller});

  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CorePaginationCubit<T, M>>().state;
    return switch (state) {
      PaginationSucceeded<T, M>(paginatedResponseModel: final items) =>
        buildPaginated(context, items, controller),
      PaginationFailed<T, M>(
        :final failure,
        paginatedResponseModel: final items,
        :final retryFunction,
      ) =>
        errorStateWidget(context, items, failure, retryFunction),
      _ => _LoadingStateWidget<T, M>(scrollController: controller),
    };
  }

  /// Builds the UI for a successful data load (or partial load with existing items).
  ///
  /// - If [paginatedResponseModel] is empty, renders [PaginationConfig.emptyBuilder] or default empty.
  /// - If [sliversBuilder] is provided, wraps slivers in a [CustomScrollView].
  /// - Otherwise uses [scrollableBuilder].
  Widget buildPaginated(
    BuildContext ctx,
    PaginationResponseModel<T, M> model,
    ScrollController? ctrl,
  ) {
    final cfg = PaginationConfig.of<T, M>(ctx);
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
    PaginationResponseModel<T, M> model,
    Failure failure,
    VoidCallback? retryFunction,
  ) {
    final config = PaginationConfig.of<T, M>(context);

    if (config.errorBuilder != null) {
      // OPTIMIZATION: Lazy evaluation - only build if needed
      Widget? cachedPaginatedWidget;
      return config.errorBuilder!(
        context,
        failure,
        retryFunction,
        cachedPaginatedWidget ??= buildPaginated(context, model, controller),
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

/// Loading state widget with optimized skeleton caching.
///
/// Uses StatefulWidget to cache skeleton placeholders and prevent
/// regeneration on every rebuild. Cache survives theme changes safely.
class _LoadingStateWidget<T extends Identifiable, M extends MetaModel>
    extends StatefulWidget {
  const _LoadingStateWidget({super.key, this.scrollController});

  final ScrollController? scrollController;

  @override
  State<_LoadingStateWidget<T, M>> createState() =>
      _LoadingStateWidgetState<T, M>();
}

class _LoadingStateWidgetState<T extends Identifiable, M extends MetaModel>
    extends State<_LoadingStateWidget<T, M>> {
  // OPTIMIZATION: Cache placeholders in State (safe, type-specific per instance)
  // Nullable to handle didChangeDependencies being called multiple times (theme changes)
  PaginationResponseModel<T, M>? _cachedPlaceholders;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Only generate if null (prevents LateInitializationError on theme changes)
    if (_cachedPlaceholders == null) {
      final cfg = PaginationConfig.of<T, M>(context);
      final cubit = context.read<CorePaginationCubit<T, M>>();

      _cachedPlaceholders = PaginationResponseModel<T, M>(
        data: List<T>.generate(
          cfg.skeletonItemCount ?? cubit.paginationStrategy.limit,
          (_) => cfg
              .emptyEntity!, // Safe: assertion guarantees non-null if loadingBuilder is null
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cfg = PaginationConfig.of<T, M>(context);

    if (cfg.loadingBuilder != null) {
      return cfg.loadingBuilder!(context);
    }

    // Fallback initialization if didChangeDependencies hasn't run yet
    _cachedPlaceholders ??= PaginationResponseModel<T, M>(
      data: List<T>.generate(
        cfg.skeletonItemCount ?? 20, // Fallback count
        (_) => cfg.emptyEntity!,
      ),
    );

    // CORRECTNESS: We MUST call the builder for Skeletonizer to work properly
    Widget skeletonChild;
    if (cfg.sliversBuilder != null) {
      skeletonChild = CustomScrollView(
        scrollDirection: cfg.scrollDirection,
        reverse: cfg.reverse,
        physics:
            const NeverScrollableScrollPhysics(), // Disable scrolling during loading
        slivers: cfg.sliversBuilder!(
          context,
          _cachedPlaceholders!,
          widget.scrollController,
        ),
      );
    } else {
      skeletonChild = cfg.scrollableBuilder!(
        context,
        _cachedPlaceholders!,
        widget.scrollController,
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

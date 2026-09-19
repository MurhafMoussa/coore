import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:strata_core/strata_core.dart';

import '../constants/padding_manager.dart';
import '../widgets/core_default_error_widget.dart';
import '../widgets/core_scrollable_content_with_fab.dart';

class PaginationConfig<T extends Identifiable, M extends MetaModel>
    extends InheritedWidget {
  const PaginationConfig({
    super.key,
    this.scrollableBuilder,
    this.sliversBuilder,
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

  final Widget Function(
    BuildContext context,
    PaginationResponseModel<T, M> items,
    ScrollController? controller,
  )? scrollableBuilder;

  final List<Widget> Function(
    BuildContext context,
    PaginationResponseModel<T, M> items,
    ScrollController? controller,
  )? sliversBuilder;

  final PaginationStrategy? paginationStrategy;
  final bool reverse;
  final Axis scrollDirection;
  final ScrollPhysics? physics;
  final Widget Function(BuildContext context)? loadingBuilder;
  final Widget Function(BuildContext context)? emptyBuilder;
  final Widget Function(
    BuildContext context,
    Failure failure,
    VoidCallback? retry,
    Widget alreadyFetchedItemsWidget,
  )? errorBuilder;

  final bool showRefreshIndicator;
  final Header Function(BuildContext context)? headerBuilder;
  final Footer Function(BuildContext context)? footerBuilder;
  final int? skeletonItemCount;
  final T? emptyEntity;
  final bool enableScrollToTop;

  static PaginationConfig<T, M> of<T extends Identifiable, M extends MetaModel>(
    BuildContext context,
  ) {
    final cfg =
        context.dependOnInheritedWidgetOfExactType<PaginationConfig<T, M>>();
    assert(cfg != null, 'No PaginationConfig<$T> found in context');
    return cfg!;
  }

  @override
  bool updateShouldNotify(covariant PaginationConfig<T, M> oldWidget) =>
      this != oldWidget;
}

class CorePaginationWidget<T extends Identifiable, M extends MetaModel>
    extends StatefulWidget {
  const CorePaginationWidget({
    super.key,
    this.scrollableBuilder,
    this.sliversBuilder,
    this.items,
    this.isLoading = false,
    this.hasReachedMax = false,
    this.failure,
    this.onRefresh,
    this.onLoadMore,
    this.onRetry,
    this.onFetchPage,
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
  })  : assert(
          (scrollableBuilder != null) ^ (sliversBuilder != null),
          'Provide exactly one of scrollableBuilder or sliversBuilder',
        ),
        assert(
          loadingBuilder != null || emptyEntity != null,
          'If loadingBuilder is not provided, emptyEntity MUST be provided for Skeletonizer.',
        );

  final Widget Function(
    BuildContext context,
    PaginationResponseModel<T, M> items,
    ScrollController? controller,
  )? scrollableBuilder;

  final List<Widget> Function(
    BuildContext context,
    PaginationResponseModel<T, M> items,
    ScrollController? controller,
  )? sliversBuilder;

  final PaginationResponseModel<T, M>? items;
  final bool isLoading;
  final bool hasReachedMax;
  final Failure? failure;
  final Future<void> Function()? onRefresh;
  final Future<void> Function()? onLoadMore;
  final VoidCallback? onRetry;

  final Future<PaginationResponseModel<T, M>> Function(int page, int limit)?
      onFetchPage;
  final PaginationStrategy? paginationStrategy;

  final bool reverse;
  final Widget Function(BuildContext context)? loadingBuilder;
  final Widget Function(
    BuildContext context,
    Failure failure,
    VoidCallback? retry,
    Widget alreadyFetchedItemsWidget,
  )? errorBuilder;
  final Widget Function(BuildContext context)? emptyBuilder;
  final Axis scrollDirection;
  final ScrollPhysics? physics;
  final bool showRefreshIndicator;
  final Header Function(BuildContext context)? headerBuilder;
  final Footer Function(BuildContext context)? footerBuilder;
  final int? skeletonItemCount;
  final T? emptyEntity;
  final bool enableScrollToTop;

  @override
  State<CorePaginationWidget<T, M>> createState() =>
      _CorePaginationWidgetState<T, M>();
}

class _CorePaginationWidgetState<T extends Identifiable, M extends MetaModel>
    extends State<CorePaginationWidget<T, M>> {
  PaginationResponseModel<T, M>? _internalItems;
  bool _internalIsLoading = false;
  bool _internalHasReachedMax = false;
  Failure? _internalFailure;
  late final PaginationStrategy _strategy;

  @override
  void initState() {
    super.initState();
    _strategy = widget.paginationStrategy ?? PagePaginationStrategy();
    if (widget.onFetchPage != null && widget.items == null) {
      _fetchInitialInternal();
    }
  }

  Future<void> _fetchInitialInternal() async {
    setState(() {
      _internalIsLoading = true;
      _internalFailure = null;
    });
    _strategy.reset();
    try {
      final res = await widget.onFetchPage!(_strategy.nextBatch, _strategy.limit);
      setState(() {
        _internalItems = res;
        _internalIsLoading = false;
        _internalHasReachedMax = res.data.length < _strategy.limit;
      });
      _strategy.increment();
    } catch (e) {
      setState(() {
        _internalIsLoading = false;
        _internalFailure = ServerFailure(message: e.toString(), statusCode: 500);
      });
    }
  }

  Future<void> _fetchMoreInternal() async {
    if (_internalHasReachedMax || _internalIsLoading || widget.onFetchPage == null) {
      return;
    }
    try {
      final res = await widget.onFetchPage!(_strategy.nextBatch, _strategy.limit);
      setState(() {
        final currentData = _internalItems?.data ?? <T>[];
        final combined = [...currentData, ...res.data];
        _internalItems = PaginationResponseModel<T, M>(data: combined, meta: res.meta);
        _internalHasReachedMax = res.data.length < _strategy.limit;
      });
      _strategy.increment();
    } catch (e) {
      // Error loading more
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveItems = widget.items ?? _internalItems;
    final effectiveIsLoading =
        widget.items != null ? widget.isLoading : _internalIsLoading;
    final effectiveHasReachedMax =
        widget.items != null ? widget.hasReachedMax : _internalHasReachedMax;
    final effectiveFailure = widget.failure ?? _internalFailure;

    final effectiveOnRefresh = widget.onRefresh ??
        (widget.onFetchPage != null ? _fetchInitialInternal : null);
    final effectiveOnLoadMore = widget.onLoadMore ??
        (widget.onFetchPage != null ? _fetchMoreInternal : null);
    final effectiveOnRetry = widget.onRetry ??
        (widget.onFetchPage != null ? _fetchInitialInternal : null);

    return PaginationConfig<T, M>(
      scrollableBuilder: widget.scrollableBuilder,
      sliversBuilder: widget.sliversBuilder,
      paginationStrategy: _strategy,
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
      child: _PaginationContent<T, M>(
        items: effectiveItems,
        isLoading: effectiveIsLoading,
        hasReachedMax: effectiveHasReachedMax,
        failure: effectiveFailure,
        onRefresh: effectiveOnRefresh,
        onLoadMore: effectiveOnLoadMore,
        onRetry: effectiveOnRetry,
      ),
    );
  }
}

class _PaginationContent<T extends Identifiable, M extends MetaModel>
    extends StatelessWidget {
  const _PaginationContent({
    required this.items,
    required this.isLoading,
    required this.hasReachedMax,
    required this.failure,
    required this.onRefresh,
    required this.onLoadMore,
    required this.onRetry,
  });

  final PaginationResponseModel<T, M>? items;
  final bool isLoading;
  final bool hasReachedMax;
  final Failure? failure;
  final Future<void> Function()? onRefresh;
  final Future<void> Function()? onLoadMore;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final config = PaginationConfig.of<T, M>(context);
    final childWidget = _EasyRefreshWidget<T, M>(
      items: items,
      isLoading: isLoading,
      hasReachedMax: hasReachedMax,
      failure: failure,
      onRefresh: onRefresh,
      onLoadMore: onLoadMore,
      onRetry: onRetry,
    );

    return config.enableScrollToTop
        ? CoreScrollableContentWithFab(
            scrollableBuilder: (controller) => _EasyRefreshWidget<T, M>(
              items: items,
              isLoading: isLoading,
              hasReachedMax: hasReachedMax,
              failure: failure,
              onRefresh: onRefresh,
              onLoadMore: onLoadMore,
              onRetry: onRetry,
              controller: controller,
            ),
          )
        : childWidget;
  }
}

class _EasyRefreshWidget<T extends Identifiable, M extends MetaModel>
    extends StatelessWidget {
  const _EasyRefreshWidget({
    required this.items,
    required this.isLoading,
    required this.hasReachedMax,
    required this.failure,
    required this.onRefresh,
    required this.onLoadMore,
    required this.onRetry,
    this.controller,
  });

  final PaginationResponseModel<T, M>? items;
  final bool isLoading;
  final bool hasReachedMax;
  final Failure? failure;
  final Future<void> Function()? onRefresh;
  final Future<void> Function()? onLoadMore;
  final VoidCallback? onRetry;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    final config = PaginationConfig.of<T, M>(context);

    return EasyRefresh(
      onRefresh: config.showRefreshIndicator ? onRefresh : null,
      onLoad: hasReachedMax ? null : onLoadMore,
      header: config.headerBuilder?.call(context) ?? const MaterialHeader(),
      footer: config.footerBuilder?.call(context) ?? const MaterialFooter(),
      child: _PaginationBody<T, M>(
        items: items,
        isLoading: isLoading,
        failure: failure,
        onRetry: onRetry,
        controller: controller,
      ),
    );
  }
}

class _PaginationBody<T extends Identifiable, M extends MetaModel>
    extends StatelessWidget {
  const _PaginationBody({
    required this.items,
    required this.isLoading,
    required this.failure,
    required this.onRetry,
    this.controller,
  });

  final PaginationResponseModel<T, M>? items;
  final bool isLoading;
  final Failure? failure;
  final VoidCallback? onRetry;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    if (isLoading && (items == null || items!.data.isEmpty)) {
      return _LoadingStateWidget<T, M>(scrollController: controller);
    }

    if (failure != null && (items == null || items!.data.isEmpty)) {
      return errorStateWidget(context, failure!, onRetry);
    }

    if (items != null) {
      return buildPaginated(context, items!, controller);
    }

    return _LoadingStateWidget<T, M>(scrollController: controller);
  }

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
    Failure failure,
    VoidCallback? retryFunction,
  ) {
    final config = PaginationConfig.of<T, M>(context);

    if (config.errorBuilder != null) {
      final dummyModel = PaginationResponseModel<T, M>(data: const []);
      return config.errorBuilder!(
        context,
        failure,
        retryFunction,
        buildPaginated(context, dummyModel, controller),
      );
    }

    return CoreDefaultErrorWidget(
      message: failure.message,
      onRetry: retryFunction,
    );
  }
}

class _LoadingStateWidget<T extends Identifiable, M extends MetaModel>
    extends StatefulWidget {
  const _LoadingStateWidget({this.scrollController});

  final ScrollController? scrollController;

  @override
  State<_LoadingStateWidget<T, M>> createState() =>
      _LoadingStateWidgetState<T, M>();
}

class _LoadingStateWidgetState<T extends Identifiable, M extends MetaModel>
    extends State<_LoadingStateWidget<T, M>> {
  PaginationResponseModel<T, M>? _cachedPlaceholders;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_cachedPlaceholders == null) {
      final cfg = PaginationConfig.of<T, M>(context);
      _cachedPlaceholders = PaginationResponseModel<T, M>(
        data: List<T>.generate(
          cfg.skeletonItemCount ?? cfg.paginationStrategy?.limit ?? 20,
          (_) => cfg.emptyEntity!,
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

    _cachedPlaceholders ??= PaginationResponseModel<T, M>(
      data: List<T>.generate(
        cfg.skeletonItemCount ?? 20,
        (_) => cfg.emptyEntity!,
      ),
    );

    Widget skeletonChild;
    if (cfg.sliversBuilder != null) {
      skeletonChild = CustomScrollView(
        scrollDirection: cfg.scrollDirection,
        reverse: cfg.reverse,
        physics: const NeverScrollableScrollPhysics(),
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

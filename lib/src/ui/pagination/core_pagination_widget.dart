import 'package:coore/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// {@category Pagination}
/// {@template pagination_config}
/// Inherited widget that provides pagination configuration to descendant widgets.
/// 
/// Contains all customizable parameters for pagination behavior and UI components.
/// {@endtemplate}
class PaginationConfig<T extends Identifiable> extends InheritedWidget {
  /// {@macro pagination_config}
  const PaginationConfig({
    super.key,
    required this.scrollableBuilder,
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
  });

  /// {@template scrollable_builder}
  /// Builder function for creating the main scrollable content.
  /// 
  /// Parameters:
  /// - [context]: Build context
  /// - [items]: List of currently loaded items
  /// - [scrollController]: Controller attached to the scroll view
  /// 
  /// Must return a ScrollView (ListView, GridView, CustomScrollView, etc.)
  /// {@endtemplate}
  final Widget Function(
    BuildContext context,
    List<T> items,
    ScrollController? scrollController,
  ) scrollableBuilder;

  /// {@template pagination_function}
  /// Data fetching function for paginated results.
  /// 
  /// Parameters:
  /// - [batch]: Current page/batch number (1-based)
  /// - [limit]: Number of items per page
  /// 
  /// Returns Future containing either the item list or failure
  /// {@endtemplate}
  final UseCaseFutureResponse<List<T>> Function(int batch, int limit)
      paginationFunction;

  /// {@template pagination_strategy}
  /// Determines pagination behavior and loading thresholds
  /// {@endtemplate}
  final PaginationStrategy paginationStrategy;

  /// {@template reverse_scroll}
  /// Whether to reverse the scroll direction (bottom-to-top/right-to-left)
  /// {@endtemplate}
  final bool reverse;

  /// {@template loading_builder}
  /// Custom loading indicator builder.
  /// 
  /// If null, shows skeletonized version of the scrollable content
  /// {@endtemplate}
  final Widget Function(BuildContext context)? loadingBuilder;

  /// {@template error_builder}
  /// Custom error state builder.
  /// 
  /// Parameters:
  /// - [context]: Build context
  /// - [failure]: Error information
  /// - [retry]: Retry callback function
  /// - [alreadyFetchedItemsWidget]: Widget showing previously loaded items
  /// {@endtemplate}
  final Widget Function(
    BuildContext context,
    Failure failure,
    VoidCallback? retry,
    Widget alreadyFetchedItemsWidget,
  )? errorBuilder;

  /// {@template empty_builder}
  /// Custom empty state builder when no items are found
  /// {@endtemplate}
  final Widget Function(BuildContext context)? emptyBuilder;

  /// {@template scroll_direction}
  /// Axis direction for scrolling (vertical/horizontal)
  /// {@endtemplate}
  final Axis scrollDirection;

  /// {@template scroll_physics}
  /// Physics behavior for the scroll view
  /// {@endtemplate}
  final ScrollPhysics? physics;


  /// {@template show_refresh_indicator}
  /// Whether to enable pull-to-refresh functionality
  /// {@endtemplate}
  final bool showRefreshIndicator;

  /// {@template header_builder}
  /// Custom header widget for the SmartRefresher
  /// 
  /// Defaults to ClassicHeader if not provided
  /// {@endtemplate}
  final Widget Function(BuildContext context, RefreshController controller)?
      headerBuilder;

  /// {@template footer_builder}
  /// Custom footer widget for the SmartRefresher
  /// 
  /// Defaults to ClassicFooter if not provided
  /// {@endtemplate}
  final Widget Function(BuildContext context, RefreshController controller)?
      footerBuilder;

  /// {@template skeleton_item_count}
  /// Number of skeleton items to show during loading.
  /// 
  /// If null, uses the pagination strategy's limit
  /// {@endtemplate}
  final int? skeletonItemCount;

  /// {@template empty_entity}
  /// Prototype entity used for skeleton loading visualization
  /// 
  /// Required if loadingBuilder is not provided
  /// {@endtemplate}
  final T? emptyEntity;

  /// {@template enable_scroll_to_top}
  /// Whether to show a floating button for scrolling to top
  /// {@endtemplate}
  final bool enableScrollToTop;

  /// {@macro pagination_config.of}
  static PaginationConfig<T> of<T extends Identifiable>(BuildContext context) {
    final config =
        context.dependOnInheritedWidgetOfExactType<PaginationConfig<T>>();
    assert(config != null, 'No PaginationConfig found in context');
    return config!;
  }

  @override
  bool updateShouldNotify(PaginationConfig<T> oldWidget) {
    return scrollableBuilder != oldWidget.scrollableBuilder ||
        paginationFunction != oldWidget.paginationFunction ||
        paginationStrategy != oldWidget.paginationStrategy ||
        reverse != oldWidget.reverse ||
        loadingBuilder != oldWidget.loadingBuilder ||
        errorBuilder != oldWidget.errorBuilder ||
        emptyBuilder != oldWidget.emptyBuilder ||
        scrollDirection != oldWidget.scrollDirection ||
        physics != oldWidget.physics ||
        
        showRefreshIndicator != oldWidget.showRefreshIndicator ||
        headerBuilder != oldWidget.headerBuilder ||
        footerBuilder != oldWidget.footerBuilder ||
        skeletonItemCount != oldWidget.skeletonItemCount ||
        emptyEntity != oldWidget.emptyEntity ||
        enableScrollToTop != oldWidget.enableScrollToTop;
  }
}

/// {@category Pagination}
/// {@template core_pagination_widget}
/// Main pagination widget that orchestrates all pagination functionality.
/// 
/// Wraps content in a [PaginationConfig] and provides [CorePaginationCubit].
/// 
/// {@tool snippet}
/// Basic usage example:
/// ```dart
/// CorePaginationWidget<Product>(
///   scrollableBuilder: (context, items, controller) => ListView.builder(
///     controller: controller,
///     itemCount: items.length,
///     itemBuilder: (_, index) => ProductItem(item: items[index]),
///   ),
///   paginationFunction: (batch, limit) => usecase.getProducts(batch, limit),
///   paginationStrategy: const PageBasedStrategy(limit: 20),
///   emptyEntity: Product.empty(),
/// )
/// ```
/// {@end-tool}
/// {@endtemplate}
class CorePaginationWidget<T extends Identifiable> extends StatelessWidget {
  /// {@macro core_pagination_widget}
  const CorePaginationWidget({
    super.key,
    required this.scrollableBuilder,
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
          emptyEntity != null || loadingBuilder != null,
          'You must provide either empty entity or a loading builder',
        );

  
  /// {@template scrollable_builder}
  /// Builder function for creating the main scrollable content.
  /// 
  /// Parameters:
  /// - [context]: Build context
  /// - [items]: List of currently loaded items
  /// - [scrollController]: Controller attached to the scroll view
  /// 
  /// Must return a ScrollView (ListView, GridView, CustomScrollView, etc.)
  /// {@endtemplate}
  final Widget Function(
    BuildContext context,
    List<T> items,
    ScrollController? scrollController,
  ) scrollableBuilder;

  /// {@template pagination_function}
  /// Data fetching function for paginated results.
  /// 
  /// Parameters:
  /// - [batch]: Current page/batch number (1-based)
  /// - [limit]: Number of items per page
  /// 
  /// Returns Future containing either the item list or failure
  /// {@endtemplate}
  final UseCaseFutureResponse<List<T>> Function(int batch, int limit)
      paginationFunction;

  /// {@template pagination_strategy}
  /// Determines pagination behavior and loading thresholds
  /// {@endtemplate}
  final PaginationStrategy paginationStrategy;

  /// {@template reverse_scroll}
  /// Whether to reverse the scroll direction (bottom-to-top/right-to-left)
  /// {@endtemplate}
  final bool reverse;

  /// {@template loading_builder}
  /// Custom loading indicator builder.
  /// 
  /// If null, shows skeletonized version of the scrollable content
  /// {@endtemplate}
  final Widget Function(BuildContext context)? loadingBuilder;

  /// {@template error_builder}
  /// Custom error state builder.
  /// 
  /// Parameters:
  /// - [context]: Build context
  /// - [failure]: Error information
  /// - [retry]: Retry callback function
  /// - [alreadyFetchedItemsWidget]: Widget showing previously loaded items
  /// {@endtemplate}
  final Widget Function(
    BuildContext context,
    Failure failure,
    VoidCallback? retry,
    Widget alreadyFetchedItemsWidget,
  )? errorBuilder;

  /// {@template empty_builder}
  /// Custom empty state builder when no items are found
  /// {@endtemplate}
  final Widget Function(BuildContext context)? emptyBuilder;

  /// {@template scroll_direction}
  /// Axis direction for scrolling (vertical/horizontal)
  /// {@endtemplate}
  final Axis scrollDirection;

  /// {@template scroll_physics}
  /// Physics behavior for the scroll view
  /// {@endtemplate}
  final ScrollPhysics? physics;



  /// {@template show_refresh_indicator}
  /// Whether to enable pull-to-refresh functionality
  /// {@endtemplate}
  final bool showRefreshIndicator;

  /// {@template header_builder}
  /// Custom header widget for the SmartRefresher
  /// 
  /// Defaults to ClassicHeader if not provided
  /// {@endtemplate}
  final Widget Function(BuildContext context, RefreshController controller)?
      headerBuilder;

  /// {@template footer_builder}
  /// Custom footer widget for the SmartRefresher
  /// 
  /// Defaults to ClassicFooter if not provided
  /// {@endtemplate}
  final Widget Function(BuildContext context, RefreshController controller)?
      footerBuilder;

  /// {@template skeleton_item_count}
  /// Number of skeleton items to show during loading.
  /// 
  /// If null, uses the pagination strategy's limit
  /// {@endtemplate}
  final int? skeletonItemCount;

  /// {@template empty_entity}
  /// Prototype entity used for skeleton loading visualization
  /// 
  /// Required if loadingBuilder is not provided
  /// {@endtemplate}
  final T? emptyEntity;

  /// {@template enable_scroll_to_top}
  /// Whether to show a floating button for scrolling to top
  /// {@endtemplate}
  final bool enableScrollToTop;

  @override
  Widget build(BuildContext context) {
    return PaginationConfig<T>(
      scrollableBuilder: scrollableBuilder,
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
              final element = context.getElementForInheritedWidgetOfExactType<PaginationConfig<T>>();
              assert(element != null, 'No PaginationConfig found in context');
              final config = element!.widget as PaginationConfig<T>;
              
              return CorePaginationCubit<T>(
                paginationFunction: config.paginationFunction,
                paginationStrategy: config.paginationStrategy,
                reverse: config.reverse,
              )..fetchInitialData();
            },
            child:  _PaginationContent<T>(),
          );
        },
      ),
    );
  }
}

/// {@nodoc}
/// {@template pagination_content}
/// Private widget that handles scroll-to-top functionality and state management.
/// 
/// Decides whether to show scroll-to-top FAB based on configuration.
/// {@endtemplate}
class _PaginationContent<T extends Identifiable> extends StatelessWidget {
  /// {@macro pagination_content}
  const _PaginationContent();

  @override
  Widget build(BuildContext context) {
    final config = PaginationConfig.of<T>(context);
    return BlocBuilder<CorePaginationCubit<T>, CorePaginationState<T>>(
      builder: (context, state) {
        return config.enableScrollToTop
            ? CoreScrollableContentWithFab(
                scrollableBuilder: (controller) => _SmartRefresherWidget<T>(
                  controller: controller,
                ),
              )
            : _SmartRefresherWidget<T>();
      },
    );
  }
}

/// {@nodoc}
/// {@template smart_refresher_widget}
/// Wrapper widget that integrates pull-to-refresh functionality.
/// 
/// Uses the SmartRefresher package to handle refresh gestures and pagination.
/// {@endtemplate}
class _SmartRefresherWidget<T extends Identifiable> extends StatelessWidget {
  /// {@macro smart_refresher_widget}
  const _SmartRefresherWidget({this.controller});

  /// Optional external scroll controller
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
      header: config.headerBuilder?.call(context, cubit.refreshController) ,
      footer: config.footerBuilder?.call(context, cubit.refreshController) 
         , 
      child: _contentBuilder(context),
    );
  }
  Widget  _contentBuilder(BuildContext context){
 final state = context.watch<CorePaginationCubit<T>>().state;
    return switch (state) {
      PaginationSucceeded<T>(:final items) =>successStateWidget(
          context,items,
        ),
      PaginationFailed<T>(:final failure, :final items, :final retryFunction) =>
        errorStateWidget(
        context,items,failure,retryFunction,
        ),
      _ => _LoadingStateWidget<T>(scrollController: controller),
    };

  }/// {@nodoc}
/// {@template error_state}
/// Handles error display while potentially showing already loaded items.
/// 
/// Prioritizes custom error builder if provided, falls back to default error UI.
/// {@endtemplate}
  Widget successStateWidget(BuildContext context,List<T> items){
    final config = PaginationConfig.of<T>(context);

    if (items.isEmpty) {
      return config.emptyBuilder?.call(context) ?? const _EmptyState();
    }

    final scrollableWidget = config.scrollableBuilder(
      context,
      items,
      controller,
    );
    assert(
      scrollableWidget is ScrollView,
      'Scrollable builder must return GridView, ListView, or Slivers',
    );
    return scrollableWidget;
  }  
/// {@nodoc}
/// {@template error_state}
/// Handles error display while potentially showing already loaded items.
/// 
/// Prioritizes custom error builder if provided, falls back to default error UI.
/// {@endtemplate}
  Widget errorStateWidget(BuildContext context,List<T> items,Failure failure,VoidCallback? retryFunction){
     final config = PaginationConfig.of<T>(context);

    if (config.errorBuilder != null) {
      return config.errorBuilder!(
        context,
        failure,
        retryFunction,
        config.scrollableBuilder(context, items, controller),
      );
    }

    if (items.isNotEmpty) {
      return config.scrollableBuilder(context, items, controller);
    }

    return  CoreDefaultErrorWidget(message: failure.message,onRetry: retryFunction,);
  }
}







/// {@nodoc}
/// {@template loading_state}
/// Shows loading state using either custom loading builder or skeletonized items.
/// {@endtemplate}
class _LoadingStateWidget<T extends Identifiable> extends StatelessWidget {
  /// {@macro loading_state}
  const _LoadingStateWidget({super.key, this.scrollController});

  /// Scroll controller
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    final config = PaginationConfig.of<T>(context);
    final cubit = context.read<CorePaginationCubit<T>>();
    if (config.loadingBuilder != null) return config.loadingBuilder!(context);

    return Skeletonizer(
      child: config.scrollableBuilder(
        context,
        List<T>.generate(
          config.skeletonItemCount ?? cubit.paginationStrategy.limit,
          (index) => config.emptyEntity!,
        ),
        scrollController,
      ),
    );
  }
}

/// {@nodoc}
/// {@template empty_state}
/// Default empty state shown when no items are available.
/// 
/// Displays an icon with "No items found" message.
/// {@endtemplate}
class _EmptyState extends StatelessWidget {
  /// {@macro empty_state}
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
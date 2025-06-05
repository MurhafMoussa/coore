import 'package:carousel_slider/carousel_slider.dart';
import 'package:coore/src/ui/constants/animation_params_manager.dart';
import 'package:flutter/material.dart';

/// Internal enum to indicate the carousel type.
enum _CarouselType { normal, builder, separated }

/// {@template core_carousel}
/// A versatile carousel widget that supports three modes:
/// - Normal: Accepts a list of [children].
/// - Builder: Uses an [itemBuilder] and [itemCount] to build items dynamically.
/// - Separated: Uses an [itemBuilder] and a [separatorBuilder] to insert a widget
///   between items (mimicking ListView.separated).
///
/// This widget wraps the carousel_slider package with a more intuitive API and
/// additional features like spacing control and center item enlargement.
///
/// Example usage:
/// ```dart
/// // Basic usage with a list of widgets
/// CoreCarousel(
///   children: [
///     Image.network('https://example.com/image1.jpg'),
///     Image.network('https://example.com/image2.jpg'),
///     Image.network('https://example.com/image3.jpg'),
///   ],
///   height: 200,
///   itemsPerPage: 2, // Show 2 items per page
///   spacing: 8,
/// )
///
/// // Using the builder constructor with fractional viewport
/// CoreCarousel.builder(
///   itemCount: 10,
///   itemBuilder: (context, index, realIndex) =>
///     Container(
///       color: Colors.primaries[index % Colors.primaries.length],
///       child: Center(child: Text('Item $index')),
///     ),
///   viewportFraction: 0.8, // Each item takes 80% of the screen width
///   enlargeCenterItem: true,
/// )
/// ```
/// {@endtemplate}
class CoreCarousel extends StatelessWidget {
  /// {@macro core_carousel}
  ///
  /// Normal Constructor: Use this when you have a fixed list of child widgets.
  ///
  /// Parameters:
  /// * [children] - The list of widgets to display in the carousel.
  /// * [carouselController] - Optional controller to programmatically control the carousel.
  /// * [aspectRatio] - The aspect ratio of the carousel when [height] is not specified.
  /// * [height] - The fixed height of the carousel. Takes precedence over [aspectRatio].
  /// * [itemsPerPage] - Number of items to show per page (integer). Cannot be used with [viewportFraction].
  /// * [viewportFraction] - The fraction of the viewport that each item should occupy (0.0 to 1.0). Cannot be used with [itemsPerPage].
  /// * [autoPlay] - Whether the carousel should automatically cycle through items.
  /// * [disableCenter] - Whether to disable centering of the active item.
  /// * [enableInfiniteScroll] - Whether the carousel should loop infinitely.
  /// * [margin] - The margin around the carousel.
  /// * [onPageChanged] - Callback when the active page changes.
  /// * [spacing] - The spacing between carousel items.
  /// * [enlargeCenterItem] - Whether to enlarge the center item.
  /// * [enlargeFactor] - How much to enlarge the center item (0.3 = 30% larger).
  const CoreCarousel({
    super.key,
    required List<Widget> this.children,
    this.carouselController,
    this.aspectRatio = 16 / 9,
    this.height,
    this.itemsPerPage,
    this.viewportFraction,
    this.autoPlay = true,
    this.disableCenter = true,
    this.enableInfiniteScroll = true,
    this.margin = EdgeInsets.zero,
    this.onPageChanged,
    this.spacing = 0,
    this.enlargeCenterItem = false,
    this.enlargeFactor = 0.3,
  }) : itemBuilder = null,
       separatorBuilder = null,
       itemCount = children.length,
       _carouselType = _CarouselType.normal,
       assert(
         (itemsPerPage == null) || (viewportFraction == null),
         'Either itemsPerPage or viewportFraction must be provided, but not both',
       ),
       assert(
         viewportFraction == null ||
             (viewportFraction > 0 && viewportFraction <= 1),
         'viewportFraction must be between 0 and 1',
       ),
       assert(
         itemsPerPage == null || itemsPerPage > 0,
         'itemsPerPage must be greater than 0',
       );

  /// Builder Constructor: Use this when you want to build items on-demand.
  ///
  /// Parameters:
  /// * [itemBuilder] - Function that builds each item with context, index, and realIndex.
  /// * [itemCount] - The total number of items in the carousel.
  /// * [carouselController] - Optional controller to programmatically control the carousel.
  /// * [aspectRatio] - The aspect ratio of the carousel when [height] is not specified.
  /// * [height] - The fixed height of the carousel. Takes precedence over [aspectRatio].
  /// * [itemsPerPage] - Number of items to show per page (integer). Cannot be used with [viewportFraction].
  /// * [viewportFraction] - The fraction of the viewport that each item should occupy (0.0 to 1.0). Cannot be used with [itemsPerPage].
  /// * [autoPlay] - Whether the carousel should automatically cycle through items.
  /// * [disableCenter] - Whether to disable centering of the active item.
  /// * [enableInfiniteScroll] - Whether the carousel should loop infinitely.
  /// * [margin] - The margin around the carousel.
  /// * [onPageChanged] - Callback when the active page changes.
  /// * [spacing] - The spacing between carousel items.
  /// * [enlargeCenterItem] - Whether to enlarge the center item.
  /// * [enlargeFactor] - How much to enlarge the center item (0.3 = 30% larger).
  const CoreCarousel.builder({
    super.key,
    required Widget Function(BuildContext context, int index, int realIndex)
    this.itemBuilder,
    required this.itemCount,
    this.carouselController,
    this.aspectRatio = 16 / 9,
    this.height,
    this.itemsPerPage,
    this.viewportFraction,
    this.autoPlay = true,
    this.disableCenter = true,
    this.enableInfiniteScroll = true,
    this.margin = EdgeInsets.zero,
    this.onPageChanged,
    this.spacing = 0,
    this.enlargeCenterItem = false,
    this.enlargeFactor = 0.3,
  }) : children = null,
       separatorBuilder = null,
       _carouselType = _CarouselType.builder,
       assert(
         (itemsPerPage == null) || (viewportFraction == null),
         'Either itemsPerPage or viewportFraction must be provided, but not both',
       ),
       assert(
         viewportFraction == null ||
             (viewportFraction > 0 && viewportFraction <= 1),
         'viewportFraction must be between 0 and 1',
       ),
       assert(
         itemsPerPage == null || itemsPerPage > 0,
         'itemsPerPage must be greater than 0',
       );

  /// Separated Constructor: Use this when you want to insert separators between items.
  ///
  /// Parameters:
  /// * [itemBuilder] - Function that builds each item with context, index, and realIndex.
  /// * [separatorBuilder] - Function that builds separators between items.
  /// * [itemCount] - The total number of items in the carousel (excluding separators).
  /// * [carouselController] - Optional controller to programmatically control the carousel.
  /// * [aspectRatio] - The aspect ratio of the carousel when [height] is not specified.
  /// * [height] - The fixed height of the carousel. Takes precedence over [aspectRatio].
  /// * [itemsPerPage] - Number of items to show per page (integer). Cannot be used with [viewportFraction].
  /// * [viewportFraction] - The fraction of the viewport that each item should occupy (0.0 to 1.0). Cannot be used with [itemsPerPage].
  /// * [autoPlay] - Whether the carousel should automatically cycle through items.
  /// * [disableCenter] - Whether to disable centering of the active item.
  /// * [enableInfiniteScroll] - Whether the carousel should loop infinitely.
  /// * [margin] - The margin around the carousel.
  /// * [onPageChanged] - Callback when the active page changes.
  /// * [spacing] - The spacing between carousel items.
  /// * [enlargeCenterItem] - Whether to enlarge the center item.
  /// * [enlargeFactor] - How much to enlarge the center item (0.3 = 30% larger).
  const CoreCarousel.separated({
    super.key,
    required Widget Function(BuildContext context, int index, int realIndex)
    this.itemBuilder,
    required Widget Function(BuildContext context, int index)
    this.separatorBuilder,
    required this.itemCount,
    this.carouselController,
    this.aspectRatio = 16 / 9,
    this.height,
    this.itemsPerPage,
    this.viewportFraction,
    this.autoPlay = true,
    this.disableCenter = true,
    this.enableInfiniteScroll = true,
    this.margin = EdgeInsets.zero,
    this.onPageChanged,
    this.spacing = 0,
    this.enlargeCenterItem = false,
    this.enlargeFactor = 0.3,
  }) : children = null,
       _carouselType = _CarouselType.separated,
       assert(
         (itemsPerPage == null) || (viewportFraction == null),
         'Either itemsPerPage or viewportFraction must be provided, but not both',
       ),
       assert(
         viewportFraction == null ||
             (viewportFraction > 0 && viewportFraction <= 1),
         'viewportFraction must be between 0 and 1',
       ),
       assert(
         itemsPerPage == null || itemsPerPage > 0,
         'itemsPerPage must be greater than 0',
       );

  /// Optional controller to programmatically control the carousel.
  final CarouselSliderController? carouselController;

  /// The aspect ratio of the carousel when [height] is not specified.
  final double aspectRatio;

  /// The fixed height of the carousel. Takes precedence over [aspectRatio].
  final double? height;

  /// Number of items to show per page (integer).
  /// Cannot be used with [viewportFraction].
  final int? itemsPerPage;

  /// The fraction of the viewport that each item should occupy (0.0 to 1.0).
  /// Cannot be used with [itemsPerPage].
  final double? viewportFraction;

  /// Whether the carousel should automatically cycle through items.
  final bool autoPlay;

  /// Whether to disable centering of the active item.
  final bool disableCenter;

  /// Whether the carousel should loop infinitely.
  final bool enableInfiniteScroll;

  /// The margin around the carousel.
  final EdgeInsets margin;

  /// Callback when the active page changes.
  final ValueSetter<int>? onPageChanged;

  /// The spacing between carousel items.
  /// This adds padding to each item, creating visual separation.
  final double spacing;

  /// Whether to enlarge the center item.
  /// When true, the center item will be larger than other items.
  final bool enlargeCenterItem;

  /// How much to enlarge the center item (0.3 = 30% larger).
  /// Only applies when [enlargeCenterItem] is true.
  final double enlargeFactor;

  // Mode-specific parameters
  /// The list of widgets to display in the carousel.
  /// Only used in the normal constructor.
  final List<Widget>? children;

  /// Function that builds each item with context, index, and realIndex.
  /// Used in builder and separated constructors.
  final Widget Function(BuildContext context, int index, int realIndex)?
  itemBuilder;

  /// Function that builds separators between items.
  /// Only used in the separated constructor.
  final Widget Function(BuildContext context, int index)? separatorBuilder;

  /// The total number of items in the carousel.
  final int itemCount;

  /// Internal enum to track which constructor was used.
  final _CarouselType _carouselType;

  // Calculate the effective item count based on carousel type
  int _getEffectiveItemCount() {
    switch (_carouselType) {
      case _CarouselType.normal:
      case _CarouselType.builder:
        return itemCount;
      case _CarouselType.separated:
        return itemCount * 2 - 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate the effective viewport fraction
    final effectiveViewportFraction =
        viewportFraction ?? (itemsPerPage != null ? 1.0 / itemsPerPage! : 1.0);
    return RepaintBoundary(
      child: Padding(
        padding: margin,
        child: CarouselSlider.builder(
          carouselController: carouselController,
          itemCount: _getEffectiveItemCount(),
          itemBuilder: (context, index, realIndex) {
            Widget item;

            // Build the item based on carousel type
            switch (_carouselType) {
              case _CarouselType.normal:
                // Normal mode: return the child at the given index
                item = children![index];
              case _CarouselType.builder:
                // Builder mode: use the provided itemBuilder
                item = itemBuilder!(context, index, realIndex);
              case _CarouselType.separated:
                // Separated mode: combine the item with its separator (except for the last one)
                if (index < itemCount - 1) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(child: itemBuilder!(context, index, realIndex)),
                      // Build the separator after the item
                      separatorBuilder!(context, index),
                    ],
                  );
                } else {
                  item = itemBuilder!(context, index, realIndex);
                }
            }

            // Apply spacing if needed
            if (spacing > 0) {
              item = Padding(
                padding: EdgeInsets.symmetric(horizontal: spacing / 2),
                child: item,
              );
            }

            return item;
          },
          options: CarouselOptions(
            // Animation settings
            autoPlay: autoPlay,
            autoPlayCurve: AnimationParamsManager.slidingCurve,
            autoPlayAnimationDuration:
                AnimationParamsManager.slidingAnimationDuration,
            autoPlayInterval: AnimationParamsManager.slidingIntervalDuration,

            // Layout settings
            viewportFraction: effectiveViewportFraction,
            height: height,
            aspectRatio: aspectRatio,

            // Behavior settings
            onPageChanged:
                onPageChanged != null
                    ? (index, _) => onPageChanged!(index)
                    : null,
            disableCenter: disableCenter,
            enableInfiniteScroll: enableInfiniteScroll,
            padEnds: false,

            // Visual effects
            enlargeCenterPage: enlargeCenterItem,
            enlargeFactor: enlargeFactor,
          ),
        ),
      ),
    );
  }
}

/// A controller for the [CoreCarousel] widget.
///
/// This controller allows programmatic control of the carousel, such as
/// animating to a specific page, jumping to a page, or starting/stopping
/// auto-play.
///
/// Example usage:
/// ```dart
/// final controller = CoreCarouselController();
///
/// // Later in your code:
/// controller.nextPage();
/// controller.previousPage();
/// controller.animateToPage(2);
/// ```
class CoreCarouselController extends CarouselSliderControllerImpl {}

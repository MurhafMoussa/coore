import 'package:carousel_slider/carousel_slider.dart';
import 'package:coore/src/ui/constants/animation_params_manager.dart';
import 'package:flutter/material.dart';

/// Internal enum to indicate the carousel type.
enum _CarouselType { normal, builder, separated }

/// A versatile carousel widget that supports three modes:
/// - Normal: Accepts a list of [children].
/// - Builder: Uses an [itemBuilder] and [itemCount] to build items dynamically.
/// - Separated: Uses an [itemBuilder] and a [separatorBuilder] to insert a widget
///   between items (mimicking ListView.separated).
///
/// Depending on the constructor used, the [CoreCarousel] will build its content
/// accordingly.
class CoreCarousel extends StatelessWidget {
  /// Normal Constructor: Use this when you have a fixed list of child widgets.
  const CoreCarousel({
    super.key,
    required List<Widget> this.children,
    this.carouselController,
    this.aspectRatio = 16 / 9,
    this.height,
    this.viewPortFraction = 1,
    this.autoPlay = true,
    this.disableCenter = true,
    this.enableInfiniteScroll = true,
    this.margin = EdgeInsets.zero,
    this.onPageChanged,
    this.spacing = 0,
    this.mainAxisExtent,
    this.crossAxisExtent,
  }) : itemBuilder = null,
       separatorBuilder = null,
       itemCount = children.length,
       _carouselType = _CarouselType.normal,
       assert(viewPortFraction >= 0 && viewPortFraction <= 1);

  /// Builder Constructor: Use this when you want to build items on-demand.
  const CoreCarousel.builder({
    super.key,
    required Widget Function(BuildContext context, int index, int realIndex)
    this.itemBuilder,

    required int this.itemCount,
    this.carouselController,
    this.aspectRatio = 16 / 9,
    this.height,
    this.viewPortFraction = 1,
    this.autoPlay = true,
    this.disableCenter = true,
    this.enableInfiniteScroll = true,
    this.margin = EdgeInsets.zero,
    this.onPageChanged,
    this.spacing = 0,
    this.mainAxisExtent,
    this.crossAxisExtent,
  }) : children = null,
       separatorBuilder = null,
       _carouselType = _CarouselType.builder,
       assert(viewPortFraction > 0 && viewPortFraction <= 1);

  /// Separated Constructor: Use this when you want to insert separators between items.
  const CoreCarousel.separated({
    super.key,
    required Widget Function(BuildContext context, int index, int realIndex)
    this.itemBuilder,
    required Widget Function(BuildContext context, int index)
    this.separatorBuilder,
    required int this.itemCount,
    this.carouselController,
    this.aspectRatio = 16 / 9,
    this.height,
    this.viewPortFraction = 1,
    this.autoPlay = true,
    this.disableCenter = true,
    this.enableInfiniteScroll = true,
    this.margin = EdgeInsets.zero,
    this.onPageChanged,
    this.spacing = 0,
    this.mainAxisExtent,
    this.crossAxisExtent,
  }) : children = null,
       _carouselType = _CarouselType.separated,
       assert(viewPortFraction > 0 && viewPortFraction <= 1);

  // Common parameters
  final CarouselSliderController? carouselController;
  final double aspectRatio;
  final double? height;
  final double viewPortFraction;
  final bool autoPlay;
  final bool disableCenter;
  final bool enableInfiniteScroll;
  final EdgeInsets margin;
  final ValueSetter<int>? onPageChanged;

  /// Spacing between items
  final double spacing;

  /// Fixed width for items (overrides aspectRatio if provided)
  final double? mainAxisExtent;

  /// Fixed height for items
  final double? crossAxisExtent;

  // Mode-specific parameters
  final List<Widget>? children;
  final Widget Function(BuildContext context, int index, int realIndex)?
  itemBuilder;
  final Widget Function(BuildContext context, int index)? separatorBuilder;
  final int? itemCount;
  final _CarouselType _carouselType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: CarouselSlider.builder(
        carouselController: carouselController,
        itemCount: itemCount,
        itemBuilder: (context, index, realIndex) {
          Widget item;

          // Build the item based on carousel type
          switch (_carouselType) {
            case _CarouselType.normal:
              item = children![index];
            case _CarouselType.builder:
              item = itemBuilder!(context, index, realIndex);
            case _CarouselType.separated:
              if (index < itemCount! - 1) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(child: itemBuilder!(context, index, realIndex)),
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

          // Apply fixed dimensions if provided
          if (mainAxisExtent != null || crossAxisExtent != null) {
            item = SizedBox(
              width: mainAxisExtent,
              height: crossAxisExtent,
              child: item,
            );
          }

          return item;
        },
        options: CarouselOptions(
          autoPlay: autoPlay,
          autoPlayCurve: AnimationParamsManager.slidingCurve,
          autoPlayAnimationDuration:
              AnimationParamsManager.slidingAnimationDuration,
          autoPlayInterval: AnimationParamsManager.slidingIntervalDuration,
          viewportFraction: viewPortFraction,
          height: height,
          aspectRatio: aspectRatio,
          onPageChanged:
              onPageChanged != null
                  ? (index, _) => onPageChanged!(index)
                  : null,
          disableCenter: disableCenter,
          enableInfiniteScroll: enableInfiniteScroll,
          padEnds: false,
        ),
      ),
    );
  }
}

/// A core carousel controller that extends the implementation of [CarouselSliderControllerImpl].
class CoreCarouselController extends CarouselSliderControllerImpl {}

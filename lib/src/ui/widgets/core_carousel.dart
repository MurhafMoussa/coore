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
  /// Normal Constructor:
  /// Use this when you have a fixed list of child widgets.
  ///
  /// [children] is the list of widgets to display.
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
  }) : itemBuilder = null,
       separatorBuilder = null,
       itemCount = children.length,
       _carouselType = _CarouselType.normal,
       assert(viewPortFraction >= 0 && viewPortFraction <= 1);

  /// Separated Constructor:
  /// Use this when you want to insert a separator between each item, similar to [ListView.separated].
  ///
  /// [itemCount] is the total number of items (without separators). The effective
  /// item count will be calculated as (itemCount * 2 - 1).
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
  }) : children = null,
       _carouselType = _CarouselType.separated,
       assert(viewPortFraction >= 0 && viewPortFraction <= 1);

  /// Builder Constructor:
  /// Use this when you want to build items on-demand with an [itemBuilder] callback.
  ///
  /// [itemCount] is the total number of items (without separators).
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
  }) : children = null,
       separatorBuilder = null,
       _carouselType = _CarouselType.builder,
       assert(viewPortFraction >= 0 && viewPortFraction <= 1);
  // Common parameters for all modes.
  final CarouselSliderController? carouselController;
  final double aspectRatio;
  final double? height;
  final double viewPortFraction;
  final bool autoPlay;
  final bool disableCenter;
  final bool enableInfiniteScroll;
  final EdgeInsets margin;
  final ValueSetter<int>? onPageChanged;

  // Mode-specific parameters:
  /// Used only in the normal mode.
  final List<Widget>? children;

  /// The builder function used in builder and separated modes.
  /// For separated mode, this builds the actual item widget.
  final Widget Function(BuildContext context, int index, int realIndex)?
  itemBuilder;

  /// Used in separated mode to build a separator widget between items.
  final Widget Function(BuildContext context, int index)? separatorBuilder;

  /// The count of actual items (not counting separators) for builder/separated modes.
  final int? itemCount;

  // Internal flag to determine which mode to use.
  final _CarouselType _carouselType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: CarouselSlider.builder(
        carouselController: carouselController,
        itemCount: itemCount,
        itemBuilder: (context, index, realIndex) {
          switch (_carouselType) {
            case _CarouselType.normal:
              // Normal mode: return the child at the given index.
              return children![index];
            case _CarouselType.builder:
              // Builder mode: use the provided itemBuilder.
              return itemBuilder!(context, index, realIndex);
            case _CarouselType.separated:
              // Separated mode: combine the item with its separator (except for the last one)
              if (index < itemCount! - 1) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(child: itemBuilder!(context, index, realIndex)),
                    // Build the separator after the item.
                    separatorBuilder!(context, index),
                  ],
                );
              } else {
                return itemBuilder!(context, index, realIndex);
              }
          }
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
                  ? (index, reason) => onPageChanged!(index)
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

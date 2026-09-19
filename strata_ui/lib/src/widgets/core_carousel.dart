import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../constants/animation_params_manager.dart';

enum _CarouselType { normal, builder, separated }

class CoreCarousel extends StatelessWidget {
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
    this.margin = EdgeInsetsDirectional.zero,
    this.onPageChanged,
    this.spacing = 0,
    this.enlargeCenterItem = false,
    this.enlargeFactor = 0.3,
    this.padEnds = false,
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
    this.margin = EdgeInsetsDirectional.zero,
    this.onPageChanged,
    this.spacing = 0,
    this.enlargeCenterItem = false,
    this.enlargeFactor = 0.3,
    this.padEnds = false,
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
    this.margin = EdgeInsetsDirectional.zero,
    this.onPageChanged,
    this.spacing = 0,
    this.enlargeCenterItem = false,
    this.enlargeFactor = 0.3,
    this.padEnds = false,
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

  final CarouselSliderController? carouselController;
  final double aspectRatio;
  final double? height;
  final int? itemsPerPage;
  final double? viewportFraction;
  final bool autoPlay;
  final bool disableCenter;
  final bool enableInfiniteScroll;
  final EdgeInsetsDirectional margin;
  final ValueSetter<int>? onPageChanged;
  final double spacing;
  final bool enlargeCenterItem;
  final double enlargeFactor;
  final bool padEnds;

  final List<Widget>? children;
  final Widget Function(BuildContext context, int index, int realIndex)?
  itemBuilder;
  final Widget Function(BuildContext context, int index)? separatorBuilder;
  final int itemCount;
  final _CarouselType _carouselType;

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
    final effectiveViewportFraction =
        viewportFraction ?? (itemsPerPage != null ? 1.0 / itemsPerPage! : 1.0);
    return Padding(
      padding: margin,
      child: CarouselSlider.builder(
        carouselController: carouselController,
        itemCount: _getEffectiveItemCount(),
        itemBuilder: (context, index, realIndex) {
          return switch (_carouselType) {
            _CarouselType.normal => children![index],
            _CarouselType.builder => itemBuilder!(context, index, realIndex),
            _CarouselType.separated =>
              index.isEven
                  ? itemBuilder!(context, index ~/ 2, realIndex)
                  : separatorBuilder!(context, index ~/ 2),
          };
        },
        options: CarouselOptions(
          autoPlay: autoPlay,
          autoPlayCurve: AnimationParamsManager.slidingCurve,
          autoPlayAnimationDuration:
              AnimationParamsManager.slidingAnimationDuration,
          autoPlayInterval: AnimationParamsManager.slidingIntervalDuration,
          viewportFraction: effectiveViewportFraction,
          height: height,
          aspectRatio: aspectRatio,
          onPageChanged: onPageChanged != null
              ? (index, _) => onPageChanged!(index)
              : null,
          disableCenter: disableCenter,
          enableInfiniteScroll: enableInfiniteScroll,
          padEnds: padEnds,
          enlargeCenterPage: enlargeCenterItem,
          enlargeFactor: enlargeFactor,
        ),
      ),
    );
  }
}

class CoreCarouselController extends CarouselSliderControllerImpl {}

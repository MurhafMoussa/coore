import 'package:carousel_slider/carousel_slider.dart';
import 'package:coore/src/ui/constants/animation_params_manager.dart';
import 'package:flutter/material.dart';

class CustomCarousel extends StatelessWidget {
  const CustomCarousel({
    super.key,
    this.onPageChanged,
    this.carouselController,
    this.aspectRatio = 16 / 9,
    this.viewPortFraction = 1,
    this.autoPlay = true,
    required this.itemBuilder,
    required this.itemCount,
    this.height,
    this.disableCenter = true,
    this.enableInfiniteScroll = true,
    this.margin = EdgeInsets.zero,
    this.separator,
  }) : assert(viewPortFraction >= 0 && viewPortFraction <= 1);
  final Widget Function(BuildContext context, int index, int realIndex)
  itemBuilder;
  final Widget? separator;
  final int itemCount;
  final ValueSetter<int>? onPageChanged;
  final CarouselSliderController? carouselController;
  final double aspectRatio;
  final double? height;
  final double viewPortFraction;
  final bool autoPlay;
  final bool disableCenter;
  final bool enableInfiniteScroll;
  final EdgeInsets margin;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: CarouselSlider.builder(
        itemCount: itemCount,
        itemBuilder: (context, index, realIndex) {
          if (separator != null) {
            return Row(
              children: [
                separator!,
                Expanded(child: itemBuilder(context, index, realIndex)),
                separator!,
              ],
            );
          }
          return itemBuilder(context, index, realIndex);
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
        carouselController: carouselController,
      ),
    );
  }
}

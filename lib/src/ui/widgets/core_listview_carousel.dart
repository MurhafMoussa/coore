import 'package:flutter/material.dart';

/// A carousel-like horizontal (or vertical) list view supporting:
/// - A fixed number of items per viewport (childPerScreen).
/// - Three constructors: default (list of children), builder, and separated.
/// - Automatic item sizing and spacing.
/// - Custom scroll controller for programmatic control.
class CoreListViewCarousel extends StatefulWidget {
  /// The scroll controller for programmatic scrolling.
  final CoreListViewCarouselController controller;

  /// The total height (for horizontal) or width (for vertical) of the carousel.
  final double height;

  /// Number of items visible per viewport (i.e., fraction of viewport each child occupies = 1/childPerScreen).
  final double childPerScreen;

  /// Spacing between items (ignored for [separated] constructor).
  final double spacing;

  /// Scroll direction (default: horizontal).
  final Axis scrollDirection;

  /// Outer padding for the ListView.
  final EdgeInsets? padding;

  /// For default constructor: the list of children.
  final List<Widget>? children;

  /// For builder/separated constructors: item builder.
  final IndexedWidgetBuilder? itemBuilder;

  /// For separated constructor: separator builder.
  final IndexedWidgetBuilder? separatorBuilder;

  /// For builder/separated constructors: number of items.
  final int? itemCount;

  /// Default constructor: accepts a list of children.
  const CoreListViewCarousel({
    super.key,
    required this.children,
    required this.height,
    required this.childPerScreen,
    required this.controller,
    this.spacing = 0.0,
    this.scrollDirection = Axis.horizontal,
    this.padding,
  }) : itemBuilder = null,
       separatorBuilder = null,
       itemCount = null;

  /// Builder constructor: lazily builds children.
  const CoreListViewCarousel.builder({
    super.key,
    required this.itemBuilder,
    required this.itemCount,
    required this.height,
    required this.childPerScreen,
    required this.controller,
    this.spacing = 0.0,
    this.scrollDirection = Axis.horizontal,
    this.padding,
  }) : children = null,
       separatorBuilder = null;

  /// Separated constructor: builds children with custom separators.
  ///
  /// [spacing] is ignored; use [separatorBuilder] to insert custom separator widgets.
  const CoreListViewCarousel.separated({
    super.key,
    required this.itemBuilder,
    required this.separatorBuilder,
    required this.itemCount,
    required this.height,
    required this.childPerScreen,
    required this.controller,
    this.spacing = 0.0,
    this.scrollDirection = Axis.horizontal,
    this.padding,
  }) : children = null;

  @override
  _CoreListViewCarouselState createState() => _CoreListViewCarouselState();
}

class _CoreListViewCarouselState extends State<CoreListViewCarousel> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final effectiveSpacing = widget.separatorBuilder != null
              ? 0.0
              : widget.spacing;
          final totalSpacing = effectiveSpacing * (widget.childPerScreen - 1);
          final itemExtent =
              (constraints.maxWidth - totalSpacing) / widget.childPerScreen;

          if (widget.children != null) {
            // Default list of children.
            final items = widget.children!.asMap().entries.map((entry) {
              final idx = entry.key;
              final child = entry.value;
              return Padding(
                padding: EdgeInsets.only(
                  right: idx == widget.children!.length - 1
                      ? 0
                      : widget.spacing,
                ),
                child: SizedBox(
                  width: widget.scrollDirection == Axis.horizontal
                      ? itemExtent
                      : null,
                  height: widget.scrollDirection == Axis.vertical
                      ? itemExtent
                      : null,
                  child: child,
                ),
              );
            }).toList();

            return ListView(
              controller: widget.controller,
              scrollDirection: widget.scrollDirection,
              padding: widget.padding,
              children: items,
            );
          }

          if (widget.separatorBuilder != null) {
            // Separated list.
            return ListView.separated(
              controller: widget.controller,
              scrollDirection: widget.scrollDirection,
              padding: widget.padding,
              itemCount: widget.itemCount!,
              itemBuilder: (context, index) => SizedBox(
                width: widget.scrollDirection == Axis.horizontal
                    ? itemExtent
                    : null,
                height: widget.scrollDirection == Axis.vertical
                    ? itemExtent
                    : null,
                child: widget.itemBuilder!(context, index),
              ),
              separatorBuilder: widget.separatorBuilder!,
            );
          }

          // Builder list with spacing.
          return ListView.builder(
            controller: widget.controller,
            scrollDirection: widget.scrollDirection,
            padding: widget.padding,
            itemCount: widget.itemCount,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                  right: index == widget.itemCount! - 1 ? 0 : widget.spacing,
                ),
                child: SizedBox(
                  width: widget.scrollDirection == Axis.horizontal
                      ? itemExtent
                      : null,
                  height: widget.scrollDirection == Axis.vertical
                      ? itemExtent
                      : null,
                  child: widget.itemBuilder!(context, index),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/// A controller for the [CoreListViewCarousel] widget.
///
/// This controller allows programmatic control of the carousel scrolling.
class CoreListViewCarouselController extends ScrollController {
  /// Animate to a specific item index.
  Future<void> animateToItem(
    int index, {
    required double itemWidth,
    required double spacing,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) async {
    final targetOffset = index * (itemWidth + spacing);
    await animateTo(targetOffset, duration: duration, curve: curve);
  }

  /// Jump to a specific item index without animation.
  void jumpToItem(
    int index, {
    required double itemWidth,
    required double spacing,
  }) {
    final targetOffset = index * (itemWidth + spacing);
    jumpTo(targetOffset);
  }

  /// Animate to the next item.
  Future<void> next({
    required double itemWidth,
    required double spacing,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) async {
    final currentOffset = offset;
    final currentIndex = (currentOffset / (itemWidth + spacing)).round();
    await animateToItem(
      currentIndex + 1,
      itemWidth: itemWidth,
      spacing: spacing,
      duration: duration,
      curve: curve,
    );
  }

  /// Animate to the previous item.
  Future<void> previous({
    required double itemWidth,
    required double spacing,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) async {
    final currentOffset = offset;
    final currentIndex = (currentOffset / (itemWidth + spacing)).round();
    final prevIndex = currentIndex - 1 < 0 ? 0 : currentIndex - 1;
    await animateToItem(
      prevIndex,
      itemWidth: itemWidth,
      spacing: spacing,
      duration: duration,
      curve: curve,
    );
  }
}

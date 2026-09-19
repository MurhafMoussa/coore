import 'package:flutter/material.dart';

class CoreListViewCarousel extends StatefulWidget {
  final CoreListViewCarouselController? controller;
  final double height;
  final double childPerScreen;
  final Axis scrollDirection;
  final EdgeInsets? padding;
  final ScrollPhysics? physics;
  final List<Widget>? children;
  final IndexedWidgetBuilder? itemBuilder;
  final IndexedWidgetBuilder? separatorBuilder;
  final int? itemCount;

  const CoreListViewCarousel({
    super.key,
    required this.children,
    required this.height,
    required this.childPerScreen,
    this.controller,
    this.scrollDirection = Axis.horizontal,
    this.padding,
    this.physics,
  }) : itemBuilder = null,
       separatorBuilder = null,
       itemCount = null;

  const CoreListViewCarousel.builder({
    super.key,
    required this.itemBuilder,
    required this.itemCount,
    required this.height,
    required this.childPerScreen,
    this.controller,
    this.scrollDirection = Axis.horizontal,
    this.padding,
    this.physics,
  }) : children = null,
       separatorBuilder = null;

  const CoreListViewCarousel.separated({
    super.key,
    required this.itemBuilder,
    required this.separatorBuilder,
    required this.itemCount,
    required this.height,
    required this.childPerScreen,
    this.scrollDirection = Axis.horizontal,
    this.padding,
    this.physics,
  }) : children = null,
       controller = null;

  @override
  State<CoreListViewCarousel> createState() => _CoreListViewCarouselState();
}

class _CoreListViewCarouselState extends State<CoreListViewCarousel> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final itemExtent = (constraints.maxWidth) / widget.childPerScreen;
          final defaultPhysics = widget.physics ?? const PageScrollPhysics();
          widget.controller?._attach(itemExtent);
          if (widget.children != null) {
            return ListView(
              controller: widget.controller,
              itemExtent: itemExtent,
              scrollDirection: widget.scrollDirection,
              padding: widget.padding,
              physics: defaultPhysics,
              children: widget.children!,
            );
          }

          if (widget.separatorBuilder != null) {
            return ListView.separated(
              controller: widget.controller,
              scrollDirection: widget.scrollDirection,
              padding: widget.padding,
              physics: defaultPhysics,
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

          return ListView.builder(
            controller: widget.controller,
            scrollDirection: widget.scrollDirection,
            padding: widget.padding,
            physics: defaultPhysics,
            itemCount: widget.itemCount,
            itemExtent: itemExtent,
            itemBuilder: widget.itemBuilder!,
          );
        },
      ),
    );
  }
}

class CoreListViewCarouselController extends ScrollController {
  double _itemExtent = 0;

  void _attach(double itemExtent) {
    _itemExtent = itemExtent;
  }

  Future<void> animateToItem(
    int index, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) async {
    if (_itemExtent == 0) return;
    final targetOffset = index * _itemExtent;
    await animateTo(targetOffset, duration: duration, curve: curve);
  }

  void jumpToItem(int index) {
    if (_itemExtent == 0) return;
    final targetOffset = index * _itemExtent;
    jumpTo(targetOffset);
  }

  Future<void> next({
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) async {
    if (_itemExtent == 0) return;
    final currentOffset = offset;
    final currentIndex = (currentOffset / _itemExtent).round();
    await animateToItem(currentIndex + 1, duration: duration, curve: curve);
  }

  Future<void> previous({
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) async {
    if (_itemExtent == 0) return;
    final currentOffset = offset;
    final currentIndex = (currentOffset / _itemExtent).round();
    final prevIndex = currentIndex - 1 < 0 ? 0 : currentIndex - 1;
    await animateToItem(prevIndex, duration: duration, curve: curve);
  }
}

import 'package:flutter/material.dart';
import '../constants/animation_params_manager.dart';
import '../responsive/responsive_functions.dart';

class CoreScrollableContentWithFab extends StatefulWidget {
  const CoreScrollableContentWithFab({
    super.key,
    required this.scrollableBuilder,
    this.padding,
    this.scrollDuration = AnimationParamsManager.scrollToTopDuration,
    this.scrollCurve = AnimationParamsManager.animateToCurve,
  });

  final Widget Function(ScrollController controller) scrollableBuilder;
  final EdgeInsets? padding;
  final Duration scrollDuration;
  final Curve scrollCurve;

  @override
  State<CoreScrollableContentWithFab> createState() =>
      _CoreScrollableContentWithFabState();
}

class _CoreScrollableContentWithFabState
    extends State<CoreScrollableContentWithFab> {
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<bool> _isFabVisible = ValueNotifier<bool>(false);

  late double fabThreshold;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fabThreshold = getValueForScreenType<double>(
      context: context,
      mobile: 150,
      tablet: 250,
      desktop: 350,
    );
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateFabVisibility);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateFabVisibility);
    _scrollController.dispose();
    _isFabVisible.dispose();
    super.dispose();
  }

  void _updateFabVisibility() {
    if (!_scrollController.hasClients) return;
    final shouldShow = _scrollController.offset > fabThreshold;
    _isFabVisible.value = shouldShow;
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: widget.scrollDuration,
      curve: widget.scrollCurve,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.scrollableBuilder(_scrollController),
        ValueListenableBuilder<bool>(
          valueListenable: _isFabVisible,
          builder: (context, isVisible, child) {
            return Positioned(
              right: 16,
              bottom: 16,
              child: AnimatedScale(
                scale: isVisible ? 1.0 : 0.0,
                duration: widget.scrollDuration,
                curve: widget.scrollCurve,
                child: FloatingActionButton(
                  heroTag: null,
                  onPressed: _scrollToTop,
                  child: const Icon(Icons.arrow_upward),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

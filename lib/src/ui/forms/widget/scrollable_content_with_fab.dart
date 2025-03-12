import 'package:coore/lib.dart';
import 'package:coore/src/ui/constants/animation_params_manager.dart';
import 'package:flutter/material.dart';

/// A reusable widget that wraps scrollable content with a scroll-to-top FAB.
/// The scrollable content is built using the provided [scrollableBuilder] that receives a [ScrollController].
class ScrollableContentWithFab extends StatefulWidget {
  const ScrollableContentWithFab({
    super.key,
    required this.scrollableBuilder,
    this.padding,
    this.scrollDuration = AnimationParamsManager.scrollToTopDuration,
    this.scrollCurve = AnimationParamsManager.animateToCurve,
  });

  /// A builder function that receives a [ScrollController] and returns a scrollable widget.
  final Widget Function(ScrollController controller) scrollableBuilder;

  /// Optional padding applied to the scrollable widget.
  final EdgeInsets? padding;

  /// Duration for the scroll-to-top animation.
  final Duration scrollDuration;

  /// Curve for the scroll-to-top animation.
  final Curve scrollCurve;

  @override
  _ScrollableContentWithFabState createState() =>
      _ScrollableContentWithFabState();
}

class _ScrollableContentWithFabState extends State<ScrollableContentWithFab> {
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<bool> _isFabVisible = ValueNotifier<bool>(false);

  // This threshold will be calculated based on the screen type.
  late double fabThreshold;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Adjust the FAB threshold based on screen size:
    // Mobile: 150px, Tablet: 250px, Desktop: 350px.
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
    _scrollController.addListener(() {
      final shouldShow = _scrollController.offset > fabThreshold;
      _isFabVisible.value = shouldShow;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _isFabVisible.dispose();
    super.dispose();
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
        // Build the scrollable content using the provided builder.
        widget.scrollableBuilder(_scrollController),
        // Display the FAB based on the ValueNotifier.
        ValueListenableBuilder<bool>(
          valueListenable: _isFabVisible,
          builder: (context, isVisible, child) {
            return isVisible
                ? Positioned(
                  right: 16,
                  bottom: 16,
                  child: FloatingActionButton(
                    onPressed: _scrollToTop,
                    child: const Icon(Icons.arrow_upward),
                  ),
                )
                : const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}

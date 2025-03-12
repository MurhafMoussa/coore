import 'package:flutter/animation.dart';

abstract final class AnimationParamsManager {
  static const animatedIconsDuration = Duration(milliseconds: 500);
  static const slidingAnimationDuration = Duration(seconds: 1);
  static const slidingIntervalDuration = Duration(seconds: 5);
  static const scrollToTopDuration = Duration(microseconds: 300);

  static const animateToCurve = Curves.easeOut;
  static const slidingCurve = Curves.easeIn;
}

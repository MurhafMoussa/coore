import 'package:flutter/material.dart';

T getValueForScreenType<T>({
  required BuildContext context,
  required T mobile,
  T? tablet,
  T? desktop,
}) {
  final double width = MediaQuery.of(context).size.width;

  // Breakpoints
  if (width >= 1200) {
    return desktop ?? tablet ?? mobile;
  } else if (width >= 600) {
    return tablet ?? desktop ?? mobile;
  } else {
    return mobile;
  }
}

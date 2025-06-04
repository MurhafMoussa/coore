import 'package:flutter/material.dart';

/// Screen size breakpoints used for responsive design
class ScreenBreakpoints {
  static const double mobile = 480;
  static const double tablet = 600;
  static const double largeTablet = 768;
  static const double desktop = 992;
  static const double largeDesktop = 1200;
}

/// Returns a value based on the current screen width.
/// 
/// Supports multiple breakpoints for responsive design:
/// - Large Desktop: >= 1200px
/// - Desktop: >= 992px
/// - Large Tablet: >= 768px
/// - Tablet: >= 600px
/// - Large Mobile: >= 480px
/// - Mobile: < 480px
T getValueForScreenType<T>({
  required BuildContext context,
  required T mobile,
  T? largeMobile,
  T? tablet,
  T? largeTablet,
  T? desktop,
  T? largeDesktop,
}) {
  final double width = MediaQuery.of(context).size.width;

  // Determine screen type based on width
  if (width >= ScreenBreakpoints.largeDesktop) {
    return _getValueWithFallback(
      largeDesktop,
      desktop,
      largeTablet,
      tablet,
      largeMobile,
      mobile,
    );
  } else if (width >= ScreenBreakpoints.desktop) {
    return _getValueWithFallback(
      desktop,
      largeTablet,
      tablet,
      largeMobile,
      mobile,
    );
  } else if (width >= ScreenBreakpoints.largeTablet) {
    return _getValueWithFallback(
      largeTablet,
      desktop,
      tablet,
      largeMobile,
      mobile,
    );
  } else if (width >= ScreenBreakpoints.tablet) {
    return _getValueWithFallback(
      tablet,
      largeTablet,
      desktop,
      largeMobile,
      mobile,
    );
  } else if (width >= ScreenBreakpoints.mobile) {
    return _getValueWithFallback(
      largeMobile,
      tablet,
      largeTablet,
      desktop,
      mobile,
    );
  } else {
    return mobile;
  }
}

/// Helper function to get the first non-null value from a list of values
T _getValueWithFallback<T>(T? primary, T? fallback1, T? fallback2, T? fallback3, T? fallback4, [T? fallback5]) {
  return primary ?? fallback1 ?? fallback2 ?? fallback3 ?? fallback4 ?? (fallback5 as T);
}

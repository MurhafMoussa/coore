import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  Size get size => MediaQuery.sizeOf(this);

  double get width => size.width;

  double get height => size.height;

  double get pixelRatio => MediaQuery.devicePixelRatioOf(this);

  Brightness get platformBrightness => MediaQuery.platformBrightnessOf(this);

  EdgeInsets get screenPadding => MediaQuery.paddingOf(this);

  double get statusBarHeight => screenPadding.top;

  double get navigationBarHeight => screenPadding.bottom;

  Orientation get orientation => MediaQuery.orientationOf(this);

  bool get isLandscape => orientation == Orientation.landscape;

  bool get isPortrait => orientation == Orientation.portrait;

  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => theme.textTheme;

  DefaultTextStyle get defaultTextStyle => DefaultTextStyle.of(this);

  ScaffoldState get scaffoldState => Scaffold.of(this);

  ScaffoldMessengerState get scaffoldMessenger => ScaffoldMessenger.of(this);

  OverlayState? get overlayState => Overlay.of(this);

  Color get primaryColor => theme.primaryColor;

  Color get scaffoldBackgroundColor => theme.scaffoldBackgroundColor;

  bool get isDarkMode => theme.brightness == Brightness.dark;

  void requestFocus(FocusNode focus) {
    FocusScope.of(this).requestFocus(focus);
  }

  void hideKeyboard() => FocusScope.of(this).unfocus();

  void openDrawer() => scaffoldState.openDrawer();

  void openEndDrawer() => scaffoldState.openEndDrawer();
}

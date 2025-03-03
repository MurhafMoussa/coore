import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// A service for displaying toast notifications in a Flutter application.
///
/// This service provides two methods for showing toast messages:
/// 1. [showToastNoContext] uses [Fluttertoast.showToast] and does not require a [BuildContext].
/// 2. [showToastWithContext] uses [FToast] and requires a [BuildContext] for full customization.
///
/// You can customize the appearance and behavior of the toast messages using the provided parameters.
class Toaster {
  /// Displays a toast message without requiring a [BuildContext].
  ///
  /// This method uses [Fluttertoast.showToast] to display a toast with the given parameters.
  ///
  /// Parameters:
  /// - [message]: The message to display (required).
  /// - [gravity]: The position where the toast will appear (default: [ToastGravity.BOTTOM]).
  /// - [timeInSecForIosWeb]: The duration for iOS and Web platforms (default: 1 second).
  /// - [backgroundColor]: The background color of the toast (default: [Colors.black]).
  /// - [textColor]: The text color of the toast (default: [Colors.white]).
  /// - [fontSize]: The font size of the toast text (default: 16.0).
  void showToastNoContext({
    required String message,
    ToastGravity gravity = ToastGravity.BOTTOM,
    Duration timeInSecForIosWeb = const Duration(seconds: 1),
    Color backgroundColor = Colors.black,
    Color textColor = Colors.white,
    double fontSize = 16.0,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: gravity,
      timeInSecForIosWeb: timeInSecForIosWeb.inSeconds,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: fontSize,
    );
  }

  /// The [FToast] instance used for displaying context-based toasts.
  FToast? _fToast;

  /// Initializes the [FToast] instance with the provided [context].
  ///
  /// This method should be called once (e.g., in the `initState` of your widget)
  /// to set up the [FToast] instance for displaying custom toasts.
  void init(BuildContext context) {
    _fToast = FToast();
    _fToast?.init(context);
  }

  /// Displays a custom toast that requires a [BuildContext].
  ///
  /// This method uses the [FToast.showToast] to display a custom [child] widget as a toast.
  ///
  /// Parameters:
  /// - [child]: The custom toast widget to display (required).
  /// - [gravity]: The position where the toast will appear (default: [ToastGravity.BOTTOM]).
  /// - [toastDuration]: The duration for which the toast is displayed (default: 2 seconds).
  /// - [positionedToastBuilder]: Optional parameter to precisely position the toast.
  void showToastWithContext({
    required Widget child,
    ToastGravity gravity = ToastGravity.BOTTOM,
    Duration toastDuration = const Duration(seconds: 2),
    PositionedToastBuilder? positionedToastBuilder,
  }) {
    _fToast?.showToast(
      child: child,
      gravity: gravity,
      toastDuration: toastDuration,
      positionedToastBuilder: positionedToastBuilder,
    );
  }

  /// Removes the currently displayed custom toast.
  ///
  /// This method immediately removes the toast displayed by [FToast].
  void removeCustomToast() {
    _fToast?.removeCustomToast();
  }

  /// Clears any queued custom toasts.
  ///
  /// This method clears the queue of toasts waiting to be displayed.
  void removeQueuedCustomToasts() {
    _fToast?.removeQueuedCustomToasts();
  }
}

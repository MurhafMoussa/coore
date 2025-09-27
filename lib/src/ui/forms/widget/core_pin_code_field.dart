import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';
import 'package:typed_form_fields/typed_form_fields.dart';

/// An enterprise-level pin code input widget that integrates with the [CoreFormCubit]
/// for state management. This widget builds upon the `pinput` package, exposing
/// a comprehensive set of customization options for behavior and appearance. It is
/// designed to maintain form consistency and provide a rich user experience across projects.
///
/// The widget leverages a [TextEditingController] internally and syncs its state
/// with the [CoreFormCubit], using the cubit's validation and error state to drive
/// the UI.
class CorePinCodeField extends StatefulWidget {
  const CorePinCodeField({
    super.key,
    required this.name,
    this.length = 6,
    this.initialValue,
    this.enabled = true,
    this.readOnly = false,
    this.obscureText = false,
    this.obscuringCharacter = '•',
    this.obscuringWidget,
    this.autofocus = false,
    this.focusNode,
    this.controller,
    // Callbacks
    this.onChanged,
    this.onCompleted,
    this.onSubmitted,
    this.onTap,
    this.onLongPress,
    this.onTapOutside,
    this.onClipboardFound,
    this.onAppPrivateCommand,
    // Theming
    this.pinTheme,
    this.defaultPinTheme,
    this.focusedPinTheme,
    this.submittedPinTheme,
    this.followingPinTheme,
    this.disabledPinTheme,
    this.errorPinTheme,
    // Behavior
    this.keyboardType = TextInputType.number,
    this.textInputAction = TextInputAction.done,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.closeKeyboardWhenCompleted = true,
    this.hapticFeedbackType = HapticFeedbackType.disabled,
    this.useNativeKeyboard = true,
    this.toolbarEnabled = true,
    this.enableSuggestions = true,
    this.enableIMEPersonalizedLearning = false,
    this.autofillHints,
    this.smsRetriever,
    this.textCapitalization = TextCapitalization.none,
    // Animation
    this.animationCurve = Curves.easeIn,
    this.animationDuration = const Duration(milliseconds: 200),
    this.pinAnimationType = PinAnimationType.scale,
    this.slideTransitionBeginOffset,
    // Cursor
    this.showCursor = true,
    this.cursor,
    this.isCursorAnimationEnabled = true,
    // Layout
    this.separatorBuilder,
    this.preFilledWidget,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.pinContentAlignment = Alignment.center,
    this.scrollPadding = const EdgeInsets.all(20),
    // Error Handling
    this.errorBuilder,
    this.errorTextStyle,
    // Other
    this.inputFormatters,
    this.selectionControls,
    this.restorationId,
    this.mouseCursor,
    this.keyboardAppearance,
    this.contextMenuBuilder,
    // Core Logic
    this.debounceTime,
    this.transformValue,
  });

  /// Unique identifier for the pin field within the form.
  final String name;

  /// The number of characters in the pin code.
  final int length;

  /// The initial value of the pin field.
  final String? initialValue;

  /// Determines if the pin field is interactive.
  final bool enabled;

  /// If true, the pin field will be read-only.
  final bool readOnly;

  /// Whether to hide the typed pin.
  final bool obscureText;

  /// The character used to obscure text. Defaults to '•'.
  final String obscuringCharacter;

  /// A custom widget to use for obscuring text instead of [obscuringCharacter].
  final Widget? obscuringWidget;

  /// If true, the field will autofocus on initialization.
  final bool autofocus;

  /// An optional [FocusNode] to manage focus for the pin field.
  final FocusNode? focusNode;

  /// An optional [TextEditingController] for the pin field. If not provided, one will be created internally.
  final TextEditingController? controller;

  /// Callback fired on every input change.
  final ValueChanged<String>? onChanged;

  /// Callback fired when the user completes entering the pin.
  final ValueChanged<String>? onCompleted;

  /// Callback fired when the user submits the field (e.g., by pressing the done button on the keyboard).
  final ValueChanged<String>? onSubmitted;

  /// Callback fired when the user taps on the pin field.
  final VoidCallback? onTap;

  /// Callback fired when the user long-presses on the pin field.
  final VoidCallback? onLongPress;

  /// A callback to be invoked when a tap is detected outside of the pin field.
  final TapRegionCallback? onTapOutside;

  /// Callback fired when the clipboard contains a string of the same length as the pin.
  final ValueChanged<String>? onClipboardFound;

  /// See [EditableText.onAppPrivateCommand].
  final AppPrivateCommandCallback? onAppPrivateCommand;

  /// The base theme for all pin cells. Can be overridden by other theme properties.
  final PinTheme? pinTheme;

  /// The theme for default (unfocused) pin cells.
  final PinTheme? defaultPinTheme;

  /// The theme for the currently focused pin cell.
  final PinTheme? focusedPinTheme;

  /// The theme for pin cells after the pin has been submitted.
  final PinTheme? submittedPinTheme;

  /// The theme for the pin that follows the focused pin.
  final PinTheme? followingPinTheme;

  /// The theme for pin cells when the widget is disabled.
  final PinTheme? disabledPinTheme;

  /// The theme for pin cells when a validation error is present.
  final PinTheme? errorPinTheme;

  /// The type of keyboard to be displayed.
  final TextInputType keyboardType;

  /// The action button on the keyboard.
  final TextInputAction textInputAction;

  /// Configures when the form should automatically validate its input.
  final AutovalidateMode autovalidateMode;

  /// If true, the keyboard will be dismissed after the pin is completed.
  final bool closeKeyboardWhenCompleted;

  /// The type of haptic feedback to trigger on input.
  final HapticFeedbackType hapticFeedbackType;

  /// Whether to use the native keyboard. If false, the field will not be focusable.
  final bool useNativeKeyboard;

  /// If true, the copy/paste toolbar will appear on long-press.
  final bool toolbarEnabled;

  /// Whether to enable text suggestions.
  final bool enableSuggestions;

  /// Whether the IME should update personalized data. Affects Android only.
  final bool enableIMEPersonalizedLearning;

  /// Hints for autofill services. Defaults to [AutofillHints.oneTimeCode].
  final Iterable<String>? autofillHints;

  /// Service for retrieving SMS codes on Android. Requires a package like `smart_auth`.
  final SmsRetriever? smsRetriever;

  /// See [EditableText.textCapitalization].
  final TextCapitalization textCapitalization;

  /// The curve for pin animations.
  final Curve animationCurve;

  /// The duration for pin animations.
  final Duration animationDuration;

  /// The type of animation to apply to the pin cells.
  final PinAnimationType pinAnimationType;

  /// The beginning offset for the slide animation.
  final Offset? slideTransitionBeginOffset;

  /// Whether to display the cursor.
  final bool showCursor;

  /// A custom widget to use for the cursor.
  final Widget? cursor;

  /// Whether to enable cursor animations.
  final bool isCursorAnimationEnabled;

  /// A builder for constructing separators between pin cells.
  final Widget Function(int index)? separatorBuilder;

  /// A widget to display in pin cells before any input is entered.
  final Widget? preFilledWidget;

  /// The alignment of the pin cells within the row.
  final MainAxisAlignment mainAxisAlignment;

  /// The alignment of the pin field and its error text.
  final CrossAxisAlignment crossAxisAlignment;

  /// The alignment of the content (character, cursor) within each pin cell.
  final AlignmentGeometry pinContentAlignment;

  /// Padding around the widget when it is scrolled into view.
  final EdgeInsets scrollPadding;

  /// A custom builder for rendering the error message. Overrides default error display.
  final Widget Function(BuildContext context, String? errorText)? errorBuilder;

  /// The text style for the default error message.
  final TextStyle? errorTextStyle;

  /// A list of [TextInputFormatter]s to apply to the input.
  final List<TextInputFormatter>? inputFormatters;

  /// Optional delegate for building the text selection handles and toolbar.
  final TextSelectionControls? selectionControls;

  /// Restoration ID to save and restore the state of the pin field.
  final String? restorationId;

  /// The cursor for a mouse pointer when it enters or hovers over the widget.
  final MouseCursor? mouseCursor;

  /// The appearance of the keyboard on iOS devices.
  final Brightness? keyboardAppearance;

  /// A builder for the context menu (copy, paste, etc.).
  final EditableTextContextMenuBuilder? contextMenuBuilder;

  /// Time to wait before triggering form updates after typing.
  final Duration? debounceTime;

  /// Function to transform the value before updating the form state.
  final String Function(String value)? transformValue;

  @override
  State<CorePinCodeField> createState() => _CorePinCodeFieldState();
}

class _CorePinCodeFieldState extends State<CorePinCodeField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FieldWrapper<String>(
      fieldName: widget.name,
      initialValue: widget.initialValue,
      debounceTime: widget.debounceTime,
      transformValue: widget.transformValue,
      builder: (context, value, error, hasError, updateValue) {
        // Sync controller with form value
        if (_controller.text != (value ?? '')) {
          _controller.text = value ?? '';
        }

        final theme = Theme.of(context);

        final defaultPinTheme =
            widget.defaultPinTheme ??
            widget.pinTheme ??
            PinTheme(
              width: 56,
              height: 56,
              textStyle: theme.textTheme.titleLarge,
              decoration: BoxDecoration(
                border: Border.all(
                  color: theme.colorScheme.onSurface.withAlpha(80),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            );

        return Pinput(
          length: widget.length,
          controller: _controller,
          focusNode: _focusNode,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          autofocus: widget.autofocus,
          obscureText: widget.obscureText,
          obscuringCharacter: widget.obscuringCharacter,
          obscuringWidget: widget.obscuringWidget,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          onChanged: (text) {
            widget.onChanged?.call(text);
            updateValue(text); // Use FieldWrapper's updateValue
          },
          onCompleted: (pin) {
            // No need to call updateValue here as onChanged is already called
            widget.onCompleted?.call(pin);
          },
          onSubmitted: (value) {
            updateValue(value); // Use FieldWrapper's updateValue
            widget.onSubmitted?.call(value);
          },
          onTap: widget.onTap,
          onLongPress: widget.onLongPress,
          onTapOutside: widget.onTapOutside,
          onClipboardFound: widget.onClipboardFound,
          onAppPrivateCommand: widget.onAppPrivateCommand,
          pinputAutovalidateMode: PinputAutovalidateMode.disabled,
          showCursor: widget.showCursor,
          cursor: widget.cursor,
          separatorBuilder: widget.separatorBuilder,
          forceErrorState: hasError,
          errorText: widget.errorBuilder == null ? error : null,
          errorTextStyle: widget.errorTextStyle,
          errorBuilder: widget.errorBuilder != null && hasError
              ? (error, _) => widget.errorBuilder!(context, error)
              : null,
          defaultPinTheme: defaultPinTheme,
          focusedPinTheme: widget.focusedPinTheme,
          submittedPinTheme: widget.submittedPinTheme,
          followingPinTheme: widget.followingPinTheme,
          disabledPinTheme: widget.disabledPinTheme,
          errorPinTheme: widget.errorPinTheme,
          preFilledWidget: widget.preFilledWidget,
          mainAxisAlignment: widget.mainAxisAlignment,
          crossAxisAlignment: widget.crossAxisAlignment,
          pinContentAlignment: widget.pinContentAlignment,
          animationCurve: widget.animationCurve,
          animationDuration: widget.animationDuration,
          pinAnimationType: widget.pinAnimationType,
          slideTransitionBeginOffset: widget.slideTransitionBeginOffset,
          useNativeKeyboard: widget.useNativeKeyboard,
          toolbarEnabled: widget.toolbarEnabled,
          isCursorAnimationEnabled: widget.isCursorAnimationEnabled,
          enableIMEPersonalizedLearning: widget.enableIMEPersonalizedLearning,
          enableSuggestions: widget.enableSuggestions,
          hapticFeedbackType: widget.hapticFeedbackType,
          closeKeyboardWhenCompleted: widget.closeKeyboardWhenCompleted,
          textCapitalization: widget.textCapitalization,
          keyboardAppearance: widget.keyboardAppearance,
          inputFormatters: widget.inputFormatters ?? [],
          autofillHints: widget.autofillHints,
          selectionControls: widget.selectionControls,
          restorationId: widget.restorationId,
          mouseCursor: widget.mouseCursor,
          scrollPadding: widget.scrollPadding,
          contextMenuBuilder: widget.contextMenuBuilder,
          smsRetriever: widget.smsRetriever,
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';
import 'package:typed_form_fields/typed_form_fields.dart';

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
    this.onChanged,
    this.onCompleted,
    this.onSubmitted,
    this.onTap,
    this.onLongPress,
    this.onTapOutside,
    this.onClipboardFound,
    this.onAppPrivateCommand,
    this.pinTheme,
    this.defaultPinTheme,
    this.focusedPinTheme,
    this.submittedPinTheme,
    this.followingPinTheme,
    this.disabledPinTheme,
    this.errorPinTheme,
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
    this.animationCurve = Curves.easeIn,
    this.animationDuration = const Duration(milliseconds: 200),
    this.pinAnimationType = PinAnimationType.scale,
    this.slideTransitionBeginOffset,
    this.showCursor = true,
    this.cursor,
    this.isCursorAnimationEnabled = true,
    this.separatorBuilder,
    this.preFilledWidget,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.pinContentAlignment = Alignment.center,
    this.scrollPadding = const EdgeInsets.all(20),
    this.errorBuilder,
    this.errorTextStyle,
    this.inputFormatters,
    this.selectionControls,
    this.restorationId,
    this.mouseCursor,
    this.keyboardAppearance,
    this.contextMenuBuilder,
    this.debounceTime,
    this.transformValue,
  });

  final String name;
  final int length;
  final String? initialValue;
  final bool enabled;
  final bool readOnly;
  final bool obscureText;
  final String obscuringCharacter;
  final Widget? obscuringWidget;
  final bool autofocus;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final TapRegionCallback? onTapOutside;
  final ValueChanged<String>? onClipboardFound;
  final AppPrivateCommandCallback? onAppPrivateCommand;
  final PinTheme? pinTheme;
  final PinTheme? defaultPinTheme;
  final PinTheme? focusedPinTheme;
  final PinTheme? submittedPinTheme;
  final PinTheme? followingPinTheme;
  final PinTheme? disabledPinTheme;
  final PinTheme? errorPinTheme;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final AutovalidateMode autovalidateMode;
  final bool closeKeyboardWhenCompleted;
  final HapticFeedbackType hapticFeedbackType;
  final bool useNativeKeyboard;
  final bool toolbarEnabled;
  final bool enableSuggestions;
  final bool enableIMEPersonalizedLearning;
  final Iterable<String>? autofillHints;
  final SmsRetriever? smsRetriever;
  final TextCapitalization textCapitalization;
  final Curve animationCurve;
  final Duration animationDuration;
  final PinAnimationType pinAnimationType;
  final Offset? slideTransitionBeginOffset;
  final bool showCursor;
  final Widget? cursor;
  final bool isCursorAnimationEnabled;
  final Widget Function(int index)? separatorBuilder;
  final Widget? preFilledWidget;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final AlignmentGeometry pinContentAlignment;
  final EdgeInsets scrollPadding;
  final Widget Function(BuildContext context, String? errorText)? errorBuilder;
  final TextStyle? errorTextStyle;
  final List<TextInputFormatter>? inputFormatters;
  final TextSelectionControls? selectionControls;
  final String? restorationId;
  final MouseCursor? mouseCursor;
  final Brightness? keyboardAppearance;
  final EditableTextContextMenuBuilder? contextMenuBuilder;
  final Duration? debounceTime;
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
    return TypedFieldWrapper<String>(
      fieldName: widget.name,
      initialValue: widget.initialValue,
      debounceTime: widget.debounceTime,
      transformValue: widget.transformValue,
      builder: (context, field) {
        final value = field.value;
        final error = field.error;
        final hasError = field.hasError;

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

        return IgnorePointer(
          ignoring: widget.readOnly,
          child: Pinput(
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
              field.updateValue(text);
            },
            onCompleted: (pin) {
              widget.onCompleted?.call(pin);
            },
            onSubmitted: (value) {
              field.updateValue(value);
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
          ),
        );
      },
    );
  }
}

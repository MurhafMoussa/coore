import 'dart:async';
import 'dart:ui' as ui;

import 'package:coore/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// An enterprise-level text field widget that integrates with the [CoreFormCubit]
/// for state management. This widget builds upon [TextFormField] from the
/// flutter_form_builder package and exposes a wide range of customization options
/// to suit various projects. It is designed to ensure consistency across multiple
/// projects while allowing advanced customization of behavior and appearance.
///
/// The widget leverages a [TextEditingController] internally to manage text input
/// and synchronizes with the form state via the [CoreFormCubit].
///
/// **Parameters:**
///
/// * **name**: Unique identifier for the text field. This key is used to store and
///   retrieve the field’s value from the form state.
/// * **obscureText**: If true, the text input will be obscured (e.g., for password fields).
/// * **enabled**: Determines if the text field accepts user input. When false, the field is disabled.
/// * **expands**: If true, the text field will expand to fill its parent widget.
///   **Note:** When set to true, both [maxLines] and [minLines] must be null.
///   This is enforced via an assert in the constructor.
/// * **readOnly**: If true, the text field will not allow changes to its text, though it may be focusable.
/// * **enableClear**: When true, a clear button is displayed inside the field allowing the
///   user to clear its contents. The clear action also updates the form state via the Cubit.
/// * **enableSuggestions**: Enables or disables text suggestions and autocorrect for the field.
/// * **showCursor**: Controls whether the text cursor is visible in the text field.
/// * **decoration**: Visual styling for the text field. This includes borders, labels,
///   icons, and error messages. The effective decoration merges any provided decoration
///   with error text fetched from the form state.
/// * **keyboardType**: Defines the type of keyboard to be displayed (e.g., email, number, text).
/// * **textInputAction**: Determines the action button shown on the keyboard (e.g., next, done).
/// * **autoFillHints**: Provides hints for autofill services to suggest relevant user data.
/// * **inputFormatters**: A list of [TextInputFormatter]s that can be used to restrict or
///   format the user input in real time.
/// * **focusNode**: An optional [FocusNode] to control the focus of this text field.
/// * **maxLines**: The maximum number of lines the text field will occupy.
///   Must be null if [expands] is true.
/// * **minLines**: The minimum number of lines for the text field.
///   Must be null if [expands] is true.
/// * **maxLength**: The maximum number of characters that can be entered into the text field.
/// * **autovalidateMode**: Configures when the text field should automatically validate its input.
/// * **textAlign**: How the text is horizontally aligned within the text field (e.g., start, center, end).
/// * **textAlignVertical**: How the text is vertically aligned inside the field.
/// * **textCapitalization**: Defines the capitalization behavior (e.g., none, words, sentences, characters).
/// * **initialText**: The initial text that will be displayed in the text field.
/// * **onTap**: Callback invoked when the text field is tapped. Useful for triggering
///   additional behavior when the field gains focus.
/// * **onEditingComplete**: Callback invoked when the user completes editing the field.
///   This is often used to update UI state or to shift focus to another field.
/// * **onTapOutside**: Callback that triggers when a user taps outside of the text field.
///   This can be used to dismiss the keyboard or to trigger validation on loss of focus.
/// * **customClearIcon**: A custom widget to display as the clear button icon. If not provided,
///   a default clear icon is used.
/// * **counterBuilder**: A custom builder function for constructing a character counter widget.
///   It receives the current text length, whether the field is focused, and the maximum allowed
///   length, then returns a widget to display the counter.
/// * **prefixIcon**: A widget displayed at the beginning of the text field.
/// * **suffixIcon**: A widget displayed at the end of the text field.
/// * **labelText**: Text that describes the input field.
/// * **hintText**: Text that suggests what sort of input the field accepts.
/// * **switchBetweenPrefixAndSuffix**: When true, the widget swaps the positions of the
///   prefix and suffix icons. This allows for dynamic UI adjustments where the normal
///   prefix icons appear as suffix icons and vice versa.
///
/// This widget provides flexible layout and styling options, allowing you to tailor
/// the input field’s appearance and behavior to meet your specific application needs.
class CoreTextField extends StatefulWidget {
  const CoreTextField({
    super.key,
    required this.name,
    this.enabled = true,
    this.obscureText = false,
    this.switchBetweenPrefixAndSuffix = false,
    this.expands = false,
    this.readOnly = false,
    this.enableClear = false,
    this.enableSuggestions = true,
    this.showCursor = true,
    this.decoration,
    this.keyboardType,
    this.textInputAction,
    this.autoFillHints,
    this.focusNode,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.maxLengthEnforcement,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.initialText,
    this.textAlignVertical = TextAlignVertical.center,
    this.textCapitalization = TextCapitalization.none,
    this.textAlign = TextAlign.start,
    this.counterBuilder,
    this.onTap,
    this.onTapOutside,
    this.onEditingComplete,
    this.customClearIcon,
    this.inputFormatters,
    this.prefixIcon,
    this.suffixIcon,
    this.hintText,
    this.labelText,
    this.style,
    this.errorBuilder,
    this.showRequiredStar = false,
    this.requiredStarColor,
    this.requiredStarWidget,
    this.requiredIndicatorBuilder,
    this.cursorColor,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.prefixWidget,
    this.suffixWidget,
    this.scrollPadding = const EdgeInsets.all(20),
    this.scrollPhysics,
    this.strutStyle,
    this.textDirection,
    this.autocorrect = true,
    this.smartDashesType,
    this.smartQuotesType,
    this.selectionControls,
    this.onSubmitted,
    this.onAppPrivateCommand,
    this.mouseCursor,
    this.obscuringCharacter = '•',
    this.contextMenuBuilder,
    this.magnifierConfiguration,
    this.undoController,
    this.restorationId,
    this.stylusHandwritingEnabled = true,
    this.enableIMEPersonalizedLearning = true,
    this.spellCheckConfiguration,
    this.selectionHeightStyle = ui.BoxHeightStyle.tight,
    this.selectionWidthStyle = ui.BoxWidthStyle.tight,
    this.debounceTime,
    this.transformValue,
    this.formatText,
    this.autofocus = false,
  }) : assert(
         !expands || (maxLines == null && minLines == null),
         'When expands is true, maxLines and minLines must both be null.',
       );

  /// Unique identifier for the text field within the form.
  final String name;

  /// Determines if the text field is interactive.
  final bool enabled;

  /// If true, the text field will expand to fill available space.
  /// **Note:** [maxLines] and [minLines] must be null when this is true.
  final bool expands;

  /// If true, the text field will be read-only.
  final bool readOnly;

  /// If true, displays a clear button to reset the text field.
  final bool enableClear;

  /// Enables or disables text suggestions and autocorrect.
  final bool enableSuggestions;

  /// Controls the visibility of the text cursor.
  final bool showCursor;

  /// Visual decoration for the text field.
  final InputDecoration? decoration;

  /// The type of keyboard to be displayed.
  final TextInputType? keyboardType;

  /// Configures the action button on the keyboard (e.g., next, done).
  final TextInputAction? textInputAction;

  /// Autofill hints to facilitate autofill operations.
  final Iterable<String>? autoFillHints;

  /// If true, the text will be obscured (e.g., for password fields).
  final bool obscureText;

  /// A list of [TextInputFormatter]s to control or format input.
  final List<TextInputFormatter>? inputFormatters;

  /// A [FocusNode] to manage focus for the text field.
  final FocusNode? focusNode;

  /// The maximum number of lines for the text field.
  /// Must be null if [expands] is true.
  final int? maxLines;

  /// The minimum number of lines for the text field.
  /// Must be null if [expands] is true.
  final int? minLines;

  /// Maximum allowed characters in the text field.
  final int? maxLength;

  /// Determines when the text field should auto-validate its input.
  final AutovalidateMode autovalidateMode;

  /// Horizontal alignment of the text within the field.
  final TextAlign textAlign;

  /// Vertical alignment of the text within the field.
  final TextAlignVertical? textAlignVertical;

  /// Controls the capitalization of the text.
  final TextCapitalization textCapitalization;

  /// The initial text to display in the text field.
  final String? initialText;

  /// Called when the text field is tapped.
  final VoidCallback? onTap;

  /// Called when editing is complete.
  final VoidCallback? onEditingComplete;

  /// Called when the user taps outside the text field.
  final void Function(PointerDownEvent)? onTapOutside;

  /// A custom Icon to use as the clear button icon.
  final Icon? customClearIcon;

  /// A boolean that replaces suffix with prefix and prefix with suffix
  final bool switchBetweenPrefixAndSuffix;

  /// Custom builder for the counter widget.
  final Widget? Function(
    BuildContext, {
    required int currentLength,
    required bool isFocused,
    required int? maxLength,
  })?
  counterBuilder;

  /// Icon displayed at the end of the text field.
  final Widget? suffixIcon;

  /// Icon displayed at the beginning of the text field.
  final Widget? prefixIcon;

  /// Text that describes the input field.
  final String? labelText;

  /// Text that suggests what sort of input the field accepts.
  final String? hintText;

  // New properties

  /// The style to use for the text being edited.
  final TextStyle? style;

  /// Custom builder for error messages.
  /// If provided, this will be used instead of the default error text display.
  final Widget Function(BuildContext context, String? errorText)? errorBuilder;

  /// Whether to show a required indicator after the label text.
  final bool showRequiredStar;

  /// The color of the required star.
  final Color? requiredStarColor;

  /// Custom widget to use as the required indicator.
  /// If provided, this will be used instead of the default star.
  final Widget? requiredStarWidget;

  /// Custom builder for the required indicator.
  /// Takes precedence over requiredStarWidget if both are provided.
  /// If null, falls back to requiredStarWidget or the default star.
  final Widget Function(BuildContext context, String labelText)?
  requiredIndicatorBuilder;

  /// The color of the cursor.
  final Color? cursorColor;

  /// How thick the cursor will be.
  final double cursorWidth;

  /// How tall the cursor will be.
  final double? cursorHeight;

  /// The radius of the cursor corners.
  final Radius? cursorRadius;

  /// A widget to display before the text input field.
  final Widget? prefixWidget;

  /// A widget to display after the text input field.
  final Widget? suffixWidget;

  /// The padding added around the text field when it scrolls.
  final EdgeInsets scrollPadding;

  /// The physics of the scrollable text field.
  final ScrollPhysics? scrollPhysics;

  /// The strut style used for the vertical layout of the text.
  final StrutStyle? strutStyle;

  /// The text direction of the text field.
  final TextDirection? textDirection;

  /// Whether to enable autocorrection.
  final bool autocorrect;

  /// The configuration of smart dashes.
  final SmartDashesType? smartDashesType;

  /// The configuration of smart quotes.
  final SmartQuotesType? smartQuotesType;

  /// Optional delegate for building the text selection handles and toolbar.
  final TextSelectionControls? selectionControls;

  /// Called when the user submits editable content.
  final ValueChanged<String>? onSubmitted;

  /// Called when the platform receives a private command.
  final AppPrivateCommandCallback? onAppPrivateCommand;

  /// The cursor for a mouse pointer when it enters or hovers over the widget.
  final MouseCursor? mouseCursor;

  /// Character used for obscuring text if obscureText is true.
  final String obscuringCharacter;

  /// Builder for the context menu.
  final EditableTextContextMenuBuilder? contextMenuBuilder;

  /// Configuration of the text magnifier.
  final TextMagnifierConfiguration? magnifierConfiguration;

  /// Controller for undo/redo operations.
  final UndoHistoryController? undoController;

  /// Restoration ID to save and restore the state of the text field.
  final String? restorationId;

  /// Whether to enable scribble for Apple Pencil.
  final bool stylusHandwritingEnabled;

  /// Whether to enable personalized learning for IME.
  final bool enableIMEPersonalizedLearning;

  /// Configuration for spell check.
  final SpellCheckConfiguration? spellCheckConfiguration;

  /// How tall the selection highlight should be.
  final ui.BoxHeightStyle selectionHeightStyle;

  /// How wide the selection highlight should be.
  final ui.BoxWidthStyle selectionWidthStyle;

  /// How to enforce the text length limit.
  final MaxLengthEnforcement? maxLengthEnforcement;

  /// Whether this text field should focus itself if nothing else is already focused.
  final bool autofocus;

  /// Time to wait before triggering form updates after typing.
  /// Useful for search fields or other scenarios where you want to
  /// reduce the number of form updates during rapid typing.
  final Duration? debounceTime;

  /// Function to transform the value before updating the form state.
  /// Useful for formatting or normalizing input.
  final String Function(String value)? transformValue;

  /// Function to format the displayed text without affecting the underlying value.
  /// Useful for displaying formatted text while maintaining raw value in the form.
  final String Function(String value)? formatText;

  @override
  State<CoreTextField> createState() => _CoreTextFieldState();
}

class _CoreTextFieldState extends State<CoreTextField> {
  bool obscureText = false;
  Timer? _debounceTimer;
  late final TextEditingController textEditingController;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();

    if (!ValueTester.isNull(widget.initialText)) {
      _updateCubit(widget.initialText);
    }

    obscureText = widget.obscureText;

    // Apply format if provided
    final initialText =
        widget.formatText != null && widget.initialText != null
            ? widget.formatText!(widget.initialText!)
            : widget.initialText;

    textEditingController = TextEditingController(text: initialText);

    // Use provided focus node or create one
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();

    // Only dispose the focus node if we created it
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }

    textEditingController.dispose();
    super.dispose();
  }

  void _updateCubit(String? text) {
    if (widget.debounceTime != null) {
      _debounceTimer?.cancel();
      _debounceTimer = Timer(widget.debounceTime!, () {
        _updateFormState(text);
      });
    } else {
      _updateFormState(text);
    }
  }

  void _updateFormState(String? text) {
    final transformedText =
        text != null && widget.transformValue != null
            ? widget.transformValue!(text)
            : text;

    context.read<CoreFormCubit>().updateField(
      widget.name,
      transformedText,
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoreFormCubit, CoreFormState>(
      builder: (context, state) {
        final errorText = state.errors[widget.name];

        // Build label text with required indicator if needed
        Widget? labelWidget;
        if (widget.labelText != null && widget.showRequiredStar) {
          // Use the custom builder if provided
          if (widget.requiredIndicatorBuilder != null) {
            labelWidget = widget.requiredIndicatorBuilder!(
              context,
              widget.labelText!,
            );
          } else {
            // Otherwise use the default implementation
            labelWidget = Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.labelText!),
                const SizedBox(width: 1),
                widget.requiredStarWidget ??
                    Text(
                      '*',
                      style: TextStyle(
                        color:
                            widget.requiredStarColor ??
                            Theme.of(context).colorScheme.error,
                      ),
                    ),
              ],
            );
          }
        }

        InputDecoration effectiveDecoration =
            (widget.decoration ?? const InputDecoration()).copyWith(
              suffixIcon:
                  widget.switchBetweenPrefixAndSuffix
                      ? _buildPrefixIcons()
                      : _buildSuffixIcons(state),
              prefixIcon:
                  widget.switchBetweenPrefixAndSuffix
                      ? _buildSuffixIcons(state)
                      : _buildPrefixIcons(),
              labelText: widget.showRequiredStar ? null : widget.labelText,
              label: labelWidget,
              hintText: widget.hintText,
              prefix: widget.prefixWidget,
              suffix: widget.suffixWidget,
              errorText: widget.errorBuilder == null ? errorText : null,
              error:
                  widget.errorBuilder != null && errorText != null
                      ? widget.errorBuilder!(context, errorText)
                      : null,
            );
        return TextFormField(
          controller: textEditingController,
          obscureText: obscureText,
          obscuringCharacter: widget.obscuringCharacter,
          decoration: effectiveDecoration,
          inputFormatters: widget.inputFormatters,
          onChanged: _updateCubit,
          onFieldSubmitted: (value) {
            _updateCubit(value);
            widget.onSubmitted?.call(value);
          },
          onSaved: _updateCubit,
          onTap: widget.onTap,
          onTapOutside: widget.onTapOutside,
          onEditingComplete: widget.onEditingComplete,
          buildCounter: widget.counterBuilder,
          enabled: widget.enabled,
          expands: widget.expands,
          readOnly: widget.readOnly,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          autofillHints: widget.autoFillHints,
          focusNode: _focusNode,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          maxLength: widget.maxLength,
          maxLengthEnforcement: widget.maxLengthEnforcement,
          autovalidateMode:
              state.validationType == ValidationType.disabled
                  ? AutovalidateMode.disabled
                  : widget.autovalidateMode,
          enableSuggestions: widget.enableSuggestions,
          showCursor: widget.showCursor,
          textAlignVertical: widget.textAlignVertical,
          textCapitalization: widget.textCapitalization,
          textAlign: widget.textAlign,
          style: widget.style,
          cursorColor: widget.cursorColor,
          cursorWidth: widget.cursorWidth,
          cursorHeight: widget.cursorHeight,
          cursorRadius: widget.cursorRadius,
          scrollPadding: widget.scrollPadding,
          scrollPhysics: widget.scrollPhysics,
          strutStyle: widget.strutStyle,
          textDirection: widget.textDirection,
          autocorrect: widget.autocorrect,
          smartDashesType: widget.smartDashesType,
          smartQuotesType: widget.smartQuotesType,
          selectionControls: widget.selectionControls,
          onAppPrivateCommand: widget.onAppPrivateCommand,
          mouseCursor: widget.mouseCursor,
          contextMenuBuilder: widget.contextMenuBuilder,
          magnifierConfiguration: widget.magnifierConfiguration,
          undoController: widget.undoController,
          restorationId: widget.restorationId,
          stylusHandwritingEnabled: widget.stylusHandwritingEnabled,
          enableIMEPersonalizedLearning: widget.enableIMEPersonalizedLearning,
          spellCheckConfiguration: widget.spellCheckConfiguration,
          selectionHeightStyle: widget.selectionHeightStyle,
          selectionWidthStyle: widget.selectionWidthStyle,
          autofocus: widget.autofocus,
        );
      },
    );
  }

  IconButton _buildClearIcon() {
    return IconButton(
      icon: widget.customClearIcon ?? const Icon(Icons.clear),
      onPressed: () {
        textEditingController.clear();
        _updateCubit('');
      },
    );
  }

  IconButton _buildVisibilityIcon() {
    return IconButton(
      icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
      onPressed:
          () => setState(() {
            obscureText = !obscureText;
          }),
    );
  }

  Widget? _buildPrefixIcons() {
    final List<Widget> prefixWidgets = [];
    if (widget.prefixIcon != null) {
      prefixWidgets.add(widget.prefixIcon!);
    }

    if (widget.obscureText) {
      prefixWidgets.add(_buildVisibilityIcon());
    }

    // If we have more than one widget, wrap them in a Row.
    Widget? finalPrefix;
    if (prefixWidgets.isNotEmpty) {
      finalPrefix =
          prefixWidgets.length == 1
              ? prefixWidgets.first
              : Row(mainAxisSize: MainAxisSize.min, children: prefixWidgets);
    }

    return finalPrefix;
  }

  Widget? _buildSuffixIcons(CoreFormState state) {
    final List<Widget> suffixWidgets = [];

    if (widget.enableClear &&
        !ValueTester.isNullOrBlank(state.values[widget.name])) {
      suffixWidgets.add(_buildClearIcon());
    }

    if (widget.suffixIcon != null) {
      suffixWidgets.add(widget.suffixIcon!);
    }

    // If we have more than one widget, wrap them in a Row.
    Widget? finalSuffix;
    if (suffixWidgets.isNotEmpty) {
      finalSuffix =
          suffixWidgets.length == 1
              ? suffixWidgets.first
              : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: suffixWidgets,
              );
    }

    return finalSuffix;
  }
}

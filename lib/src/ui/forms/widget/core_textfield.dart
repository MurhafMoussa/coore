import 'package:coore/src/ui/forms/cubit/core_form_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//todo(Murhaf): if you want more types go to https://pub.dev/packages/flutter_form_builder
/// An enterprise-level text field widget that integrates with the [CoreFormCubit]
/// for state management. This widget builds upon [FormBuilderTextField] from the
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
///
/// * **obscureText**: If true, the text input will be obscured (e.g., for password fields).
///
/// * **enabled**: Determines if the text field accepts user input. When false, the field is disabled.
///
/// * **expands**: If true, the text field will expand to fill its parent widget.
///   **Note:** When set to true, both [maxLines] and [minLines] must be null.
///   This is enforced via an assert in the constructor.
///
/// * **readOnly**: If true, the text field will not allow changes to its text, though it may be focusable.
///
/// * **enableClear**: When true, a clear button is displayed inside the field allowing the
///   user to clear its contents. The clear action also updates the form state via the Cubit.
///
/// * **enableSuggestions**: Enables or disables text suggestions and autocorrect for the field.
///
/// * **showCursor**: Controls whether the text cursor is visible in the text field.
///
/// * **decoration**: Visual styling for the text field. This includes borders, labels,
///   icons, and error messages. The effective decoration merges any provided decoration
///   with error text fetched from the form state.
///
/// * **keyboardType**: Defines the type of keyboard to be displayed (e.g., email, number, text).
///
/// * **textInputAction**: Determines the action button shown on the keyboard (e.g., next, done).
///
/// * **autoFillHints**: Provides hints for autofill services to suggest relevant user data.
///
/// * **inputFormatters**: A list of [TextInputFormatter]s that can be used to restrict or
///   format the user input in real time.
///
/// * **focusNode**: An optional [FocusNode] to control the focus of this text field.
///
/// * **maxLines**: The maximum number of lines the text field will occupy.
///   Must be null if [expands] is true.
///
/// * **minLines**: The minimum number of lines for the text field.
///   Must be null if [expands] is true.
///
/// * **maxLength**: The maximum number of characters that can be entered into the text field.
///
/// * **autovalidateMode**: Configures when the text field should automatically validate its input.
///
/// * **textAlign**: How the text is horizontally aligned within the text field (e.g., start, center, end).
///
/// * **textAlignVertical**: How the text is vertically aligned inside the field.
///
/// * **textCapitalization**: Defines the capitalization behavior (e.g., none, words, sentences, characters).
///
/// * **initialText**: The initial text that will be displayed in the text field.
///
/// * **onTap**: Callback invoked when the text field is tapped. Useful for triggering
///   additional behavior when the field gains focus.
///
/// * **onEditingComplete**: Callback invoked when the user completes editing the field.
///   This is often used to update UI state or to shift focus to another field.
///
/// * **onTapOutside**: Callback that triggers when a user taps outside of the text field.
///   This can be used to dismiss the keyboard or to trigger validation on loss of focus.
///
/// * **customClearIcon**: A custom widget to display as the clear button icon. If not provided,
///   a default clear icon is used.
///
/// * **counterBuilder**: A custom builder function for constructing a character counter widget.
///   It receives the current text length, whether the field is focused, and the maximum allowed
///   length, then returns a widget to display the counter.
class CoreTextField extends StatefulWidget {
  const CoreTextField({
    super.key,
    required this.name,
    this.obscureText = false,
    this.enabled = true,
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
  }) : assert(
         !expands || (maxLines == null && minLines == null),
         'When expands is true, maxLines and minLines must both be null.',
       );

  /// Unique identifier for the text field within the form.
  final String name;

  /// If true, the text will be obscured (e.g., for password fields).
  final bool obscureText;

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

  /// A custom widget to use as the clear button icon.
  final Widget? customClearIcon;

  /// Custom builder for the counter widget.
  final Widget? Function(
    BuildContext, {
    required int currentLength,
    required bool isFocused,
    required int? maxLength,
  })?
  counterBuilder;

  @override
  State<CoreTextField> createState() => _CoreTextFieldState();
}

class _CoreTextFieldState extends State<CoreTextField> {
  @override
  void initState() {
    _updateCubit(widget.initialText);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoreFormCubit, CoreFormState>(
      builder: (context, state) {
        // Merge the provided [InputDecoration] with error text from the form state.
        InputDecoration effectiveDecoration = (widget.decoration ??
                const InputDecoration())
            .copyWith(errorText: state.errors[widget.name]);

        // If the clear button is enabled, add it as a suffix icon.
        if (widget.enableClear) {
          effectiveDecoration = effectiveDecoration.copyWith(
            suffixIcon: IconButton(
              icon: widget.customClearIcon ?? const Icon(Icons.clear),
              onPressed: () {
                context.read<CoreFormCubit>().updateField(widget.name, '');
              },
            ),
          );
        }

        return TextFormField(
          obscureText: widget.obscureText,
          decoration: effectiveDecoration,
          inputFormatters: widget.inputFormatters,
          onChanged: _updateCubit,
          onFieldSubmitted: _updateCubit,
          onSaved: _updateCubit,
          onTap: widget.onTap,
          onTapOutside: widget.onTapOutside,
          onEditingComplete: widget.onEditingComplete,
          buildCounter: widget.counterBuilder,
          enabled: widget.enabled,
          expands: widget.expands,
          initialValue: widget.initialText,
          readOnly: widget.readOnly,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          autofillHints: widget.autoFillHints,
          focusNode: widget.focusNode,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          maxLength: widget.maxLength,
          autovalidateMode: widget.autovalidateMode,
          enableSuggestions: widget.enableSuggestions,
          showCursor: widget.showCursor,
          textAlignVertical: widget.textAlignVertical,
          textCapitalization: widget.textCapitalization,
          textAlign: widget.textAlign,
        );
      },
    );
  }

  void _updateCubit(String? text) {
    context.read<CoreFormCubit>().updateField(widget.name, text);
  }
}

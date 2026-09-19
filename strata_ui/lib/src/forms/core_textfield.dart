import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:typed_form_fields/typed_form_fields.dart';

typedef VisibilityToggleBuilder = Widget Function(
  BuildContext context,
  bool isObscured,
  VoidCallback toggle,
  ValueChanged<bool> setObscured,
);

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
    this.visibilityToggleBuilder,
    this.visibilityIconBuilder,
    this.onVisibilityChanged,
    this.onChanged,
  }) : assert(
          !expands || (maxLines == null && minLines == null),
          'When expands is true, maxLines and minLines must both be null.',
        );

  final String name;
  final bool enabled;
  final bool expands;
  final bool readOnly;
  final bool enableClear;
  final bool enableSuggestions;
  final bool showCursor;
  final InputDecoration? decoration;
  final VisibilityToggleBuilder? visibilityToggleBuilder;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autoFillHints;
  final bool obscureText;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final AutovalidateMode autovalidateMode;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final Widget Function(BuildContext context, bool isObscured)?
      visibilityIconBuilder;
  final void Function(BuildContext context, bool isObscured)?
      onVisibilityChanged;
  final TextCapitalization textCapitalization;
  final String? initialText;
  final VoidCallback? onTap;
  final VoidCallback? onEditingComplete;
  final void Function(PointerDownEvent)? onTapOutside;
  final Icon? customClearIcon;
  final bool switchBetweenPrefixAndSuffix;
  final Widget? Function(
    BuildContext, {
    required int currentLength,
    required bool isFocused,
    required int? maxLength,
  })? counterBuilder;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? labelText;
  final String? hintText;
  final TextStyle? style;
  final Widget Function(BuildContext context, String? errorText)? errorBuilder;
  final bool showRequiredStar;
  final Color? requiredStarColor;
  final Widget? requiredStarWidget;
  final Widget Function(BuildContext context, String labelText)?
      requiredIndicatorBuilder;
  final Color? cursorColor;
  final double cursorWidth;
  final double? cursorHeight;
  final Radius? cursorRadius;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final EdgeInsets scrollPadding;
  final ScrollPhysics? scrollPhysics;
  final StrutStyle? strutStyle;
  final TextDirection? textDirection;
  final bool autocorrect;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;
  final TextSelectionControls? selectionControls;
  final ValueChanged<String>? onSubmitted;
  final AppPrivateCommandCallback? onAppPrivateCommand;
  final MouseCursor? mouseCursor;
  final String obscuringCharacter;
  final EditableTextContextMenuBuilder? contextMenuBuilder;
  final TextMagnifierConfiguration? magnifierConfiguration;
  final UndoHistoryController? undoController;
  final String? restorationId;
  final bool stylusHandwritingEnabled;
  final bool enableIMEPersonalizedLearning;
  final SpellCheckConfiguration? spellCheckConfiguration;
  final ui.BoxHeightStyle selectionHeightStyle;
  final ui.BoxWidthStyle selectionWidthStyle;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final bool autofocus;
  final Duration? debounceTime;
  final String Function(String value)? transformValue;
  final String Function(String value)? formatText;
  final ValueChanged<String?>? onChanged;

  @override
  State<CoreTextField> createState() => _CoreTextFieldState();
}

class _CoreTextFieldState extends State<CoreTextField> {
  bool obscureText = false;
  late final TextEditingController textEditingController;
  late final FocusNode _focusNode;
  void Function(String?)? _currentUpdateValue;

  @override
  void initState() {
    super.initState();
    obscureText = widget.obscureText;

    final initialText = widget.formatText != null && widget.initialText != null
        ? widget.formatText!(widget.initialText!)
        : widget.initialText;

    textEditingController = TextEditingController(text: initialText);
    _focusNode = widget.focusNode ?? FocusNode();
  }

  void _notifyVisibilityChanged() {
    widget.onVisibilityChanged?.call(context, obscureText);
  }

  void _toggleObscure() {
    setState(() => obscureText = !obscureText);
    _notifyVisibilityChanged();
  }

  void _setObscure(bool value) {
    if (obscureText == value) return;
    setState(() => obscureText = value);
    _notifyVisibilityChanged();
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TypedFieldWrapper<String>(
      fieldName: widget.name,
      initialValue: widget.initialText,
      debounceTime: widget.debounceTime,
      transformValue: widget.transformValue,
      builder: (context, field) {
        final value = field.value;
        final error = field.error;
        final hasError = field.hasError;

        _currentUpdateValue = (val) {
          field.updateValue(val);
          widget.onChanged?.call(val);
        };

        if (textEditingController.text != (value ?? '')) {
          final formattedValue = widget.formatText != null && value != null
              ? widget.formatText!(value)
              : value ?? '';
          textEditingController.text = formattedValue;
        }

        Widget? labelWidget;
        if (widget.labelText != null && widget.showRequiredStar) {
          if (widget.requiredIndicatorBuilder != null) {
            labelWidget = widget.requiredIndicatorBuilder!(
              context,
              widget.labelText!,
            );
          } else {
            labelWidget = Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.labelText!),
                const SizedBox(width: 1),
                widget.requiredStarWidget ??
                    Text(
                      '*',
                      style: TextStyle(
                        color: widget.requiredStarColor ??
                            Theme.of(context).colorScheme.error,
                      ),
                    ),
              ],
            );
          }
        }

        InputDecoration effectiveDecoration =
            (widget.decoration ?? const InputDecoration()).copyWith(
          suffixIcon: widget.switchBetweenPrefixAndSuffix
              ? _buildPrefixIcons()
              : _buildSuffixIcons(value),
          prefixIcon: widget.switchBetweenPrefixAndSuffix
              ? _buildSuffixIcons(value)
              : _buildPrefixIcons(),
          labelText: widget.showRequiredStar ? null : widget.labelText,
          label: labelWidget,
          hintText: widget.hintText,
          prefix: widget.prefixWidget,
          suffix: widget.suffixWidget,
          errorText: widget.errorBuilder == null ? error : null,
          error: widget.errorBuilder != null && hasError
              ? widget.errorBuilder!(context, error)
              : null,
        );

        return IgnorePointer(
          ignoring: widget.readOnly,
          child: TextFormField(
            controller: textEditingController,
            obscureText: obscureText,
            obscuringCharacter: widget.obscuringCharacter,
            decoration: effectiveDecoration,
            inputFormatters: widget.inputFormatters,
            onChanged: (val) {
              field.updateValue(val);
              widget.onChanged?.call(val);
            },
            onFieldSubmitted: (fieldValue) {
              field.updateValue(fieldValue);
              widget.onChanged?.call(fieldValue);
              widget.onSubmitted?.call(fieldValue);
            },
            onSaved: (val) {
              field.updateValue(val);
              widget.onChanged?.call(val);
            },
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
            autovalidateMode: widget.autovalidateMode,
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
          ),
        );
      },
    );
  }

  Widget _buildClearIcon() {
    return IconButton(
      icon: widget.customClearIcon ?? const Icon(Icons.clear),
      onPressed: () {
        textEditingController.clear();
        _currentUpdateValue?.call('');
      },
    );
  }

  Widget _buildVisibilityToggle(BuildContext context) {
    if (widget.visibilityToggleBuilder != null) {
      return widget.visibilityToggleBuilder!(
        context,
        obscureText,
        _toggleObscure,
        _setObscure,
      );
    }

    final icon = widget.visibilityIconBuilder?.call(context, obscureText) ??
        Icon(obscureText ? Icons.visibility_off : Icons.visibility);

    return IconButton(icon: icon, onPressed: _toggleObscure);
  }

  Widget? _buildPrefixIcons() {
    final List<Widget> prefixWidgets = [];
    if (widget.prefixIcon != null) {
      prefixWidgets.add(widget.prefixIcon!);
    }

    if (widget.obscureText) {
      prefixWidgets.add(_buildVisibilityToggle(context));
    }

    Widget? finalPrefix;
    if (prefixWidgets.isNotEmpty) {
      finalPrefix = prefixWidgets.length == 1
          ? prefixWidgets.first
          : Row(mainAxisSize: MainAxisSize.min, children: prefixWidgets);
    }

    return finalPrefix;
  }

  Widget? _buildSuffixIcons(String? currentValue) {
    final List<Widget> suffixWidgets = [];

    if (widget.enableClear && (currentValue != null && currentValue.isNotEmpty)) {
      suffixWidgets.add(_buildClearIcon());
    }

    if (widget.suffixIcon != null) {
      suffixWidgets.add(widget.suffixIcon!);
    }

    Widget? finalSuffix;
    if (suffixWidgets.isNotEmpty) {
      finalSuffix = suffixWidgets.length == 1
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

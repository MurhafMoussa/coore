import 'package:coore/lib.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// A customizable text widget that truncates content with "read more/less" functionality.
///
/// Supports both selectable and non-selectable text modes. Automatically detects when
/// text content exceeds specified line limits and shows expand/collapse controls.
///
/// Example:
/// ```dart
/// CoreReadMore(
///   text: 'Long text content...',
///   trimLines: 3,
///   expandText: 'Show more',
///   collapseText: 'Show less',
/// )
/// ```

class CoreReadMoreText extends StatefulWidget {
  const CoreReadMoreText(
    this.text, {
    required this.numLines,
    required this.readMoreText,
    required this.readLessText,

    this.readMoreTextStyle,

    this.style,
    this.locale,
    this.onReadMoreClicked,

    this.textKey,
    super.key,
  }) : cursorHeight = null,
       _isSelectable = false,
       showCursor = null,
       cursorWidth = null,
       cursorColor = null,
       cursorRadius = null,
       contextMenuBuilder = null;

  /// Show a read more text widget with the use of [SelectableText] instead
  /// of normal [Text] widget.
  ///
  /// You can customize the look and feel of the [SelectableText] like cursor
  /// width, cursor height, cursor color, etc...
  const CoreReadMoreText.selectable(
    this.text, {
    super.key,
    required this.numLines,
    required this.readMoreText,
    required this.readLessText,

    this.textKey,

    this.readMoreTextStyle,

    this.style,
    this.locale,
    this.onReadMoreClicked,
    this.cursorColor,
    this.cursorRadius,
    this.cursorWidth,
    this.showCursor,
    this.contextMenuBuilder,
    this.cursorHeight,
  }) : _isSelectable = true;

  /// The main text that needs to be shown.
  final String text;

  /// The number of lines before trim the text.
  final int numLines;

  /// The main text style.
  final TextStyle? style;

  /// The style of read more/less text.
  final TextStyle? readMoreTextStyle;

  /// The show more text.
  final String readMoreText;

  /// The show less text.
  final String readLessText;

  /// Called when clicked on read more.
  final VoidCallback? onReadMoreClicked;

  /// The locale of the main text, that allows the widget calculate the
  /// number of lines accurately.
  ///
  /// It's optional and should be used when the passed text locale is different
  /// from the app locale.
  ///
  /// e.g: The app locale is `en` but you pass a german text.
  final Locale? locale;

  /// Whether to show the cursor or not.
  final bool? showCursor;

  /// The cursor width if the cursor is shown.
  final double? cursorWidth;

  /// The cursor height if the cursor is shown.
  final double? cursorHeight;

  /// The cursor color if the cursor is shown.
  final Color? cursorColor;

  /// The cursor radius if the cursor is shown.
  final Radius? cursorRadius;

  /// The toolbar options of the selection area.
  final Widget Function(BuildContext, EditableTextState)? contextMenuBuilder;
  final bool _isSelectable;

  /// The key for the content text.
  final Key? textKey;

  @override
  State<CoreReadMoreText> createState() => _CoreReadMoreTextState();
}

class _CoreReadMoreTextState extends State<CoreReadMoreText> {
  var _isTextExpanded = false;
  late final TapGestureRecognizer _tapGestureRecognizer;
  @override
  void initState() {
    super.initState();
    _tapGestureRecognizer = TapGestureRecognizer()..onTap = _onReadMoreClicked;
  }

  @override
  void dispose() {
    _tapGestureRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultShowMoreStyle = context.textTheme.bodyMedium?.copyWith(
      decoration: TextDecoration.underline,
      color: context.primaryColor,
      decorationColor: context.primaryColor,
    );

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final textSpan = TextSpan(
          text: '${widget.text} ',
          children: [
            TextSpan(
              text: _isTextExpanded ? widget.readLessText : widget.readMoreText,
              style: widget.readMoreTextStyle ?? defaultShowMoreStyle,
              recognizer: _tapGestureRecognizer,
            ),
          ],
        );
        return (widget._isSelectable)
            ? SelectableText.rich(
              textSpan,
              key: widget.textKey,
              maxLines: _isTextExpanded ? null : widget.numLines,
              style: widget.style,
              cursorColor: widget.cursorColor,
              cursorWidth: widget.cursorWidth ?? 2,
              cursorHeight: widget.cursorHeight,
              cursorRadius: widget.cursorRadius,
              showCursor: widget.showCursor ?? false,

              contextMenuBuilder: widget.contextMenuBuilder,
              scrollPhysics: const NeverScrollableScrollPhysics(),
            )
            : Text.rich(
              textSpan,
              key: widget.textKey,
              maxLines: _isTextExpanded ? null : widget.numLines,
              style: widget.style,
            );
      },
    );
  }

  void _onReadMoreClicked() {
    _isTextExpanded = !_isTextExpanded;
    setState(() {});
    widget.onReadMoreClicked?.call();
  }
}

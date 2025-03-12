import 'package:coore/lib.dart';
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
///   iconColor: Theme.of(context).primaryColor,
/// )
/// ```

class CoreReadMoreText extends StatefulWidget {
  const CoreReadMoreText(
    this.text, {
    required this.numLines,
    required this.readMoreText,
    required this.readLessText,

    this.readMoreIcon,
    this.readLessIcon,
    this.readMoreTextStyle,

    this.style,
    this.locale,
    this.onReadMoreClicked,
    this.readMoreKey,
    this.textKey,
    super.key,
  }) : assert(
         (readMoreIcon != null && readLessIcon != null) ||
             readMoreIcon == null && readLessIcon == null,
         'You need to specify both read more and read less icons ',
       ),
       cursorHeight = null,
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

    this.readMoreKey,
    this.textKey,
    this.readMoreIcon,
    this.readLessIcon,
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

  /// The icon that needs to be shown when the text is collapsed.
  ///
  /// When you specify [readMoreIcon] you also need to specify [readLessIcon].
  final Widget? readMoreIcon;

  /// The icon that needs to be shown when the text is expanded.
  ///
  /// When you specify [readMoreIcon] you also need to specify [readLessIcon].
  final Widget? readLessIcon;

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

  /// The key for read more button.
  final Key? readMoreKey;

  @override
  State<CoreReadMoreText> createState() => _CoreReadMoreTextState();
}

class _CoreReadMoreTextState extends State<CoreReadMoreText> {
  var _isTextExpanded = false;

  @override
  Widget build(BuildContext context) {
    final defaultShowMoreStyle = context.textTheme.bodyMedium?.copyWith(
      decoration: TextDecoration.underline,
      color: context.primaryColor,
      decorationColor: context.primaryColor,
    );

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final locale = widget.locale ?? Localizations.maybeLocaleOf(context);
        final span = TextSpan(text: widget.text);
        final tp = TextPainter(
          text: span,
          locale: locale,
          maxLines: widget.numLines,
          textDirection: Directionality.of(context),
        )..layout(maxWidth: constraints.maxWidth);
        return Row(
          children: [
            if (widget._isSelectable)
              SelectableText(
                widget.text,
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
            else
              Text.rich(
                TextSpan(
                  text: '${widget.text} ',
                  children: [
                    TextSpan(
                      text:
                          _isTextExpanded
                              ? widget.readLessText
                              : widget.readMoreText,
                      style: widget.readMoreTextStyle ?? defaultShowMoreStyle,
                    ),
                  ],
                ),
                key: widget.textKey,
                maxLines: _isTextExpanded ? null : widget.numLines,
                style: widget.style,
              ),

            if (tp.didExceedMaxLines && widget.readMoreIcon != null)
              GestureDetector(
                key: widget.readMoreKey,
                onTap: _onReadMoreClicked,
                child:
                    _isTextExpanded
                        ? widget.readLessIcon!
                        : widget.readMoreIcon!,
              ),
          ],
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

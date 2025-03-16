import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

/// A highly customizable text widget that can expand and collapse long text
/// content with rich text annotations and styling options.
///
/// Example usage with clickable URLs:
/// ```dart
/// CoreReadMoreText(
///   'Visit https://example.com for more details. '
///   'Follow #flutter on social media!',
///   trimLength: 50,
///   trimMode: TrimMode.Length,
///   moreStyle: TextStyle(color: Colors.blue),
///   lessStyle: TextStyle(color: Colors.blue),
///   annotations: [
///     Annotation(
///       regExp: RegExp(r'https?://\S+'),
///       spanBuilder: ({text, textStyle}) =&gt; TextSpan(
///         text: text,
///         style: textStyle?.copyWith(color: Colors.blue),
///         recognizer: TapGestureRecognizer()..onTap = () {
///           launchUrl(Uri.parse(text));
///         },
///       ),
///     ),
///     Annotation(
///       regExp: RegExp(r'#(\w+)'),
///       spanBuilder: ({text, textStyle}) =&gt; TextSpan(
///         text: text,
///         style: textStyle?.copyWith(
///           color: Colors.green,
///           fontWeight: FontWeight.bold,
///         ),
///       ),
///     ),
///   ],
/// )
/// ```
class CoreReadMoreText extends StatefulWidget {
  /// Creates an expandable/collapsible text widget with rich formatting options
  const CoreReadMoreText(
    this.data, {
    super.key,
    this.isCollapsed,
    this.preDataText,
    this.postDataText,
    this.preDataTextStyle,
    this.postDataTextStyle,
    this.trimExpandedText = 'show less',
    this.trimCollapsedText = 'read more',
    this.colorClickableText,
    this.trimLength = 100,
    this.trimLines = 2,
    this.trimMode = CoreTrimMode.line,
    this.style,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.textScaler,
    this.semanticsLabel,
    this.moreStyle,
    this.lessStyle,
    this.delimiter = '… ',
    this.delimiterStyle,

    this.isExpandable = true,
  });

  /// The primary text content to be displayed
  final String data;

  /// External controller for collapse/expand state
  final ValueNotifier<bool>? isCollapsed;

  /// Text displayed before the main content
  final String? preDataText;

  /// Text displayed after the main content and before the expand/collapse button
  final String? postDataText;

  /// Style for the preDataText content
  final TextStyle? preDataTextStyle;

  /// Style for the postDataText content
  final TextStyle? postDataTextStyle;

  /// Text to show when content is expanded (default: 'show less')
  final String trimExpandedText;

  /// Text to show when content is collapsed (default: 'read more')
  final String trimCollapsedText;

  /// Color for the expand/collapse button text (inherits from theme if null)
  final Color? colorClickableText;

  /// Maximum character count when trimMode == Length (default: 240)
  final int trimLength;

  /// Maximum line count when trimMode == Lines (default: 2)
  final int trimLines;

  /// Determines text truncation method (characters vs lines)
  final CoreTrimMode trimMode;

  /// Base text style for the content
  final TextStyle? style;

  /// Text alignment for the content
  final TextAlign? textAlign;

  /// Text direction for the content
  final TextDirection? textDirection;

  /// Locale for the text
  final Locale? locale;

  /// Text scaling factor
  final TextScaler? textScaler;

  /// Semantic label for accessibility
  final String? semanticsLabel;

  /// Style for the expand button text
  final TextStyle? moreStyle;

  /// Style for the collapse button text
  final TextStyle? lessStyle;

  /// Delimiter between text and expand/collapse button (default: '… ')
  final String delimiter;

  /// Style for the delimiter text
  final TextStyle? delimiterStyle;

  /// Enables/disables expand functionality (default: true)
  final bool isExpandable;

  @override
  State<CoreReadMoreText> createState() => _CoreReadMoreTextState();
}

class _CoreReadMoreTextState extends State<CoreReadMoreText> {
  TrimMode get trimMode => switch (widget.trimMode) {
    CoreTrimMode.length => TrimMode.Length,

    CoreTrimMode.line => TrimMode.Line,
  };
  @override
  Widget build(BuildContext context) {
    return ReadMoreText(
      '${widget.data} ',
      key: widget.key,
      isCollapsed: widget.isCollapsed,
      preDataText: widget.preDataText,
      postDataText: widget.postDataText,
      preDataTextStyle: widget.preDataTextStyle,
      postDataTextStyle: widget.postDataTextStyle,
      trimExpandedText: widget.trimExpandedText,
      trimCollapsedText: widget.trimCollapsedText,
      colorClickableText: widget.colorClickableText,
      trimLength: widget.trimLength,
      trimLines: widget.trimLines,
      trimMode: trimMode,
      style: widget.style,
      textAlign: widget.textAlign,
      textDirection: widget.textDirection,
      locale: widget.locale,
      textScaler: widget.textScaler,
      semanticsLabel: widget.semanticsLabel,
      moreStyle: widget.moreStyle,
      lessStyle: widget.lessStyle,
      delimiter: widget.delimiter,
      delimiterStyle: widget.delimiterStyle,

      isExpandable: widget.isExpandable,
    );
  }
}

enum CoreTrimMode { length, line }

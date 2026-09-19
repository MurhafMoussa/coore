import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

enum CoreTrimMode { length, line }

class const CoreReadMoreText(
  final String data, {
  super.key,
  final ValueNotifier<bool>? isCollapsed,
  final String? preDataText,
  final String? postDataText,
  final TextStyle? preDataTextStyle,
  final TextStyle? postDataTextStyle,
  final String trimExpandedText = 'show less',
  final String trimCollapsedText = 'read more',
  final Color? colorClickableText,
  final int trimLength = 100,
  final int trimLines = 2,
  final CoreTrimMode trimMode = CoreTrimMode.line,
  final TextStyle? style,
  final TextAlign? textAlign,
  final TextDirection? textDirection,
  final Locale? locale,
  final TextScaler? textScaler,
  final String? semanticsLabel,
  final TextStyle? moreStyle,
  final TextStyle? lessStyle,
  final String delimiter = '… ',
  final TextStyle? delimiterStyle,
  final bool isExpandable = true,
}) extends StatefulWidget {

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

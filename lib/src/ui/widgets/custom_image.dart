import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:coore/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';

class CustomImage extends StatelessWidget {
  const CustomImage._({
    this.imageUrl,
    this.imagePath,
    this.imageBytes,
    this.imageFile,
    this.scale,
    this.width,
    this.height,
    this.color,
    this.colorBlendMode,
    this.fit = BoxFit.fill,
    this.alignment = Alignment.center,
    this.placeholderAssetImage,
    this.placeholderBuilder,
    this.progressIndicatorBuilder,
    this.errorBuilder,
    this.showError = false,
    this.showProgressIndicator = false,
    this.memCacheWidth,
    this.memCacheHeight,
    this.cacheKey,
    this.maxWidthDiskCache,
    this.maxHeightDiskCache,
    this.shimmerBaseColor,
    this.shimmerHighlightColor,
    this.placeholderForegroundColor,
    this.httpHeaders,
    this.imageBuilder,
    this.fadeOutDuration = const Duration(milliseconds: 1000),
    this.fadeOutCurve = Curves.easeOut,
    this.fadeInDuration = const Duration(milliseconds: 500),
    this.fadeInCurve = Curves.easeIn,
    this.repeat = ImageRepeat.noRepeat,
    this.matchTextDirection = false,
    this.useOldImageOnUrlChange = false,
    this.progressBarColor,
    this.filterQuality = FilterQuality.low,
    this.placeholderFadeInDuration,
  });

  /// Factory constructor for network image
  factory CustomImage.network(
    String imageUrl, {
    String? placeholderAssetImage,
    Widget Function(BuildContext context, String)? placeholderBuilder,
    Widget Function(BuildContext, String, DownloadProgress)?
    progressIndicatorBuilder,
    Widget Function(BuildContext, String, dynamic)? errorBuilder,
    bool showError = false,
    bool showProgressIndicator = false,
    double? height,
    double? width,
    BoxFit fit = BoxFit.fill,
    Alignment alignment = Alignment.center,
    int? memCacheWidth,
    int? memCacheHeight,
    String? cacheKey,
    int? maxWidthDiskCache,
    int? maxHeightDiskCache,
    Color? shimmerBaseColor,
    Color? shimmerHighlightColor,
    Color? placeholderForegroundColor,
    Map<String, String>? httpHeaders,
    Widget Function(BuildContext context, ImageProvider<Object> imageProvider)?
    imageBuilder,
    Duration? fadeOutDuration = const Duration(milliseconds: 1000),
    Curve fadeOutCurve = Curves.easeOut,
    Duration fadeInDuration = const Duration(milliseconds: 500),
    Curve fadeInCurve = Curves.easeIn,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    bool matchTextDirection = false,
    bool useOldImageOnUrlChange = false,
    Color? color,
    Color? progressBarColor,
    FilterQuality filterQuality = FilterQuality.low,
    BlendMode? colorBlendMode,
    Duration? placeholderFadeInDuration,
  }) {
    return CustomImage._(
      imageUrl: imageUrl,
      placeholderAssetImage: placeholderAssetImage,
      placeholderBuilder: placeholderBuilder,
      progressIndicatorBuilder: progressIndicatorBuilder,
      errorBuilder: errorBuilder,
      showError: showError,
      showProgressIndicator: showProgressIndicator,
      height: height,
      width: width,
      fit: fit,
      alignment: alignment,
      memCacheWidth: memCacheWidth,
      memCacheHeight: memCacheHeight,
      cacheKey: cacheKey,
      maxWidthDiskCache: maxWidthDiskCache,
      maxHeightDiskCache: maxHeightDiskCache,
      shimmerBaseColor: shimmerBaseColor,
      shimmerHighlightColor: shimmerHighlightColor,
      placeholderForegroundColor: placeholderForegroundColor,
      httpHeaders: httpHeaders,
      imageBuilder: imageBuilder,
      fadeOutDuration: fadeOutDuration,
      fadeOutCurve: fadeOutCurve,
      fadeInDuration: fadeInDuration,
      fadeInCurve: fadeInCurve,
      repeat: repeat,
      matchTextDirection: matchTextDirection,
      useOldImageOnUrlChange: useOldImageOnUrlChange,
      color: color,
      progressBarColor: progressBarColor,
      filterQuality: filterQuality,
      colorBlendMode: colorBlendMode,
      placeholderFadeInDuration: placeholderFadeInDuration,
    );
  }

  /// Factory constructor for asset image
  factory CustomImage.asset(
    String imagePath, {
    double? scale,
    double? width,
    double? height,
    Color? color,
    BlendMode? colorBlendMode,
    BoxFit? fit = BoxFit.fill,
    Alignment alignment = Alignment.center,
  }) {
    return CustomImage._(
      imagePath: imagePath,
      scale: scale,
      width: width,
      height: height,
      color: color,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
    );
  }

  /// Factory constructor for file image
  factory CustomImage.file(
    String imagePath, {
    double? scale,
    double? width,
    double? height,
    Color? color,
    BlendMode? colorBlendMode,
    BoxFit? fit = BoxFit.fill,
    Alignment alignment = Alignment.center,
  }) {
    return CustomImage._(
      imageFile: File(imagePath),
      scale: scale,
      width: width,
      height: height,
      color: color,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
    );
  }

  final String? imageUrl;
  final String? imagePath;
  final Uint8List? imageBytes;
  final File? imageFile;
  final double? scale;
  final double? width;
  final double? height;
  final Color? color;
  final BlendMode? colorBlendMode;
  final BoxFit? fit;
  final Alignment alignment;
  final String? placeholderAssetImage;
  final Widget Function(BuildContext, String)? placeholderBuilder;
  final Widget Function(BuildContext, String, DownloadProgress)?
  progressIndicatorBuilder;
  final Widget Function(BuildContext, String, dynamic)? errorBuilder;
  final bool showError;
  final bool showProgressIndicator;
  final int? memCacheWidth;
  final int? memCacheHeight;
  final String? cacheKey;
  final int? maxWidthDiskCache;
  final int? maxHeightDiskCache;
  final Color? shimmerBaseColor;
  final Color? shimmerHighlightColor;
  final Color? placeholderForegroundColor;

  final Map<String, String>? httpHeaders;
  final Widget Function(
    BuildContext context,
    ImageProvider<Object> imageProvider,
  )?
  imageBuilder;
  final Duration? fadeOutDuration;
  final Curve fadeOutCurve;
  final Duration fadeInDuration;
  final Curve fadeInCurve;
  final ImageRepeat repeat;
  final bool matchTextDirection;
  final bool useOldImageOnUrlChange;
  final Color? progressBarColor;
  final FilterQuality filterQuality;
  final Duration? placeholderFadeInDuration;

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null) {
      return CachedNetworkImage(
        color: color,
        colorBlendMode: colorBlendMode,
        fadeInCurve: fadeInCurve,
        fadeInDuration: fadeInDuration,
        fadeOutCurve: fadeOutCurve,
        fadeOutDuration: fadeOutDuration,
        filterQuality: filterQuality,
        httpHeaders: httpHeaders,
        imageBuilder: imageBuilder,
        key: key,
        matchTextDirection: matchTextDirection,
        placeholderFadeInDuration: placeholderFadeInDuration,
        repeat: repeat,
        useOldImageOnUrlChange: useOldImageOnUrlChange,
        memCacheHeight: memCacheHeight,
        memCacheWidth: memCacheWidth,
        maxHeightDiskCache: maxHeightDiskCache,
        maxWidthDiskCache: maxWidthDiskCache,
        cacheKey: cacheKey,
        height: height,
        width: width,
        fit: fit,
        alignment: alignment,
        imageUrl: imageUrl!,
        placeholder:
            (placeholderBuilder != null)
                ? placeholderBuilder
                : ((progressIndicatorBuilder == null && !showProgressIndicator)
                    ? _defaultPlaceholderBuilder()
                    : null),
        errorWidget: errorBuilder ?? _defaultErrorBuilder(context),
        progressIndicatorBuilder:
            progressIndicatorBuilder ??
            ((placeholderBuilder == null && showProgressIndicator)
                ? _defaultProgressIndicatorBuilder(context)
                : null),
      );
    } else if (imageFile != null) {
      return Image.file(
        imageFile!,
        key: key,
        scale: scale ?? 1,
        width: width,
        height: height,
        color: color,
        fit: fit,
        alignment: alignment,
        colorBlendMode: colorBlendMode,
      );
    } else if (imageBytes != null) {
      return Image.memory(
        imageBytes!,
        key: key,
        scale: scale!,
        width: width,
        height: height,
        color: color,
        fit: fit,
        alignment: alignment,
        colorBlendMode: colorBlendMode,
      );
    } else if (imagePath != null) {
      final bool isSvg = imagePath!.endsWith('svg');
      return isSvg
          ? SvgPicture.asset(
            imagePath!,
            key: key,
            width: width,
            height: height,
            colorFilter:
                color != null
                    ? ColorFilter.mode(
                      color!,
                      colorBlendMode ?? BlendMode.srcIn,
                    )
                    : null,
            fit: fit ?? BoxFit.contain,
            alignment: alignment,
          )
          : Image.asset(
            imagePath!,
            key: key,
            scale: scale,
            width: width,
            height: height,
            color: color,
            fit: fit,
            alignment: alignment,
            colorBlendMode: colorBlendMode,
          );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget Function(BuildContext context, String url)
  _defaultPlaceholderBuilder() {
    return (BuildContext context, String url) {
      return SizedBox(
        width: width,
        height: height,
        child: Shimmer.fromColors(
          baseColor: shimmerBaseColor ?? Colors.grey.shade300,
          highlightColor:
              shimmerHighlightColor ?? context.colorScheme.onInverseSurface,
          child: _buildSvgPlaceHolder(),
        ),
      );
    };
  }

  Widget _buildSvgPlaceHolder() {
    return Icon(
      Icons.image,
      size: width,
      color: placeholderForegroundColor ?? Colors.grey.shade300,
      blendMode: BlendMode.srcIn,
    );
  }

  Widget Function(BuildContext context, String url, Object error)
  _defaultErrorBuilder(BuildContext context) {
    return (BuildContext context, String url, Object error) {
      return placeholderAssetImage == null
          ? _buildSvgPlaceHolder()
          : CustomImage.asset(
            placeholderAssetImage!,
            width: width,
            height: height,
            fit: fit,
            alignment: alignment,
            color: Colors.grey.shade300,
          );
    };
  }

  Widget Function(BuildContext context, String url, DownloadProgress progress)
  _defaultProgressIndicatorBuilder(BuildContext context) {
    return (BuildContext context, String url, DownloadProgress progress) {
      if (progress.totalSize == null) {
        return _buildSvgPlaceHolder();
      }
      return CircularProgressIndicator.adaptive(
        value: progress.downloaded / progress.totalSize!,
        strokeWidth: 5,
        strokeAlign: -3,
        backgroundColor: Colors.grey.shade300,
        valueColor: AlwaysStoppedAnimation<Color>(
          progressBarColor ?? context.colorScheme.primary,
        ),
      );
    };
  }
}

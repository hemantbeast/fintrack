// Fix warning
// ignore_for_file: depend_on_referenced_packages
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CustomImage extends StatelessWidget {
  const CustomImage({
    required this.image,
    super.key,
    this.fit,
    this.shape,
    this.borderRadius,
    this.clipBehavior = Clip.antiAlias,
    this.filterQuality = FilterQuality.low,
    this.width,
    this.height,
    this.color,
    this.constraints,
    this.excludeFromSemantics = false,
    this.semanticLabel,
    this.placeholder,
    this.errorWidget,
  });

  final ImageProvider<Object> image;

  final BoxFit? fit;

  final BoxShape? shape;

  final BorderRadius? borderRadius;

  final Clip clipBehavior;

  final FilterQuality filterQuality;

  final double? width;

  final double? height;

  final Color? color;

  final BoxConstraints? constraints;

  final bool excludeFromSemantics;

  final String? semanticLabel;

  final Widget Function(BuildContext context, String placeholder)? placeholder;

  final Widget Function(BuildContext context, String error, dynamic stackTrace)? errorWidget;

  @override
  Widget build(BuildContext context) {
    Widget? imgWidget;
    final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);

    if (image is NetworkImage) {
      final cachedImage = image as NetworkImage;

      imgWidget = CachedNetworkImage(
        imageUrl: cachedImage.url,
        height: height,
        width: width,
        fit: fit,
        color: color,
        filterQuality: filterQuality,
        cacheManager: CacheImageManager().instance,
        memCacheWidth: width != null ? (width! * devicePixelRatio).round() : null,
        placeholder: (context, url) {
          return placeholder?.call(context, '') ?? const SizedBox();
        },
        errorWidget: (context, url, error) {
          return errorWidget?.call(context, error.toString(), null) ?? const SizedBox();
        },
        errorListener: (value) {
          debugPrint(value.toString());
        },
      );
    } else if (image is AssetImage) {
      imgWidget = Image.asset(
        (image as AssetImage).assetName,
        filterQuality: filterQuality,
        fit: fit,
        width: width,
        height: height,
        color: color,
      );
    } else if (image is MemoryImage) {
      imgWidget = Image.memory(
        (image as MemoryImage).bytes,
        filterQuality: filterQuality,
        fit: fit,
        width: width,
        height: height,
        color: color,
        gaplessPlayback: true,
      );
    } else if (image is FileImage) {
      imgWidget = Image.file(
        (image as FileImage).file,
        filterQuality: filterQuality,
        fit: fit,
        width: width,
        height: height,
        color: color,
      );
    }

    if (shape != null) {
      switch (shape!) {
        case BoxShape.circle:
          imgWidget = ClipOval(
            clipBehavior: clipBehavior,
            child: imgWidget,
          );
        case BoxShape.rectangle:
          if (borderRadius != null) {
            imgWidget = ClipRRect(
              borderRadius: borderRadius!,
              clipBehavior: clipBehavior,
              child: imgWidget,
            );
          }
      }
    }

    if (constraints != null) {
      imgWidget = ConstrainedBox(
        constraints: constraints!,
        child: imgWidget,
      );
    }

    if (excludeFromSemantics) {
      return imgWidget!;
    }
    return Semantics(
      container: semanticLabel != null,
      image: true,
      label: semanticLabel ?? '',
      child: imgWidget,
    );
  }
}

class CacheImageManager {
  factory CacheImageManager() {
    return _instance;
  }

  CacheImageManager._internal() {
    instance = DefaultCacheManager();
  }

  late final CacheManager instance;

  static final CacheImageManager _instance = CacheImageManager._internal();
}

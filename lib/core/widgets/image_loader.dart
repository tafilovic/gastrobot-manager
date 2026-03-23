import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Loads and displays an image from a URL.
/// When [cache] is true (default), uses [CachedNetworkImage]. When false (e.g. profile image),
/// uses [Image.network] so the image is always fetched fresh.
class ImageLoader extends StatelessWidget {
  const ImageLoader({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.cache = true,
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final bool cache;

  @override
  Widget build(BuildContext context) {
    if (cache) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: placeholder != null
            ? (_, _) => placeholder!
            : (_, _) => const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
        errorWidget: errorWidget != null
            ? (_, _, _) => errorWidget!
            : (_, _, _) => const Icon(Icons.broken_image_outlined),
      );
    }
    return Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return placeholder != null
            ? placeholder!
            : const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
      },
      errorBuilder: (_, _, _) =>
          errorWidget ?? const Icon(Icons.broken_image_outlined),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Loads and displays an image from a URL with caching.
/// Wraps [CachedNetworkImage] so the implementation can be replaced later
/// (e.g. different cache or network image package) without changing call sites.
class ImageLoader extends StatelessWidget {
  const ImageLoader({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: placeholder != null
          ? (_, __) => placeholder!
          : (_, __) => const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
      errorWidget: errorWidget != null
          ? (_, __, ___) => errorWidget!
          : (_, __, ___) => const Icon(Icons.broken_image_outlined),
    );
  }
}

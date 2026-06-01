import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class AppImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final bool isApiImage;
  final IconData? errorIcon;

  const AppImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.isApiImage = true,
    this.errorIcon,
  });

  @override
  Widget build(BuildContext context) {
    Widget image = CachedNetworkImage(
      imageUrl: '$url',
      width: width,
      height: height,
      fit: fit,

      // =========================
      // SKELETON (shimmer_animation)
      // =========================
      placeholder: (context, url) {
        return Shimmer(
          duration: const Duration(seconds: 2),
          interval: const Duration(milliseconds: 500),
          color: Colors.grey.shade300,
          colorOpacity: 0.3,
          enabled: true,
          child: CircleAvatar(
            child: Container(
              width: width,
              height: height,
              color: Colors.grey.shade300,
            ),
          ),
        );
      },

      // =========================
      // ERROR
      // =========================
      errorWidget: (context, url, error) {
        return Container(
          width: width,
          height: height,
          color: Colors.grey.shade200,
          child: Icon(errorIcon ?? Icons.broken_image),
        );
      },
    );

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: image);
    }

    return image;
  }
}

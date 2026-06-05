import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CircleAppImage extends StatefulWidget {
  const CircleAppImage({
    super.key,
    this.imageUrl,
    this.name,
    this.radius = 18,
    this.backgroundColor,
    this.foregroundColor,
    this.fallbackIcon = Icons.person_outline,
  });

  final String? imageUrl;
  final String? name;
  final double radius;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final IconData fallbackIcon;

  @override
  State<CircleAppImage> createState() => _CircleAppImageState();
}

class _CircleAppImageState extends State<CircleAppImage> {
  bool _hasImageError = false;

  @override
  void didUpdateWidget(covariant CircleAppImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      _hasImageError = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final imageUrl = widget.imageUrl?.trim();
    final canLoadImage =
        imageUrl != null && imageUrl.isNotEmpty && !_hasImageError;
    final foregroundColor =
        widget.foregroundColor ?? colorScheme.onSecondaryContainer;

    return CircleAvatar(
      radius: widget.radius,
      backgroundColor: widget.backgroundColor ?? colorScheme.secondaryContainer,
      foregroundColor: foregroundColor,
      backgroundImage: canLoadImage
          ? CachedNetworkImageProvider(imageUrl)
          : null,
      onBackgroundImageError: canLoadImage
          ? (_, _) {
              if (mounted) {
                setState(() => _hasImageError = true);
              }
            }
          : null,
      child: canLoadImage ? null : _FallbackContent(widget: widget),
    );
  }
}

class _FallbackContent extends StatelessWidget {
  const _FallbackContent({required this.widget});

  final CircleAppImage widget;

  @override
  Widget build(BuildContext context) {
    final initial = _initial(widget.name);
    if (initial != null) {
      return Text(
        initial,
        style: TextStyle(
          fontSize: widget.radius * 0.82,
          fontWeight: FontWeight.w800,
        ),
      );
    }
    return Icon(widget.fallbackIcon, size: widget.radius);
  }

  String? _initial(String? name) {
    final trimmed = name?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed.characters.first.toUpperCase();
  }
}

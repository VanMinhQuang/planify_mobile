import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

/// Types of marker UI to render on the map.
enum MarkerType {
  /// A rounded card with icon + title + optional subtitle.
  card,

  /// A classic teardrop pin with an icon inside.
  pin,

  /// A small pill badge (e.g. price, status label) with a tail arrow.
  badge,

  /// Provide your own [customWidget].
  custom,
}

class MapMarkerModel<T> {
  const MapMarkerModel({
    required this.id,
    required this.latLng,
    this.type = MarkerType.pin,
    this.title,
    this.subtitle,
    this.imageUrl,
    this.icon,
    this.iconColor,
    this.markerColor,
    this.badgeText,
    this.customWidget,
    this.width = 130,
    this.height = 70,
    this.data,
  });

  final String id;
  final LatLng latLng;
  final MarkerType type;

  final String? title;
  final String? subtitle;

  final String? imageUrl;

  final IconData? icon;
  final Color? iconColor;
  final Color? markerColor;

  final String? badgeText;

  final Widget? customWidget;

  final double width;
  final double height;

  /// ✅ strongly typed custom payload
  final T? data;

  MapMarkerModel<T> copyWith({
    String? id,
    LatLng? latLng,
    MarkerType? type,
    String? title,
    String? subtitle,
    String? imageUrl,
    IconData? icon,
    Color? iconColor,
    Color? markerColor,
    String? badgeText,
    Widget? customWidget,
    double? width,
    double? height,
    T? data,
  }) {
    return MapMarkerModel<T>(
      id: id ?? this.id,
      latLng: latLng ?? this.latLng,
      type: type ?? this.type,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      imageUrl: imageUrl ?? this.imageUrl,
      icon: icon ?? this.icon,
      iconColor: iconColor ?? this.iconColor,
      markerColor: markerColor ?? this.markerColor,
      badgeText: badgeText ?? this.badgeText,
      customWidget: customWidget ?? this.customWidget,
      width: width ?? this.width,
      height: height ?? this.height,
      data: data ?? this.data,
    );
  }
}

import 'package:app_core/ui/widgets/map/map_attributes.dart';
import 'package:flutter/material.dart';

class PinMarker extends StatelessWidget {
  final MapMarkerModel model;
  const PinMarker({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final color = model.markerColor ?? Theme.of(context).primaryColor;
    final iconColor = model.iconColor ?? Colors.white;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2.5),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(
            model.icon ?? Icons.location_on,
            color: iconColor,
            size: 18,
          ),
        ),
        Container(
          width: 3,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: color.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}

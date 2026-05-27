import 'package:app_core/ui/widgets/map/map_attributes.dart';
import 'package:flutter/material.dart';

class BadgeMarker extends StatelessWidget {
  final MapMarkerModel model;
  const BadgeMarker({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final color = model.markerColor ?? Theme.of(context).primaryColor;
    final iconColor = model.iconColor ?? color;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(6, 5, 10, 5),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.35),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  model.icon ?? Icons.sell_rounded,
                  color: iconColor,
                  size: 11,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                model.badgeText ?? '', // ← uses badgeText, not label
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        // small tail
        CustomPaint(size: const Size(10, 6), painter: _BadgeTailPainter(color)),
      ],
    );
  }
}

class _BadgeTailPainter extends CustomPainter {
  final Color color;
  const _BadgeTailPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}

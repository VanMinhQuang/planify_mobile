import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';

class CardMarker extends StatelessWidget {
  final MapMarkerModel model;
  const CardMarker({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final color = model.markerColor ?? Theme.of(context).primaryColor;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black12, width: 0.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: model.imageUrl != null
                    ? Image.network(
                        model.imageUrl!,
                        width: 36,
                        height: 36,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _fallbackIcon(color),
                      )
                    : _fallbackIcon(color),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (model.title != null)
                      Text(model.title!, style: AppTextStyles.normal12()),
                    if (model.subtitle != null)
                      Text(
                        model.subtitle!,
                        style: AppTextStyles.normal10(color: AppColor.hint),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        CustomPaint(size: const Size(14, 8), painter: _TailPainter()),
      ],
    );
  }

  Widget _fallbackIcon(Color color) {
    return Container(
      width: 36,
      height: 36,
      color: color.withOpacity(0.15),
      child: Icon(model.icon ?? Icons.location_on, color: color, size: 18),
    );
  }
}

class _TailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()..color = Colors.white;
    final stroke = Paint()
      ..color = Colors.black12
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, fill);
    canvas.drawPath(path, stroke);
  }

  @override
  bool shouldRepaint(_) => false;
}

import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';

class LegendDot extends StatelessWidget {
  const LegendDot({super.key, required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 6.w,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        Text(label, style: AppTextStyles.normal12(color: AppColor.primary)),
      ],
    );
  }
}

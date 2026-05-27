import 'package:flutter/material.dart';

import '../../app_core.dart';

class StatusBadge extends StatelessWidget {
  final Color color;
  final String label;
  final EdgeInsetsGeometry? padding;

  const StatusBadge({
    super.key,
    required this.color,
    required this.label,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 5.w,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          Text(label, style: AppTextStyles.semiBold10(color: Colors.white)),
        ],
      ),
    );
  }
}

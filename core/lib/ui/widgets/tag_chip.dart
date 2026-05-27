import 'package:app_core/ui/ui.dart';
import 'package:flutter/material.dart';

class TagChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final EdgeInsetsGeometry? padding;
  final Color color;
  final Color textColor;
  const TagChip({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.textColor,

    this.padding,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: padding ?? EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(12.sp),
      border: Border.all(
        color: AppColor.border.withValues(alpha: 0.15),
        width: 0.5,
      ),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 11.sp, color: textColor),
        SizedBox(width: 4.w),
        Text(label, style: AppTextStyles.semiBold10(color: textColor)),
      ],
    ),
  );
}

import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';

class SectionWidget extends StatelessWidget {
  const SectionWidget({
    super.key,
    this.title = '',
    this.icon,
    this.children = const [],
    this.titleBorderColor,
    this.textColor,
    this.backgroundColor,
    this.hasSpacing = true,
  });

  final String title;
  final IconData? icon;
  final List<Widget> children;
  final Color? titleBorderColor;
  final Color? textColor;
  final Color? backgroundColor;
  final bool hasSpacing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Stack(
        children: [
          // 🔲 Container (card)
          Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
            decoration: BoxDecoration(
              color: backgroundColor ?? AppColor.background,
              borderRadius: BorderRadius.circular(12),
              border: Border(
                left: BorderSide(
                  color: titleBorderColor ?? Colors.transparent,
                  width: 6,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children
                  .expand(
                    (w) => [w, if (hasSpacing) const SizedBox(height: 12)],
                  )
                  .toList(),
            ),
          ),

          // 🏷 Title overlay
          Positioned(
            left: 12,
            top: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: titleBorderColor ?? Colors.transparent,
                ),
              ),
              child: Row(
                children: [
                  if (icon != null)
                    Icon(icon, size: 14, color: textColor ?? AppColor.blueDark),
                  if (icon != null) const SizedBox(width: 4),
                  Text(
                    title,
                    style: AppTextStyles.semiBold12(
                      color: textColor ?? AppColor.textDark,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

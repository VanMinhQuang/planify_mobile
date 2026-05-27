import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';

class DefaultAppBar extends StatelessWidget {
  const DefaultAppBar({
    super.key,
    this.onBack,
    required this.title,
    this.canGoBack = false,
    this.onRight,
    this.iconRight,
  });

  final String title;
  final bool canGoBack; // ← fixed casing
  final VoidCallback? onBack;
  final Widget? iconRight;
  final VoidCallback? onRight;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 56.h, 12.w, 8.h),
      decoration: BoxDecoration(gradient: AppColor.darkGradient),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ── Left: back button or spacer ──────────────
          if (canGoBack)
            InkWell(
              onTap: onBack ?? () => Navigator.of(context).pop(),
              child: Icon(
                Icons.arrow_back_rounded,
                size: 18.sp,
                color: AppColor.white,
              ),
            )
          else
            SizedBox.square(dimension: 18.h),

          // ── Center: title ────────────────────────────
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              style: AppTextStyles.semiBold16(color: AppColor.white),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),

          // ── Right: icon or spacer ────────────────────
          if (iconRight != null)
            GestureDetector(onTap: onRight, child: iconRight)
          else
            SizedBox.square(dimension: 18.h),
        ],
      ),
    );
  }
}

import 'package:app_core/ui/ui.dart';
import 'package:flutter/material.dart';

class DetailCard extends StatelessWidget {
  final Widget child;
  const DetailCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12.sp),
      border: Border.all(color: AppColor.border, width: 0.5),
      boxShadow: [
        BoxShadow(
          color: AppColor.foreground.withValues(alpha: 0.15),
          blurRadius: 12,
          offset: Offset(0, 4.h),
        ),
      ],
    ),
    child: child,
  );
}

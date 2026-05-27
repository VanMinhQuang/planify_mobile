import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';

class MetaItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  const MetaItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final isEmpty = value == null || value!.isEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 12.w,
              color: AppColor.muted.withValues(alpha: 0.6),
            ),
            SizedBox(width: 4.w),
            Text(
              label,
              style: AppTextStyles.normal10().copyWith(
                color: AppColor.muted.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Text(
          isEmpty ? 'Chưa có' : value!,
          style: isEmpty
              ? AppTextStyles.normal12().copyWith(color: AppColor.muted)
              : AppTextStyles.semiBold12(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

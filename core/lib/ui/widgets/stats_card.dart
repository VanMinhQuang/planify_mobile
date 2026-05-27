import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';

class MiniStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const MiniStatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          spacing: 6.h,
          children: [
            Icon(icon, size: 18, color: AppColor.primary),
            Text(value, style: AppTextStyles.bold16()),
            Text(
              label,
              style: AppTextStyles.normal12(color: AppColor.textMuted),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final IconData? icon;

  const SectionCard({
    super.key,
    required this.title,
    required this.child,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 24, color: AppColor.primary),
                  SizedBox(width: 10.w),
                ],
                Text(title, style: AppTextStyles.semiBold14()),
              ],
            ),
          ),
          Separator.divider(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: child,
          ),
        ],
      ),
    );
  }
}

class InfoColumn extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  const InfoColumn({
    super.key,
    required this.icon,
    required this.label,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    final isEmpty = value == null || value!.isEmpty;
    return Row(
      children: [
        Icon(icon, size: 18.sp, color: AppColor.muted.withValues(alpha: 0.6)),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.normal12(
                  color: AppColor.muted.withValues(alpha: 0.6),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                isEmpty ? 'Chưa có' : value!,
                style: isEmpty
                    ? AppTextStyles.normal14(color: AppColor.muted)
                    : AppTextStyles.semiBold14(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  final int? labelFlex;
  final int? valueFlex;
  final int textSize;
  final int iconSize;
  final double paddingVertical;

  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
    this.labelFlex,
    this.valueFlex,
    this.textSize = 14,
    this.iconSize = 16,
    this.paddingVertical = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: paddingVertical.h),
      child: Row(
        children: [
          Icon(icon, size: iconSize.sp, color: AppColor.primary),
          SizedBox(width: 10.w),
          Expanded(
            flex: labelFlex ?? 3,
            child: Text(
              label,
              style: AppTextStyles.normal14().copyWith(fontSize: textSize.sp),
            ),
          ),
          Expanded(
            flex: valueFlex ?? 5,
            child: Text(
              value.isNotEmpty ? value : '-',
              style: AppTextStyles.semiBold14(
                color: valueColor ?? AppColor.textDark,
              ).copyWith(fontSize: textSize.sp),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

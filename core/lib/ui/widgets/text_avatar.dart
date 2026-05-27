import 'package:flutter/material.dart';
import '../../app_core.dart';

class TextAvatar extends StatelessWidget {
  final String name;
  final bool danger;
  const TextAvatar({super.key, required this.name, this.danger = false});

  String get _initials {
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32.w,
      height: 32.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: danger
            ? AppColor.red500.withValues(alpha: 0.1)
            : AppColor.slate200,
        border: Border.all(
          color: AppColor.border.withValues(alpha: 0.15),
          width: 0.5,
        ),
      ),
      child: Center(
        child: Text(
          _initials,
          style: AppTextStyles.normal12().copyWith(
            fontWeight: FontWeight.w500,
            color: danger ? AppColor.red700 : AppColor.muted,
          ),
        ),
      ),
    );
  }
}

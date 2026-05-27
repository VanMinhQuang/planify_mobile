import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';

class EmptyDataWidget extends StatelessWidget {
  final String? text;
  final IconData icon;

  const EmptyDataWidget({
    super.key,
    this.text,
    this.icon = LucideIcons.fileQuestionMark,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 64, color: AppColor.hint),
          const SizedBox(height: 12),
          Text(
            text ?? LocaleKeys.no_data.tr(),
            style: AppTextStyles.normal14(color: AppColor.hint),
          ),
        ],
      ),
    );
  }
}

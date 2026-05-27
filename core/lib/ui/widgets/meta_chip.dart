import 'package:app_core/ui/constants/app_text_styles.dart';
import 'package:flutter/material.dart';

import '../constants/app_size.dart';

class MetaChip extends StatelessWidget {
  const MetaChip({super.key, required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 4.w,
      children: [
        Icon(icon, size: 13),
        Flexible(child: Text(label, style: AppTextStyles.normal10())),
      ],
    );
  }
}

import 'package:app_core/ui/constants/app_size.dart';
import 'package:flutter/material.dart';

class SectionsItem extends StatelessWidget {
  final Widget? firstItem;
  final Widget? secondItem;
  const SectionsItem({super.key, this.firstItem, this.secondItem});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4.w,
        children: [
          if (firstItem != null) Expanded(child: firstItem!),
          if (secondItem != null) Expanded(child: secondItem!),
        ],
      ),
    );
  }
}

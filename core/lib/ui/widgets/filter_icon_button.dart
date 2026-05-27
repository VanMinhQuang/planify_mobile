import 'package:flutter/material.dart';

import '../../app_core.dart';

class FilterIconButton extends StatelessWidget {
  final bool hasFilter;
  final VoidCallback onTap;

  const FilterIconButton({
    super.key,
    required this.hasFilter,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: hasFilter ? AppColor.blueDark : AppColor.slate100,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: hasFilter ? AppColor.blueDark : AppColor.slate300,
            width: 0.5,
          ),
        ),
        child: Icon(
          LucideIcons.listFilter600,
          color: hasFilter ? AppColor.white : AppColor.slate600,
        ),
      ),
    );
  }
}

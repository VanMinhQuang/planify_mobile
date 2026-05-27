import 'package:flutter/material.dart';

import '../../app_core.dart';

class StatCard extends StatelessWidget {
  final String title;
  final int value;
  final IconData icon;
  final Color iconColor;
  final bool isLoading;
  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            spacing: 8.w,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(10.sp),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 18.sp, color: iconColor),
              ),
              Expanded(
                child: AppSkeleton(
                  isLoading: isLoading,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        value.formatNumberWithDots(),
                        style: AppTextStyles.semiBold14(),
                      ),
                      Text(title, style: AppTextStyles.normal10()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

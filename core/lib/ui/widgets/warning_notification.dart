import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';

class WarningNotificationWidget extends StatelessWidget {
  final List<String> notifications;

  const WarningNotificationWidget({super.key, required this.notifications});

  @override
  Widget build(BuildContext context) {
    final items = notifications.take(3).where((e) => e != '').toList();
    if (items.isEmpty) return SizedBox();
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(vertical: 20.h),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColor.amber50,
          borderRadius: BorderRadius.circular(12),
          border: const Border(
            left: BorderSide(color: AppColor.warning, width: 4),
          ),
        ),
        child: Column(
          children: List.generate(items.length, (index) {
            final text = items[index];
            final isLast = index == items.length - 1;

            return Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 8.w,
                  children: [
                    const Icon(
                      LucideIcons.triangleAlert,
                      color: AppColor.warning,
                    ),
                    Expanded(
                      child: Text(
                        text,
                        style: AppTextStyles.normal10().copyWith(
                          fontSize: 11.sp,
                          color: AppColor.warningDark,
                        ),
                      ),
                    ),
                  ],
                ),

                // 👇 Divider giữa items
                if (!isLast)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.h),
                    child: Separator.divider(),
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

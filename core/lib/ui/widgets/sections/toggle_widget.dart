import 'package:app_core/ui/ui.dart';
import 'package:flutter/material.dart';

class ToggleWidget extends StatelessWidget {
  const ToggleWidget({
    super.key,
    this.label = '',
    this.value = false,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.normal12()),
        Transform.scale(
          scale: 0.9,
          child: Switch.adaptive(
            activeColor: AppColor.blueDark,
            inactiveTrackColor: AppColor.gray500,
            value: value,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

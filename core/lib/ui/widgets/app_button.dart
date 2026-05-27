import 'package:app_core/ui/constants/app_color.dart';
import 'package:app_core/ui/constants/app_radius.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    this.onTap,
    this.child,
    this.isDisabled = false,
    this.colorButton,
    this.borderColor = Colors.transparent,
    this.padding,
  });

  final void Function()? onTap;
  final Widget? child;
  final bool isDisabled;
  final LinearGradient? colorButton;
  final Color borderColor;
  final EdgeInsets? padding;

  LinearGradient get _effectiveGradient =>
      colorButton ?? AppColor.primaryGradient;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isDisabled ? 0.5 : 1.0,
      child: Material(
        color: Colors.transparent,
        borderRadius: AppRadius.rounded10,
        child: InkWell(
          onTap: isDisabled ? null : onTap,
          borderRadius: AppRadius.rounded10,
          child: Ink(
            decoration: BoxDecoration(
              gradient: isDisabled
                  ? LinearGradient(
                      colors: [Colors.grey.shade300, Colors.grey.shade300],
                    )
                  : _effectiveGradient,
              borderRadius: AppRadius.rounded10,
              border: Border.all(color: borderColor),
            ),
            child: Padding(
              padding:
                  padding ??
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              child: Center(child: child),
            ),
          ),
        ),
      ),
    );
  }
}

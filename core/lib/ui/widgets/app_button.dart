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
    this.foregroundColor = AppColor.white,
  });

  final void Function()? onTap;
  final Widget? child;
  final bool isDisabled;
  final LinearGradient? colorButton;
  final Color borderColor;
  final EdgeInsets? padding;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    final effectiveGradient = colorButton ?? context.planifyGradients.primary;
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
                      colors: [AppColor.slate200, AppColor.slate300],
                    )
                  : effectiveGradient,
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

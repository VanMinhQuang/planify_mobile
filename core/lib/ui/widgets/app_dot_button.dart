import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:app_core/ui/constants/app_color.dart';

class AppDottedButton extends StatelessWidget {
  const AppDottedButton({
    super.key,
    this.onTap,
    this.child,
    this.isDisabled = false,
    this.dashPattern = const [6, 4],
    this.strokeWidth = 1.5,
    this.borderRadius = 12,
    this.padding,
    this.colorButton,
  });

  final VoidCallback? onTap;
  final Widget? child;
  final bool isDisabled;
  final List<double> dashPattern;
  final double strokeWidth;
  final double borderRadius;
  final EdgeInsets? padding;
  final LinearGradient? colorButton;

  LinearGradient get _effectiveGradient =>
      colorButton ?? AppColor.primaryGradient;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isDisabled ? 0.5 : 1.0,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: isDisabled ? null : onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: DottedBorder(
            options: RoundedRectDottedBorderOptions(
              radius: Radius.circular(borderRadius),
              strokeWidth: strokeWidth,
              dashPattern: dashPattern,
              padding: EdgeInsets.zero,
              gradient: _effectiveGradient,
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

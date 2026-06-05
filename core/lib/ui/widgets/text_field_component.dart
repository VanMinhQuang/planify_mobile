import 'package:app_core/ui/constants/app_color.dart';
import 'package:app_core/ui/constants/app_radius.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../constants/app_size.dart';
import '../constants/app_text_styles.dart';
import '../theme.dart';
import 'app_skeleton.dart';

class TextFormFieldComponent extends StatelessWidget {
  const TextFormFieldComponent({
    super.key,
    this.onTap,
    this.isDropDown = false,
    this.isDateBox = false,
    this.isReadOnly = false,
    this.boxColor,
    this.placeholder,
    this.prefixIcon,
    this.suffixIcon,
    this.errorText,
    this.validator,
    this.isPassword = false,
    this.obscureText = false,
    this.controller,
    this.keyboardType,
    this.onChanged,
    this.onToggleObscure,
    this.focusNode,
    this.showClearButton = false,
    this.initialValue,
    this.onClear,
    this.isRequired = false,
    this.titleText,
    this.maxLine = 1,
    this.maxLength,
    this.inputFormatter = const [],
    this.isLoadingSkeleton = false,
    this.isAutoValidate = false,
    this.minLine,
    this.labelText,
    this.textInputAction,
  });

  final String? labelText;
  final int? maxLength;
  final VoidCallback? onTap;
  final bool isDropDown;
  final bool isDateBox;
  final bool isReadOnly;
  final bool isRequired;
  final String? titleText;
  final String? placeholder;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? errorText;
  final String? Function(String?)? validator;
  final bool isPassword;
  final bool obscureText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final VoidCallback? onToggleObscure;
  final FocusNode? focusNode;
  final bool showClearButton;
  final String? initialValue;
  final VoidCallback? onClear;
  final int? maxLine;
  final Color? boxColor;
  final List<TextInputFormatter> inputFormatter;
  final bool isLoadingSkeleton;
  final bool isAutoValidate;
  final int? minLine;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (titleText != null)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.h),
            child: RichText(
              text: TextSpan(
                text: titleText!,
                style: context.normal12(),
                children: [
                  if (isRequired)
                    TextSpan(
                      text: ' *',
                      style: context.normal12(color: context.colors.error),
                    ),
                ],
              ),
            ),
          ),

        AppSkeleton(
          isLoading: isLoadingSkeleton,
          child: TextFormField(
            autovalidateMode: isAutoValidate
                ? AutovalidateMode.onUserInteraction
                : null,
            style: context.normal14(color: colors.onSurface),
            onTap: isReadOnly
                ? null
                : (isDropDown || isDateBox)
                ? onTap
                : null,
            //textInputAction: textInputAction,
            readOnly: (isDropDown || isDateBox || isReadOnly),
            minLines: minLine,
            maxLines: maxLine,
            maxLength: maxLength,
            inputFormatters: inputFormatter,
            enableInteractiveSelection:
                !(isDropDown || isDateBox || isReadOnly),
            initialValue: initialValue,
            controller: controller,
            keyboardType: keyboardType,
            focusNode: focusNode,
            obscureText: isPassword ? obscureText : false,
            onChanged: (value) => onChanged?.call(value.trim()),
            validator: (value) => validator?.call(value?.trim()),
            cursorColor: AppColor.muted,
            decoration: InputDecoration(
              filled: true,
              counterText: '',
              labelText: labelText,
              labelStyle: context.normal12(),
              fillColor: isReadOnly ? AppColor.hint.withAlpha(60) : boxColor,
              hintText: placeholder,
              hintStyle: AppTextStyles.normal14(color: AppColor.hint),
              prefixIcon: prefixIcon == null
                  ? null
                  : Padding(
                      padding: EdgeInsets.only(left: 12.h),
                      child: prefixIcon,
                    ),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        obscureText ? Icons.visibility_off : Icons.visibility,
                        color: AppColor.primary,
                      ),
                      onPressed: onToggleObscure,
                    )
                  : showClearButton
                  ? Padding(
                      padding: EdgeInsets.only(right: 12.h),
                      child: GestureDetector(
                        onTap: () {
                          if (controller != null) {
                            controller!.clear();
                          }
                          if (onChanged != null) {
                            onChanged?.call('');
                          }
                          onClear?.call();
                        },
                        child: Icon(
                          LucideIcons.circleX,
                          color: AppColor.primary,
                        ),
                      ),
                    )
                  : isDropDown
                  ? Padding(
                      padding: EdgeInsets.only(right: 12.h),
                      child: Icon(
                        Icons.keyboard_arrow_down_outlined,
                        color: AppColor.primary,
                      ),
                    )
                  : isDateBox
                  ? Padding(
                      padding: EdgeInsets.only(right: 12.h),
                      child: Icon(
                        Icons.calendar_month_rounded,
                        color: AppColor.primary,
                      ),
                    )
                  : suffixIcon == null
                  ? null
                  : Padding(
                      padding: EdgeInsets.only(right: 12.h),
                      child: suffixIcon,
                    ),
              suffixIconConstraints: BoxConstraints(
                minWidth: 24.w,
                minHeight: 24.h,
              ),
              errorText: errorText,
              errorStyle: AppTextStyles.normal12(color: AppColor.red600),
              errorMaxLines: 2,
              border: OutlineInputBorder(
                borderRadius: AppRadius.rounded8,
                borderSide: BorderSide(color: AppColor.border, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: AppRadius.rounded8,
                borderSide: BorderSide(color: AppColor.cpms700, width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppRadius.rounded8,
                borderSide: BorderSide(color: AppColor.border, width: 1),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: AppRadius.rounded8,
                borderSide: BorderSide(color: AppColor.red600, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: AppRadius.rounded8,
                borderSide: BorderSide(color: AppColor.red600, width: 1),
              ),
              contentPadding: EdgeInsets.symmetric(
                vertical: 10.h,
                horizontal: 12.w,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

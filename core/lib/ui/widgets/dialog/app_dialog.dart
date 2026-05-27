import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';

class AppWarningDialog {
  static void show({
    required BuildContext context,
    required String message,
    String? subtitle,
    VoidCallback? onConfirm,
    bool dismissOnTouchOutside = true,
    bool dismissOnBackKeyPress = true,
  }) {
    AppConfirmDialog.show(
      context: context,
      message: message,
      subtitle: subtitle,
      onConfirm: onConfirm,
      showCancel: false,
      confirmText: LocaleKeys.confirm.tr(),

      iconTitle: Icon(
        LucideIcons.circleAlert400,
        size: 30.sp,
        color: AppColor.warning,
      ),

      iconBgColor: AppColor.warningSoft,
      iconInnerColor: Colors.transparent,

      colorTextOk: AppColor.background,

      dismissOnTouchOutside: dismissOnTouchOutside,
      dismissOnBackKeyPress: dismissOnBackKeyPress,
    );
  }
}

class AppConfirmDialog {
  static void show({
    required BuildContext context,
    required String message,
    Widget? icon,
    required Widget iconTitle,
    required Color? iconBgColor,
    required Color? iconInnerColor,
    String? subtitle,
    Color? colorIcon,
    String? cancelText,
    String? confirmText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool showCancel = true,
    bool showConfirm = true,
    LinearGradient? confirmColor,
    LinearGradient? cancelColor,
    Color textCancelColor = Colors.black,
    Color? colorTextOk,
    bool? hasBorderBtnCancel = true,
    Widget? iconCancel,
    bool? hasBorderBtnOk = false,
    bool dismissOnBackKeyPress = true,
    bool dismissOnTouchOutside = true,
    Color borderCancelColor = Colors.transparent,
    Color borderConfirmColor = Colors.transparent,
    Widget child = const SizedBox.shrink(),
    bool isEnableConfirm = true,
    bool isEnableCancel = true,
  }) {
    AwesomeDialog(
      context: context,
      dismissOnBackKeyPress: dismissOnBackKeyPress,
      dismissOnTouchOutside: dismissOnTouchOutside,
      animType: AnimType.scale,
      dialogType: DialogType.noHeader,
      width: SizeConfig.width * 0.9,
      dialogBackgroundColor: AppColor.white,
      isDense: true,
      keyboardAware: true,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      bodyHeaderDistance: 0,
      btnCancel: null,
      btnOk: null,
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 16.h),
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: iconBgColor,
            ),
            padding: const EdgeInsets.all(8),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: iconInnerColor,
              ),
              child: iconTitle,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            message,
            style: AppTextStyles.semiBold14(),
            textAlign: TextAlign.center,
          ),
          if (subtitle != null)
            Text(
              subtitle,
              style: AppTextStyles.normal12(
                color: AppColor.muted,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          child,

          Separator.spacer(30.h),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                showCancel
                    ? Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 10.h,
                            horizontal: 5.w,
                          ),
                          child: AppButton(
                            isDisabled: !isEnableCancel,
                            padding: EdgeInsets.symmetric(
                              horizontal: 5.w,
                              vertical: 10.h,
                            ),

                            borderColor: borderCancelColor,
                            colorButton: cancelColor,
                            onTap: () {
                              Navigator.of(context).pop();
                              onCancel?.call();
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 3.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (iconCancel != null) iconCancel,
                                  if (iconCancel != null) SizedBox(width: 4.h),
                                  Flexible(
                                    child: Text(
                                      cancelText ?? LocaleKeys.cancel.tr(),
                                      textAlign: TextAlign.center,
                                      style: AppTextStyles.bold14(
                                        color: textCancelColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),

                // Confirm button
                showConfirm
                    ? Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 10.h,
                            horizontal: 5.w,
                          ),
                          child: AppButton(
                            isDisabled: !isEnableConfirm,
                            padding: EdgeInsets.symmetric(
                              horizontal: 5.w,
                              vertical: 10.h,
                            ),
                            borderColor: borderConfirmColor,
                            colorButton: confirmColor,
                            onTap: () {
                              Navigator.of(context).pop();
                              onConfirm?.call();
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 3.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (icon != null) icon,
                                  if (icon != null) SizedBox(width: 4.h),
                                  Flexible(
                                    child: Text(
                                      confirmText ?? LocaleKeys.confirm.tr(),
                                      textAlign: TextAlign.center,
                                      style: AppTextStyles.bold14(
                                        color: colorTextOk ?? AppColor.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ],
      ),
    ).show();
  }

  static void showCustom({
    required BuildContext context,
    Widget? icon,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    String? cancelText,
    String? confirmText,
    bool showCancel = true,
    bool showConfirm = true,
    LinearGradient? confirmColor,
    LinearGradient? cancelColor,
    Color textCancelColor = Colors.black,
    Color? colorTextOk,
    bool? hasBorderBtnCancel = true,
    Widget? iconCancel,
    bool? hasBorderBtnOk = false,
    bool dismissOnBackKeyPress = true,
    bool dismissOnTouchOutside = true,
    Color borderCancelColor = Colors.transparent,
    Color borderConfirmColor = Colors.transparent,
    Widget child = const SizedBox.shrink(),
  }) {
    AwesomeDialog(
      context: context,
      dismissOnBackKeyPress: dismissOnBackKeyPress,
      dismissOnTouchOutside: dismissOnTouchOutside,
      animType: AnimType.scale,
      dialogType: DialogType.noHeader,
      width: SizeConfig.width * 0.9,
      dialogBackgroundColor: AppColor.white,
      dialogBorderRadius: BorderRadius.circular(20.sp),
      isDense: true,
      keyboardAware: true,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      bodyHeaderDistance: 0,
      btnCancel: showCancel
          ? Padding(
              padding: EdgeInsets.only(top: 24.h),
              child: AppButton(
                borderColor: borderCancelColor,
                onTap: () {
                  Navigator.of(context).pop();
                  onCancel?.call();
                },
                colorButton: cancelColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (iconCancel != null) iconCancel,
                    if (iconCancel != null) SizedBox(width: 4.h),
                    Text(
                      cancelText ?? LocaleKeys.cancel.tr(),
                      style: AppTextStyles.bold12(color: textCancelColor),
                    ),
                  ],
                ),
              ),
            )
          : null,
      btnOk: showConfirm
          ? Padding(
              padding: EdgeInsets.only(top: 24.h),
              child: AppButton(
                borderColor: borderConfirmColor,
                colorButton: confirmColor,
                onTap: () {
                  Navigator.of(context).pop();
                  onConfirm?.call();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) icon,
                    if (icon != null) SizedBox(width: 4.h),
                    Text(
                      confirmText ?? LocaleKeys.confirm.tr(),
                      style: AppTextStyles.bold14(
                        color: colorTextOk ?? AppColor.white,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
      body: child,
    ).show();
  }
}

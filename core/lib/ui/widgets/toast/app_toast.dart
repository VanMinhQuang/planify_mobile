import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';

class CustomToast {
  static void showSuccess({
    required BuildContext context,
    required String message,
    EdgeInsetsGeometry margin = EdgeInsets.zero,
  }) {
    toastification.dismissAll();

    toastification.show(
      context: context,
      alignment: Alignment.topCenter,
      margin: margin,
      animationDuration: const Duration(milliseconds: 500),
      type: ToastificationType.success,
      icon: Icon(LucideIcons.circleCheck, color: Colors.white),
      animationBuilder: (context, animation, alignment, child) {
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero)
              .animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              ),
          child: FadeTransition(
            opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
            child: child,
          ),
        );
      },
      showIcon: true,
      dragToClose: true,
      dismissDirection: DismissDirection.vertical,
      title: Text(
        message,
        style: AppTextStyles.semiBold14(color: AppColor.white),
      ),
      style: ToastificationStyle.fillColored,
      backgroundColor: AppColor.green500,
      autoCloseDuration: const Duration(milliseconds: 1500),
      closeOnClick: true,
      closeButton: ToastCloseButton(showType: CloseButtonShowType.none),
    );
  }

  static void show({
    required BuildContext context,
    required String message,
    Widget leading = const SizedBox(),
    EdgeInsetsGeometry margin = EdgeInsets.zero,
  }) {
    toastification.dismissAll();

    toastification.show(
      context: context,
      alignment: Alignment.topCenter,
      margin: margin,
      animationDuration: const Duration(milliseconds: 500),
      type: ToastificationType.error,
      icon: leading,
      animationBuilder: (context, animation, alignment, child) {
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero)
              .animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              ),
          child: FadeTransition(
            opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
            child: child,
          ),
        );
      },
      showIcon: true,
      dragToClose: false,
      dismissDirection: DismissDirection.vertical,
      title: Text(message, style: AppTextStyles.semiBold14()),
      style: ToastificationStyle.flat,
      autoCloseDuration: const Duration(milliseconds: 1500),
      closeOnClick: true,

      closeButton: ToastCloseButton(showType: CloseButtonShowType.none),
    );
  }

  static void showNoInternet(BuildContext context) {
    toastification.dismissAll();

    toastification.show(
      context: context,
      title: Text(
        'Mất kết nôi internet',
        style: AppTextStyles.semiBold14(color: AppColor.white),
      ),
      icon: Icon(Icons.wifi_off, size: 16.sp, color: AppColor.white),
      type: ToastificationType.error,
      style: ToastificationStyle.fillColored,
      alignment: Alignment.topCenter,
      autoCloseDuration: const Duration(seconds: 5),
    );
  }

  static void showOnlineToast(BuildContext context) {
    toastification.dismissAll();

    toastification.show(
      context: context,
      title: Text('Đã có kết nối internet', style: AppTextStyles.semiBold14()),
      icon: Icon(Icons.wifi, size: 16.sp, color: AppColor.green500),
      type: ToastificationType.success,
      style: ToastificationStyle.flat,
      alignment: Alignment.topCenter,
      autoCloseDuration: const Duration(seconds: 5),
    );
  }
}

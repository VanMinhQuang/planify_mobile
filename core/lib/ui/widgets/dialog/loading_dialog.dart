import 'package:app_core/ui/constants/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../constants/app_size.dart';

class LoadingDialog extends StatelessWidget {
  static bool _isShowing = false;

  static void show(BuildContext context, {Key? key}) {
    if (_isShowing) return;

    _isShowing = true;

    showDialog<void>(
      context: context,
      useRootNavigator: false,
      barrierColor: Colors.black.withValues(alpha: 0.65),
      barrierDismissible: false,
      builder: (_) => LoadingDialog(key: key),
    ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));
  }

  static void hide(BuildContext context) {
    if (Navigator.of(context).canPop() && _isShowing) {
      _isShowing = false;
      Navigator.of(context).pop();
    }
  }

  const LoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Stack(
        children: [
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: AppColor.slate900.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16.sp),
              ),
              child: SpinKitFadingCircle(
                color: AppColor.planifyLavender,
                size: 48.h,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

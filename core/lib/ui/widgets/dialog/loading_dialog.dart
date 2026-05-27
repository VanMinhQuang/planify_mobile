import 'package:app_core/generated/assets.gen.dart';
import 'package:app_core/ui/constants/app_color.dart';
import 'package:flutter/material.dart';

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
                borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                image: DecorationImage(
                  image: Assets.images.huyHieu.provider(),
                  fit: BoxFit.contain,
                ),
              ),
              height: 52.h,
              width: 52.h,
            ),
          ),
          Center(
            child: SizedBox(
              height: 64.h,
              width: 64.h,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(AppColor.muted),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:io';

import 'package:app_core/app_core.dart';
import 'package:app_core/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';

class AuthContainer extends StatelessWidget {
  const AuthContainer({
    super.key,
    required this.child,
    this.padding,
    this.onBack,
    this.actions,
    this.versionApp,
    this.versionCode,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final String? versionApp;
  final String? versionCode;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      left: false,
      right: false,
      bottom: Platform.isAndroid,
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColor.white,
        body: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Container(
            padding:
                padding ?? EdgeInsets.only(left: 16.w, right: 16.w, top: 40.h),
            decoration: BoxDecoration(
              gradient: context.planifyGradients.surface,
            ),
            child: Column(
              spacing: 40.h,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 16.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      if (actions != null && actions!.isNotEmpty)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 8.h,
                          children: actions!,
                        ),
                    ],
                  ),
                ),
                Expanded(child: child),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

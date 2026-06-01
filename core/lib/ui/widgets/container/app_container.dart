import 'dart:io';

import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';

import '../default_app_bar.dart';

class AppContainer extends StatelessWidget {
  const AppContainer({
    super.key,
    required this.child,
    this.padding,
    this.hasAppBar = true,
    this.hasCustomAppBar = false,
    this.appBarTitle = '',
    this.onBack,
    this.iconRight,
    this.onRight,
    this.backgroundColor,
    this.customAppBar = const SizedBox(),
    this.canGoBack = true,
    this.isFullScreen = false,
    this.bottomNav,
    this.gradient,
    this.onRefresh,
    this.fab,
    this.fabLocation,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Gradient? gradient;
  final bool hasAppBar;
  final bool hasCustomAppBar;
  final Widget customAppBar;
  final String appBarTitle;
  final VoidCallback? onBack;
  final Widget? iconRight;
  final VoidCallback? onRight;
  final bool canGoBack;
  final bool isFullScreen;
  final Widget? bottomNav;
  final RefreshCallback? onRefresh;
  final Widget? fab;
  final FloatingActionButtonLocation? fabLocation;

  @override
  Widget build(BuildContext context) {
    Widget content = Column(
      children: [
        if (hasAppBar)
          hasCustomAppBar
              ? customAppBar
              : DefaultAppBar(
                  title: appBarTitle,
                  canGoBack: canGoBack,
                  onBack: () {
                    if (onBack != null) {
                      onBack!();
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                  iconRight: iconRight,
                  onRight: onRight,
                )
        else if (!isFullScreen)
          const SizedBox(height: 52),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              gradient: context.planifyGradients.background,
            ),
            padding: isFullScreen
                ? EdgeInsets.zero
                : padding ?? const EdgeInsets.symmetric(horizontal: 16),
            child: onRefresh != null
                ? AppRefresh(onRefresh: onRefresh!, child: child)
                : child,
          ),
        ),
      ],
    );

    return SafeArea(
      top: false,
      left: false,
      right: false,
      bottom: Platform.isAndroid,
      child: PopScope(
        onPopInvokedWithResult: (didPop, result) {},
        child: Scaffold(
          floatingActionButtonLocation: fabLocation,
          floatingActionButton: fab,
          extendBody: isFullScreen,
          extendBodyBehindAppBar: isFullScreen,
          backgroundColor: gradient != null
              ? Colors.transparent
              : backgroundColor,
          bottomNavigationBar: bottomNav,
          body: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              gradient: gradient,
            ),
            child: GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: content,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';

class HomeContainer extends StatelessWidget {
  const HomeContainer({
    super.key,
    required this.child,
    this.padding,
    this.onBack,
    this.actions,
    this.bottomNavBar = const SizedBox(),
    this.bottomBarController,
  });

  final Widget Function(BuildContext, ScrollController) child;
  final Widget bottomNavBar;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final BottomBarController? bottomBarController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,

      backgroundColor: AppColor.white,
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BottomBar(
      controller: bottomBarController,

      // ✅ layout: replaces flat params width, borderRadius, fit, clip
      layout: BottomBarLayout(
        width: MediaQuery.of(context).size.width * 0.9,
        borderRadius: BorderRadius.circular(500),
        fit: StackFit.expand,
        clip: Clip.none, // needed so the FAB/icon isn't clipped
        alignment: Alignment.bottomCenter, // was: barAlignment
      ),

      // ✅ motion: replaces duration, curve, start, end
      motion: const BottomBarMotion.cupertino(
        preset: BottomBarCupertinoMotion.smooth,
        duration: Duration(seconds: 1),
        slideStart: Offset(0, 2), // was: start: 2 (double → Offset)
        slideEnd: Offset.zero, // was: end: 0
      ),

      // ✅ scrollBehavior: replaces hideOnScroll, reverse, scrollOpposite
      scrollBehavior: const BottomBarScrollBehavior(
        hideOnScroll: true,
        reverse: false,
        scrollOpposite: false,
      ),

      theme: BottomBarThemeData(
        iconDecoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        barDecoration: BoxDecoration(
          color: Colors.white, // was: barColor: Colors.white
          borderRadius: BorderRadius.circular(500),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
      ),

      // ✅ icon: same signature (width, height) => Widget
      icon: (width, height) => Center(
        child: Icon(
          Icons.arrow_upward_rounded,
          color: AppColor.muted,
          size: width,
        ),
      ),

      // ✅ body: now a plain Widget, no more (context, controller) builder
      body: child(context, ScrollController()),

      // ✅ child: unchanged
      child: bottomNavBar,
    );
  }
}

import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';
import 'package:scroll_to_hide/scroll_to_hide.dart';

class HomeContainer extends StatefulWidget {
  const HomeContainer({
    super.key,
    required this.child,
    this.padding,
    this.onBack,
    this.actions,
    this.bottomNavBar = const SizedBox(),
    this.hideController,
  });

  final Widget child;
  final Widget bottomNavBar;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final ScrollToHideController? hideController;

  @override
  State<HomeContainer> createState() => _HomeContainerState();
}

class _HomeContainerState extends State<HomeContainer> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: AppColor.white,
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: widget.child,
      ),
      bottomNavigationBar: widget.bottomNavBar,
    );
  }
}

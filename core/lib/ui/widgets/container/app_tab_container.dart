import 'package:app_core/ui/widgets/default_app_bar.dart';
import 'package:draggable_fab/draggable_fab.dart';
import 'package:flutter/material.dart';

import '../../constants/app_color.dart';
import '../../constants/app_size.dart';
import '../../constants/app_text_styles.dart';

class AppTabItem {
  const AppTabItem({required this.label, this.icon, this.count});

  final String label;
  final int? count;
  final IconData? icon;
}

class AppTabBarContainer extends StatefulWidget {
  const AppTabBarContainer({
    super.key,
    required this.tabs,
    required this.children,
    this.initialIndex = 0,
    this.onTabChanged,
    this.onFabTap,
    this.fabIcon,
    this.hasAppBar = false,
    this.canGoBack = true,
    this.appBarTitle = '',
    this.customAppBar,
    this.onBack,
    this.iconRight,
    this.onRight,
    this.fabLocation,
  }) : assert(tabs.length > 0, 'tabs must not be empty'),
       assert(
         tabs.length == children.length,
         'tabs and children must have the same length',
       );

  final List<AppTabItem> tabs;
  final int initialIndex;
  final List<Widget> children;
  final IconData? fabIcon;
  final Function(int, String)? onFabTap;
  final bool hasAppBar;
  final bool canGoBack;
  final String appBarTitle;
  final Widget? customAppBar;
  final VoidCallback? onBack;
  final Widget? iconRight;
  final VoidCallback? onRight;
  final FloatingActionButtonLocation? fabLocation;

  /// Called whenever the active tab changes.
  final ValueChanged<int>? onTabChanged;

  @override
  State<AppTabBarContainer> createState() => _AppTabBarState();
}

class _AppTabBarState extends State<AppTabBarContainer>
    with SingleTickerProviderStateMixin {
  // ← required for TabController
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.tabs.length,
      initialIndex: widget.initialIndex,
      vsync: this,
    );

    // Single listener handles both tab tap and swipe
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        widget.onTabChanged?.call(_tabController.index);
      }
    });
  }

  @override
  void didUpdateWidget(AppTabBarContainer oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Only recreate if length actually changed
    if (oldWidget.tabs.length != widget.tabs.length) {
      final clampedIndex = _tabController.index.clamp(
        0,
        widget.tabs.length - 1,
      );

      _tabController.dispose();
      _tabController = TabController(
        length: widget.tabs.length,
        initialIndex: clampedIndex, // ← preserve position if possible
        vsync: this,
      );

      _tabController.addListener(() {
        if (!_tabController.indexIsChanging) {
          widget.onTabChanged?.call(_tabController.index);
        }
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onTap(int index) {
    if (_tabController.index == index) return;
    _tabController.animateTo(index); // handles adjacent, jumps instantly if far
    widget.onTabChanged?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: widget.fabIcon == null
          ? null
          : Builder(
              builder: (context) {
                final size = MediaQuery.of(context).size;
                return DraggableFab(
                  initPosition: Offset(size.width - 72, size.height - 160),
                  child: FloatingActionButton(
                    backgroundColor: AppColor.primary,
                    onPressed: () => widget.onFabTap?.call(
                      _tabController.index,
                      widget.tabs[_tabController.index].label,
                    ),
                    child: Icon(widget.fabIcon, color: AppColor.white),
                  ),
                );
              },
            ),

      backgroundColor: AppColor.background,
      body: Column(
        children: [
          if (widget.hasAppBar)
            widget.customAppBar != null
                ? widget.customAppBar!
                : DefaultAppBar(
                    title: widget.appBarTitle,
                    canGoBack: widget.canGoBack,
                    onBack: () {
                      if (widget.onBack != null) {
                        widget.onBack!();
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                    iconRight: widget.iconRight,
                    onRight: widget.onRight,
                  ),

          // Tab bar header
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: widget.hasAppBar ? 0 : 60,
              left: 16,
              right: 16,
              bottom: 16,
            ),
            decoration: BoxDecoration(
              gradient: AppColor.darkGradient,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(top: 20.h),
              child: AnimatedBuilder(
                // Rebuild tab bar only when index changes
                animation: _tabController,
                builder: (context, _) {
                  return widget.tabs.length > 2
                      ? SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            spacing: 16.w,

                            children: List.generate(
                              widget.tabs.length,
                              (index) => _buildTabItem(index, true),
                            ),
                          ),
                        )
                      : Row(
                          spacing: 4.w,
                          children: List.generate(
                            widget.tabs.length,
                            (index) =>
                                Expanded(child: _buildTabItem(index, false)),
                          ),
                        );
                },
              ),
            ),
          ),

          // Page content
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
              child: TabBarView(
                controller: _tabController,
                children: widget.children,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, bool isMoreThan2) {
    final tab = widget.tabs[index];
    final isActive = _tabController.index == index;

    final foreground = isActive ? AppColor.slate950 : AppColor.white;
    final background = isActive ? AppColor.white : Colors.transparent;
    final borderColor = isActive
        ? AppColor.white
        : AppColor.white.withOpacity(0.5);

    return IntrinsicWidth(
      child: GestureDetector(
        onTap: () => _onTap(index),
        child: Padding(
          padding: const EdgeInsets.only(top: 6, right: 6),

          child: Stack(
            clipBehavior: Clip.none,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                width: isMoreThan2 ? 150.w : double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: background,
                  border: Border.all(color: borderColor, width: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 8.w,
                  children: [
                    if (tab.icon != null)
                      Icon(tab.icon, color: foreground, size: 18),
                    Text(
                      tab.label,
                      style: AppTextStyles.semiBold14(color: foreground),
                    ),
                  ],
                ),
              ),
              if (tab.count != null)
                Positioned(
                  top: -6,
                  right: -6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.red600,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      tab.count! > 99 ? '99+' : '${tab.count}',
                      style: AppTextStyles.semiBold14(
                        color: AppColor.white,
                      ).copyWith(fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

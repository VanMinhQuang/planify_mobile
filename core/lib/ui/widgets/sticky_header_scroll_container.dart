import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';

class StickyHeaderScrollView extends StatefulWidget {
  final Widget collapsingContent;
  final Widget stickyContent;
  final Widget Function(ScrollController) listBuilder;
  final ScrollController? scrollController;
  final Future<void> Function()? onRefresh;

  const StickyHeaderScrollView({
    super.key,
    required this.collapsingContent,
    required this.stickyContent,
    required this.listBuilder,
    this.scrollController,
    this.onRefresh,
  });

  @override
  State<StickyHeaderScrollView> createState() => _StickyHeaderScrollViewState();
}

class _StickyHeaderScrollViewState extends State<StickyHeaderScrollView> {
  late ScrollController _scrollController;
  final _stickyKey = GlobalKey();
  double _stickyHeight = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureSticky());
  }

  // Re-measure whenever orientation/size changes
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureSticky());
  }

  void _measureSticky() {
    if (!mounted) return;
    final box = _stickyKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _measureSticky());
      return;
    }
    final height = box.size.height;
    if (height > 0 && height != _stickyHeight) {
      setState(() => _stickyHeight = height * 1.15);
    }
  }

  @override
  void dispose() {
    if (widget.scrollController == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final body = Stack(
      children: [
        Positioned(
          top: -10000,
          left: 0,
          right: 0,
          child: KeyedSubtree(key: _stickyKey, child: widget.stickyContent),
        ),
        if (_stickyHeight > 0)
          Positioned.fill(
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(child: widget.collapsingContent),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _MeasuredStickyDelegate(
                    height: _stickyHeight,
                    child: widget.stickyContent,
                  ),
                ),
                widget.listBuilder(_scrollController),
              ],
            ),
          ),
      ],
    );

    if (widget.onRefresh != null) {
      return AppRefresh(onRefresh: widget.onRefresh!, child: body);
    }

    return body;
  }
}

class _MeasuredStickyDelegate extends SliverPersistentHeaderDelegate {
  final double height;
  final Widget child;

  _MeasuredStickyDelegate({required this.height, required this.child});

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  bool shouldRebuild(_MeasuredStickyDelegate old) =>
      old.height != height || old.child != child;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    // Clamp the child to the actual available height to prevent
    // layoutExtent > paintExtent when rotating to a smaller dimension
    return OverflowBox(
      minHeight: 0,
      maxHeight: height,
      alignment: Alignment.topCenter,
      child: child,
    );
  }
}

import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ListViewAdaptive<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final ScrollController? scrollController;
  final bool isLoading;
  final bool isLoadMore;
  final bool hasMore;
  final VoidCallback? onRefresh;
  final int gridCrossAxisCount;
  final double ratio;
  final EdgeInsets? padding;
  final bool forceList;

  const ListViewAdaptive({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.scrollController,
    this.isLoading = false,
    this.isLoadMore = false,
    this.hasMore = false,
    this.onRefresh,
    this.ratio = 1.5,
    this.gridCrossAxisCount = 1,
    this.padding,
    this.forceList = false,
  });

  int get _itemCount => items.length + (hasMore ? 1 : 0);

  Widget _buildItem(BuildContext context, int index) {
    if (index == items.length) {
      return BottomLoader(isLoadMore: isLoadMore);
    }
    return itemBuilder(context, items[index]);
  }

  @override
  Widget build(BuildContext context) {
    final bool isEmpty = !isLoading && items.isEmpty;

    return AppSkeleton(
      isLoading: isLoading,
      child: AppRefresh(
        onRefresh: () async => onRefresh?.call(),
        child: isEmpty
            ? const EmptyDataWidget()
            : (forceList
                  ? _buildList(context)
                  : (DeviceUtils.isTabletLandscape(context)
                        ? _buildGrid(context)
                        : _buildList(context))),
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: padding ?? EdgeInsets.only(bottom: 100.h),
      itemCount: _itemCount,
      itemBuilder: _buildItem,
    );
  }

  Widget _buildGrid(BuildContext context) {
    return MasonryGridView.builder(
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: padding ?? EdgeInsets.only(bottom: 100.h),
      gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: gridCrossAxisCount,
      ),
      mainAxisSpacing: 0,
      crossAxisSpacing: 0,
      itemCount: _itemCount,
      itemBuilder: _buildItem,
    );
  }
}

class SliverListViewAdaptive<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final bool isLoading;
  final bool isLoadMore;
  final bool hasMore;
  final int gridCrossAxisCount;
  final double ratio;
  final EdgeInsets? padding;
  final bool forceList;

  const SliverListViewAdaptive({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.isLoading = false,
    this.isLoadMore = false,
    this.hasMore = false,
    this.gridCrossAxisCount = 1,
    this.ratio = 1.8,
    this.padding,
    this.forceList = false,
  });

  @override
  Widget build(BuildContext context) {
    /// ✅ 1. SAFE EMPTY STATE (outside SliverPadding)
    if (!isLoading && items.isEmpty) {
      return const SliverToBoxAdapter(child: EmptyDataWidget());
    }

    final sliver = forceList
        ? _buildList()
        : (DeviceUtils.isTabletLandscape(context)
              ? _buildGrid()
              : _buildList());

    return SliverPadding(
      padding: padding ?? EdgeInsets.only(bottom: 100.h),
      sliver: sliver,
    );
  }

  /// =========================
  /// LIST MODE (SAFE FOOTER)
  /// =========================
  Widget _buildList() {
    final itemCount = items.length + (hasMore ? 1 : 0);

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        if (hasMore && index == items.length) {
          return BottomLoader(isLoadMore: isLoadMore);
        }

        return itemBuilder(context, items[index]);
      }, childCount: itemCount),
    );
  }

  /// =========================
  /// GRID MODE (FIXED FOOTER SAFETY)
  /// =========================
  Widget _buildGrid() {
    // No skeletonCount needed — masonry has no fixed rows to fill
    final itemCount = items.length + (isLoadMore ? 1 : 0);

    return SliverMasonryGrid.count(
      crossAxisCount: gridCrossAxisCount,
      mainAxisSpacing: 0,
      crossAxisSpacing: 0,
      childCount: itemCount,
      itemBuilder: (context, index) {
        if (index >= items.length) {
          // ✅ Same skeleton pattern — reuse real item as shimmer shape
          return AppSkeleton(
            isLoading: true,
            child: itemBuilder(context, items.last),
          );
        }
        return itemBuilder(context, items[index]);
      },
    );
  }
}

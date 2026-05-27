import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';

class GridWidget extends StatelessWidget {
  final List<Widget> children;
  final int columns;
  const GridWidget({super.key, required this.children, required this.columns});

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];

    for (var i = 0; i < children.length; i += columns) {
      final rowChildren = <Widget>[];

      for (var j = 0; j < columns; j++) {
        final index = i + j;
        final isLast = j == columns - 1;

        if (index < children.length) {
          rowChildren.add(Expanded(child: children[index]));
        } else {
          rowChildren.add(const Expanded(child: SizedBox.shrink()));
        }

        if (!isLast) {
          rowChildren.add(
            VerticalDivider(width: 0.5, thickness: 0.5, color: AppColor.muted),
          );
        }
      }

      final isLastRow = i + columns >= children.length;
      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: rowChildren,
          ),
        ),
      );

      if (!isLastRow) {
        rows.add(Divider(height: 0.5, thickness: 0.5, color: AppColor.muted));
      }
    }

    return Column(children: rows);
  }
}

class GridCell extends StatelessWidget {
  final String label;
  final String? value;
  final Color? valueColor;
  const GridCell({super.key, required this.label, this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    final isEmpty = value == null || value!.isEmpty;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.normal10().copyWith(
              color: AppColor.muted.withValues(alpha: 0.6),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            isEmpty ? '-' : value!,
            style: isEmpty
                ? AppTextStyles.normal12().copyWith(color: AppColor.muted)
                : AppTextStyles.semiBold12().copyWith(color: valueColor),
          ),
        ],
      ),
    );
  }
}

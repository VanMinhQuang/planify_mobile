import 'package:flutter/material.dart';

class CardRowGrid extends StatelessWidget {
  final List<Widget> items;
  final int columns;
  final bool hasSpacing;
  const CardRowGrid({
    super.key,
    this.items = const [],
    this.columns = 1,
    this.hasSpacing = true,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> rows = [];

    for (int i = 0; i < items.length; i += columns) {
      final remaining = items.length - i;

      rows.add(
        IntrinsicHeight(
          child: Row(
            children: [
              if (remaining < columns) ...[
                for (int j = 0; j < remaining; j++) ...[
                  Expanded(
                    flex: j == 0 ? columns - (remaining - 1) : 1,
                    child: items[i + j],
                  ),
                  if (j != remaining - 1) const SizedBox(width: 12),
                ],
              ] else ...[
                for (int j = 0; j < columns; j++) ...[
                  Expanded(child: items[i + j]),
                  if (j != columns - 1) const SizedBox(width: 12),
                ],
              ],
            ],
          ),
        ),
      );

      if (hasSpacing) rows.add(const SizedBox(height: 12));
    }

    return Column(children: rows);
  }
}

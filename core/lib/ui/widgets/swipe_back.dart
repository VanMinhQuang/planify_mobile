import 'package:flutter/widgets.dart';

class SwipeBackWrapper extends StatelessWidget {
  const SwipeBackWrapper({
    super.key,
    required this.child,
    required this.canSwipeBack,
    this.isRefreshData = false,
  });

  final Widget child;
  final bool canSwipeBack;
  final bool isRefreshData;

  @override
  Widget build(BuildContext context) {
    var startDx = 0.0;

    return GestureDetector(
      onHorizontalDragStart: (details) {
        startDx = details.globalPosition.dx;
      },
      onHorizontalDragUpdate: (details) {
        final distance = details.globalPosition.dx - startDx;

        if (distance > 100 && Navigator.canPop(context) && canSwipeBack) {
          Navigator.of(context).pop(isRefreshData ? true : null);
        }
      },
      child: child,
    );
  }
}

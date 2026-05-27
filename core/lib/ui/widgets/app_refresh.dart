import 'package:flutter/material.dart';

class AppRefresh extends StatelessWidget {
  final Widget child;
  final VoidCallback? onRefresh;
  const AppRefresh({super.key, required this.child, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: () async {
        onRefresh?.call();
      },
      child: child,
    );
  }
}

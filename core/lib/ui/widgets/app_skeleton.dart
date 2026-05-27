import 'package:app_core/app_core.dart';
import 'package:flutter/widgets.dart';

class AppSkeleton extends StatelessWidget {
  const AppSkeleton({super.key, required this.child, required this.isLoading});

  final Widget child;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(enabled: isLoading, child: child);
  }
}

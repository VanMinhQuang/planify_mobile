import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class BottomLoader extends StatelessWidget {
  final bool isLoadMore;

  const BottomLoader({super.key, required this.isLoadMore});

  @override
  Widget build(BuildContext context) {
    if (!isLoadMore) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: SpinKitThreeBounce(color: Colors.blueAccent, size: 24),
      ),
    );
  }
}

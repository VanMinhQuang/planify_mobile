import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';

class TransformContentContainer extends StatelessWidget {
  final List<Widget>? insideBackgroundChildren;
  final Widget? outsideBackgroundChildren;
  final VoidCallback? onRefresh;
  const TransformContentContainer({
    super.key,
    this.insideBackgroundChildren,
    this.outsideBackgroundChildren,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppRefresh(
        onRefresh: () async {
          onRefresh?.call();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 60, left: 16, right: 16),
                  decoration: BoxDecoration(
                    color: AppColor.backgroundDark,
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(24),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColor.slate950, // Starting color
                        AppColor.backgroundDark, // Maintain dark until 95%
                        AppColor.backgroundDark.withValues(
                          alpha: 0.2,
                        ), // End with white
                      ],
                      stops: const [
                        0.0,
                        0.85,
                        1.0, // Fade to white in the last 5%
                      ],
                    ),
                  ),
                  child: Column(
                    children: insideBackgroundChildren ?? const <Widget>[],
                  ),
                ),
                outsideBackgroundChildren ?? const SizedBox(),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

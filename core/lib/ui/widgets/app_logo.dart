import 'package:flutter/material.dart';

import '../../app_core.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = 40,
    this.showText = true,
    this.heroTag = planifyLogoHeroTag,
  });

  static const planifyLogoHeroTag = 'planify-logo';

  final double size;
  final bool showText;
  final Object? heroTag;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final logo = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: context.gradients.background,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withValues(alpha: .22),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Assets.logo.logoNoBackground.image(),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (heroTag == null) logo else Hero(tag: heroTag!, child: logo),
        if (showText) ...[
          const SizedBox(width: 10),
          Text(
            'Planify',
            style: context.bold22(color: colors.onSurface, height: 1),
          ),
        ],
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';

class Separator {
  static Widget spacer([double? space]) => Gap(space ?? 12);

  static List<Widget> spaceChildren({
    double? space,
    required List<Widget> children,
  }) {
    return children.separate(space ?? 12);
  }

  static Widget divider({
    double indent = 0,
    double? endIndent,
    double thickness = 0.5,
    BorderRadiusGeometry? radius,
    Color? color,
  }) => Divider(
    height: 0,
    indent: indent,
    thickness: thickness,
    endIndent: endIndent,
    radius: radius,
    color: color,
  );

  static Widget none() => const Gap(0);
}

extension ListGutter on List<Widget> {
  List<Widget> separate([double? space]) => length <= 1
      ? this
      : sublist(1).fold([
          first,
        ], (r, element) => [...r, Separator.spacer(space ?? 12), element]);
}

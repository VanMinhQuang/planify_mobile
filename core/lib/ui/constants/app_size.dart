// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

const num kDesignWidth = 375;
const num kDesignHeight = 812;

class SizeConfig {
  SizeConfig._();

  static late double width;
  static late double height;
  static late Orientation orientation;

  static late bool isTablet;

  static void init(BoxConstraints constraints, Orientation o) {
    orientation = o;
    width = constraints.maxWidth;
    height = constraints.maxHeight;

    isTablet = width >= 600;
  }

  /// -------------------------
  /// SCALE X (horizontal)
  /// -------------------------
  static double get scaleX {
    final baseScale = width / kDesignWidth;

    if (isTablet) {
      // prevent UI from becoming too large on tablet
      return baseScale.clamp(0.85, 1.3);
    }

    return baseScale;
  }

  /// -------------------------
  /// SCALE Y (vertical)
  /// -------------------------
  static double get scaleY {
    final baseScale = height / kDesignHeight;

    if (isTablet) {
      return baseScale.clamp(0.85, 1.3);
    }

    return baseScale;
  }

  /// -------------------------
  /// OPTIONAL: tablet density reduction
  /// (makes UI slightly more compact)
  /// -------------------------
  static double get tabletFactor {
    return isTablet ? 0.88 : 1.0;
  }
}

typedef ResponsiveBuilder =
    Widget Function(BuildContext context, Orientation orientation);

class Sizer extends StatelessWidget {
  const Sizer({super.key, required this.builder});

  final ResponsiveBuilder builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeConfig.init(constraints, orientation);
            return builder(context, orientation);
          },
        );
      },
    );
  }
}

class ResponsiveWidget extends StatelessWidget {
  const ResponsiveWidget({
    super.key,
    required this.mobile,
    required this.tablet,
  });

  final Widget mobile;
  final Widget tablet;

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    return isTablet ? tablet : mobile;
  }
}

extension SizeExtension on num {
  /// width scaling (horizontal UI)
  double get w => this * SizeConfig.scaleX * SizeConfig.tabletFactor;

  /// height scaling (vertical spacing)
  double get h => this * SizeConfig.scaleY * SizeConfig.tabletFactor;

  /// font scaling (stable on tablet)
  double get sp {
    final base = this * SizeConfig.scaleX;

    return base;
  }
}

extension FormatExtension on double {
  /// Return a [double] value with formatted according to provided fractionDigits
  double toDoubleValue({int fractionDigits = 2}) {
    return double.parse(toStringAsFixed(fractionDigits));
  }

  double isNonZero({num defaultValue = 0.0}) {
    return this > 0 ? this : defaultValue.toDouble();
  }
}

class Responsive {
  Responsive._();

  /// Material standard breakpoint
  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.shortestSide >= 600;
  }

  static bool isPhone(BuildContext context) {
    return MediaQuery.of(context).size.shortestSide < 600;
  }
}

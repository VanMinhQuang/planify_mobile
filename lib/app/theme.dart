import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';

class PlanifyTheme {
  static const _primary = Color(0xFF2F6FED);
  static const _secondary = Color(0xFF13A86B);
  static const _tertiary = Color(0xFFE9A227);

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: _primary,
      primary: _primary,
      secondary: _secondary,
      tertiary: _tertiary,
      surface: const Color(0xFFF8FAFC),
    );

    return _baseTheme(
      scheme: scheme,
      scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      cardColor: Colors.white,
    );
  }

  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: _primary,
      primary: const Color(0xFF8FB4FF),
      secondary: const Color(0xFF62D8A3),
      tertiary: const Color(0xFFFFC35C),
      surface: const Color(0xFF121826),
    );

    return _baseTheme(
      scheme: scheme,
      scaffoldBackgroundColor: const Color(0xFF0D111A),
      cardColor: const Color(0xFF171E2E),
    );
  }

  static ThemeData _baseTheme({
    required ColorScheme scheme,
    required Color scaffoldBackgroundColor,
    required Color cardColor,
  }) {
    final baseTheme = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
    );

    final textTheme = GoogleFonts.beVietnamProTextTheme(
      baseTheme.textTheme,
    ).apply(bodyColor: scheme.onSurface, displayColor: scheme.onSurface);

    return baseTheme.copyWith(
      textTheme: textTheme,
      primaryTextTheme: GoogleFonts.beVietnamProTextTheme(
        baseTheme.primaryTextTheme,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: scaffoldBackgroundColor,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: scheme.onSurface,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
        filled: true,
        fillColor: scheme.surface,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

extension PlanifyContextTheme on BuildContext {
  ThemeData get theme => Theme.of(this);

  ColorScheme get colors => theme.colorScheme;

  TextTheme get textStyles => theme.textTheme;

  bool get isDarkMode => theme.brightness == Brightness.dark;

  TextStyle get displayLarge => textStyles.displayLarge!;
  TextStyle get displayMedium => textStyles.displayMedium!;
  TextStyle get displaySmall => textStyles.displaySmall!;
  TextStyle get headlineLarge => textStyles.headlineLarge!;
  TextStyle get headlineMedium => textStyles.headlineMedium!;
  TextStyle get headlineSmall => textStyles.headlineSmall!;
  TextStyle get titleLarge => textStyles.titleLarge!;
  TextStyle get titleMedium => textStyles.titleMedium!;
  TextStyle get titleSmall => textStyles.titleSmall!;
  TextStyle get bodyLarge => textStyles.bodyLarge!;
  TextStyle get bodyMedium => textStyles.bodyMedium!;
  TextStyle get bodySmall => textStyles.bodySmall!;
  TextStyle get labelLarge => textStyles.labelLarge!;
  TextStyle get labelMedium => textStyles.labelMedium!;
  TextStyle get labelSmall => textStyles.labelSmall!;

  TextStyle _textStyle({
    required double fontSize,
    required FontWeight fontWeight,
    Color? color,
    double? height,
  }) {
    return textStyles.bodyMedium!.copyWith(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
    );
  }

  TextStyle normal10({Color? color, double? height}) => _textStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w400,
    color: color,
    height: height,
  );

  TextStyle normal12({Color? color, double? height}) => _textStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: color,
    height: height,
  );

  TextStyle normal14({Color? color, double? height}) => _textStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: color,
    height: height,
  );

  TextStyle normal16({Color? color, double? height}) => _textStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: color,
    height: height,
  );

  TextStyle normal18({Color? color, double? height}) => _textStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w400,
    color: color,
    height: height,
  );

  TextStyle normal20({Color? color, double? height}) => _textStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w400,
    color: color,
    height: height,
  );

  TextStyle normal22({Color? color, double? height}) => _textStyle(
    fontSize: 22.sp,
    fontWeight: FontWeight.w400,
    color: color,
    height: height,
  );

  TextStyle normal24({Color? color, double? height}) => _textStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w400,
    color: color,
    height: height,
  );

  TextStyle semiBold10({Color? color, double? height}) => _textStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w500,
    color: color,
    height: height,
  );

  TextStyle semiBold12({Color? color, double? height}) => _textStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    color: color,
    height: height,
  );

  TextStyle semiBold14({Color? color, double? height}) => _textStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: color,
    height: height,
  );

  TextStyle semiBold16({Color? color, double? height}) => _textStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: color,
    height: height,
  );

  TextStyle semiBold18({Color? color, double? height}) => _textStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
    color: color,
    height: height,
  );

  TextStyle semiBold20({Color? color, double? height}) => _textStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w500,
    color: color,
    height: height,
  );

  TextStyle semiBold22({Color? color, double? height}) => _textStyle(
    fontSize: 22.sp,
    fontWeight: FontWeight.w500,
    color: color,
    height: height,
  );

  TextStyle semiBold24({Color? color, double? height}) => _textStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w500,
    color: color,
    height: height,
  );

  TextStyle bold10({Color? color, double? height}) => _textStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w700,
    color: color,
    height: height,
  );

  TextStyle bold12({Color? color, double? height}) => _textStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w700,
    color: color,
    height: height,
  );

  TextStyle bold14({Color? color, double? height}) => _textStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w700,
    color: color,
    height: height,
  );

  TextStyle bold16({Color? color, double? height}) => _textStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w700,
    color: color,
    height: height,
  );

  TextStyle bold18({Color? color, double? height}) => _textStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w700,
    color: color,
    height: height,
  );

  TextStyle bold20({Color? color, double? height}) => _textStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w700,
    color: color,
    height: height,
  );

  TextStyle bold22({Color? color, double? height}) => _textStyle(
    fontSize: 22.sp,
    fontWeight: FontWeight.w700,
    color: color,
    height: height,
  );

  TextStyle bold24({Color? color, double? height}) => _textStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w700,
    color: color,
    height: height,
  );
}

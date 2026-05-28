import 'package:flutter/material.dart';

class AppColor {
  AppColor._(); // prevent instantiation

  // ======================
  // BRAND
  // ======================
  static const primary = planifyBlue;

  // ======================
  // PLANIFY PALETTE
  // ======================
  static const planifyInk = Color(0xFF182033);
  static const planifyInkSoft = Color(0xFF334155);
  static const planifyBlue = Color(0xFF3366FF);
  static const planifyBlueSoft = Color(0xFFDCE7FF);
  static const planifyMint = Color(0xFF14B8A6);
  static const planifyMintSoft = Color(0xFFD7F8F2);
  static const planifyAmber = Color(0xFFF59E0B);
  static const planifyAmberSoft = Color(0xFFFFF1CC);
  static const planifyCoral = Color(0xFFFF6B6B);
  static const planifyCoralSoft = Color(0xFFFFE1E1);
  static const planifyLavender = Color(0xFF7C3AED);
  static const planifyLavenderSoft = Color(0xFFEDE7FF);
  static const planifyPeach = Color(0xFFFFB38A);
  static const planifyLemon = Color(0xFFFFD166);
  static const planifyCloud = Color(0xFFF7F9FC);
  static const planifyMist = Color(0xFFE8EEF8);
  static const planifySurface = Color(0xFFFFFFFF);
  static const planifyNight = Color(0xFF111827);
  static const planifyNightSurface = Color(0xFF182235);
  static const planifyNightSurfaceHigh = Color(0xFF22304A);
  static const planifyNightText = Color(0xFFEAF0FA);
  static const planifyNightMuted = Color(0xFFAAB6C8);

  static const planifyLightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: planifyBlue,
    onPrimary: white,
    primaryContainer: planifyBlueSoft,
    onPrimaryContainer: planifyInk,
    secondary: planifyMint,
    onSecondary: white,
    secondaryContainer: planifyMintSoft,
    onSecondaryContainer: planifyInk,
    tertiary: planifyAmber,
    onTertiary: planifyInk,
    tertiaryContainer: planifyAmberSoft,
    onTertiaryContainer: planifyInk,
    error: red600,
    onError: white,
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF410002),
    surface: planifySurface,
    onSurface: planifyInk,
    surfaceContainerLowest: white,
    surfaceContainerLow: planifyCloud,
    surfaceContainer: Color(0xFFF0F4FA),
    surfaceContainerHigh: planifyMist,
    surfaceContainerHighest: Color(0xFFD8E1F0),
    outline: Color(0xFF9AA8BC),
    outlineVariant: Color(0xFFD7DFEB),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: planifyInk,
    onInverseSurface: white,
    inversePrimary: Color(0xFFAFC4FF),
    surfaceTint: planifyBlue,
  );

  static const planifyDarkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFAFC4FF),
    onPrimary: Color(0xFF08235F),
    primaryContainer: Color(0xFF1D3F91),
    onPrimaryContainer: Color(0xFFE7EEFF),
    secondary: Color(0xFF66E0D0),
    onSecondary: Color(0xFF003D37),
    secondaryContainer: Color(0xFF075D54),
    onSecondaryContainer: Color(0xFFD7F8F2),
    tertiary: Color(0xFFFFC766),
    onTertiary: Color(0xFF432B00),
    tertiaryContainer: Color(0xFF6A4500),
    onTertiaryContainer: Color(0xFFFFE6B0),
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),
    surface: planifyNightSurface,
    onSurface: planifyNightText,
    surfaceContainerLowest: Color(0xFF0B1020),
    surfaceContainerLow: planifyNight,
    surfaceContainer: planifyNightSurface,
    surfaceContainerHigh: planifyNightSurfaceHigh,
    surfaceContainerHighest: Color(0xFF2C3B58),
    outline: Color(0xFF7F8CA3),
    outlineVariant: Color(0xFF3B4860),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: planifyNightText,
    onInverseSurface: planifyInk,
    inversePrimary: planifyBlue,
    surfaceTint: Color(0xFFAFC4FF),
  );

  // ======================
  // BACKGROUND / SURFACE
  // ======================
  static const background = planifyCloud;
  static const backgroundDark = planifyNight;
  static const foreground = planifyInk;

  static const warningDark = Color(0xFF8A5A00);
  static const warning = planifyAmber;
  static const warningLight = planifyLemon;
  static const warningSoft = planifyAmberSoft;
  // ======================
  // LEGACY ALIASES, PLANIFY VALUES
  // ======================

  static const cpms50 = planifyCloud;
  static const cpms100 = planifyBlueSoft;
  static const cpms200 = Color(0xFFC9D8FF);
  static const cpms300 = Color(0xFFAFC4FF);
  static const cpms400 = Color(0xFF7EA0FF);
  static const cpms500 = planifyBlue;
  static const cpms600 = Color(0xFF2854D9);
  static const cpms700 = Color(0xFF1D3F91);
  static const cpms800 = Color(0xFF22304A);
  static const cpms900 = planifyInk;
  static const red500 = planifyCoral;
  static const red600 = Color(0xFFE24C5B);
  static const red700 = Color(0xFFB93748);
  static const hint = Color(0xFF9AA8BC);
  static const muted = Color(0xFF748095);
  static const border = Color(0xFFDCE4F0);
  static const slate100 = Color(0xFFF2F6FC);
  static const slate200 = planifyMist;
  static const slate300 = Color(0xFFD7DFEB);
  static const slate400 = Color(0xFFB4C0D1);
  static const slate500 = Color(0xFF8190A8);
  static const slate600 = Color(0xFF64718A);
  static const slate700 = planifyInkSoft;
  static const slate800 = planifyNightSurfaceHigh;
  static const slate900 = planifyNight;
  static const slate950 = Color(0xFF0B1020);
  static const blueDark = Color(0xFF1D3F91);
  static const blue600 = Color(0xFF2854D9);

  static const yellow800 = planifyAmber;
  static const orange500 = planifyPeach;
  static const orange600 = Color(0xFFE88957);
  static const green500 = planifyMint;
  static const green800 = Color(0xFF08786D);
  static const green900 = Color(0xFF075D54);

  static const gray500 = muted;

  static const purple500 = planifyLavender;
  // ======================
  // TEXT COLORS
  // ======================
  static const textDark = planifyInk;
  static const textMuted = muted;
  static const white = Color(0xFFFFFFFF);
  static const textLightSecond = planifyNightMuted;
  static const textPrimary = planifyBlue;
  static const textSecondary = planifyMint;
  static const textDisabled = hint;
  static const textYellow = planifyAmber;
  static const amber50 = Color(0xFFFFFBF0);
  static const amber100 = planifyAmberSoft;
  static const amber200 = Color(0xFFFFE3A1);
  static const amber300 = planifyLemon;
  static const amber400 = Color(0xFFFFBE45);
  static const amber500 = planifyAmber;
  static const amber600 = Color(0xFFD98B06);
  static const amber700 = warningDark;
  static const amber800 = Color(0xFF6F4700);
  static const amber900 = Color(0xFF4A3000);
  static const amber950 = Color(0xFF2B1A00);
  // ======================
  // Gradient
  // ======================
  static LinearGradient get skeletonGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [planifyMist, planifyBlueSoft, planifyMintSoft],
    stops: const [0.0, 0.5, 1.0],
  );
  static LinearGradient get whiteGradient => LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [white, white, white],
    stops: const [0.0, 0.5, 1.0],
  );

  static LinearGradient get transparentGradient => LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Colors.transparent, Colors.transparent, Colors.transparent],
    stops: const [0.0, 0.5, 1.0],
  );

  static LinearGradient get primaryGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [planifyBlue, planifyLavender, planifyMint],
    stops: const [0.0, 0.52, 1.0],
  );

  static LinearGradient get darkGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [slate950, planifyNightSurface, blueDark],
    stops: const [0.0, 0.7, 1.0],
  );

  static LinearGradient get cuteGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [planifyLavenderSoft, planifyCoralSoft, planifyAmberSoft],
    stops: [0.0, 0.48, 1.0],
  );

  static LinearGradient get surfaceGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [planifySurface, planifyCloud, planifyMintSoft],
    stops: [0.0, 0.62, 1.0],
  );

  static LinearGradient get softPrimaryGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [planifyBlueSoft, planifyLavenderSoft, planifyMintSoft],
    stops: [0.0, 0.5, 1.0],
  );

  static LinearGradient get errorGradient => LinearGradient(
    colors: [
      planifyCoral.withValues(alpha: .22),
      planifyCoralSoft,
      planifyAmberSoft,
    ],
    stops: const [0.0, 0.7, 1.0],
  );
}

@immutable
class PlanifyGradientTheme extends ThemeExtension<PlanifyGradientTheme> {
  const PlanifyGradientTheme({
    required this.primary,
    required this.background,
    required this.surface,
    required this.accent,
    required this.warning,
  });

  final LinearGradient primary;
  final LinearGradient background;
  final LinearGradient surface;
  final LinearGradient accent;
  final LinearGradient warning;

  static const light = PlanifyGradientTheme(
    primary: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        AppColor.planifyBlue,
        AppColor.planifyLavender,
        AppColor.planifyMint,
      ],
      stops: [0.0, 0.52, 1.0],
    ),
    background: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        AppColor.planifyCloud,
        AppColor.planifySurface,
        AppColor.planifyMintSoft,
      ],
      stops: [0.0, 0.62, 1.0],
    ),
    surface: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        AppColor.planifySurface,
        AppColor.planifyCloud,
        AppColor.planifyBlueSoft,
      ],
      stops: [0.0, 0.72, 1.0],
    ),
    accent: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        AppColor.planifyLavenderSoft,
        AppColor.planifyCoralSoft,
        AppColor.planifyAmberSoft,
      ],
      stops: [0.0, 0.48, 1.0],
    ),
    warning: LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [AppColor.planifyAmberSoft, AppColor.planifyLemon],
    ),
  );

  static const dark = PlanifyGradientTheme(
    primary: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF6F8CFF), AppColor.planifyLavender, Color(0xFF31CBBB)],
      stops: [0.0, 0.48, 1.0],
    ),
    background: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFF0B1020),
        AppColor.planifyNight,
        AppColor.planifyNightSurface,
      ],
      stops: [0.0, 0.58, 1.0],
    ),
    surface: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        AppColor.planifyNightSurfaceHigh,
        AppColor.planifyNightSurface,
        AppColor.planifyNight,
      ],
      stops: [0.0, 0.55, 1.0],
    ),
    accent: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF392B6D), Color(0xFF5E324C), Color(0xFF5C461C)],
      stops: [0.0, 0.48, 1.0],
    ),
    warning: LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [Color(0xFF6A4500), Color(0xFF9A6412)],
    ),
  );

  @override
  PlanifyGradientTheme copyWith({
    LinearGradient? primary,
    LinearGradient? background,
    LinearGradient? surface,
    LinearGradient? accent,
    LinearGradient? warning,
  }) {
    return PlanifyGradientTheme(
      primary: primary ?? this.primary,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      accent: accent ?? this.accent,
      warning: warning ?? this.warning,
    );
  }

  @override
  PlanifyGradientTheme lerp(
    ThemeExtension<PlanifyGradientTheme>? other,
    double t,
  ) {
    if (other is! PlanifyGradientTheme) {
      return this;
    }
    return PlanifyGradientTheme(
      primary: LinearGradient.lerp(primary, other.primary, t) ?? primary,
      background:
          LinearGradient.lerp(background, other.background, t) ?? background,
      surface: LinearGradient.lerp(surface, other.surface, t) ?? surface,
      accent: LinearGradient.lerp(accent, other.accent, t) ?? accent,
      warning: LinearGradient.lerp(warning, other.warning, t) ?? warning,
    );
  }
}

extension PlanifyGradientContext on BuildContext {
  PlanifyGradientTheme get planifyGradients {
    return Theme.of(this).extension<PlanifyGradientTheme>() ??
        PlanifyGradientTheme.light;
  }
}

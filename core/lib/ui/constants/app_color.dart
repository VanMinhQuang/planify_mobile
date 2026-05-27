import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';

class AppColor {
  AppColor._(); // prevent instantiation

  // ======================
  // BRAND
  // ======================
  static const primary = Color(0xFF081427);

  // ======================
  // BACKGROUND / SURFACE
  // ======================
  static const background = Color(0xFFF6F7FB);
  static const backgroundDark = Color(0xFF0B2C5F);
  static const foreground = Color(0xFF0A1A2E);

  static const warningDark = Color(0xFF9E400E);
  static const warning = Color(0xFFF59E0B); // Tailwind amber-500
  static const warningLight = Color(0xFFFDE68A); // amber-200
  static const warningSoft = Color(0xFFFEF3C7); // amber-100
  // ======================
  // CPMS PALETTE
  // ======================

  static const cpms50 = Color(0xFFEFF6FF);
  static const cpms100 = Color(0xFFDBEAFE);
  static const cpms200 = Color(0xFFBFDBFE);
  static const cpms300 = Color(0xFF93C5FD);
  static const cpms400 = Color(0xFF60A5FA);
  static const cpms500 = Color(0xFF3B82F6);
  static const cpms600 = Color(0xFF1E4D8B);
  static const cpms700 = Color(0xFF163A6B);
  static const cpms800 = Color(0xFF0F2747);
  static const cpms900 = Color(0xFF0A1A2E);
  static const red500 = Color(0xFFEF4444);
  static const red600 = Color(0xFFDC2626);
  static const red700 = Color(0xFFB91C1C);
  static const hint = Color(0xFF9CA3AF);
  static const muted = Color(0xFF6B7280);
  static const border = Color(0xFFE5E7EB);
  static const slate100 = Color(0xFFF1F5F9);
  static const slate200 = Color(0xFFE2E8F0);
  static const slate300 = Color(0xFFCBD5E1);
  static const slate400 = Color(0xFF94A3B8);
  static const slate500 = Color(0xFF64748B);
  static const slate600 = Color(0xFF475569);
  static const slate700 = Color(0xFF334155);
  static const slate800 = Color(0xFF1E293B);
  static const slate900 = Color(0xFF0F172A);
  static const slate950 = Color(0xFF020617);
  static const blueDark = Color(0xFF1E4D8B);
  static const blue600 = Color(0xFF163A6B);

  static const yellow800 = Color(0xFFF59E0B);
  static const orange500 = Color(0xFFF97316);
  static const orange600 = Color(0xFFb45309);
  static const green500 = Color(0xFF22C55E);
  static const green800 = Color(0xFF2E7D32);
  static const green900 = Color(0xFF047857);

  static const gray500 = Color(0xFF94A3B8);

  static const purple500 = Color(0xFF6D28D9);
  // ======================
  // TEXT COLORS
  // ======================
  static const textDark = Color(0xFF0A1A2E);
  static const textMuted = Color(0xFF6B7280);
  static const white = Color(0xFFFFFFFF);
  static const textLightSecond = Color(0xFFCBD5E1);
  static const textPrimary = Color(0xFF3B82F6);
  static const textSecondary = Color(0xFF1E4D8B);
  static const textDisabled = Color(0xFF9CA3AF);
  static const textYellow = Color(0xFFF2BF44);
  static const amber50 = Color(0xFFFFFBEB);
  static const amber100 = Color(0xFFFEF3C7);
  static const amber200 = Color(0xFFFDE68A);
  static const amber300 = Color(0xFFFCD34D);
  static const amber400 = Color(0xFFFBBF24);
  static const amber500 = Color(0xFFF59E0B);
  static const amber600 = Color(0xFFD97706);
  static const amber700 = Color(0xFFB45309);
  static const amber800 = Color(0xFF92400E);
  static const amber900 = Color(0xFF78350F);
  static const amber950 = Color(0xFF451A03);
  // ======================
  // Gradient
  // ======================
  static LinearGradient get skeletonGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [cpms800, cpms700, cpms500],
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
    colors: [primary, cpms600, cpms500.withValues(alpha: .25)],
    stops: const [0.0, 0.7, 1.0],
  );

  static LinearGradient get darkGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [slate950, cpms800, cpms700],
    stops: const [0.0, 0.7, 1.0],
  );

  static LinearGradient get errorGradient => LinearGradient(
    colors: [
      red500.withValues(alpha: .25),
      red500.withValues(alpha: .25),
      red500.withValues(alpha: .25),
    ],
    stops: const [0.0, 0.7, 1.0],
  );
}

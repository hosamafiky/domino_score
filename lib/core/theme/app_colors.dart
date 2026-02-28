import 'package:flutter/material.dart';

/// Centralized app color palette.
/// Use these colors for consistency across light and dark themes.
abstract final class AppColors {
  AppColors._();

  // ─── Primary palette (green) ───────────────────────────────────────────────
  static const Color primaryDark = Color(0xFF1B5E20);
  static const Color primary = Color(0xFF2E7D32);
  static const Color primaryLight = Color(0xFF66BB6A);
  static const Color primaryLighter = Color(0xFF81C784);

  // ─── Semantic ─────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF2E7D32);
  static const Color error = Color(0xFFB71C1C);
  static const Color errorLight = Color(0xFFEF5350);
  static const Color warning = Color(0xFFF57C00);
  static const Color warningLight = Color(0xFFFFB74D);
  static const Color info = Color(0xFF1565C0);
  static const Color infoLight = Color(0xFF42A5F5);

  // ─── Neutrals (light theme) ───────────────────────────────────────────────
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color onSurfaceLight = Color(0xFF212121);
  static const Color onSurfaceVariantLight = Color(0xFF757575);
  static const Color outlineLight = Color(0xFFE0E0E0);

  // ─── Neutrals (dark theme) ─────────────────────────────────────────────────
  static const Color surfaceDark = Color(0xFF121212);
  static const Color backgroundDark = Color(0xFF1E1E1E);
  static const Color onSurfaceDark = Color(0xFFE1E1E1);
  static const Color onSurfaceVariantDark = Color(0xFFB0B0B0);
  static const Color outlineDark = Color(0xFF424242);
}

import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFFF6BD00);
  static const Color primaryDark = Color(0xFFF6BD00);
  static const Color primaryLight = Color(0xFFF6BD00);

  // Background Colors
  static const Color background = Color(0xFF121312);
  static const Color backgroundLight = Color(0xFF282A28);
  static const Color surface = Color(0xFF1F1F1F);
  static const Color surfaceLight = Color(0xFF2E2E2E);

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB3B3B3);
  static const Color textTertiary = Color(0xFF808080);

  // Accent & Status Colors
  static const Color accent = Color(0xFFF6BD00);
  static const Color error = Color(0xFFE82626);
  static const Color success = Color(0xFF57AA53);

  // Divider Colors
  static const Color divider = Color(0xFF282828);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  AppColors._();
}


import 'package:flutter/material.dart';

/// MindEase Color Design Tokens
class AppColors {
  AppColors._();

  // Primary Terracotta / Coral Palette
  static const Color primary = Color(0xFFCE4B37);
  static const Color primaryDark = Color(0xFFB33A27);
  static const Color primaryLight = Color(0xFFE46957);
  static const Color primarySubtle = Color(0xFFFDF1EE);

  // Background & Surfaces
  static const Color background = Color(0xFFFAF8F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF4EFEA);

  // Text Colors
  static const Color textPrimary = Color(0xFF261D1A);
  static const Color textSecondary = Color(0xFF6B625C);
  static const Color textTertiary = Color(0xFF9E958E);
  static const Color textPlaceholder = Color(0xFFAEA7A0);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Brand Accent (Links, interactive text)
  static const Color accentTeal = Color(0xFF0F766E);
  static const Color accentTealDark = Color(0xFF0D5E57);
  static const Color accentTealLight = Color(0xFF14B8A6);

  // Alert & Feedback Banners
  // Error / Warning
  static const Color alertErrorBg = Color(0xFFFDEEEC);
  static const Color alertErrorBorder = Color(0xFFF7C2B9);
  static const Color alertErrorText = Color(0xFFB83824);
  static const Color alertErrorIcon = Color(0xFFD44B36);

  // Success
  static const Color alertSuccessBg = Color(0xFFEDF7EE);
  static const Color alertSuccessBorder = Color(0xFFBCE3C4);
  static const Color alertSuccessText = Color(0xFF236539);
  static const Color alertSuccessIcon = Color(0xFF2E8548);

  // Form Fields
  static const Color inputBg = Color(0xFFFFFFFF);
  static const Color inputBorder = Color(0xFFE8E2DA);
  static const Color inputBorderFocused = Color(0xFFCE4B37);
  static const Color inputBorderValid = Color(0xFF7EAA83);
  static const Color inputBorderError = Color(0xFFE05745);
  static const Color inputPrefixIcon = Color(0xFF7A706A);
  static const Color inputSuffixIcon = Color(0xFF9E958E);

  // Mood Faces (Welcome Screen)
  static const Color moodCalm = Color(0xFF98AA7D);
  static const Color moodHappy = Color(0xFFF5C558);
  static const Color moodNeutral = Color(0xFFCBB29E);
  static const Color moodSad = Color(0xFFE17357);
  static const Color moodWorried = Color(0xFFA39CFE);

  // Logo Palette
  static const Color logoCoral = Color(0xFFE76F51);
  static const Color logoGolden = Color(0xFFF4A261);
  static const Color logoTeal = Color(0xFF2A9D8F);
  static const Color logoDarkBlue = Color(0xFF264653);
  static const Color logoPurple = Color(0xFF7209B7);
  static const Color logoGreen = Color(0xFF588157);
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// MindEase Central ThemeData
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    final base = ThemeData.light();

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primary,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.textOnPrimary,
        secondary: AppColors.accentTeal,
        onSecondary: Colors.white,
        background: AppColors.background,
        onBackground: AppColors.textPrimary,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        error: AppColors.alertErrorText,
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inputBg,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        hintStyle: AppTypography.inputHint,
        labelStyle: AppTypography.inputLabel,
        helperStyle: AppTypography.inputHelper,
        errorStyle: AppTypography.inputError,
        border: const OutlineInputBorder(
          borderRadius: AppSpacing.roundedPill,
          borderSide: BorderSide(color: AppColors.inputBorder, width: 1.2),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: AppSpacing.roundedPill,
          borderSide: BorderSide(color: AppColors.inputBorder, width: 1.2),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: AppSpacing.roundedPill,
          borderSide: BorderSide(color: AppColors.inputBorderFocused, width: 1.6),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: AppSpacing.roundedPill,
          borderSide: BorderSide(color: AppColors.inputBorderError, width: 1.4),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: AppSpacing.roundedPill,
          borderSide: BorderSide(color: AppColors.inputBorderError, width: 1.6),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          minimumSize: const Size.fromHeight(AppSpacing.buttonHeight),
          shape: const RoundedRectangleBorder(
            borderRadius: AppSpacing.roundedPill,
          ),
          elevation: 0,
          textStyle: AppTypography.buttonLarge,
        ),
      ),
    );
  }
}

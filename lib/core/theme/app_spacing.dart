import 'package:flutter/material.dart';

/// MindEase Spacing & Dimension Tokens
class AppSpacing {
  AppSpacing._();

  static const double xxs = 4.0;
  static const double xs = 8.0;
  static const double sm = 12.0;
  static const double md = 16.0;
  static const double lg = 20.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double xxxl = 40.0;

  // Component Heights
  static const double buttonHeight = 52.0;
  static const double inputHeight = 52.0;
  static const double backButtonSize = 40.0;

  // Border Radii
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusPill = 28.0;
  static const double radiusCircular = 100.0;

  static const BorderRadius roundedSm = BorderRadius.all(Radius.circular(radiusSm));
  static const BorderRadius roundedMd = BorderRadius.all(Radius.circular(radiusMd));
  static const BorderRadius roundedLg = BorderRadius.all(Radius.circular(radiusLg));
  static const BorderRadius roundedPill = BorderRadius.all(Radius.circular(radiusPill));
  static const BorderRadius roundedCircular = BorderRadius.all(Radius.circular(radiusCircular));
}

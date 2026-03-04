import 'package:flutter/material.dart';

/// Centralized font and typography definitions for the Laffa bike-sharing app.
/// Uses system fonts for reliability (no network downloads needed).
/// System fonts: Roboto on Android, SF Pro on iOS - both professional.
/// All screens and widgets should reference these constants for consistent typography.
class AppFonts {
  AppFonts._(); // Prevent instantiation

  // ──────────────────────────────────────────────
  // Font Weights
  // ──────────────────────────────────────────────
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;

  // ──────────────────────────────────────────────
  // Font Sizes
  // ──────────────────────────────────────────────
  static const double sizeXSmall = 10.0;
  static const double sizeSmall = 12.0;
  static const double sizeBody = 14.0;
  static const double sizeMedium = 16.0;
  static const double sizeLarge = 18.0;
  static const double sizeXLarge = 20.0;
  static const double sizeHeading = 24.0;
  static const double sizeDisplay = 28.0;
  static const double sizeDisplayLarge = 32.0;
  static const double sizeHero = 40.0;

  // ──────────────────────────────────────────────
  // Line Heights
  // ──────────────────────────────────────────────
  static const double lineHeightTight = 1.2;
  static const double lineHeightNormal = 1.4;
  static const double lineHeightRelaxed = 1.6;

  // ──────────────────────────────────────────────
  // Core Style Builder
  // ──────────────────────────────────────────────

  /// Returns a TextStyle using system fonts (no network download).
  static TextStyle style({
    required bool isArabic,
    double fontSize = sizeBody,
    FontWeight fontWeight = regular,
    Color? color,
    double? height,
    TextDecoration? decoration,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      decoration: decoration,
      letterSpacing: letterSpacing,
    );
  }

  // ──────────────────────────────────────────────
  // Convenience Text Style Builders
  // ──────────────────────────────────────────────

  /// Hero / display title text style.
  static TextStyle displayLarge({required bool isArabic, Color? color}) {
    return style(
      isArabic: isArabic,
      fontSize: sizeDisplayLarge,
      fontWeight: bold,
      color: color,
    );
  }

  /// Display medium text style.
  static TextStyle displayMedium({required bool isArabic, Color? color}) {
    return style(
      isArabic: isArabic,
      fontSize: sizeDisplay,
      fontWeight: bold,
      color: color,
    );
  }

  /// Heading text style.
  static TextStyle heading({required bool isArabic, Color? color}) {
    return style(
      isArabic: isArabic,
      fontSize: sizeHeading,
      fontWeight: semiBold,
      color: color,
    );
  }

  /// Sub-heading text style.
  static TextStyle subheading({required bool isArabic, Color? color}) {
    return style(
      isArabic: isArabic,
      fontSize: sizeXLarge,
      fontWeight: semiBold,
      color: color,
    );
  }

  /// Title text style.
  static TextStyle title({required bool isArabic, Color? color}) {
    return style(
      isArabic: isArabic,
      fontSize: sizeLarge,
      fontWeight: semiBold,
      color: color,
    );
  }

  /// Subtitle text style.
  static TextStyle subtitle({required bool isArabic, Color? color}) {
    return style(
      isArabic: isArabic,
      fontSize: sizeMedium,
      fontWeight: medium,
      color: color,
    );
  }

  /// Body large text style.
  static TextStyle bodyLarge({required bool isArabic, Color? color}) {
    return style(
      isArabic: isArabic,
      fontSize: sizeMedium,
      fontWeight: regular,
      color: color,
    );
  }

  /// Body medium / default text style.
  static TextStyle bodyMedium({required bool isArabic, Color? color}) {
    return style(
      isArabic: isArabic,
      fontSize: sizeBody,
      fontWeight: regular,
      color: color,
    );
  }

  /// Body small text style.
  static TextStyle bodySmall({required bool isArabic, Color? color}) {
    return style(
      isArabic: isArabic,
      fontSize: sizeSmall,
      fontWeight: regular,
      color: color,
    );
  }

  /// Caption / extra small text style.
  static TextStyle caption({required bool isArabic, Color? color}) {
    return style(
      isArabic: isArabic,
      fontSize: sizeXSmall,
      fontWeight: regular,
      color: color,
    );
  }

  /// Label / button text style.
  static TextStyle label({required bool isArabic, Color? color}) {
    return style(
      isArabic: isArabic,
      fontSize: sizeBody,
      fontWeight: semiBold,
      color: color,
    );
  }

  /// Button text style.
  static TextStyle button({required bool isArabic, Color? color}) {
    return style(
      isArabic: isArabic,
      fontSize: sizeMedium,
      fontWeight: semiBold,
      color: color,
    );
  }
}

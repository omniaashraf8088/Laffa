import 'package:flutter/material.dart';

import 'fonts.dart';

/// Centralized text styles for the entire app.
/// Every screen should use these instead of inline AppFonts.style() calls.
class AppTextStyles {
  AppTextStyles._();

  // ── Display ───────────────────────────────────────
  /// 40px bold — hero numbers, large amounts.
  static TextStyle hero({required bool isArabic, Color? color}) =>
      AppFonts.style(
        isArabic: isArabic,
        fontSize: AppFonts.sizeHero,
        fontWeight: AppFonts.bold,
        color: color,
      );

  /// 32px bold — display title.
  static TextStyle displayLarge({required bool isArabic, Color? color}) =>
      AppFonts.displayLarge(isArabic: isArabic, color: color);

  /// 28px bold — display medium, large balance.
  static TextStyle displayMedium({required bool isArabic, Color? color}) =>
      AppFonts.displayMedium(isArabic: isArabic, color: color);

  // ── Headings ──────────────────────────────────────
  /// 24px semiBold — page headings.
  static TextStyle heading({required bool isArabic, Color? color}) =>
      AppFonts.heading(isArabic: isArabic, color: color);

  /// 24px bold — bold page headings, prices.
  static TextStyle headingBold({required bool isArabic, Color? color}) =>
      AppFonts.style(
        isArabic: isArabic,
        fontSize: AppFonts.sizeHeading,
        fontWeight: AppFonts.bold,
        color: color,
      );

  /// 22px bold — large price display.
  static TextStyle priceLarge({required bool isArabic, Color? color}) =>
      AppFonts.style(
        isArabic: isArabic,
        fontSize: 22,
        fontWeight: AppFonts.bold,
        color: color,
      );

  /// 20px semiBold — sub-heading.
  static TextStyle subheading({required bool isArabic, Color? color}) =>
      AppFonts.subheading(isArabic: isArabic, color: color);

  /// 20px bold — bold sub-heading.
  static TextStyle subheadingBold({required bool isArabic, Color? color}) =>
      AppFonts.style(
        isArabic: isArabic,
        fontSize: AppFonts.sizeXLarge,
        fontWeight: AppFonts.bold,
        color: color,
      );

  // ── Title ─────────────────────────────────────────
  /// 18px semiBold — screen/section titles.
  static TextStyle title({required bool isArabic, Color? color}) =>
      AppFonts.title(isArabic: isArabic, color: color);

  /// 18px bold — bold titles.
  static TextStyle titleBold({required bool isArabic, Color? color}) =>
      AppFonts.style(
        isArabic: isArabic,
        fontSize: AppFonts.sizeLarge,
        fontWeight: AppFonts.bold,
        color: color,
      );

  // ── Section / Card Title ──────────────────────────
  /// 16px bold — section headers, card titles (most used pattern).
  static TextStyle sectionTitle({required bool isArabic, Color? color}) =>
      AppFonts.style(
        isArabic: isArabic,
        fontSize: AppFonts.sizeMedium,
        fontWeight: AppFonts.bold,
        color: color,
      );

  /// 16px semiBold — button text, emphasis.
  static TextStyle button({required bool isArabic, Color? color}) =>
      AppFonts.button(isArabic: isArabic, color: color);

  /// 16px medium — subtitle, secondary headers.
  static TextStyle subtitle({required bool isArabic, Color? color}) =>
      AppFonts.subtitle(isArabic: isArabic, color: color);

  /// 16px regular — body large.
  static TextStyle bodyLarge({required bool isArabic, Color? color}) =>
      AppFonts.bodyLarge(isArabic: isArabic, color: color);

  // ── Body ──────────────────────────────────────────
  /// 14px regular — default body text.
  static TextStyle body({required bool isArabic, Color? color}) =>
      AppFonts.bodyMedium(isArabic: isArabic, color: color);

  /// 14px medium — emphasized body.
  static TextStyle bodyMedium({required bool isArabic, Color? color}) =>
      AppFonts.style(
        isArabic: isArabic,
        fontSize: AppFonts.sizeBody,
        fontWeight: AppFonts.medium,
        color: color,
      );

  /// 14px semiBold — labels, inline emphasis.
  static TextStyle label({required bool isArabic, Color? color}) =>
      AppFonts.label(isArabic: isArabic, color: color);

  /// 14px bold — strong body text.
  static TextStyle bodyBold({required bool isArabic, Color? color}) =>
      AppFonts.style(
        isArabic: isArabic,
        fontSize: AppFonts.sizeBody,
        fontWeight: AppFonts.bold,
        color: color,
      );

  // ── Small / Caption ───────────────────────────────
  /// 12px regular — body small, descriptions.
  static TextStyle bodySmall({required bool isArabic, Color? color}) =>
      AppFonts.bodySmall(isArabic: isArabic, color: color);

  /// 12px medium — metadata, secondary info.
  static TextStyle smallMedium({required bool isArabic, Color? color}) =>
      AppFonts.style(
        isArabic: isArabic,
        fontSize: AppFonts.sizeSmall,
        fontWeight: AppFonts.medium,
        color: color,
      );

  /// 12px semiBold — small labels, tags.
  static TextStyle smallLabel({required bool isArabic, Color? color}) =>
      AppFonts.style(
        isArabic: isArabic,
        fontSize: AppFonts.sizeSmall,
        fontWeight: AppFonts.semiBold,
        color: color,
      );

  /// 12px bold — small bold text.
  static TextStyle smallBold({required bool isArabic, Color? color}) =>
      AppFonts.style(
        isArabic: isArabic,
        fontSize: AppFonts.sizeSmall,
        fontWeight: AppFonts.bold,
        color: color,
      );

  // ── Tiny / XSmall ─────────────────────────────────
  /// 10px regular — captions, timestamps.
  static TextStyle caption({required bool isArabic, Color? color}) =>
      AppFonts.caption(isArabic: isArabic, color: color);

  /// 10px medium — tiny metadata.
  static TextStyle captionMedium({required bool isArabic, Color? color}) =>
      AppFonts.style(
        isArabic: isArabic,
        fontSize: AppFonts.sizeXSmall,
        fontWeight: AppFonts.medium,
        color: color,
      );

  /// 10px semiBold — tiny labels.
  static TextStyle captionSemiBold({required bool isArabic, Color? color}) =>
      AppFonts.style(
        isArabic: isArabic,
        fontSize: AppFonts.sizeXSmall,
        fontWeight: AppFonts.semiBold,
        color: color,
      );

  // ── Auth Screens (non-standard sizes) ─────────────
  /// 28-32px bold — auth screen titles (responsive).
  static TextStyle authTitle({
    required bool isArabic,
    Color? color,
    bool large = false,
  }) => AppFonts.style(
    isArabic: isArabic,
    fontSize: large ? 32 : 28,
    fontWeight: AppFonts.bold,
    color: color,
  );

  /// 15-16px semiBold — auth buttons, form actions.
  static TextStyle authButton({
    required bool isArabic,
    Color? color,
    bool large = false,
  }) => AppFonts.style(
    isArabic: isArabic,
    fontSize: large ? 16 : 15,
    fontWeight: AppFonts.semiBold,
    color: color,
  );

  /// 13px semiBold — auth small labels.
  static TextStyle authSmallLabel({required bool isArabic, Color? color}) =>
      AppFonts.style(
        isArabic: isArabic,
        fontSize: 13,
        fontWeight: AppFonts.semiBold,
        color: color,
      );

  /// 15-16px regular — auth body text (responsive).
  static TextStyle authBody({
    required bool isArabic,
    Color? color,
    bool large = false,
  }) => AppFonts.style(
    isArabic: isArabic,
    fontSize: large ? 16 : 15,
    fontWeight: AppFonts.regular,
    color: color,
  );

  /// 17px bold — auth secondary title.
  static TextStyle authSecondaryTitle({required bool isArabic, Color? color}) =>
      AppFonts.style(
        isArabic: isArabic,
        fontSize: 17,
        fontWeight: AppFonts.bold,
        color: color,
      );

  // ── Onboarding ────────────────────────────────────
  /// 28-36px bold — onboarding hero title (responsive).
  static TextStyle onboardingTitle({
    required bool isArabic,
    Color? color,
    bool large = false,
  }) => AppFonts.style(
    isArabic: isArabic,
    fontSize: large ? 36 : 28,
    fontWeight: AppFonts.bold,
    color: color,
  );

  /// 16-18px regular — onboarding body text (responsive).
  static TextStyle onboardingBody({
    required bool isArabic,
    Color? color,
    bool large = false,
  }) => AppFonts.style(
    isArabic: isArabic,
    fontSize: large ? 18 : 16,
    fontWeight: AppFonts.regular,
    color: color,
  );
}

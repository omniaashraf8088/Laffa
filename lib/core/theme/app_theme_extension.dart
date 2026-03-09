import 'package:flutter/material.dart';

import 'app_colors.dart';

class LaffaThemeExtension extends ThemeExtension<LaffaThemeExtension> {
  final Color cardBackground;
  final Color shimmerBase;
  final Color shimmerHighlight;
  final Color dividerColor;
  final Color shadowColor;
  final Color overlayColor;
  final Color bookingCardColor;
  final Color tripTimerBg;
  final Color ratingBg;
  final Color successBg;
  final Color errorBg;
  final Color warningBg;
  final Color infoBg;

  const LaffaThemeExtension({
    required this.cardBackground,
    required this.shimmerBase,
    required this.shimmerHighlight,
    required this.dividerColor,
    required this.shadowColor,
    required this.overlayColor,
    required this.bookingCardColor,
    required this.tripTimerBg,
    required this.ratingBg,
    required this.successBg,
    required this.errorBg,
    required this.warningBg,
    required this.infoBg,
  });

  static const LaffaThemeExtension light = LaffaThemeExtension(
    cardBackground: AppColors.white,
    shimmerBase: AppColors.shimmer,
    shimmerHighlight: AppColors.greyLight,
    dividerColor: AppColors.divider,
    shadowColor: AppColors.shadow,
    overlayColor: AppColors.overlay,
    bookingCardColor: AppColors.bookingCard,
    tripTimerBg: AppColors.tripTimerBackground,
    ratingBg: AppColors.ratingBackground,
    successBg: AppColors.successLight,
    errorBg: AppColors.errorLight,
    warningBg: AppColors.warningLight,
    infoBg: AppColors.infoLight,
  );

  static const LaffaThemeExtension dark = LaffaThemeExtension(
    cardBackground: AppColors.surfaceDark,
    shimmerBase: AppColors.greyDark,
    shimmerHighlight: AppColors.greyMedium,
    dividerColor: AppColors.greyDark,
    shadowColor: AppColors.black,
    overlayColor: AppColors.overlay,
    bookingCardColor: AppColors.surfaceDark,
    tripTimerBg: AppColors.black,
    ratingBg: AppColors.surfaceDark,
    successBg: AppColors.darkPresetGreen,
    errorBg: AppColors.darkPresetRed,
    warningBg: AppColors.darkPresetBrown,
    infoBg: AppColors.darkPresetBlue,
  );

  @override
  LaffaThemeExtension copyWith({
    Color? cardBackground,
    Color? shimmerBase,
    Color? shimmerHighlight,
    Color? dividerColor,
    Color? shadowColor,
    Color? overlayColor,
    Color? bookingCardColor,
    Color? tripTimerBg,
    Color? ratingBg,
    Color? successBg,
    Color? errorBg,
    Color? warningBg,
    Color? infoBg,
  }) {
    return LaffaThemeExtension(
      cardBackground: cardBackground ?? this.cardBackground,
      shimmerBase: shimmerBase ?? this.shimmerBase,
      shimmerHighlight: shimmerHighlight ?? this.shimmerHighlight,
      dividerColor: dividerColor ?? this.dividerColor,
      shadowColor: shadowColor ?? this.shadowColor,
      overlayColor: overlayColor ?? this.overlayColor,
      bookingCardColor: bookingCardColor ?? this.bookingCardColor,
      tripTimerBg: tripTimerBg ?? this.tripTimerBg,
      ratingBg: ratingBg ?? this.ratingBg,
      successBg: successBg ?? this.successBg,
      errorBg: errorBg ?? this.errorBg,
      warningBg: warningBg ?? this.warningBg,
      infoBg: infoBg ?? this.infoBg,
    );
  }

  @override
  LaffaThemeExtension lerp(covariant LaffaThemeExtension? other, double t) {
    if (other == null) return this;
    return LaffaThemeExtension(
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      shimmerBase: Color.lerp(shimmerBase, other.shimmerBase, t)!,
      shimmerHighlight: Color.lerp(
        shimmerHighlight,
        other.shimmerHighlight,
        t,
      )!,
      dividerColor: Color.lerp(dividerColor, other.dividerColor, t)!,
      shadowColor: Color.lerp(shadowColor, other.shadowColor, t)!,
      overlayColor: Color.lerp(overlayColor, other.overlayColor, t)!,
      bookingCardColor: Color.lerp(
        bookingCardColor,
        other.bookingCardColor,
        t,
      )!,
      tripTimerBg: Color.lerp(tripTimerBg, other.tripTimerBg, t)!,
      ratingBg: Color.lerp(ratingBg, other.ratingBg, t)!,
      successBg: Color.lerp(successBg, other.successBg, t)!,
      errorBg: Color.lerp(errorBg, other.errorBg, t)!,
      warningBg: Color.lerp(warningBg, other.warningBg, t)!,
      infoBg: Color.lerp(infoBg, other.infoBg, t)!,
    );
  }
}

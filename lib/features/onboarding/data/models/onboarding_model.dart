import 'package:flutter/material.dart';

/// Model class for Onboarding page data
class OnboardingModel {
  final String titleEn;
  final String titleAr;
  final String descriptionEn;
  final String descriptionAr;
  final String? lottieAssetPath;
  final IconData? fallbackIcon;
  final Color backgroundColor;

  const OnboardingModel({
    required this.titleEn,
    required this.titleAr,
    required this.descriptionEn,
    required this.descriptionAr,
    this.lottieAssetPath,
    this.fallbackIcon,
    required this.backgroundColor,
  });

  /// Get title based on language
  String getTitle(bool isArabic) => isArabic ? titleAr : titleEn;

  /// Get description based on language
  String getDescription(bool isArabic) =>
      isArabic ? descriptionAr : descriptionEn;

  OnboardingModel copyWith({
    String? titleEn,
    String? titleAr,
    String? descriptionEn,
    String? descriptionAr,
    String? lottieAssetPath,
    IconData? fallbackIcon,
    Color? backgroundColor,
  }) {
    return OnboardingModel(
      titleEn: titleEn ?? this.titleEn,
      titleAr: titleAr ?? this.titleAr,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      lottieAssetPath: lottieAssetPath ?? this.lottieAssetPath,
      fallbackIcon: fallbackIcon ?? this.fallbackIcon,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }
}

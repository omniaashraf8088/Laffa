import 'package:flutter/material.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/localization/app_strings_ar.dart';
import '../../../core/localization/app_strings_en.dart';
import '../../../core/theme/app_colors.dart';
import 'models/onboarding_model.dart';

/// Predefined onboarding pages for Laffa app.
/// Separated from the model to keep models clean and data-only.
const List<OnboardingModel> onboardingPages = [
  OnboardingModel(
    titleEn: AppStringsEn.onboardingTitle1,
    titleAr: AppStringsAr.onboardingTitle1,
    descriptionEn: AppStringsEn.onboardingDesc1,
    descriptionAr: AppStringsAr.onboardingDesc1,
    lottieAssetPath: AppAssets.onboarding1,
    fallbackIcon: Icons.electric_scooter_rounded,
    backgroundColor: AppColors.onboardingBg1,
  ),
  OnboardingModel(
    titleEn: AppStringsEn.onboardingTitle2,
    titleAr: AppStringsAr.onboardingTitle2,
    descriptionEn: AppStringsEn.onboardingDesc2,
    descriptionAr: AppStringsAr.onboardingDesc2,
    lottieAssetPath: AppAssets.onboarding2,
    fallbackIcon: Icons.location_on_rounded,
    backgroundColor: AppColors.onboardingBg2,
  ),
  OnboardingModel(
    titleEn: AppStringsEn.onboardingTitle3,
    titleAr: AppStringsAr.onboardingTitle3,
    descriptionEn: AppStringsEn.onboardingDesc3,
    descriptionAr: AppStringsAr.onboardingDesc3,
    lottieAssetPath: AppAssets.onboarding3,
    fallbackIcon: Icons.qr_code_scanner_rounded,
    backgroundColor: AppColors.onboardingBg3,
  ),
  OnboardingModel(
    titleEn: AppStringsEn.onboardingTitle4,
    titleAr: AppStringsAr.onboardingTitle4,
    descriptionEn: AppStringsEn.onboardingDesc4,
    descriptionAr: AppStringsAr.onboardingDesc4,
    lottieAssetPath: AppAssets.onboarding4,
    fallbackIcon: Icons.route_rounded,
    backgroundColor: AppColors.onboardingBg4,
  ),
  OnboardingModel(
    titleEn: AppStringsEn.onboardingTitle5,
    titleAr: AppStringsAr.onboardingTitle5,
    descriptionEn: AppStringsEn.onboardingDesc5,
    descriptionAr: AppStringsAr.onboardingDesc5,
    lottieAssetPath: AppAssets.onboarding5,
    fallbackIcon: Icons.local_offer_rounded,
    backgroundColor: AppColors.onboardingBg5,
  ),
];

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
}

/// Predefined onboarding pages for Laffa app
class OnboardingData {
  static const List<OnboardingModel> pages = [
    OnboardingModel(
      titleEn: 'Welcome to Laffa',
      titleAr: 'مرحباً بك في Laffa',
      descriptionEn: 'Your smart way to move around the city easily.',
      descriptionAr: 'طريقتك الذكية للتنقل في المدينة بسهولة.',
      lottieAssetPath: 'assets/animations/onboarding_1.json',
      fallbackIcon: Icons.electric_scooter_rounded,
      backgroundColor: Color(0xFFF5EBDD),
    ),
    OnboardingModel(
      titleEn: 'Find Nearby Stations',
      titleAr: 'اعثر على محطات قريبة',
      descriptionEn: 'Discover scooter stations close to you instantly.',
      descriptionAr: 'اكتشف محطات الدراجات القريبة منك على الفور.',
      lottieAssetPath: 'assets/animations/onboarding_2.json',
      fallbackIcon: Icons.location_on_rounded,
      backgroundColor: Color(0xFFFFF8F0),
    ),
    OnboardingModel(
      titleEn: 'Unlock & Ride',
      titleAr: 'افتح واركب',
      descriptionEn: 'Scan, unlock, and start your ride in seconds.',
      descriptionAr: 'امسح، افتح، وابدأ رحلتك في ثوانٍ.',
      lottieAssetPath: 'assets/animations/onboarding_3.json',
      fallbackIcon: Icons.qr_code_scanner_rounded,
      backgroundColor: Color(0xFFFFF5E9),
    ),
    OnboardingModel(
      titleEn: 'Track Your Trips',
      titleAr: 'تتبع رحلاتك',
      descriptionEn: 'View trip history and track your ride details.',
      descriptionAr: 'عرض سجل الرحلات وتتبع تفاصيل رحلتك.',
      lottieAssetPath: 'assets/animations/onboarding_4.json',
      fallbackIcon: Icons.route_rounded,
      backgroundColor: Color(0xFFFFF2E6),
    ),
    OnboardingModel(
      titleEn: 'Save with Coupons',
      titleAr: 'وفّر مع الكوبونات',
      descriptionEn: 'Apply discount coupons and save money.',
      descriptionAr: 'طبّق كوبونات الخصم ووفّر المال.',
      lottieAssetPath: 'assets/animations/onboarding_5.json',
      fallbackIcon: Icons.local_offer_rounded,
      backgroundColor: Color(0xFFFFF0DD),
    ),
  ];
}

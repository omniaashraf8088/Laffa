import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/localization/app_strings_ar.dart';
import '../../../../core/localization/app_strings_en.dart';
import '../../../../core/router/app_router.dart';

class ProfileServicesGrid extends StatelessWidget {
  final bool isArabic;

  const ProfileServicesGrid({super.key, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    final services = [
      _ServiceItem(
        Icons.electric_scooter_rounded,
        isArabic ? AppStringsAr.myRides : AppStringsEn.myRides,
        AppRouter.rideHistory,
        AppColors.primary,
      ),
      _ServiceItem(
        Icons.payment_rounded,
        isArabic ? AppStringsAr.payments : AppStringsEn.payments,
        AppRouter.paymentMethods,
        AppColors.info,
      ),
      _ServiceItem(
        Icons.card_giftcard_rounded,
        isArabic ? AppStringsAr.coupons : AppStringsEn.coupons,
        AppRouter.coupons,
        AppColors.warning,
      ),
      _ServiceItem(
        Icons.location_on_rounded,
        isArabic ? AppStringsAr.savedPlaces : AppStringsEn.savedPlaces,
        AppRouter.savedPlaces,
        AppColors.success,
      ),
      _ServiceItem(
        Icons.notifications_rounded,
        isArabic ? AppStringsAr.notifications : AppStringsEn.notifications,
        '',
        AppColors.secondary,
      ),
      _ServiceItem(
        Icons.support_agent_rounded,
        isArabic ? AppStringsAr.support : AppStringsEn.support,
        AppRouter.chat,
        AppColors.accent,
      ),
      _ServiceItem(
        Icons.settings_rounded,
        isArabic ? AppStringsAr.settings : AppStringsEn.settings,
        AppRouter.settings,
        AppColors.greyDark,
      ),
      _ServiceItem(
        Icons.star_rounded,
        isArabic ? AppStringsAr.rateRide : AppStringsEn.rateRide,
        AppRouter.rating,
        AppColors.ratingStar,
      ),
      _ServiceItem(
        Icons.shield_rounded,
        isArabic ? AppStringsAr.safetyCenter : AppStringsEn.safetyCenter,
        AppRouter.safetyCenter,
        AppColors.error,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isArabic ? AppStringsAr.services : AppStringsEn.services,
            style: AppTextStyles.sectionTitle(
              isArabic: isArabic,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.0,
            ),
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              return _ServiceTile(service: service, isArabic: isArabic);
            },
          ),
        ],
      ),
    );
  }
}

class _ServiceTile extends StatelessWidget {
  final _ServiceItem service;
  final bool isArabic;

  const _ServiceTile({required this.service, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: service.route.isNotEmpty
          ? () => context.push(service.route)
          : null,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderLight),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: service.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(service.icon, color: service.color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              service.label,
              textAlign: TextAlign.center,
              style: AppTextStyles.caption(
                isArabic: isArabic,
                color: AppColors.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceItem {
  final IconData icon;
  final String label;
  final String route;
  final Color color;

  const _ServiceItem(this.icon, this.label, this.route, this.color);
}

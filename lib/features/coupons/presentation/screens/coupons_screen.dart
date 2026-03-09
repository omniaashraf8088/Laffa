import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/localization/app_strings_ar.dart';
import '../../../../core/localization/app_strings_en.dart';
import '../../../../core/localization/localization_provider.dart';
import '../../data/coupons_dummy_data.dart';
import '../widgets/coupon_input.dart';
import '../widgets/coupon_card.dart';

class CouponsScreen extends ConsumerWidget {
  const CouponsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = ref.watch(localizationProvider);
    final isArabic = localization.language == AppLanguage.ar;

    final activeCoupons = dummyCoupons.where((c) => c.isActive).toList();
    final expiredCoupons = dummyCoupons.where((c) => !c.isActive).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          isArabic ? AppStringsAr.coupons : AppStringsEn.coupons,
          style: AppTextStyles.title(
            isArabic: isArabic,
            color: AppColors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CouponInput(isArabic: isArabic),
            const SizedBox(height: 24),
            if (activeCoupons.isNotEmpty) ...[
              Text(
                isArabic
                    ? AppStringsAr.activeCoupons
                    : AppStringsEn.activeCoupons,
                style: AppTextStyles.label(
                  isArabic: isArabic,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 10),
              ...activeCoupons.map(
                (c) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: CouponCard(coupon: c, isArabic: isArabic),
                ),
              ),
            ],
            if (expiredCoupons.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                isArabic
                    ? AppStringsAr.expiredCoupons
                    : AppStringsEn.expiredCoupons,
                style: AppTextStyles.label(
                  isArabic: isArabic,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 10),
              ...expiredCoupons.map(
                (c) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: CouponCard(coupon: c, isArabic: isArabic),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

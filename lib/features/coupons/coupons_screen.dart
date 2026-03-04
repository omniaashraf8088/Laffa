import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/colors.dart';
import '../../core/constants/fonts.dart';
import '../../core/localization/app_strings_ar.dart';
import '../../core/localization/app_strings_en.dart';
import '../../core/localization/localization_provider.dart';

class _CouponItem {
  final String code;
  final String discount;
  final String expiryDate;
  final bool isActive;

  const _CouponItem({
    required this.code,
    required this.discount,
    required this.expiryDate,
    required this.isActive,
  });
}

const _dummyCoupons = [
  _CouponItem(code: 'WELCOME50', discount: '50%', expiryDate: '2026-04-01', isActive: true),
  _CouponItem(code: 'RIDE20', discount: '20%', expiryDate: '2026-03-15', isActive: true),
  _CouponItem(code: 'LAFFA10', discount: '10 EGP', expiryDate: '2026-05-01', isActive: true),
  _CouponItem(code: 'SUMMER30', discount: '30%', expiryDate: '2026-01-15', isActive: false),
];

class CouponsScreen extends ConsumerWidget {
  const CouponsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = ref.watch(localizationProvider);
    final isArabic = localization.language == AppLanguage.ar;

    final activeCoupons = _dummyCoupons.where((c) => c.isActive).toList();
    final expiredCoupons = _dummyCoupons.where((c) => !c.isActive).toList();

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
          style: AppFonts.title(isArabic: isArabic, color: AppColors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCouponInput(isArabic),
            const SizedBox(height: 24),
            if (activeCoupons.isNotEmpty) ...[
              Text(
                isArabic ? AppStringsAr.activeCoupons : AppStringsEn.activeCoupons,
                style: AppFonts.label(isArabic: isArabic, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 10),
              ...activeCoupons.map((c) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildCouponCard(c, isArabic),
              )),
            ],
            if (expiredCoupons.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                isArabic ? AppStringsAr.expiredCoupons : AppStringsEn.expiredCoupons,
                style: AppFonts.label(isArabic: isArabic, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 10),
              ...expiredCoupons.map((c) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildCouponCard(c, isArabic),
              )),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCouponInput(bool isArabic) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isArabic ? AppStringsAr.applyCoupon : AppStringsEn.applyCoupon,
            style: AppFonts.label(isArabic: isArabic, color: AppColors.text),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: isArabic ? AppStringsAr.couponCode : AppStringsEn.couponCode,
                    prefixIcon: const Icon(Icons.local_offer_rounded, color: AppColors.primary, size: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                ),
                child: Text(
                  isArabic ? 'تطبيق' : 'Apply',
                  style: AppFonts.label(isArabic: isArabic, color: AppColors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCouponCard(_CouponItem coupon, bool isArabic) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: coupon.isActive ? AppColors.white : AppColors.greyLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: coupon.isActive ? AppColors.primary.withValues(alpha: 0.3) : AppColors.border,
        ),
        boxShadow: coupon.isActive
            ? [BoxShadow(color: AppColors.shadow, blurRadius: 6, offset: const Offset(0, 2))]
            : [],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: coupon.isActive
                  ? AppColors.primary.withValues(alpha: 0.12)
                  : AppColors.greyMedium.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                coupon.discount,
                style: AppFonts.style(
                  isArabic: isArabic,
                  fontSize: AppFonts.sizeMedium,
                  fontWeight: AppFonts.bold,
                  color: coupon.isActive ? AppColors.primary : AppColors.textTertiary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  coupon.code,
                  style: AppFonts.label(
                    isArabic: isArabic,
                    color: coupon.isActive ? AppColors.text : AppColors.textTertiary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isArabic ? 'ينتهي: ${coupon.expiryDate}' : 'Expires: ${coupon.expiryDate}',
                  style: AppFonts.caption(isArabic: isArabic, color: AppColors.textTertiary),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: coupon.isActive ? AppColors.successLight : AppColors.greyLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              coupon.isActive
                  ? (isArabic ? 'نشط' : 'Active')
                  : (isArabic ? 'منتهي' : 'Expired'),
              style: AppFonts.caption(
                isArabic: isArabic,
                color: coupon.isActive ? AppColors.success : AppColors.textTertiary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

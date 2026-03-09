import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/localization/app_strings_ar.dart';
import '../../../../core/localization/app_strings_en.dart';
import '../../data/models/coupon_model.dart';

class CouponCard extends StatelessWidget {
  final CouponItem coupon;
  final bool isArabic;

  const CouponCard({super.key, required this.coupon, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: coupon.isActive ? AppColors.white : AppColors.greyLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: coupon.isActive
              ? AppColors.primary.withValues(alpha: 0.3)
              : AppColors.border,
        ),
        boxShadow: coupon.isActive
            ? [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ]
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
                style: AppTextStyles.sectionTitle(
                  isArabic: isArabic,
                  color: coupon.isActive
                      ? AppColors.primary
                      : AppColors.textTertiary,
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
                  style: AppTextStyles.label(
                    isArabic: isArabic,
                    color: coupon.isActive
                        ? AppColors.text
                        : AppColors.textTertiary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isArabic
                      ? '${AppStringsAr.expires}: ${DateFormat.yMMMd().format(coupon.expiryDate)}'
                      : '${AppStringsEn.expires}: ${DateFormat.yMMMd().format(coupon.expiryDate)}',
                  style: AppTextStyles.caption(
                    isArabic: isArabic,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: coupon.isActive
                  ? AppColors.successLight
                  : AppColors.greyLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              coupon.isActive
                  ? (isArabic ? AppStringsAr.active : AppStringsEn.active)
                  : (isArabic ? AppStringsAr.expired : AppStringsEn.expired),
              style: AppTextStyles.caption(
                isArabic: isArabic,
                color: coupon.isActive
                    ? AppColors.success
                    : AppColors.textTertiary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

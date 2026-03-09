import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/localization/app_strings_ar.dart';
import '../../../../core/localization/app_strings_en.dart';

/// Widget that displays the payment amount summary.
class PaymentSummaryWidget extends StatelessWidget {
  final double amount;
  final String currency;
  final bool isArabic;

  const PaymentSummaryWidget({
    super.key,
    required this.amount,
    this.currency = AppStringsEn.currency,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            isArabic ? AppStringsAr.amountDue : AppStringsEn.amountDue,
            style: AppTextStyles.body(
              isArabic: isArabic,
              color: AppColors.white.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${amount.toStringAsFixed(1)} $currency',
            style: AppTextStyles.hero(
              isArabic: isArabic,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              isArabic
                  ? AppStringsAr.estimatedRideCost
                  : AppStringsEn.estimatedRideCost,
              style: AppTextStyles.caption(
                isArabic: isArabic,
                color: AppColors.white.withValues(alpha: 0.9),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

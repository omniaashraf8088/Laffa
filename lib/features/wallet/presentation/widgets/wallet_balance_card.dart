import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/localization/app_strings_ar.dart';
import '../../../../core/localization/app_strings_en.dart';

class WalletBalanceCard extends StatelessWidget {
  final bool isArabic;
  final VoidCallback onTopUp;
  final String balance;

  const WalletBalanceCard({
    super.key,
    required this.isArabic,
    required this.onTopUp,
    // ignore: prefer_interpolation_to_compose_strings
    this.balance = '0.00 ' + AppStringsEn.currency,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isArabic
                ? AppStringsAr.currentBalance
                : AppStringsEn.currentBalance,
            style: AppTextStyles.body(
              isArabic: isArabic,
              color: AppColors.secondaryLight,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            balance,
            style: AppTextStyles.displayMedium(
              isArabic: isArabic,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: onTopUp,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.white,
                foregroundColor: AppColors.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                isArabic ? AppStringsAr.topUp : AppStringsEn.topUp,
                style: AppTextStyles.label(
                  isArabic: isArabic,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

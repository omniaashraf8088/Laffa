import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/localization/app_strings_ar.dart';
import '../../../../core/localization/app_strings_en.dart';

class TripsEmptyState extends StatelessWidget {
  final bool isArabic;

  const TripsEmptyState({super.key, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.history_rounded,
              color: AppColors.primary,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isArabic ? AppStringsAr.noTripsYet : AppStringsEn.noTripsYet,
            style: AppTextStyles.title(
              isArabic: isArabic,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isArabic
                ? AppStringsAr.startFirstRide
                : AppStringsEn.startFirstRide,
            style: AppTextStyles.body(
              isArabic: isArabic,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

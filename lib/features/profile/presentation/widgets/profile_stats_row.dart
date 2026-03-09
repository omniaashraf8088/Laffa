import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/localization/app_strings_ar.dart';
import '../../../../core/localization/app_strings_en.dart';

class ProfileStatsRow extends StatelessWidget {
  final bool isArabic;
  final String totalRides;
  final String totalKm;
  final String totalHours;

  const ProfileStatsRow({
    super.key,
    required this.isArabic,
    this.totalRides = '0',
    this.totalKm = '0',
    this.totalHours = '0',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _StatCard(
              icon: Icons.electric_scooter_rounded,
              value: totalRides,
              label: isArabic ? AppStringsAr.rides : AppStringsEn.rides,
              color: AppColors.primary,
              isArabic: isArabic,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              icon: Icons.straighten_rounded,
              value: totalKm,
              label: isArabic
                  ? AppStringsAr.kilometers
                  : AppStringsEn.kilometers,
              color: AppColors.success,
              isArabic: isArabic,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              icon: Icons.timer_rounded,
              value: totalHours,
              label: isArabic ? AppStringsAr.hours : AppStringsEn.hours,
              color: AppColors.info,
              isArabic: isArabic,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final bool isArabic;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.sectionTitle(
              isArabic: isArabic,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.caption(
              isArabic: isArabic,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

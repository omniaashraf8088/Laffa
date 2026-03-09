import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/localization/app_strings_ar.dart';
import '../../../../core/localization/app_strings_en.dart';
import '../../data/models/trip_model.dart';

class TripCard extends StatelessWidget {
  final TripItem trip;
  final bool isArabic;

  const TripCard({super.key, required this.trip, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.tripCompleted.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.electric_scooter_rounded,
                  color: AppColors.tripCompleted,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trip.stationName,
                      style: AppTextStyles.label(
                        isArabic: isArabic,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      DateFormat.yMMMd().format(trip.date),
                      style: AppTextStyles.caption(
                        isArabic: isArabic,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.successLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isArabic ? AppStringsAr.completed : AppStringsEn.completed,
                  style: AppTextStyles.caption(
                    isArabic: isArabic,
                    color: AppColors.success,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _TripStat(
                  icon: Icons.timer_rounded,
                  value: trip.formattedDuration,
                  label: isArabic
                      ? AppStringsAr.duration
                      : AppStringsEn.duration,
                  isArabic: isArabic,
                ),
                Container(width: 1, height: 30, color: AppColors.border),
                _TripStat(
                  icon: Icons.straighten_rounded,
                  value: trip.formattedDistance,
                  label: isArabic
                      ? AppStringsAr.distance
                      : AppStringsEn.distance,
                  isArabic: isArabic,
                ),
                Container(width: 1, height: 30, color: AppColors.border),
                _TripStat(
                  icon: Icons.payments_rounded,
                  value: trip.formattedCost,
                  label: isArabic ? AppStringsAr.cost : AppStringsEn.cost,
                  isArabic: isArabic,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TripStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final bool isArabic;

  const _TripStat({
    required this.icon,
    required this.value,
    required this.label,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 16),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.smallBold(
            isArabic: isArabic,
            color: AppColors.text,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.caption(
            isArabic: isArabic,
            color: AppColors.textTertiary,
          ),
        ),
      ],
    );
  }
}

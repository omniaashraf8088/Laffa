import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/localization/app_strings_ar.dart';
import '../../../../core/localization/app_strings_en.dart';
import '../../data/models/booking_model.dart';

/// Card widget that displays a single bike's details for selection.
class BikeCard extends StatelessWidget {
  final Bike bike;
  final bool isSelected;
  final bool isArabic;
  final VoidCallback onTap;

  const BikeCard({
    super.key,
    required this.bike,
    required this.isSelected,
    required this.isArabic,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.bookingCard : AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          children: [
            // Bike icon based on type
            _buildBikeIcon(),
            const SizedBox(width: 14),

            // Bike info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bike.name,
                    style: AppTextStyles.button(
                      isArabic: isArabic,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _buildTypeBadge(),
                      const SizedBox(width: 8),
                      if (bike.type == 'electric') _buildBatteryIndicator(),
                    ],
                  ),
                ],
              ),
            ),

            // Price per minute
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${bike.pricePerMinute.toStringAsFixed(1)} ${AppStringsEn.currency}',
                  style: AppTextStyles.sectionTitle(
                    isArabic: isArabic,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  '/${isArabic ? AppStringsAr.perMin : AppStringsEn.perMin}',
                  style: AppTextStyles.bodySmall(
                    isArabic: isArabic,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),

            // Selection indicator
            if (isSelected) ...[
              const SizedBox(width: 10),
              const Icon(
                Icons.check_circle_rounded,
                color: AppColors.primary,
                size: 24,
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Builds the bike icon based on type.
  Widget _buildBikeIcon() {
    IconData icon;
    Color bgColor;

    switch (bike.type) {
      case 'electric':
        icon = Icons.electric_bike_rounded;
        bgColor = AppColors.info.withValues(alpha: 0.1);
        break;
      case 'premium':
        icon = Icons.pedal_bike_rounded;
        bgColor = AppColors.warning.withValues(alpha: 0.1);
        break;
      default:
        icon = Icons.directions_bike_rounded;
        bgColor = AppColors.primary.withValues(alpha: 0.1);
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: AppColors.primary, size: 28),
    );
  }

  /// Builds the bike type badge.
  Widget _buildTypeBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        bike.displayType,
        style: AppTextStyles.captionMedium(
          isArabic: isArabic,
          color: AppColors.accent,
        ),
      ),
    );
  }

  /// Builds the battery level indicator for electric bikes.
  Widget _buildBatteryIndicator() {
    final percent = bike.batteryPercent;
    final color = percent > 50
        ? AppColors.success
        : percent > 20
        ? AppColors.warning
        : AppColors.error;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          percent > 80
              ? Icons.battery_full_rounded
              : percent > 50
              ? Icons.battery_5_bar_rounded
              : percent > 20
              ? Icons.battery_3_bar_rounded
              : Icons.battery_1_bar_rounded,
          color: color,
          size: 16,
        ),
        const SizedBox(width: 2),
        Text(
          '$percent%',
          style: AppTextStyles.captionMedium(isArabic: isArabic, color: color),
        ),
      ],
    );
  }
}

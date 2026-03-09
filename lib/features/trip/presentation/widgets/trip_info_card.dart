import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/localization/app_strings_ar.dart';
import '../../../../core/localization/app_strings_en.dart';
import '../../data/models/trip_model.dart';

/// Card widget that displays trip information (bike, station, distance, cost).
class TripInfoCard extends StatelessWidget {
  final Trip trip;
  final bool isArabic;
  final bool showCost;

  const TripInfoCard({
    super.key,
    required this.trip,
    required this.isArabic,
    this.showCost = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Bike info row
          _buildInfoRow(
            icon: Icons.directions_bike_rounded,
            label: isArabic ? AppStringsAr.bike : AppStringsEn.bike,
            value: trip.bikeName,
            color: AppColors.primary,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: AppColors.divider, height: 1),
          ),

          // Start station row
          _buildInfoRow(
            icon: Icons.location_on_rounded,
            label: isArabic
                ? AppStringsAr.startStation
                : AppStringsEn.startStation,
            value: trip.startStation,
            color: AppColors.success,
          ),

          if (trip.endStation != null) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(color: AppColors.divider, height: 1),
            ),
            _buildInfoRow(
              icon: Icons.flag_rounded,
              label: isArabic
                  ? AppStringsAr.endStation
                  : AppStringsEn.endStation,
              value: trip.endStation!,
              color: AppColors.error,
            ),
          ],

          if (trip.distanceKm > 0) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(color: AppColors.divider, height: 1),
            ),
            _buildInfoRow(
              icon: Icons.straighten_rounded,
              label: isArabic ? AppStringsAr.distance : AppStringsEn.distance,
              value: '${trip.distanceKm.toStringAsFixed(1)} km',
              color: AppColors.info,
            ),
          ],

          if (showCost && trip.cost > 0) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(color: AppColors.divider, height: 1),
            ),
            _buildInfoRow(
              icon: Icons.payments_rounded,
              label: isArabic ? AppStringsAr.cost : AppStringsEn.cost,
              value: '${trip.cost.toStringAsFixed(1)} ${AppStringsEn.currency}',
              color: AppColors.primary,
              isBold: true,
            ),
          ],
        ],
      ),
    );
  }

  /// Builds a single info row with icon, label, and value.
  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    bool isBold = false,
  }) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.caption(
                  isArabic: isArabic,
                  color: AppColors.textTertiary,
                ),
              ),
              Text(
                value,
                style: isBold
                    ? AppTextStyles.bodyBold(
                        isArabic: isArabic,
                        color: AppColors.text,
                      )
                    : AppTextStyles.label(
                        isArabic: isArabic,
                        color: AppColors.text,
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

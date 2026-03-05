import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/fonts.dart';
import '../../domain/booking_model.dart';

/// Widget that displays a summary of the booking before confirmation.
class BookingSummaryWidget extends StatelessWidget {
  final Bike bike;
  final String stationName;
  final int estimatedMinutes;
  final bool isArabic;

  const BookingSummaryWidget({
    super.key,
    required this.bike,
    required this.stationName,
    required this.estimatedMinutes,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    final estimatedCost = bike.pricePerMinute * estimatedMinutes;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Text(
            isArabic ? 'ملخص الحجز' : 'Booking Summary',
            style: AppFonts.title(isArabic: isArabic, color: AppColors.text),
          ),
          const SizedBox(height: 16),

          // Divider
          const Divider(color: AppColors.divider, height: 1),
          const SizedBox(height: 16),

          // Bike details row
          _buildRow(label: isArabic ? 'الدراجة' : 'Bike', value: bike.name),
          const SizedBox(height: 12),

          // Type row
          _buildRow(
            label: isArabic ? 'النوع' : 'Type',
            value: bike.displayType,
          ),
          const SizedBox(height: 12),

          // Station row
          _buildRow(label: isArabic ? 'المحطة' : 'Station', value: stationName),
          const SizedBox(height: 12),

          // Rate row
          _buildRow(
            label: isArabic ? 'السعر/دقيقة' : 'Rate/min',
            value: '${bike.pricePerMinute.toStringAsFixed(1)} EGP',
          ),
          const SizedBox(height: 12),

          // Duration row
          _buildRow(
            label: isArabic ? 'المدة المتوقعة' : 'Est. Duration',
            value: '$estimatedMinutes min',
          ),
          const SizedBox(height: 16),

          // Divider
          const Divider(color: AppColors.divider, height: 1),
          const SizedBox(height: 16),

          // Total cost row (highlighted)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isArabic ? 'التكلفة المتوقعة' : 'Estimated Cost',
                style: AppFonts.style(
                  isArabic: isArabic,
                  fontSize: AppFonts.sizeMedium,
                  fontWeight: AppFonts.bold,
                  color: AppColors.text,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${estimatedCost.toStringAsFixed(1)} EGP',
                  style: AppFonts.style(
                    isArabic: isArabic,
                    fontSize: AppFonts.sizeMedium,
                    fontWeight: AppFonts.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds a label-value row for the summary.
  Widget _buildRow({required String label, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppFonts.style(
            isArabic: isArabic,
            fontSize: AppFonts.sizeBody,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: AppFonts.style(
            isArabic: isArabic,
            fontSize: AppFonts.sizeBody,
            fontWeight: AppFonts.medium,
            color: AppColors.text,
          ),
        ),
      ],
    );
  }
}

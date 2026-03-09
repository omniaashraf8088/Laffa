import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/localization/app_strings_ar.dart';
import '../../../../core/localization/app_strings_en.dart';

/// Duration picker widget that lets the user select an estimated ride duration.
class DurationPickerWidget extends StatelessWidget {
  final int selectedMinutes;
  final bool isArabic;
  final ValueChanged<int> onChanged;

  const DurationPickerWidget({
    super.key,
    required this.selectedMinutes,
    required this.isArabic,
    required this.onChanged,
  });

  static const List<int> _presets = [15, 30, 45, 60, 90, 120];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isArabic
              ? AppStringsAr.estRideDuration
              : AppStringsEn.estRideDuration,
          style: AppTextStyles.label(isArabic: isArabic, color: AppColors.text),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _presets.map((minutes) {
            final isSelected = minutes == selectedMinutes;
            return GestureDetector(
              onTap: () => onChanged(minutes),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                  ),
                ),
                child: Text(
                  _formatMinutes(minutes),
                  style: AppTextStyles.smallLabel(
                    isArabic: isArabic,
                    color: isSelected ? AppColors.white : AppColors.text,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// Formats minutes into a human-readable string.
  String _formatMinutes(int minutes) {
    if (minutes >= 60) {
      final hours = minutes ~/ 60;
      final mins = minutes % 60;
      if (mins == 0) return '${hours}h';
      return '${hours}h ${mins}m';
    }
    return '${minutes}m';
  }
}

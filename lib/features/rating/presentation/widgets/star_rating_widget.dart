import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/localization/app_strings_ar.dart';
import '../../../../core/localization/app_strings_en.dart';

/// Interactive star rating widget.
/// Users tap or drag to select 1-5 stars.
class StarRatingWidget extends StatelessWidget {
  final int rating;
  final bool isArabic;
  final ValueChanged<int> onRatingChanged;
  final double size;

  const StarRatingWidget({
    super.key,
    required this.rating,
    required this.isArabic,
    required this.onRatingChanged,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            final starIndex = index + 1;
            final isFilled = starIndex <= rating;

            return GestureDetector(
              onTap: () => onRatingChanged(starIndex),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: AnimatedScale(
                  scale: isFilled ? 1.15 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    isFilled ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: isFilled
                        ? AppColors.ratingStar
                        : AppColors.ratingStarEmpty,
                    size: size,
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 12),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Text(
            _getRatingLabel(rating, isArabic),
            key: ValueKey(rating),
            style: AppTextStyles.button(
              isArabic: isArabic,
              color: rating > 0 ? AppColors.primary : AppColors.textTertiary,
            ),
          ),
        ),
      ],
    );
  }

  /// Returns a label describing the selected rating.
  String _getRatingLabel(int stars, bool isArabic) {
    if (isArabic) {
      switch (stars) {
        case 1:
          return AppStringsAr.ratingPoor;
        case 2:
          return AppStringsAr.ratingFair;
        case 3:
          return AppStringsAr.ratingGood;
        case 4:
          return AppStringsAr.ratingGreat;
        case 5:
          return AppStringsAr.ratingExcellent;
        default:
          return AppStringsAr.tapToRate;
      }
    }

    switch (stars) {
      case 1:
        return AppStringsEn.ratingPoor;
      case 2:
        return AppStringsEn.ratingFair;
      case 3:
        return AppStringsEn.ratingGood;
      case 4:
        return AppStringsEn.ratingGreat;
      case 5:
        return AppStringsEn.ratingExcellent;
      default:
        return AppStringsEn.tapToRate;
    }
  }
}

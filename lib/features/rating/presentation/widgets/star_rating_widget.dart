import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/fonts.dart';

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
            style: AppFonts.style(
              isArabic: isArabic,
              fontSize: AppFonts.sizeMedium,
              fontWeight: AppFonts.semiBold,
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
          return 'سيئة';
        case 2:
          return 'مقبولة';
        case 3:
          return 'جيدة';
        case 4:
          return 'ممتازة';
        case 5:
          return 'رائعة!';
        default:
          return 'اضغط لتقييم';
      }
    }

    switch (stars) {
      case 1:
        return 'Poor';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Great';
      case 5:
        return 'Excellent!';
      default:
        return 'Tap to rate';
    }
  }
}

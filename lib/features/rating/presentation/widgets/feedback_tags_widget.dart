import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/app_text_styles.dart';

/// Widget that displays selectable feedback tags as chips.
class FeedbackTagsWidget extends StatelessWidget {
  final List<String> tags;
  final List<String> selectedTags;
  final bool isArabic;
  final ValueChanged<String> onTagToggled;

  const FeedbackTagsWidget({
    super.key,
    required this.tags,
    required this.selectedTags,
    required this.isArabic,
    required this.onTagToggled,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tags.map((tag) {
        final isSelected = selectedTags.contains(tag);

        return GestureDetector(
          onTap: () => onTagToggled(tag),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.1)
                  : AppColors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.border,
              ),
            ),
            child: Text(
              tag,
              style: isSelected
                  ? AppTextStyles.smallLabel(
                      isArabic: isArabic,
                      color: AppColors.primary,
                    )
                  : AppTextStyles.bodySmall(
                      isArabic: isArabic,
                      color: AppColors.textSecondary,
                    ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

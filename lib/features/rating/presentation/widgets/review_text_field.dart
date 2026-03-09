import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/localization/app_strings_ar.dart';
import '../../../../core/localization/app_strings_en.dart';

/// Text field widget for writing a review comment.
class ReviewTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool isArabic;
  final ValueChanged<String>? onChanged;

  const ReviewTextField({
    super.key,
    required this.controller,
    required this.isArabic,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isArabic ? AppStringsAr.addComment : AppStringsEn.addComment,
          style: AppTextStyles.bodyMedium(
            isArabic: isArabic,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: 4,
          maxLength: 500,
          onChanged: onChanged,
          style: AppTextStyles.body(isArabic: isArabic, color: AppColors.text),
          decoration: InputDecoration(
            hintText: isArabic
                ? 'أخبرنا عن تجربتك...'
                : 'Tell us about your experience...',
            hintStyle: AppTextStyles.body(
              isArabic: isArabic,
              color: AppColors.textTertiary,
            ),
            filled: true,
            fillColor: AppColors.white,
            contentPadding: const EdgeInsets.all(16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppColors.primary, width: 1.5),
            ),
            counterStyle: AppTextStyles.caption(
              isArabic: isArabic,
              color: AppColors.textTertiary,
            ),
          ),
        ),
      ],
    );
  }
}

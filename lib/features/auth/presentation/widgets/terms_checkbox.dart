import 'package:flutter/material.dart';

import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/localization/app_strings_ar.dart';
import '../../../../core/localization/app_strings_en.dart';
import '../../../../core/theme/app_theme.dart';

class TermsCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool isArabic;

  const TermsCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: (v) => onChanged(v ?? false),
          fillColor: WidgetStateProperty.all(AppColors.primary),
        ),
        Expanded(
          child: Text(
            isArabic ? AppStringsAr.agreeTerms : AppStringsEn.agreeTerms,
            style: AppTextStyles.authSmallLabel(
              isArabic: isArabic,
              color: AppColors.greyDark,
            ),
          ),
        ),
      ],
    );
  }
}

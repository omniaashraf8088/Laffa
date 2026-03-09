import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/localization/app_strings_ar.dart';
import '../../../../core/localization/app_strings_en.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';

class SavePasswordRow extends StatelessWidget {
  final bool rememberPassword;
  final ValueChanged<bool> onChanged;
  final bool isArabic;

  const SavePasswordRow({
    super.key,
    required this.rememberPassword,
    required this.onChanged,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () => onChanged(!rememberPassword),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppDimensions.paddingSmall,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                    value: rememberPassword,
                    onChanged: (value) => onChanged(value ?? false),
                    activeColor: AppColors.primary,
                  ),
                  Expanded(
                    child: Text(
                      isArabic
                          ? AppStringsAr.savePassword
                          : AppStringsEn.savePassword,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.label(
                        isArabic: isArabic,
                        color: AppColors.text,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton(
              onPressed: () => context.push(AppRouter.forgotPassword),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                isArabic
                    ? AppStringsAr.forgotPassword
                    : AppStringsEn.forgotPassword,
                style: AppTextStyles.label(
                  isArabic: isArabic,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

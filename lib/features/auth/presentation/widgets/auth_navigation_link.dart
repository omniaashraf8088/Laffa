import 'package:flutter/material.dart';

import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';

class AuthNavigationLink extends StatelessWidget {
  final String promptText;
  final String actionText;
  final VoidCallback onPressed;
  final bool isArabic;

  const AuthNavigationLink({
    super.key,
    required this.promptText,
    required this.actionText,
    required this.onPressed,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          promptText,
          style: AppTextStyles.body(isArabic: isArabic, color: AppColors.grey),
        ),
        TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            actionText,
            style: AppTextStyles.bodyBold(
              isArabic: isArabic,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}

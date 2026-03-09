import 'package:flutter/material.dart';

import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';

class AuthTitle extends StatelessWidget {
  final String text;
  final bool isArabic;
  final bool isSmallScreen;

  const AuthTitle({
    super.key,
    required this.text,
    required this.isArabic,
    required this.isSmallScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.authTitle(
        isArabic: isArabic,
        color: AppColors.primary,
        large: !isSmallScreen,
      ),
      textAlign: TextAlign.center,
    );
  }
}

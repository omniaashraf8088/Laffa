import 'package:flutter/material.dart';

import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';

class AuthSubtitle extends StatelessWidget {
  final String text;
  final bool isArabic;
  final bool isSmallScreen;

  const AuthSubtitle({
    super.key,
    required this.text,
    required this.isArabic,
    required this.isSmallScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.authBody(
        isArabic: isArabic,
        color: AppColors.grey,
        large: !isSmallScreen,
      ),
      textAlign: TextAlign.center,
    );
  }
}

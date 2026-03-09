import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../controllers/auth_provider.dart';

class AuthErrorMessage extends StatelessWidget {
  final AuthState authState;
  final bool isArabic;

  const AuthErrorMessage({
    super.key,
    required this.authState,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    if (authState.errorMessage == null || authState.errorMessage!.isEmpty) {
      return const SizedBox.shrink();
    }

    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppDimensions.paddingLarge),
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.1),
          border: Border.all(color: AppColors.error, width: 1),
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 20),
            const SizedBox(width: AppDimensions.paddingMedium),
            Expanded(
              child: Text(
                authState.errorMessage ?? '',
                style: AppTextStyles.bodyMedium(
                  isArabic: isArabic,
                  color: AppColors.error,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

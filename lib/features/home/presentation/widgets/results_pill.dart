import 'package:flutter/material.dart';

import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';

class ResultsPill extends StatelessWidget {
  final String label;
  final bool isArabic;

  const ResultsPill({super.key, required this.label, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: AppTextStyles.smallLabel(
          isArabic: isArabic,
          color: AppColors.text,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class OptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isArabic;
  final bool isSelected;
  final VoidCallback onTap;

  const OptionTile({
    super.key,
    required this.icon,
    required this.label,
    required this.isArabic,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.12)
                    : AppColors.greyLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isSelected ? AppColors.primary : AppColors.textTertiary,
                size: 18,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.subtitle(
                  isArabic: isArabic,
                  color: isSelected ? AppColors.primary : AppColors.text,
                ),
              ),
            ),
            if (isSelected)
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: AppColors.white,
                  size: 14,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

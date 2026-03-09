import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/localization/app_strings_ar.dart';
import '../../../../core/localization/app_strings_en.dart';
import '../../../auth/presentation/controllers/auth_provider.dart';

class ProfileHeader extends StatelessWidget {
  final AuthUser? user;
  final bool isArabic;

  const ProfileHeader({super.key, required this.user, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
      child: Column(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: AppColors.secondary,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.person_rounded,
              color: AppColors.white,
              size: 48,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            user?.name ??
                (isArabic
                    ? AppStringsAr.defaultUser
                    : AppStringsEn.defaultUser),
            style: AppTextStyles.heading(
              isArabic: isArabic,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            user?.email ?? '',
            style: AppTextStyles.body(
              isArabic: isArabic,
              color: AppColors.secondaryLight,
            ),
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.edit_rounded, size: 16),
            label: Text(
              isArabic ? AppStringsAr.editProfile : AppStringsEn.editProfile,
              style: AppTextStyles.label(
                isArabic: isArabic,
                color: AppColors.white,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.white,
              side: const BorderSide(color: AppColors.secondary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }
}

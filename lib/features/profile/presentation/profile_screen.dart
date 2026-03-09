import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/localization/app_strings_ar.dart';
import '../../../core/localization/app_strings_en.dart';
import '../../../core/localization/localization_provider.dart';
import '../../auth/presentation/controllers/auth_provider.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_stats_row.dart';
import 'widgets/profile_services_grid.dart';
import 'widgets/profile_menu_section.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = ref.watch(localizationProvider);
    final isArabic = localization.language == AppLanguage.ar;
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          isArabic ? AppStringsAr.profile : AppStringsEn.profile,
          style: AppTextStyles.title(
            isArabic: isArabic,
            color: AppColors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileHeader(user: user, isArabic: isArabic),
            const SizedBox(height: 20),
            ProfileStatsRow(isArabic: isArabic),
            const SizedBox(height: 20),
            ProfileServicesGrid(isArabic: isArabic),
            const SizedBox(height: 20),
            ProfileMenuSection(isArabic: isArabic),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

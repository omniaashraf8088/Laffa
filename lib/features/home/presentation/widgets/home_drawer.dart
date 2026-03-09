import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/localization/app_strings_ar.dart';
import '../../../../core/localization/app_strings_en.dart';
import '../../../../core/localization/localization_provider.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';

class HomeDrawer extends ConsumerWidget {
  final bool isArabic;

  const HomeDrawer({super.key, required this.isArabic});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      backgroundColor: AppColors.background,
      child: SafeArea(
        child: Column(
          children: [
            _DrawerHeader(isArabic: isArabic),
            const SizedBox(height: 8),
            _DrawerMenuItem(
              icon: Icons.home_rounded,
              label: isArabic ? AppStringsAr.home : AppStringsEn.home,
              isArabic: isArabic,
              onTap: () => Navigator.of(context).pop(),
            ),
            _DrawerMenuItem(
              icon: Icons.person_rounded,
              label: isArabic ? AppStringsAr.profile : AppStringsEn.profile,
              isArabic: isArabic,
              onTap: () {
                Navigator.of(context).pop();
                context.push(AppRouter.profile);
              },
            ),
            _DrawerMenuItem(
              icon: Icons.history_rounded,
              label: isArabic
                  ? AppStringsAr.tripHistory
                  : AppStringsEn.tripHistory,
              isArabic: isArabic,
              onTap: () {
                Navigator.of(context).pop();
                context.push(AppRouter.trips);
              },
            ),
            _DrawerMenuItem(
              icon: Icons.local_offer_rounded,
              label: isArabic ? AppStringsAr.coupons : AppStringsEn.coupons,
              isArabic: isArabic,
              onTap: () {
                Navigator.of(context).pop();
                context.push(AppRouter.coupons);
              },
            ),
            _DrawerMenuItem(
              icon: Icons.chat_rounded,
              label: isArabic ? AppStringsAr.support : AppStringsEn.support,
              isArabic: isArabic,
              onTap: () {
                Navigator.of(context).pop();
                context.push(AppRouter.chat);
              },
            ),
            _DrawerMenuItem(
              icon: Icons.settings_rounded,
              label: isArabic ? AppStringsAr.settings : AppStringsEn.settings,
              isArabic: isArabic,
              onTap: () {
                Navigator.of(context).pop();
                context.push(AppRouter.settings);
              },
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _DrawerMenuItem(
                icon: Icons.language_rounded,
                label: isArabic
                    ? AppStringsEn.switchLang
                    : AppStringsAr.switchLang,
                isArabic: isArabic,
                onTap: () {
                  ref
                      .read(localizationProvider.notifier)
                      .setLanguage(isArabic ? AppLanguage.en : AppLanguage.ar);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _DrawerMenuItem(
                icon: Icons.dark_mode_rounded,
                label: isArabic
                    ? AppStringsAr.toggleTheme
                    : AppStringsEn.toggleTheme,
                isArabic: isArabic,
                onTap: () {
                  ref.read(localizationProvider.notifier).toggleTheme();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  final bool isArabic;

  const _DrawerHeader({required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(color: AppColors.primary),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.secondary,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Icon(
              Icons.person_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            isArabic ? AppStringsAr.welcome : AppStringsEn.welcome,
            style: AppTextStyles.subheadingBold(
              isArabic: isArabic,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            AppStringsEn.appName,
            style: AppTextStyles.smallMedium(
              isArabic: isArabic,
              color: AppColors.secondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isArabic;
  final VoidCallback onTap;

  const _DrawerMenuItem({
    required this.icon,
    required this.label,
    required this.isArabic,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary, size: 22),
      title: Text(
        label,
        style: AppTextStyles.bodyMedium(
          isArabic: isArabic,
          color: AppColors.text,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }
}

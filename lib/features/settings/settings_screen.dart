import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/colors.dart';
import '../../core/constants/fonts.dart';
import '../../core/localization/app_strings_ar.dart';
import '../../core/localization/app_strings_en.dart';
import '../../core/localization/localization_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = ref.watch(localizationProvider);
    final isArabic = localization.language == AppLanguage.ar;

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
          isArabic ? AppStringsAr.settings : AppStringsEn.settings,
          style: AppFonts.title(isArabic: isArabic, color: AppColors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(
              isArabic ? AppStringsAr.language : AppStringsEn.language,
              isArabic,
            ),
            const SizedBox(height: 10),
            _buildLanguageSelector(ref, localization, isArabic),
            const SizedBox(height: 24),
            _buildSectionTitle(
              isArabic ? AppStringsAr.theme : AppStringsEn.theme,
              isArabic,
            ),
            const SizedBox(height: 10),
            _buildThemeSelector(ref, localization, isArabic),
            const SizedBox(height: 24),
            _buildSectionTitle(isArabic ? 'عام' : 'General', isArabic),
            const SizedBox(height: 10),
            _buildSettingsCard(
              children: [
                _buildSettingsTile(
                  icon: Icons.notifications_rounded,
                  label: isArabic
                      ? AppStringsAr.notifications
                      : AppStringsEn.notifications,
                  isArabic: isArabic,
                  trailing: Switch(
                    value: true,
                    onChanged: (_) {},
                    activeThumbColor: AppColors.primary,
                  ),
                ),
                _buildDivider(),
                _buildSettingsTile(
                  icon: Icons.help_outline_rounded,
                  label: isArabic
                      ? AppStringsAr.helpSupport
                      : AppStringsEn.helpSupport,
                  isArabic: isArabic,
                  onTap: () => context.push('/chat'),
                ),
                _buildDivider(),
                _buildSettingsTile(
                  icon: Icons.info_outline_rounded,
                  label: isArabic ? AppStringsAr.aboutUs : AppStringsEn.aboutUs,
                  isArabic: isArabic,
                  onTap: () {},
                ),
                _buildDivider(),
                _buildSettingsTile(
                  icon: Icons.description_rounded,
                  label: isArabic
                      ? AppStringsAr.termsConditions
                      : AppStringsEn.termsConditions,
                  isArabic: isArabic,
                  onTap: () {},
                ),
                _buildDivider(),
                _buildSettingsTile(
                  icon: Icons.privacy_tip_rounded,
                  label: isArabic
                      ? AppStringsAr.privacyPolicy
                      : AppStringsEn.privacyPolicy,
                  isArabic: isArabic,
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 24),
            Center(
              child: Text(
                'Laffa v1.0.0',
                style: AppFonts.caption(
                  isArabic: isArabic,
                  color: AppColors.textTertiary,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isArabic) {
    return Text(
      title,
      style: AppFonts.style(
        isArabic: isArabic,
        fontSize: AppFonts.sizeSmall,
        fontWeight: AppFonts.semiBold,
        color: AppColors.textSecondary,
      ),
    );
  }

  Widget _buildLanguageSelector(
    WidgetRef ref,
    LocalizationState localization,
    bool isArabic,
  ) {
    return _buildSettingsCard(
      children: [
        _buildOptionTile(
          icon: Icons.language_rounded,
          label: 'English',
          isArabic: isArabic,
          isSelected: localization.language == AppLanguage.en,
          onTap: () {
            ref.read(localizationProvider.notifier).setLanguage(AppLanguage.en);
          },
        ),
        _buildDivider(),
        _buildOptionTile(
          icon: Icons.language_rounded,
          label: 'العربية',
          isArabic: isArabic,
          isSelected: localization.language == AppLanguage.ar,
          onTap: () {
            ref.read(localizationProvider.notifier).setLanguage(AppLanguage.ar);
          },
        ),
      ],
    );
  }

  Widget _buildThemeSelector(
    WidgetRef ref,
    LocalizationState localization,
    bool isArabic,
  ) {
    return _buildSettingsCard(
      children: [
        _buildOptionTile(
          icon: Icons.light_mode_rounded,
          label: isArabic ? 'فاتح' : 'Light',
          isArabic: isArabic,
          isSelected: localization.themeMode == AppThemeMode.light,
          onTap: () {
            ref
                .read(localizationProvider.notifier)
                .setThemeMode(AppThemeMode.light);
          },
        ),
        _buildDivider(),
        _buildOptionTile(
          icon: Icons.dark_mode_rounded,
          label: isArabic ? 'داكن' : 'Dark',
          isArabic: isArabic,
          isSelected: localization.themeMode == AppThemeMode.dark,
          onTap: () {
            ref
                .read(localizationProvider.notifier)
                .setThemeMode(AppThemeMode.dark);
          },
        ),
        _buildDivider(),
        _buildOptionTile(
          icon: Icons.settings_brightness_rounded,
          label: isArabic ? 'نظام' : 'System',
          isArabic: isArabic,
          isSelected: localization.themeMode == AppThemeMode.system,
          onTap: () {
            ref
                .read(localizationProvider.notifier)
                .setThemeMode(AppThemeMode.system);
          },
        ),
      ],
    );
  }

  Widget _buildSettingsCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String label,
    required bool isArabic,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
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
                style: AppFonts.subtitle(
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

  Widget _buildSettingsTile({
    required IconData icon,
    required String label,
    required bool isArabic,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
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
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.primary, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: AppFonts.subtitle(
                  isArabic: isArabic,
                  color: AppColors.text,
                ),
              ),
            ),
            if (trailing != null)
              trailing
            else
              Icon(
                isArabic
                    ? Icons.chevron_left_rounded
                    : Icons.chevron_right_rounded,
                color: AppColors.textTertiary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      indent: 66,
      endIndent: 16,
      color: AppColors.borderLight,
    );
  }
}

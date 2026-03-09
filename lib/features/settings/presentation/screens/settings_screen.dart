import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/localization/app_strings_ar.dart';
import '../../../../core/localization/app_strings_en.dart';
import '../../../../core/localization/localization_provider.dart';
import '../../../../core/router/app_router.dart';
import '../widgets/settings_card.dart';
import '../widgets/option_tile.dart';
import '../widgets/settings_tile.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const _settingsDivider = Divider(
    height: 1,
    indent: 66,
    endIndent: 16,
    color: AppColors.borderLight,
  );

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
          style: AppTextStyles.title(
            isArabic: isArabic,
            color: AppColors.white,
          ),
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
            SettingsCard(
              children: [
                OptionTile(
                  icon: Icons.language_rounded,
                  label: AppStringsEn.langEnglish,
                  isArabic: isArabic,
                  isSelected: localization.language == AppLanguage.en,
                  onTap: () {
                    ref
                        .read(localizationProvider.notifier)
                        .setLanguage(AppLanguage.en);
                  },
                ),
                _settingsDivider,
                OptionTile(
                  icon: Icons.language_rounded,
                  label: AppStringsEn.langArabic,
                  isArabic: isArabic,
                  isSelected: localization.language == AppLanguage.ar,
                  onTap: () {
                    ref
                        .read(localizationProvider.notifier)
                        .setLanguage(AppLanguage.ar);
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSectionTitle(
              isArabic ? AppStringsAr.theme : AppStringsEn.theme,
              isArabic,
            ),
            const SizedBox(height: 10),
            SettingsCard(
              children: [
                OptionTile(
                  icon: Icons.light_mode_rounded,
                  label: isArabic ? AppStringsAr.light : AppStringsEn.light,
                  isArabic: isArabic,
                  isSelected: localization.themeMode == AppThemeMode.light,
                  onTap: () {
                    ref
                        .read(localizationProvider.notifier)
                        .setThemeMode(AppThemeMode.light);
                  },
                ),
                _settingsDivider,
                OptionTile(
                  icon: Icons.dark_mode_rounded,
                  label: isArabic ? AppStringsAr.dark : AppStringsEn.dark,
                  isArabic: isArabic,
                  isSelected: localization.themeMode == AppThemeMode.dark,
                  onTap: () {
                    ref
                        .read(localizationProvider.notifier)
                        .setThemeMode(AppThemeMode.dark);
                  },
                ),
                _settingsDivider,
                OptionTile(
                  icon: Icons.settings_brightness_rounded,
                  label: isArabic ? AppStringsAr.system : AppStringsEn.system,
                  isArabic: isArabic,
                  isSelected: localization.themeMode == AppThemeMode.system,
                  onTap: () {
                    ref
                        .read(localizationProvider.notifier)
                        .setThemeMode(AppThemeMode.system);
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSectionTitle(
              isArabic ? AppStringsAr.general : AppStringsEn.general,
              isArabic,
            ),
            const SizedBox(height: 10),
            SettingsCard(
              children: [
                SettingsTile(
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
                _settingsDivider,
                SettingsTile(
                  icon: Icons.help_outline_rounded,
                  label: isArabic
                      ? AppStringsAr.helpSupport
                      : AppStringsEn.helpSupport,
                  isArabic: isArabic,
                  onTap: () => context.push(AppRouter.chat),
                ),
                _settingsDivider,
                SettingsTile(
                  icon: Icons.info_outline_rounded,
                  label: isArabic ? AppStringsAr.aboutUs : AppStringsEn.aboutUs,
                  isArabic: isArabic,
                  onTap: () {},
                ),
                _settingsDivider,
                SettingsTile(
                  icon: Icons.description_rounded,
                  label: isArabic
                      ? AppStringsAr.termsConditions
                      : AppStringsEn.termsConditions,
                  isArabic: isArabic,
                  onTap: () {},
                ),
                _settingsDivider,
                SettingsTile(
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
                style: AppTextStyles.caption(
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
      style: AppTextStyles.smallLabel(
        isArabic: isArabic,
        color: AppColors.textSecondary,
      ),
    );
  }
}

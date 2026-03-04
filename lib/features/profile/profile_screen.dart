import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/colors.dart';
import '../../core/constants/fonts.dart';
import '../../core/localization/app_strings_ar.dart';
import '../../core/localization/app_strings_en.dart';
import '../../core/localization/localization_provider.dart';
import '../auth/auth_provider.dart';

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
          style: AppFonts.title(isArabic: isArabic, color: AppColors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(context, user, isArabic),
            const SizedBox(height: 20),
            _buildStatsRow(isArabic),
            const SizedBox(height: 20),
            _buildMenuSection(context, ref, isArabic),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(
    BuildContext context,
    AuthUser? user,
    bool isArabic,
  ) {
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
            user?.name ?? (isArabic ? 'مستخدم Laffa' : 'Laffa User'),
            style: AppFonts.heading(isArabic: isArabic, color: AppColors.white),
          ),
          const SizedBox(height: 4),
          Text(
            user?.email ?? 'user@laffa.com',
            style: AppFonts.bodyMedium(
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
              style: AppFonts.label(isArabic: isArabic, color: AppColors.white),
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

  Widget _buildStatsRow(bool isArabic) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              icon: Icons.electric_scooter_rounded,
              value: '24',
              label: isArabic ? 'رحلة' : 'Rides',
              color: AppColors.primary,
              isArabic: isArabic,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              icon: Icons.straighten_rounded,
              value: '87.5',
              label: isArabic ? 'كم' : 'km',
              color: AppColors.success,
              isArabic: isArabic,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              icon: Icons.timer_rounded,
              value: '12.3',
              label: isArabic ? 'ساعة' : 'hrs',
              color: AppColors.info,
              isArabic: isArabic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
    required bool isArabic,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
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
      child: Column(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppFonts.style(
              isArabic: isArabic,
              fontSize: AppFonts.sizeMedium,
              fontWeight: AppFonts.bold,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppFonts.caption(
              isArabic: isArabic,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context, WidgetRef ref, bool isArabic) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
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
        child: Column(
          children: [
            _buildMenuItem(
              icon: Icons.history_rounded,
              label: isArabic ? AppStringsAr.myTrips : AppStringsEn.myTrips,
              isArabic: isArabic,
              onTap: () => context.push('/trips'),
            ),
            _buildDivider(),
            _buildMenuItem(
              icon: Icons.account_balance_wallet_rounded,
              label: isArabic
                  ? AppStringsAr.walletBalance
                  : AppStringsEn.walletBalance,
              trailing: Text(
                '125.00 EGP',
                style: AppFonts.label(
                  isArabic: isArabic,
                  color: AppColors.primary,
                ),
              ),
              isArabic: isArabic,
              onTap: () {},
            ),
            _buildDivider(),
            _buildMenuItem(
              icon: Icons.payment_rounded,
              label: isArabic
                  ? AppStringsAr.paymentMethods
                  : AppStringsEn.paymentMethods,
              isArabic: isArabic,
              onTap: () {},
            ),
            _buildDivider(),
            _buildMenuItem(
              icon: Icons.card_giftcard_rounded,
              label: isArabic
                  ? AppStringsAr.referralCode
                  : AppStringsEn.referralCode,
              isArabic: isArabic,
              onTap: () {},
            ),
            _buildDivider(),
            _buildMenuItem(
              icon: Icons.share_rounded,
              label: isArabic
                  ? AppStringsAr.inviteFriends
                  : AppStringsEn.inviteFriends,
              isArabic: isArabic,
              onTap: () {},
            ),
            _buildDivider(),
            _buildMenuItem(
              icon: Icons.settings_rounded,
              label: isArabic ? AppStringsAr.settings : AppStringsEn.settings,
              isArabic: isArabic,
              onTap: () => context.push('/settings'),
            ),
            _buildDivider(),
            _buildMenuItem(
              icon: Icons.logout_rounded,
              label: isArabic ? AppStringsAr.logout : AppStringsEn.logout,
              isArabic: isArabic,
              iconColor: AppColors.error,
              textColor: AppColors.error,
              showArrow: false,
              onTap: () {
                ref.read(authProvider.notifier).logout();
                context.go('/login');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required bool isArabic,
    required VoidCallback onTap,
    Widget? trailing,
    Color iconColor = AppColors.primary,
    Color textColor = AppColors.text,
    bool showArrow = true,
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
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: AppFonts.subtitle(isArabic: isArabic, color: textColor),
              ),
            ),
            ?trailing,
            if (showArrow)
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

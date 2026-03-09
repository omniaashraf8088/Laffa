import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/localization/app_strings_ar.dart';
import '../../../../core/localization/app_strings_en.dart';
import '../../../../core/router/app_router.dart';
import '../../../auth/presentation/controllers/auth_provider.dart';

class ProfileMenuSection extends ConsumerWidget {
  final bool isArabic;
  final String walletBalance;

  const ProfileMenuSection({
    super.key,
    required this.isArabic,
    // ignore: prefer_interpolation_to_compose_strings
    this.walletBalance = '0.00 ' + AppStringsEn.currency,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            _MenuItem(
              icon: Icons.history_rounded,
              label: isArabic ? AppStringsAr.myTrips : AppStringsEn.myTrips,
              isArabic: isArabic,
              onTap: () => context.push(AppRouter.trips),
            ),
            const _MenuDivider(),
            _MenuItem(
              icon: Icons.account_balance_wallet_rounded,
              label: isArabic
                  ? AppStringsAr.walletBalance
                  : AppStringsEn.walletBalance,
              trailing: Text(
                walletBalance,
                style: AppTextStyles.label(
                  isArabic: isArabic,
                  color: AppColors.primary,
                ),
              ),
              isArabic: isArabic,
              onTap: () => context.push(AppRouter.wallet),
            ),
            const _MenuDivider(),
            _MenuItem(
              icon: Icons.payment_rounded,
              label: isArabic
                  ? AppStringsAr.paymentMethods
                  : AppStringsEn.paymentMethods,
              isArabic: isArabic,
              onTap: () => context.push(AppRouter.paymentMethods),
            ),
            const _MenuDivider(),
            _MenuItem(
              icon: Icons.card_giftcard_rounded,
              label: isArabic
                  ? AppStringsAr.referralCode
                  : AppStringsEn.referralCode,
              isArabic: isArabic,
              onTap: () => context.push(AppRouter.referral),
            ),
            const _MenuDivider(),
            _MenuItem(
              icon: Icons.share_rounded,
              label: isArabic
                  ? AppStringsAr.inviteFriends
                  : AppStringsEn.inviteFriends,
              isArabic: isArabic,
              onTap: () => context.push(AppRouter.referral),
            ),
            const _MenuDivider(),
            _MenuItem(
              icon: Icons.settings_rounded,
              label: isArabic ? AppStringsAr.settings : AppStringsEn.settings,
              isArabic: isArabic,
              onTap: () => context.push(AppRouter.settings),
            ),
            const _MenuDivider(),
            _MenuItem(
              icon: Icons.logout_rounded,
              label: isArabic ? AppStringsAr.logout : AppStringsEn.logout,
              isArabic: isArabic,
              iconColor: AppColors.error,
              textColor: AppColors.error,
              showArrow: false,
              onTap: () {
                ref.read(authProvider.notifier).logout();
                context.go(AppRouter.login);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isArabic;
  final VoidCallback onTap;
  final Widget? trailing;
  final Color iconColor;
  final Color textColor;
  final bool showArrow;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.isArabic,
    required this.onTap,
    this.trailing,
    this.iconColor = AppColors.primary,
    this.textColor = AppColors.text,
    this.showArrow = true,
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
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.subtitle(
                  isArabic: isArabic,
                  color: textColor,
                ),
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
}

class _MenuDivider extends StatelessWidget {
  const _MenuDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      indent: 66,
      endIndent: 16,
      color: AppColors.borderLight,
    );
  }
}

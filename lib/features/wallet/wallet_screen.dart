import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/colors.dart';
import '../../core/constants/fonts.dart';
import '../../core/localization/app_strings_ar.dart';
import '../../core/localization/app_strings_en.dart';
import '../../core/localization/localization_provider.dart';

class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

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
          isArabic ? AppStringsAr.wallet : AppStringsEn.wallet,
          style: AppFonts.title(isArabic: isArabic, color: AppColors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Balance card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isArabic
                        ? AppStringsAr.currentBalance
                        : AppStringsEn.currentBalance,
                    style: AppFonts.bodyMedium(
                      isArabic: isArabic,
                      color: AppColors.secondaryLight,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '125.00 EGP',
                    style: AppFonts.style(
                      isArabic: isArabic,
                      fontSize: AppFonts.sizeDisplay,
                      fontWeight: AppFonts.bold,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: () => _showTopUpSheet(context, isArabic),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.white,
                        foregroundColor: AppColors.primary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        isArabic ? AppStringsAr.topUp : AppStringsEn.topUp,
                        style: AppFonts.label(
                          isArabic: isArabic,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Transactions header
            Align(
              alignment: isArabic
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Text(
                isArabic
                    ? AppStringsAr.recentTransactions
                    : AppStringsEn.recentTransactions,
                style: AppFonts.style(
                  isArabic: isArabic,
                  fontSize: AppFonts.sizeMedium,
                  fontWeight: AppFonts.bold,
                  color: AppColors.text,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Transaction list
            _buildTransaction(
              icon: Icons.electric_scooter_rounded,
              title: isArabic ? 'رحلة - City Glide' : 'Ride - City Glide',
              subtitle: '2026-03-05',
              amount: '-62.5 EGP',
              isDebit: true,
              isArabic: isArabic,
            ),
            _buildTransaction(
              icon: Icons.account_balance_wallet_rounded,
              title: isArabic ? 'شحن رصيد' : 'Top Up',
              subtitle: '2026-03-04',
              amount: '+200.0 EGP',
              isDebit: false,
              isArabic: isArabic,
            ),
            _buildTransaction(
              icon: Icons.electric_scooter_rounded,
              title: isArabic ? 'رحلة - Metro Flash' : 'Ride - Metro Flash',
              subtitle: '2026-03-04',
              amount: '-54.0 EGP',
              isDebit: true,
              isArabic: isArabic,
            ),
            _buildTransaction(
              icon: Icons.card_giftcard_rounded,
              title: isArabic ? 'كوبون خصم' : 'Coupon Discount',
              subtitle: '2026-03-02',
              amount: '+15.0 EGP',
              isDebit: false,
              isArabic: isArabic,
            ),
            _buildTransaction(
              icon: Icons.electric_scooter_rounded,
              title: isArabic ? 'رحلة - Pharaoh Ride' : 'Ride - Pharaoh Ride',
              subtitle: '2026-03-01',
              amount: '-100.0 EGP',
              isDebit: true,
              isArabic: isArabic,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransaction({
    required IconData icon,
    required String title,
    required String subtitle,
    required String amount,
    required bool isDebit,
    required bool isArabic,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: (isDebit ? AppColors.error : AppColors.success).withValues(
                alpha: 0.1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isDebit ? AppColors.error : AppColors.success,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppFonts.style(
                    isArabic: isArabic,
                    fontSize: AppFonts.sizeBody,
                    fontWeight: AppFonts.semiBold,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppFonts.caption(
                    isArabic: isArabic,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: AppFonts.style(
              isArabic: isArabic,
              fontSize: AppFonts.sizeBody,
              fontWeight: AppFonts.bold,
              color: isDebit ? AppColors.error : AppColors.success,
            ),
          ),
        ],
      ),
    );
  }

  void _showTopUpSheet(BuildContext context, bool isArabic) {
    final amounts = [50, 100, 200, 500];
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.greyMedium,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isArabic
                  ? AppStringsAr.chooseTopUpAmount
                  : AppStringsEn.chooseTopUpAmount,
              style: AppFonts.title(isArabic: isArabic, color: AppColors.text),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: amounts.map((amt) {
                return SizedBox(
                  width: (MediaQuery.of(ctx).size.width - 72) / 2,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isArabic
                                ? '$amt ${AppStringsAr.topUpSuccess}'
                                : '$amt ${AppStringsEn.topUpSuccess}',
                          ),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      '$amt EGP',
                      style: AppFonts.label(
                        isArabic: isArabic,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

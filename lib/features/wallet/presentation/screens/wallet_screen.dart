import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/localization/app_strings_ar.dart';
import '../../../../core/localization/app_strings_en.dart';
import '../../../../core/localization/localization_provider.dart';
import '../../data/wallet_dummy_data.dart';

class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  // TODO: Replace with actual balance from provider/API
  // ignore: prefer_interpolation_to_compose_strings
  static const String _currentBalance = '125.00 ' + AppStringsEn.currency;

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
                    style: AppTextStyles.body(
                      isArabic: isArabic,
                      color: AppColors.secondaryLight,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _currentBalance,
                    style: AppTextStyles.displayMedium(
                      isArabic: isArabic,
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
                        style: AppTextStyles.label(
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
                style: AppTextStyles.sectionTitle(
                  isArabic: isArabic,
                  color: AppColors.text,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Transaction list
            ...dummyTransactions.map(
              (tx) => _buildTransaction(
                icon: tx.icon,
                title: tx.title(isArabic),
                subtitle: tx.date,
                amount: tx.amount,
                isDebit: tx.isDebit,
                isArabic: isArabic,
              ),
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
                  style: AppTextStyles.label(
                    isArabic: isArabic,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTextStyles.caption(
                    isArabic: isArabic,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: AppTextStyles.bodyBold(
              isArabic: isArabic,
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
              style: AppTextStyles.title(
                isArabic: isArabic,
                color: AppColors.text,
              ),
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
                      '$amt ${AppStringsEn.currency}',
                      style: AppTextStyles.label(
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

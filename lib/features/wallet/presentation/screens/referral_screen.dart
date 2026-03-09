import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/localization/app_strings_ar.dart';
import '../../../../core/localization/app_strings_en.dart';
import '../../../../core/localization/localization_provider.dart';

class ReferralScreen extends ConsumerWidget {
  const ReferralScreen({super.key});

  static const String _referralCode = 'LAFFA2026';

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
          isArabic ? AppStringsAr.referralCode : AppStringsEn.referralCode,
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
            const SizedBox(height: 20),

            // Illustration area
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.card_giftcard_rounded,
                color: AppColors.primary,
                size: 48,
              ),
            ),
            const SizedBox(height: 20),

            Text(
              isArabic
                  ? AppStringsAr.shareCodeGetCredit
                  : AppStringsEn.shareCodeGetCredit,
              textAlign: TextAlign.center,
              style: AppTextStyles.title(
                isArabic: isArabic,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isArabic
                  ? AppStringsAr.referralDescription
                  : AppStringsEn.referralDescription,
              textAlign: TextAlign.center,
              style: AppTextStyles.body(
                isArabic: isArabic,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 28),

            // Referral code card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    isArabic
                        ? AppStringsAr.yourReferralCode
                        : AppStringsEn.yourReferralCode,
                    style: AppTextStyles.body(
                      isArabic: isArabic,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: Text(
                      _referralCode,
                      style: AppTextStyles.headingBold(
                        isArabic: isArabic,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 44,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Clipboard.setData(
                                const ClipboardData(text: _referralCode),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    isArabic
                                        ? AppStringsAr.codeCopied
                                        : AppStringsEn.codeCopied,
                                  ),
                                  backgroundColor: AppColors.success,
                                ),
                              );
                            },
                            icon: const Icon(Icons.copy_rounded, size: 18),
                            label: Text(
                              isArabic ? AppStringsAr.copy : AppStringsEn.copy,
                              style: AppTextStyles.label(
                                isArabic: isArabic,
                                color: AppColors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 44,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    isArabic
                                        ? AppStringsAr.shareComingSoon
                                        : AppStringsEn.shareComingSoon,
                                  ),
                                  backgroundColor: AppColors.info,
                                ),
                              );
                            },
                            icon: const Icon(Icons.share_rounded, size: 18),
                            label: Text(
                              isArabic
                                  ? AppStringsAr.share
                                  : AppStringsEn.share,
                              style: AppTextStyles.label(
                                isArabic: isArabic,
                                color: AppColors.primary,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              side: const BorderSide(color: AppColors.primary),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Stats
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    value: '3',
                    label: isArabic
                        ? AppStringsAr.friendsInvited
                        : AppStringsEn.friendsInvited,
                    icon: Icons.people_rounded,
                    isArabic: isArabic,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    value: '60 ${AppStringsEn.currency}',
                    label: isArabic
                        ? AppStringsAr.creditsEarned
                        : AppStringsEn.creditsEarned,
                    icon: Icons.wallet_rounded,
                    isArabic: isArabic,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String value,
    required String label,
    required IconData icon,
    required bool isArabic,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.titleBold(
              isArabic: isArabic,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption(
              isArabic: isArabic,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/localization/app_strings_ar.dart';
import '../../../../core/localization/app_strings_en.dart';
import '../../../../core/localization/localization_provider.dart';
import '../../../../core/router/app_router.dart';

class SafetyCenterScreen extends ConsumerWidget {
  const SafetyCenterScreen({super.key});

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
          isArabic ? AppStringsAr.safetyCenter : AppStringsEn.safetyCenter,
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
            // Emergency banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.errorLight,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.error.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.emergency_rounded,
                      color: AppColors.error,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isArabic
                        ? AppStringsAr.needEmergencyHelp
                        : AppStringsEn.needEmergencyHelp,
                    style: AppTextStyles.titleBold(
                      isArabic: isArabic,
                      color: AppColors.error,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isArabic
                        ? AppStringsAr.tapToContactEmergency
                        : AppStringsEn.tapToContactEmergency,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body(
                      isArabic: isArabic,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _showEmergencyDialog(context, isArabic);
                      },
                      icon: const Icon(
                        Icons.call_rounded,
                        color: AppColors.white,
                      ),
                      label: Text(
                        isArabic
                            ? AppStringsAr.callEmergency
                            : AppStringsEn.callEmergency,
                        style: AppTextStyles.label(
                          isArabic: isArabic,
                          color: AppColors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Safety tips section
            Text(
              isArabic ? AppStringsAr.safetyTips : AppStringsEn.safetyTips,
              style: AppTextStyles.sectionTitle(
                isArabic: isArabic,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 12),
            _buildTipCard(
              icon: Icons.health_and_safety_rounded,
              title: isArabic
                  ? AppStringsAr.wearHelmet
                  : AppStringsEn.wearHelmet,
              subtitle: isArabic
                  ? AppStringsAr.wearHelmetDesc
                  : AppStringsEn.wearHelmetDesc,
              color: AppColors.info,
              isArabic: isArabic,
            ),
            const SizedBox(height: 12),
            _buildTipCard(
              icon: Icons.speed_rounded,
              title: isArabic
                  ? AppStringsAr.followSpeedLimits
                  : AppStringsEn.followSpeedLimits,
              subtitle: isArabic
                  ? AppStringsAr.followSpeedLimitsDesc
                  : AppStringsEn.followSpeedLimitsDesc,
              color: AppColors.warning,
              isArabic: isArabic,
            ),
            const SizedBox(height: 12),
            _buildTipCard(
              icon: Icons.visibility_rounded,
              title: isArabic
                  ? AppStringsAr.stayVisible
                  : AppStringsEn.stayVisible,
              subtitle: isArabic
                  ? AppStringsAr.stayVisibleDesc
                  : AppStringsEn.stayVisibleDesc,
              color: AppColors.success,
              isArabic: isArabic,
            ),
            const SizedBox(height: 12),
            _buildTipCard(
              icon: Icons.phone_android_rounded,
              title: isArabic
                  ? AppStringsAr.noPhoneWhileRiding
                  : AppStringsEn.noPhoneWhileRiding,
              subtitle: isArabic
                  ? AppStringsAr.noPhoneWhileRidingDesc
                  : AppStringsEn.noPhoneWhileRidingDesc,
              color: AppColors.error,
              isArabic: isArabic,
            ),
            const SizedBox(height: 12),
            _buildTipCard(
              icon: Icons.traffic_rounded,
              title: isArabic
                  ? AppStringsAr.followTrafficRules
                  : AppStringsEn.followTrafficRules,
              subtitle: isArabic
                  ? AppStringsAr.followTrafficRulesDesc
                  : AppStringsEn.followTrafficRulesDesc,
              color: AppColors.primary,
              isArabic: isArabic,
            ),
            const SizedBox(height: 24),

            // Report issue section
            Text(
              isArabic
                  ? AppStringsAr.reportAnIssue
                  : AppStringsEn.reportAnIssue,
              style: AppTextStyles.sectionTitle(
                isArabic: isArabic,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 12),
            _buildReportButton(
              icon: Icons.report_problem_rounded,
              label: isArabic
                  ? AppStringsAr.reportAccident
                  : AppStringsEn.reportAccident,
              isArabic: isArabic,
              onTap: () {
                context.push(AppRouter.chat);
              },
            ),
            const SizedBox(height: 10),
            _buildReportButton(
              icon: Icons.build_rounded,
              label: isArabic
                  ? AppStringsAr.brokenScooter
                  : AppStringsEn.brokenScooter,
              isArabic: isArabic,
              onTap: () {
                context.push(AppRouter.chat);
              },
            ),
            const SizedBox(height: 10),
            _buildReportButton(
              icon: Icons.dangerous_rounded,
              label: isArabic
                  ? AppStringsAr.unsafeRoad
                  : AppStringsEn.unsafeRoad,
              isArabic: isArabic,
              onTap: () {
                context.push(AppRouter.chat);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTipCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required bool isArabic,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
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
                const SizedBox(height: 4),
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
        ],
      ),
    );
  }

  Widget _buildReportButton({
    required IconData icon,
    required String label,
    required bool isArabic,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.error, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.body(
                  isArabic: isArabic,
                  color: AppColors.text,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }

  void _showEmergencyDialog(BuildContext context, bool isArabic) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.warning_rounded, color: AppColors.error),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                isArabic
                    ? AppStringsAr.emergencyConfirmation
                    : AppStringsEn.emergencyConfirmation,
                style: AppTextStyles.sectionTitle(
                  isArabic: isArabic,
                  color: AppColors.text,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          isArabic
              ? AppStringsAr.confirmCallEmergency
              : AppStringsEn.confirmCallEmergency,
          style: AppTextStyles.body(
            isArabic: isArabic,
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              isArabic ? AppStringsAr.cancel : AppStringsEn.cancel,
              style: AppTextStyles.label(
                isArabic: isArabic,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isArabic
                        ? AppStringsAr.connectingEmergency
                        : AppStringsEn.connectingEmergency,
                  ),
                  backgroundColor: AppColors.error,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              isArabic ? AppStringsAr.callNow : AppStringsEn.callNow,
              style: AppTextStyles.label(
                isArabic: isArabic,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

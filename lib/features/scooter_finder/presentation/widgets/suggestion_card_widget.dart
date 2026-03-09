import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/localization/localization_provider.dart';
import '../../../../core/localization/app_strings_ar.dart';
import '../../../../core/localization/app_strings_en.dart';
import '../controllers/scooter_finder_provider.dart';
import '../../data/models/scooter_suggestion_model.dart';

/// A small suggestion card shown on the map when smart suggestions are enabled.
/// User can tap "View Scooter" (focuses camera) or "Ignore" (dismisses card).
class SuggestionCardWidget extends ConsumerWidget {
  /// Called when the user taps "View Scooter".
  /// Parent should animate the map camera to the scooter lat/lng.
  final void Function(ScooterSuggestion scooter) onViewScooter;

  const SuggestionCardWidget({super.key, required this.onViewScooter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final finderState = ref.watch(scooterFinderProvider);
    final localization = ref.watch(localizationProvider);
    final isArabic = localization.language == AppLanguage.ar;

    if (!finderState.showCard) return const SizedBox.shrink();

    final scooter = finderState.suggestion!;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Container(
        key: ValueKey(scooter.id),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.borderLight),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title row
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    color: AppColors.primary,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    isArabic
                        ? AppStringsAr.suggestedScooterNearby
                        : AppStringsEn.suggestedScooterNearby,
                    style: AppTextStyles.label(
                      isArabic: isArabic,
                      color: AppColors.text,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Info grid: 2x2
            Row(
              children: [
                _infoChip(Icons.qr_code_rounded, scooter.id, isArabic),
                const SizedBox(width: 10),
                _infoChip(
                  Icons.battery_charging_full_rounded,
                  scooter.batteryDisplay,
                  isArabic,
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                _infoChip(
                  Icons.near_me_rounded,
                  scooter.distanceDisplay,
                  isArabic,
                ),
                const SizedBox(width: 10),
                _infoChip(
                  Icons.payments_rounded,
                  scooter.estimatedCostDisplay,
                  isArabic,
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 38,
                    child: ElevatedButton(
                      onPressed: () => onViewScooter(scooter),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        isArabic
                            ? AppStringsAr.viewScooter
                            : AppStringsEn.viewScooter,
                        style: AppTextStyles.label(
                          isArabic: isArabic,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 38,
                    child: OutlinedButton(
                      onPressed: () {
                        ref.read(scooterFinderProvider.notifier).dismiss();
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textSecondary,
                        side: const BorderSide(color: AppColors.border),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        isArabic ? AppStringsAr.ignore : AppStringsEn.ignore,
                        style: AppTextStyles.label(
                          isArabic: isArabic,
                          color: AppColors.textSecondary,
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
    );
  }

  Widget _infoChip(IconData icon, String text, bool isArabic) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: AppColors.primary),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.smallLabel(
                  isArabic: isArabic,
                  color: AppColors.text,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

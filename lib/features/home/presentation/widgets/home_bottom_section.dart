import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/localization/app_strings_ar.dart';
import '../../../../core/localization/app_strings_en.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../controllers/home_provider.dart';
import '../../data/models/station_model.dart';

class HomeBottomSection extends ConsumerWidget {
  final HomeState homeState;
  final bool isArabic;

  const HomeBottomSection({
    super.key,
    required this.homeState,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTripLabel = isArabic
        ? AppStringsAr.activeTrip
        : AppStringsEn.activeTrip;
    final noActiveTripLabel = isArabic
        ? AppStringsAr.noActiveTrip
        : AppStringsEn.noActiveTrip;
    final tripHistoryLabel = isArabic
        ? AppStringsAr.tripHistory
        : AppStringsEn.tripHistory;
    final couponsLabel = isArabic ? AppStringsAr.coupons : AppStringsEn.coupons;
    final activeTrip = homeState.activeTrip;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ActiveTripCard(
          activeTrip: activeTrip,
          homeState: homeState,
          isArabic: isArabic,
          activeTripLabel: activeTripLabel,
          noActiveTripLabel: noActiveTripLabel,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _ActionCard(
                label: tripHistoryLabel,
                icon: Icons.history_rounded,
                isArabic: isArabic,
                onTap: () => context.push(AppRouter.trips),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionCard(
                label: couponsLabel,
                icon: Icons.local_offer_rounded,
                isArabic: isArabic,
                onTap: () => context.push(AppRouter.coupons),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ActiveTripCard extends ConsumerWidget {
  final ActiveTrip? activeTrip;
  final HomeState homeState;
  final bool isArabic;
  final String activeTripLabel;
  final String noActiveTripLabel;

  const _ActiveTripCard({
    required this.activeTrip,
    required this.homeState,
    required this.isArabic,
    required this.activeTripLabel,
    required this.noActiveTripLabel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            activeTripLabel,
            style: AppTextStyles.label(
              isArabic: isArabic,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          if (activeTrip == null)
            Text(
              noActiveTripLabel,
              style: AppTextStyles.authButton(
                isArabic: isArabic,
                color: AppColors.text,
              ),
            )
          else
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activeTrip!.stationName,
                        style: AppTextStyles.sectionTitle(
                          isArabic: isArabic,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(height: 4),
                      StreamBuilder<int>(
                        stream: Stream<int>.periodic(
                          const Duration(seconds: 1),
                          (value) => value,
                        ),
                        builder: (context, snapshot) {
                          final duration = DateTime.now().difference(
                            activeTrip!.startTime,
                          );
                          return Text(
                            _formatDuration(duration),
                            style: AppTextStyles.label(
                              isArabic: isArabic,
                              color: AppColors.primary,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: homeState.isLoading
                      ? null
                      : () => ref.read(homeProvider.notifier).endTrip(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    isArabic ? AppStringsAr.endRide : AppStringsEn.endRide,
                    style: AppTextStyles.authSmallLabel(isArabic: isArabic),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    final hours = duration.inHours;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }
}

class _ActionCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isArabic;
  final VoidCallback onTap;

  const _ActionCard({
    required this.label,
    required this.icon,
    required this.isArabic,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.primary, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.authSmallLabel(
                    isArabic: isArabic,
                    color: AppColors.text,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

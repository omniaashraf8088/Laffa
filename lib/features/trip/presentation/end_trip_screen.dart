import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/fonts.dart';
import '../../../core/localization/localization_provider.dart';
import '../domain/trip_model.dart';
import '../domain/trip_provider.dart';
import 'widgets/trip_info_card.dart';

/// End trip screen shown after a trip is completed.
/// Displays trip summary with duration, distance, and cost.
class EndTripScreen extends ConsumerWidget {
  const EndTripScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripState = ref.watch(tripProvider);
    final localization = ref.watch(localizationProvider);
    final isArabic = localization.language == AppLanguage.ar;

    final completedTrip = tripState.completedTrip;

    if (completedTrip == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 64,
                color: AppColors.greyMedium,
              ),
              const SizedBox(height: 16),
              Text(
                isArabic ? 'لا توجد بيانات رحلة' : 'No trip data available',
                style: AppFonts.bodyMedium(
                  isArabic: isArabic,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go('/home'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                ),
                child: Text(isArabic ? 'العودة للرئيسية' : 'Back to Home'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 24),

                    // Success icon
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: AppColors.successLight,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.success.withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: AppColors.success,
                        size: 50,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Title
                    Text(
                      isArabic ? 'انتهت الرحلة!' : 'Trip Completed!',
                      style: AppFonts.heading(
                        isArabic: isArabic,
                        color: AppColors.text,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      isArabic
                          ? 'شكراً لاستخدامك Laffa'
                          : 'Thanks for riding with Laffa',
                      style: AppFonts.bodyMedium(
                        isArabic: isArabic,
                        color: AppColors.textSecondary,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Trip stats cards row
                    _buildStatsRow(completedTrip, isArabic),

                    const SizedBox(height: 24),

                    // Detailed trip info card
                    TripInfoCard(
                      trip: completedTrip,
                      isArabic: isArabic,
                      showCost: true,
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Bottom actions
            _buildBottomActions(context, ref, completedTrip, isArabic),
          ],
        ),
      ),
    );
  }

  /// Builds the stats row with duration, distance, and cost.
  Widget _buildStatsRow(Trip trip, bool isArabic) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.timer_rounded,
            label: isArabic ? 'المدة' : 'Duration',
            value: trip.formattedDuration,
            color: AppColors.info,
            isArabic: isArabic,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildStatCard(
            icon: Icons.straighten_rounded,
            label: isArabic ? 'المسافة' : 'Distance',
            value: '${trip.distanceKm.toStringAsFixed(1)} km',
            color: AppColors.success,
            isArabic: isArabic,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildStatCard(
            icon: Icons.payments_rounded,
            label: isArabic ? 'التكلفة' : 'Cost',
            value: trip.cost.toStringAsFixed(1),
            color: AppColors.primary,
            isArabic: isArabic,
          ),
        ),
      ],
    );
  }

  /// Builds a single stat card.
  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required bool isArabic,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
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
              color: color.withOpacity(0.1),
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
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppFonts.style(
              isArabic: isArabic,
              fontSize: AppFonts.sizeXSmall,
              color: AppColors.textTertiary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Builds bottom action buttons.
  Widget _buildBottomActions(
    BuildContext context,
    WidgetRef ref,
    Trip trip,
    bool isArabic,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            // Rate trip button (primary)
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  context.go('/rating?tripId=${trip.id}');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                icon: const Icon(Icons.star_rounded, size: 20),
                label: Text(
                  isArabic ? 'قيّم الرحلة' : 'Rate This Trip',
                  style: AppFonts.button(
                    isArabic: isArabic,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Skip / go home button (secondary)
            SizedBox(
              width: double.infinity,
              height: 48,
              child: TextButton(
                onPressed: () {
                  ref.read(tripProvider.notifier).clearCompletedTrip();
                  context.go('/home');
                },
                child: Text(
                  isArabic ? 'تخطي' : 'Skip',
                  style: AppFonts.style(
                    isArabic: isArabic,
                    fontSize: AppFonts.sizeMedium,
                    fontWeight: AppFonts.semiBold,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

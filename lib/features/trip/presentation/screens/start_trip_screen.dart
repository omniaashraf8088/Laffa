import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/localization/app_strings_ar.dart';
import '../../../../core/localization/app_strings_en.dart';
import '../../../../core/localization/localization_provider.dart';
import '../../../../core/router/app_router.dart';
import '../../../booking/presentation/controllers/booking_provider.dart';
import '../../data/models/trip_model.dart';
import '../controllers/trip_provider.dart';
import '../widgets/trip_timer_widget.dart';
import '../widgets/trip_info_card.dart';

/// Start trip screen shown after payment. Displays trip details and live timer.
/// Users can begin their ride and see real-time duration tracking.
class StartTripScreen extends ConsumerStatefulWidget {
  const StartTripScreen({super.key});

  @override
  ConsumerState<StartTripScreen> createState() => _StartTripScreenState();
}

class _StartTripScreenState extends ConsumerState<StartTripScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // Start the trip using booking data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startTripFromBooking();
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  /// Reads booking data and starts a trip.
  void _startTripFromBooking() {
    final bookingState = ref.read(bookingProvider);
    final booking = bookingState.currentBooking;
    final bike = bookingState.selectedBike;

    if (booking != null && bike != null) {
      ref
          .read(tripProvider.notifier)
          .startTrip(
            bikeId: bike.id,
            bikeName: bike.name,
            bikeType: bike.type,
            stationName: booking.stationName,
          );
    } else {
      // Fallback: create a demo trip
      ref
          .read(tripProvider.notifier)
          .startTrip(
            bikeId: 'demo_bike',
            bikeName: 'City Cruiser',
            bikeType: 'standard',
            stationName: 'Downtown Hub',
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tripState = ref.watch(tripProvider);
    final localization = ref.watch(localizationProvider);
    final isArabic = localization.language == AppLanguage.ar;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          isArabic ? AppStringsAr.yourTrip : AppStringsEn.yourTrip,
          style: AppTextStyles.title(
            isArabic: isArabic,
            color: AppColors.white,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: tripState.isLoading
          ? _buildLoadingState(isArabic)
          : tripState.error != null
          ? _buildErrorState(tripState.error!, isArabic)
          : tripState.activeTrip != null
          ? _buildActiveTripContent(tripState.activeTrip!, isArabic)
          : _buildNoTripState(isArabic),
    );
  }

  /// Builds the active trip content with timer and controls.
  Widget _buildActiveTripContent(Trip trip, bool isArabic) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 16),

                // Status indicator with pulse animation
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(
                          alpha: 0.1 + (_pulseController.value * 0.1),
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.success.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: AppColors.success,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isArabic
                                ? AppStringsAr.tripInProgress
                                : AppStringsEn.tripInProgress,
                            style: AppTextStyles.label(
                              isArabic: isArabic,
                              color: AppColors.success,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 32),

                // Live timer
                TripTimerWidget(
                  startTime: trip.startTime,
                  isArabic: isArabic,
                  isLarge: true,
                ),

                const SizedBox(height: 32),

                // Trip info card
                TripInfoCard(trip: trip, isArabic: isArabic),

                const SizedBox(height: 24),

                // Safety tips
                _buildSafetyTips(isArabic),
              ],
            ),
          ),
        ),

        // End trip button at bottom
        _buildEndTripButton(isArabic),
      ],
    );
  }

  /// Builds safety tips section.
  Widget _buildSafetyTips(bool isArabic) {
    final tips = isArabic
        ? [
            AppStringsAr.safetyTip1,
            AppStringsAr.safetyTip2,
            AppStringsAr.safetyTip3,
          ]
        : [
            AppStringsEn.safetyTip1,
            AppStringsEn.safetyTip2,
            AppStringsEn.safetyTip3,
          ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.warningLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.health_and_safety_rounded,
                color: AppColors.warning,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                isArabic ? AppStringsAr.safetyTips : AppStringsEn.safetyTips,
                style: AppTextStyles.label(
                  isArabic: isArabic,
                  color: AppColors.text,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...tips.map(
            (tip) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  const SizedBox(width: 28),
                  const Icon(
                    Icons.check_circle_outline_rounded,
                    size: 14,
                    color: AppColors.warning,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    tip,
                    style: AppTextStyles.bodySmall(
                      isArabic: isArabic,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the end trip button.
  Widget _buildEndTripButton(bool isArabic) {
    final tripState = ref.watch(tripProvider);

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
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: tripState.isEnding
                ? null
                : () async {
                    await ref.read(tripProvider.notifier).endTrip();
                    if (mounted) {
                      context.go(AppRouter.endTrip);
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
            icon: tripState.isEnding
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.white,
                      ),
                    ),
                  )
                : const Icon(Icons.stop_circle_rounded, size: 22),
            label: Text(
              tripState.isEnding
                  ? (isArabic
                        ? AppStringsAr.endingTrip
                        : AppStringsEn.endingTrip)
                  : (isArabic ? AppStringsAr.endTrip : AppStringsEn.endTrip),
              style: AppTextStyles.button(
                isArabic: isArabic,
                color: AppColors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the loading state.
  Widget _buildLoadingState(bool isArabic) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          const SizedBox(height: 20),
          Text(
            isArabic ? AppStringsAr.unlockingBike : AppStringsEn.unlockingBike,
            style: AppTextStyles.body(
              isArabic: isArabic,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the error state.
  Widget _buildErrorState(String error, bool isArabic) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              error,
              textAlign: TextAlign.center,
              style: AppTextStyles.body(
                isArabic: isArabic,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRouter.home),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
              ),
              child: Text(
                isArabic ? AppStringsAr.backToHome : AppStringsEn.backToHome,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the no-trip state.
  Widget _buildNoTripState(bool isArabic) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.directions_bike_outlined,
              size: 64,
              color: AppColors.greyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              isArabic ? AppStringsAr.noActiveTrip : AppStringsEn.noActiveTrip,
              style: AppTextStyles.title(
                isArabic: isArabic,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRouter.home),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
              ),
              child: Text(
                isArabic ? AppStringsAr.backToHome : AppStringsEn.backToHome,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

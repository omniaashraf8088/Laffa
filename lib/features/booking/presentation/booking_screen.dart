import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/fonts.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/localization/localization_provider.dart';
import '../domain/booking_provider.dart';
import 'widgets/bike_card.dart';
import 'widgets/booking_summary_widget.dart';
import 'widgets/duration_picker_widget.dart';

/// Booking screen where users select a bike and confirm their booking.
/// Receives station info via query parameters from the map/home screen.
class BookingScreen extends ConsumerStatefulWidget {
  final String stationId;
  final String stationName;

  const BookingScreen({
    super.key,
    required this.stationId,
    required this.stationName,
  });

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  @override
  void initState() {
    super.initState();
    // Load bikes for this station when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(bookingProvider.notifier)
          .loadBikes(
            stationId: widget.stationId,
            stationName: widget.stationName,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(bookingProvider);
    final localization = ref.watch(localizationProvider);
    final isArabic = localization.language == AppLanguage.ar;
    final size = MediaQuery.of(context).size;

    // Listen for booking confirmation to navigate to payment
    ref.listen<BookingState>(bookingProvider, (previous, next) {
      if (next.currentBooking != null &&
          previous?.currentBooking == null &&
          !next.isLoading) {
        context.push(
          '/payment?bookingId=${next.currentBooking!.id}'
          '&amount=${next.currentBooking!.estimatedCost.toStringAsFixed(1)}',
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          isArabic ? 'حجز دراجة' : 'Book a Bike',
          style: AppFonts.title(isArabic: isArabic, color: AppColors.white),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.white),
          onPressed: () {
            ref.read(bookingProvider.notifier).reset();
            context.pop();
          },
        ),
      ),
      body: bookingState.isLoading && bookingState.availableBikes.isEmpty
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            )
          : bookingState.error != null && bookingState.availableBikes.isEmpty
          ? _buildErrorState(bookingState.error!, isArabic)
          : _buildContent(bookingState, isArabic, size),
    );
  }

  /// Builds the main scrollable content.
  Widget _buildContent(BookingState state, bool isArabic, Size size) {
    return Column(
      children: [
        // Station info header
        _buildStationHeader(isArabic),

        // Scrollable content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Available bikes section
                Text(
                  isArabic ? 'الدراجات المتاحة' : 'Available Bikes',
                  style: AppFonts.style(
                    isArabic: isArabic,
                    fontSize: AppFonts.sizeLarge,
                    fontWeight: AppFonts.semiBold,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 12),

                // Bike list
                if (state.availableBikes.isEmpty)
                  _buildEmptyState(isArabic)
                else
                  ...state.availableBikes.map(
                    (bike) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: BikeCard(
                        bike: bike,
                        isSelected: state.selectedBike?.id == bike.id,
                        isArabic: isArabic,
                        onTap: () {
                          ref.read(bookingProvider.notifier).selectBike(bike);
                        },
                      ),
                    ),
                  ),

                const SizedBox(height: 20),

                // Duration picker (visible when a bike is selected)
                if (state.selectedBike != null) ...[
                  DurationPickerWidget(
                    selectedMinutes: state.estimatedMinutes,
                    isArabic: isArabic,
                    onChanged: (minutes) {
                      ref
                          .read(bookingProvider.notifier)
                          .updateEstimatedMinutes(minutes);
                    },
                  ),
                  const SizedBox(height: 24),

                  // Booking summary
                  BookingSummaryWidget(
                    bike: state.selectedBike!,
                    stationName: widget.stationName,
                    estimatedMinutes: state.estimatedMinutes,
                    isArabic: isArabic,
                  ),
                  const SizedBox(height: 24),
                ],

                // Error message
                if (state.error != null)
                  _buildErrorBanner(state.error!, isArabic),
              ],
            ),
          ),
        ),

        // Confirm booking button (bottom)
        if (state.selectedBike != null) _buildConfirmButton(state, isArabic),
      ],
    );
  }

  /// Builds the station header banner.
  Widget _buildStationHeader(bool isArabic) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Icon(Icons.location_on_rounded, color: AppColors.primary, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              widget.stationName,
              style: AppFonts.style(
                isArabic: isArabic,
                fontSize: AppFonts.sizeBody,
                fontWeight: AppFonts.semiBold,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the empty state when no bikes are available.
  Widget _buildEmptyState(bool isArabic) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.directions_bike_outlined,
              size: 64,
              color: AppColors.greyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              isArabic
                  ? 'لا توجد دراجات متاحة حالياً'
                  : 'No bikes available at this station',
              textAlign: TextAlign.center,
              style: AppFonts.style(
                isArabic: isArabic,
                fontSize: AppFonts.sizeMedium,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the error state widget.
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
              style: AppFonts.bodyMedium(
                isArabic: isArabic,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                ref
                    .read(bookingProvider.notifier)
                    .loadBikes(
                      stationId: widget.stationId,
                      stationName: widget.stationName,
                    );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
              ),
              child: Text(isArabic ? 'إعادة المحاولة' : 'Retry'),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds an error banner inside the content.
  Widget _buildErrorBanner(String error, bool isArabic) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.errorLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              error,
              style: AppFonts.bodySmall(
                isArabic: isArabic,
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the bottom confirm booking button.
  Widget _buildConfirmButton(BookingState state, bool isArabic) {
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
          height: AppDimensions.buttonHeight,
          child: ElevatedButton(
            onPressed: state.isLoading
                ? null
                : () {
                    ref.read(bookingProvider.notifier).confirmBooking();
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
            child: state.isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.white,
                      ),
                    ),
                  )
                : Text(
                    isArabic ? 'تأكيد الحجز' : 'Confirm Booking',
                    style: AppFonts.button(
                      isArabic: isArabic,
                      color: AppColors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

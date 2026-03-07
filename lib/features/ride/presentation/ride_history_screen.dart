import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/fonts.dart';
import '../../../core/localization/localization_provider.dart';
import '../domain/ride_model.dart';
import '../domain/ride_provider.dart';

/// Ride history screen showing all completed and cancelled rides.
class RideHistoryScreen extends ConsumerWidget {
  const RideHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rideState = ref.watch(rideProvider);
    final localization = ref.watch(localizationProvider);
    final isArabic = localization.language == AppLanguage.ar;
    final history = rideState.rideHistory;

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
          isArabic ? 'سجل الرحلات' : 'Ride History',
          style: AppFonts.title(isArabic: isArabic, color: AppColors.white),
        ),
        centerTitle: true,
      ),
      body: history.isEmpty
          ? _buildEmptyState(isArabic)
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: history.length,
              separatorBuilder: (_, i) => const SizedBox(height: 12),
              itemBuilder: (context, index) =>
                  _buildRideCard(history[index], isArabic),
            ),
    );
  }

  Widget _buildEmptyState(bool isArabic) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.electric_scooter_rounded,
              color: AppColors.primary,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isArabic ? 'لا توجد رحلات بعد' : 'No rides yet',
            style: AppFonts.title(isArabic: isArabic, color: AppColors.text),
          ),
          const SizedBox(height: 8),
          Text(
            isArabic
                ? 'امسح رمز QR لبدء رحلتك الأولى'
                : 'Scan a QR code to start your first ride',
            style: AppFonts.bodyMedium(
              isArabic: isArabic,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRideCard(RideHistoryItem ride, bool isArabic) {
    final isCompleted = ride.status == RideHistoryStatus.completed;
    final statusColor = isCompleted ? AppColors.success : AppColors.grey;
    final statusLabel = isCompleted
        ? (isArabic ? 'مكتملة' : 'Completed')
        : (isArabic ? 'ملغية' : 'Cancelled');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: scooter name + status
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.electric_scooter_rounded,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ride.scooterName,
                      style: AppFonts.style(
                        isArabic: isArabic,
                        fontSize: AppFonts.sizeMedium,
                        fontWeight: AppFonts.bold,
                        color: AppColors.text,
                      ),
                    ),
                    Text(
                      'ID: ${ride.scooterId}',
                      style: AppFonts.style(
                        isArabic: isArabic,
                        fontSize: AppFonts.sizeSmall,
                        fontWeight: AppFonts.medium,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  statusLabel,
                  style: AppFonts.style(
                    isArabic: isArabic,
                    fontSize: AppFonts.sizeXSmall,
                    fontWeight: AppFonts.semiBold,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Stats
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                _buildSmallStat(
                  icon: Icons.calendar_today_rounded,
                  value: ride.formattedDate,
                  isArabic: isArabic,
                ),
                _buildVerticalDivider(),
                _buildSmallStat(
                  icon: Icons.timer_rounded,
                  value: ride.formattedDuration,
                  isArabic: isArabic,
                ),
                _buildVerticalDivider(),
                _buildSmallStat(
                  icon: Icons.straighten_rounded,
                  value: ride.formattedDistance,
                  isArabic: isArabic,
                ),
                _buildVerticalDivider(),
                _buildSmallStat(
                  icon: Icons.payments_rounded,
                  value: ride.formattedCost,
                  isArabic: isArabic,
                  isBold: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallStat({
    required IconData icon,
    required String value,
    required bool isArabic,
    bool isBold = false,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 14),
          const SizedBox(height: 4),
          Text(
            value,
            textAlign: TextAlign.center,
            style: AppFonts.style(
              isArabic: isArabic,
              fontSize: AppFonts.sizeXSmall,
              fontWeight: isBold ? AppFonts.bold : AppFonts.semiBold,
              color: isBold ? AppColors.primary : AppColors.text,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 1,
      height: 28,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      color: AppColors.borderLight,
    );
  }
}

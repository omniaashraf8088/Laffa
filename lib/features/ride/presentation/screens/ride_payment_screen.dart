import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/localization/localization_provider.dart';
import '../../../../core/localization/app_strings_ar.dart';
import '../../../../core/localization/app_strings_en.dart';
import '../../../../core/router/app_router.dart';
import '../../data/models/ride_model.dart';
import '../controllers/ride_provider.dart';

/// Payment screen shown after a ride is completed.
/// Shows ride summary, cost breakdown, and payment method selection.
class RidePaymentScreen extends ConsumerStatefulWidget {
  const RidePaymentScreen({super.key});

  @override
  ConsumerState<RidePaymentScreen> createState() => _RidePaymentScreenState();
}

class _RidePaymentScreenState extends ConsumerState<RidePaymentScreen> {
  String _selectedPayment = 'wallet';

  @override
  Widget build(BuildContext context) {
    final rideState = ref.watch(rideProvider);
    final localization = ref.watch(localizationProvider);
    final isArabic = localization.language == AppLanguage.ar;
    final ride = rideState.activeRide;

    if (ride == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.info_outline_rounded,
                size: 64,
                color: AppColors.greyMedium,
              ),
              const SizedBox(height: 16),
              Text(
                isArabic ? AppStringsAr.noRideData : AppStringsEn.noRideData,
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
                child: Text(isArabic ? AppStringsAr.home : AppStringsEn.home),
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
                    const SizedBox(height: 16),
                    // Success icon
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.successLight,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.success.withValues(alpha: 0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: AppColors.success,
                        size: 44,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      isArabic
                          ? AppStringsAr.rideCompleted
                          : AppStringsEn.rideCompleted,
                      style: AppTextStyles.heading(
                        isArabic: isArabic,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isArabic
                          ? AppStringsAr.thanksForRiding
                          : AppStringsEn.thanksForRiding,
                      style: AppTextStyles.body(
                        isArabic: isArabic,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Ride summary card
                    _buildRideSummary(ride, isArabic),
                    const SizedBox(height: 20),

                    // Cost breakdown
                    _buildCostBreakdown(ride, isArabic),
                    const SizedBox(height: 20),

                    // Payment methods
                    _buildPaymentMethods(isArabic),
                  ],
                ),
              ),
            ),
            _buildConfirmButton(ride, isArabic),
          ],
        ),
      ),
    );
  }

  Widget _buildRideSummary(RideSession ride, bool isArabic) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.electric_scooter_rounded,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ride.scooter.name,
                      style: AppTextStyles.sectionTitle(
                        isArabic: isArabic,
                        color: AppColors.text,
                      ),
                    ),
                    Text(
                      'ID: ${ride.scooter.id}',
                      style: AppTextStyles.smallMedium(
                        isArabic: isArabic,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Stats row
          Row(
            children: [
              _buildSummaryItem(
                icon: Icons.timer_rounded,
                label: isArabic ? AppStringsAr.duration : AppStringsEn.duration,
                value: ride.formattedDuration,
                color: AppColors.info,
                isArabic: isArabic,
              ),
              const SizedBox(width: 16),
              _buildSummaryItem(
                icon: Icons.straighten_rounded,
                label: isArabic ? AppStringsAr.distance : AppStringsEn.distance,
                value: '${ride.distanceKm.toStringAsFixed(1)} km',
                color: AppColors.success,
                isArabic: isArabic,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required bool isArabic,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 6),
            Text(
              value,
              style: AppTextStyles.sectionTitle(
                isArabic: isArabic,
                color: AppColors.text,
              ),
            ),
            Text(
              label,
              style: AppTextStyles.captionMedium(
                isArabic: isArabic,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCostBreakdown(RideSession ride, bool isArabic) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isArabic ? AppStringsAr.costBreakdown : AppStringsEn.costBreakdown,
            style: AppTextStyles.sectionTitle(
              isArabic: isArabic,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 16),
          _buildCostRow(
            label: isArabic
                ? AppStringsAr.costPerMinute
                : AppStringsEn.costPerMinute,
            value:
                '${ride.scooter.pricePerMinute.toStringAsFixed(1)} ${AppStringsEn.currency}',
            isArabic: isArabic,
          ),
          const SizedBox(height: 10),
          _buildCostRow(
            label: isArabic
                ? AppStringsAr.rideDuration
                : AppStringsEn.rideDuration,
            value: ride.formattedDuration,
            isArabic: isArabic,
          ),
          const SizedBox(height: 10),
          _buildCostRow(
            label: isArabic ? AppStringsAr.rideCost : AppStringsEn.rideCost,
            value:
                '${ride.estimatedCost.toStringAsFixed(1)} ${AppStringsEn.currency}',
            isArabic: isArabic,
          ),
          const SizedBox(height: 10),
          _buildCostRow(
            label: isArabic ? AppStringsAr.serviceFee : AppStringsEn.serviceFee,
            value:
                '${ride.serviceFee.toStringAsFixed(1)} ${AppStringsEn.currency}',
            isArabic: isArabic,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: AppColors.borderLight),
          ),
          _buildCostRow(
            label: isArabic ? AppStringsAr.total : AppStringsEn.total,
            value:
                '${ride.grandTotal.toStringAsFixed(1)} ${AppStringsEn.currency}',
            isArabic: isArabic,
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildCostRow({
    required String label,
    required String value,
    required bool isArabic,
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isBold
              ? AppTextStyles.sectionTitle(
                  isArabic: isArabic,
                  color: AppColors.text,
                )
              : AppTextStyles.bodyMedium(
                  isArabic: isArabic,
                  color: AppColors.textSecondary,
                ),
        ),
        Text(
          value,
          style: isBold
              ? AppTextStyles.titleBold(
                  isArabic: isArabic,
                  color: AppColors.primary,
                )
              : AppTextStyles.label(isArabic: isArabic, color: AppColors.text),
        ),
      ],
    );
  }

  Widget _buildPaymentMethods(bool isArabic) {
    final methods = [
      _PaymentOption(
        id: 'card',
        icon: Icons.credit_card_rounded,
        label: isArabic ? AppStringsAr.creditCard : AppStringsEn.creditCard,
        subtitle: isArabic ? '•••• 4242' : '•••• 4242',
      ),
      _PaymentOption(
        id: 'wallet',
        icon: Icons.account_balance_wallet_rounded,
        label: isArabic ? AppStringsAr.wallet : AppStringsEn.wallet,
        subtitle: isArabic
            ? '125.00 ${AppStringsAr.currencyAr}'
            : '125.00 ${AppStringsEn.currency}',
      ),
      _PaymentOption(
        id: 'cash',
        icon: Icons.money_rounded,
        label: isArabic ? AppStringsAr.cash : AppStringsEn.cash,
        subtitle: isArabic
            ? AppStringsAr.payOnArrival
            : AppStringsEn.payOnArrival,
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isArabic ? AppStringsAr.paymentMethod : AppStringsEn.paymentMethod,
            style: AppTextStyles.sectionTitle(
              isArabic: isArabic,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 14),
          ...methods.map(
            (m) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _buildPaymentTile(m, isArabic),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentTile(_PaymentOption method, bool isArabic) {
    final selected = _selectedPayment == method.id;
    return GestureDetector(
      onTap: () => setState(() => _selectedPayment = method.id),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.06)
              : AppColors.background,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.borderLight,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : AppColors.greyLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                method.icon,
                color: selected ? AppColors.primary : AppColors.grey,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method.label,
                    style: AppTextStyles.label(
                      isArabic: isArabic,
                      color: AppColors.text,
                    ),
                  ),
                  Text(
                    method.subtitle,
                    style: AppTextStyles.smallMedium(
                      isArabic: isArabic,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? AppColors.primary : AppColors.greyMedium,
                  width: 2,
                ),
              ),
              child: selected
                  ? Container(
                      margin: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmButton(RideSession ride, bool isArabic) {
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
          child: ElevatedButton(
            onPressed: () => _confirmPayment(ride, isArabic),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
            child: Text(
              isArabic
                  ? '${AppStringsAr.confirmPayment} · ${ride.grandTotal.toStringAsFixed(1)} ${AppStringsAr.currencyAr}'
                  : '${AppStringsEn.confirmPayment} · ${ride.grandTotal.toStringAsFixed(1)} ${AppStringsEn.currency}',
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

  void _confirmPayment(RideSession ride, bool isArabic) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.successLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: AppColors.success,
                size: 48,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              isArabic
                  ? AppStringsAr.paymentSuccessful
                  : AppStringsEn.paymentSuccessful,
              style: AppTextStyles.title(
                isArabic: isArabic,
                color: AppColors.text,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              isArabic
                  ? '${ride.grandTotal.toStringAsFixed(1)} ${AppStringsAr.currencyAr}'
                  : '${ride.grandTotal.toStringAsFixed(1)} ${AppStringsEn.currency}',
              style: AppTextStyles.heading(
                isArabic: isArabic,
                color: AppColors.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  ref.read(rideProvider.notifier).resetRide();
                  context.go(AppRouter.rideHistory);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  isArabic
                      ? AppStringsAr.viewRideHistory
                      : AppStringsEn.viewRideHistory,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                ref.read(rideProvider.notifier).resetRide();
                context.go(AppRouter.home);
              },
              child: Text(
                isArabic ? AppStringsAr.backToHome : AppStringsEn.backToHome,
                style: AppTextStyles.label(
                  isArabic: isArabic,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentOption {
  final String id;
  final IconData icon;
  final String label;
  final String subtitle;

  const _PaymentOption({
    required this.id,
    required this.icon,
    required this.label,
    required this.subtitle,
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/fonts.dart';
import '../../../core/localization/localization_provider.dart';
import '../domain/ride_model.dart';
import '../domain/ride_provider.dart';

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
                isArabic ? 'لا توجد بيانات رحلة' : 'No ride data',
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
                child: Text(isArabic ? 'الرئيسية' : 'Home'),
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
                      isArabic ? 'انتهت الرحلة!' : 'Ride Completed!',
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
                      style: AppFonts.style(
                        isArabic: isArabic,
                        fontSize: AppFonts.sizeMedium,
                        fontWeight: AppFonts.bold,
                        color: AppColors.text,
                      ),
                    ),
                    Text(
                      'ID: ${ride.scooter.id}',
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
            ],
          ),
          const SizedBox(height: 20),
          // Stats row
          Row(
            children: [
              _buildSummaryItem(
                icon: Icons.timer_rounded,
                label: isArabic ? 'المدة' : 'Duration',
                value: ride.formattedDuration,
                color: AppColors.info,
                isArabic: isArabic,
              ),
              const SizedBox(width: 16),
              _buildSummaryItem(
                icon: Icons.straighten_rounded,
                label: isArabic ? 'المسافة' : 'Distance',
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
              style: AppFonts.style(
                isArabic: isArabic,
                fontSize: AppFonts.sizeMedium,
                fontWeight: AppFonts.bold,
                color: AppColors.text,
              ),
            ),
            Text(
              label,
              style: AppFonts.style(
                isArabic: isArabic,
                fontSize: AppFonts.sizeXSmall,
                fontWeight: AppFonts.medium,
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
            isArabic ? 'تفاصيل التكلفة' : 'Cost Breakdown',
            style: AppFonts.style(
              isArabic: isArabic,
              fontSize: AppFonts.sizeMedium,
              fontWeight: AppFonts.bold,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 16),
          _buildCostRow(
            label: isArabic ? 'السعر لكل دقيقة' : 'Cost per minute',
            value: '${ride.scooter.pricePerMinute.toStringAsFixed(1)} EGP',
            isArabic: isArabic,
          ),
          const SizedBox(height: 10),
          _buildCostRow(
            label: isArabic ? 'مدة الرحلة' : 'Ride duration',
            value: ride.formattedDuration,
            isArabic: isArabic,
          ),
          const SizedBox(height: 10),
          _buildCostRow(
            label: isArabic ? 'تكلفة الركوب' : 'Ride cost',
            value: '${ride.estimatedCost.toStringAsFixed(1)} EGP',
            isArabic: isArabic,
          ),
          const SizedBox(height: 10),
          _buildCostRow(
            label: isArabic ? 'رسوم الخدمة (10%)' : 'Service fee (10%)',
            value: '${ride.serviceFee.toStringAsFixed(1)} EGP',
            isArabic: isArabic,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: AppColors.borderLight),
          ),
          _buildCostRow(
            label: isArabic ? 'الإجمالي' : 'Total',
            value: '${ride.grandTotal.toStringAsFixed(1)} EGP',
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
          style: AppFonts.style(
            isArabic: isArabic,
            fontSize: isBold ? AppFonts.sizeMedium : AppFonts.sizeBody,
            fontWeight: isBold ? AppFonts.bold : AppFonts.medium,
            color: isBold ? AppColors.text : AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: AppFonts.style(
            isArabic: isArabic,
            fontSize: isBold ? AppFonts.sizeLarge : AppFonts.sizeBody,
            fontWeight: isBold ? AppFonts.bold : AppFonts.semiBold,
            color: isBold ? AppColors.primary : AppColors.text,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethods(bool isArabic) {
    final methods = [
      _PaymentOption(
        id: 'card',
        icon: Icons.credit_card_rounded,
        label: isArabic ? 'بطاقة ائتمان' : 'Credit Card',
        subtitle: isArabic ? '•••• 4242' : '•••• 4242',
      ),
      _PaymentOption(
        id: 'wallet',
        icon: Icons.account_balance_wallet_rounded,
        label: isArabic ? 'المحفظة' : 'Wallet',
        subtitle: isArabic ? '125.00 ج.م' : '125.00 EGP',
      ),
      _PaymentOption(
        id: 'cash',
        icon: Icons.money_rounded,
        label: isArabic ? 'نقداً' : 'Cash',
        subtitle: isArabic ? 'الدفع عند الوصول' : 'Pay on arrival',
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
            isArabic ? 'طريقة الدفع' : 'Payment Method',
            style: AppFonts.style(
              isArabic: isArabic,
              fontSize: AppFonts.sizeMedium,
              fontWeight: AppFonts.bold,
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
                    style: AppFonts.style(
                      isArabic: isArabic,
                      fontSize: AppFonts.sizeBody,
                      fontWeight: AppFonts.semiBold,
                      color: AppColors.text,
                    ),
                  ),
                  Text(
                    method.subtitle,
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
                  ? 'تأكيد الدفع · ${ride.grandTotal.toStringAsFixed(1)} EGP'
                  : 'Confirm Payment · ${ride.grandTotal.toStringAsFixed(1)} EGP',
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
              isArabic ? 'تم الدفع بنجاح!' : 'Payment Successful!',
              style: AppFonts.title(isArabic: isArabic, color: AppColors.text),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              isArabic
                  ? '${ride.grandTotal.toStringAsFixed(1)} ج.م'
                  : '${ride.grandTotal.toStringAsFixed(1)} EGP',
              style: AppFonts.heading(
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
                  context.go('/ride-history');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(isArabic ? 'سجل الرحلات' : 'View Ride History'),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                ref.read(rideProvider.notifier).resetRide();
                context.go('/home');
              },
              child: Text(
                isArabic ? 'العودة للرئيسية' : 'Back to Home',
                style: AppFonts.label(
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/localization/localization_provider.dart';
import '../../../../core/localization/app_strings_ar.dart';
import '../../../../core/localization/app_strings_en.dart';
import '../controllers/payment_provider.dart';
import '../widgets/payment_form_widget.dart';
import '../widgets/payment_method_selector.dart';
import '../widgets/payment_summary_widget.dart';

/// Payment screen where users select a payment method and complete the payment.
/// Receives booking ID and amount via query parameters.
class PaymentScreen extends ConsumerStatefulWidget {
  final String bookingId;
  final double amount;

  const PaymentScreen({
    super.key,
    required this.bookingId,
    required this.amount,
  });

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _holderNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(paymentProvider.notifier)
          .initialize(bookingId: widget.bookingId, amount: widget.amount);
    });
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _holderNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final paymentState = ref.watch(paymentProvider);
    final localization = ref.watch(localizationProvider);
    final isArabic = localization.language == AppLanguage.ar;

    // Listen for payment success to navigate to start trip
    ref.listen(paymentProvider, (previous, next) {
      if (next.paymentSuccess && !(previous?.paymentSuccess ?? false)) {
        _showPaymentSuccessDialog(context, isArabic);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          isArabic ? AppStringsAr.payment : AppStringsEn.payment,
          style: AppTextStyles.title(
            isArabic: isArabic,
            color: AppColors.white,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.white),
          onPressed: () {
            ref.read(paymentProvider.notifier).reset();
            context.pop();
          },
        ),
      ),
      body: paymentState.isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            )
          : _buildContent(paymentState, isArabic),
    );
  }

  /// Builds the main scrollable content.
  Widget _buildContent(PaymentState paymentState, bool isArabic) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Payment amount summary
                PaymentSummaryWidget(amount: widget.amount, isArabic: isArabic),
                const SizedBox(height: 24),

                // Payment method selector
                PaymentMethodSelector(
                  methods: paymentState.paymentMethods,
                  selectedMethod: paymentState.selectedMethod,
                  isArabic: isArabic,
                  onSelected: (method) {
                    ref
                        .read(paymentProvider.notifier)
                        .selectPaymentMethod(method);
                  },
                ),
                const SizedBox(height: 24),

                // Card form (only visible when card method is selected)
                if (paymentState.selectedMethod?.type == 'card') ...[
                  PaymentFormWidget(
                    cardNumberController: _cardNumberController,
                    expiryController: _expiryController,
                    cvvController: _cvvController,
                    holderNameController: _holderNameController,
                    isArabic: isArabic,
                  ),
                  const SizedBox(height: 16),
                ],

                // Error message
                if (paymentState.error != null)
                  _buildErrorBanner(paymentState.error!, isArabic),
              ],
            ),
          ),
        ),

        // Pay button at bottom
        _buildPayButton(paymentState, isArabic),
      ],
    );
  }

  /// Builds the bottom pay button.
  Widget _buildPayButton(PaymentState state, bool isArabic) {
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
            onPressed: state.isProcessing || state.selectedMethod == null
                ? null
                : () => _handlePayment(isArabic),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              disabledBackgroundColor: AppColors.greyMedium,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
            child: state.isProcessing
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        isArabic
                            ? AppStringsAr.processing
                            : AppStringsEn.processing,
                        style: AppTextStyles.button(
                          isArabic: isArabic,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  )
                : Text(
                    isArabic
                        ? '${AppStringsAr.payAmount} ${widget.amount.toStringAsFixed(1)} ${AppStringsAr.currency}'
                        : '${AppStringsEn.payAmount} ${widget.amount.toStringAsFixed(1)} ${AppStringsEn.currency}',
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

  /// Handles the payment process with validation.
  void _handlePayment(bool isArabic) {
    final notifier = ref.read(paymentProvider.notifier);

    // Update card details in state if card method selected
    final state = ref.read(paymentProvider);
    if (state.selectedMethod?.type == 'card') {
      notifier.updateCardNumber(_cardNumberController.text);
      notifier.updateExpiryDate(_expiryController.text);
      notifier.updateCVV(_cvvController.text);
      notifier.updateCardHolderName(_holderNameController.text);

      final error = notifier.validateCardDetails();
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }
    }

    notifier.processPayment();
  }

  /// Shows the payment success dialog and navigates to start trip.
  void _showPaymentSuccessDialog(BuildContext context, bool isArabic) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
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
                    ? AppStringsAr.canStartTrip
                    : AppStringsEn.canStartTrip,
                style: AppTextStyles.body(
                  isArabic: isArabic,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    ref.read(paymentProvider.notifier).reset();
                    context.go(AppRouter.startTrip);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    isArabic ? AppStringsAr.startTrip : AppStringsEn.startTrip,
                    style: AppTextStyles.button(
                      isArabic: isArabic,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Builds an error banner.
  Widget _buildErrorBanner(String error, bool isArabic) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.errorLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              error,
              style: AppTextStyles.bodySmall(
                isArabic: isArabic,
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

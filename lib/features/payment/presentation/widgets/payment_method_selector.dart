import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/fonts.dart';
import '../../domain/payment_model.dart';

/// Widget that displays selectable payment methods (card, wallet, cash).
class PaymentMethodSelector extends StatelessWidget {
  final List<PaymentMethod> methods;
  final PaymentMethod? selectedMethod;
  final bool isArabic;
  final ValueChanged<PaymentMethod> onSelected;

  const PaymentMethodSelector({
    super.key,
    required this.methods,
    required this.selectedMethod,
    required this.isArabic,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isArabic ? 'طريقة الدفع' : 'Payment Method',
          style: AppFonts.style(
            isArabic: isArabic,
            fontSize: AppFonts.sizeMedium,
            fontWeight: AppFonts.semiBold,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 12),
        ...methods.map((method) {
          final isSelected = selectedMethod?.id == method.id;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _buildMethodCard(method, isSelected),
          );
        }),
      ],
    );
  }

  /// Builds a single payment method card.
  Widget _buildMethodCard(PaymentMethod method, bool isSelected) {
    return GestureDetector(
      onTap: () => onSelected(method),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.06)
              : AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            // Method icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getMethodColor(method.type).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _getMethodIcon(method.type),
                color: _getMethodColor(method.type),
                size: 22,
              ),
            ),
            const SizedBox(width: 12),

            // Method info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method.displayName,
                    style: AppFonts.style(
                      isArabic: isArabic,
                      fontSize: AppFonts.sizeBody,
                      fontWeight: AppFonts.semiBold,
                      color: AppColors.text,
                    ),
                  ),
                  if (method.isDefault)
                    Text(
                      isArabic ? 'افتراضي' : 'Default',
                      style: AppFonts.style(
                        isArabic: isArabic,
                        fontSize: AppFonts.sizeXSmall,
                        color: AppColors.primary,
                      ),
                    ),
                ],
              ),
            ),

            // Selection radio
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.greyMedium,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  /// Returns the icon for a payment method type.
  IconData _getMethodIcon(String type) {
    switch (type) {
      case 'card':
        return Icons.credit_card_rounded;
      case 'wallet':
        return Icons.account_balance_wallet_rounded;
      case 'cash':
        return Icons.money_rounded;
      default:
        return Icons.payment_rounded;
    }
  }

  /// Returns the color for a payment method type.
  Color _getMethodColor(String type) {
    switch (type) {
      case 'card':
        return AppColors.info;
      case 'wallet':
        return AppColors.primary;
      case 'cash':
        return AppColors.success;
      default:
        return AppColors.grey;
    }
  }
}

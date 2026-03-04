import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/fonts.dart';

/// Payment card form widget with card number, expiry, CVV, and holder name fields.
/// Includes automatic formatting and real-time validation feedback.
class PaymentFormWidget extends StatelessWidget {
  final TextEditingController cardNumberController;
  final TextEditingController expiryController;
  final TextEditingController cvvController;
  final TextEditingController holderNameController;
  final bool isArabic;
  final String? cardNumberError;
  final String? expiryError;
  final String? cvvError;
  final String? holderNameError;

  const PaymentFormWidget({
    super.key,
    required this.cardNumberController,
    required this.expiryController,
    required this.cvvController,
    required this.holderNameController,
    required this.isArabic,
    this.cardNumberError,
    this.expiryError,
    this.cvvError,
    this.holderNameError,
  });

  @override
  Widget build(BuildContext context) {
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
          // Card number field
          _buildField(
            label: isArabic ? 'رقم البطاقة' : 'Card Number',
            hint: '1234 5678 9012 3456',
            controller: cardNumberController,
            error: cardNumberError,
            keyboardType: TextInputType.number,
            icon: Icons.credit_card_rounded,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(16),
              _CardNumberFormatter(),
            ],
          ),

          const SizedBox(height: 16),

          // Expiry and CVV row
          Row(
            children: [
              Expanded(
                child: _buildField(
                  label: isArabic ? 'تاريخ الانتهاء' : 'Expiry',
                  hint: 'MM/YY',
                  controller: expiryController,
                  error: expiryError,
                  keyboardType: TextInputType.number,
                  icon: Icons.calendar_today_rounded,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                    _ExpiryDateFormatter(),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _buildField(
                  label: 'CVV',
                  hint: '123',
                  controller: cvvController,
                  error: cvvError,
                  keyboardType: TextInputType.number,
                  icon: Icons.lock_outline_rounded,
                  obscureText: true,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Card holder name
          _buildField(
            label: isArabic ? 'اسم حامل البطاقة' : 'Card Holder Name',
            hint: isArabic ? 'الاسم كما يظهر على البطاقة' : 'As shown on card',
            controller: holderNameController,
            error: holderNameError,
            keyboardType: TextInputType.name,
            icon: Icons.person_outline_rounded,
            textCapitalization: TextCapitalization.words,
          ),
        ],
      ),
    );
  }

  /// Builds a single form field with label, icon, and error handling.
  Widget _buildField({
    required String label,
    required String hint,
    required TextEditingController controller,
    String? error,
    TextInputType? keyboardType,
    IconData? icon,
    bool obscureText = false,
    List<TextInputFormatter>? inputFormatters,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppFonts.style(
            isArabic: isArabic,
            fontSize: AppFonts.sizeSmall,
            fontWeight: AppFonts.medium,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          inputFormatters: inputFormatters,
          textCapitalization: textCapitalization,
          style: AppFonts.style(
            isArabic: isArabic,
            fontSize: AppFonts.sizeBody,
            fontWeight: AppFonts.medium,
            color: AppColors.text,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppFonts.style(
              isArabic: isArabic,
              fontSize: AppFonts.sizeBody,
              color: AppColors.textTertiary,
            ),
            prefixIcon: icon != null
                ? Icon(icon, color: AppColors.primary, size: 20)
                : null,
            errorText: error,
            errorStyle: AppFonts.style(
              isArabic: isArabic,
              fontSize: AppFonts.sizeXSmall,
              color: AppColors.error,
            ),
            filled: true,
            fillColor: AppColors.background,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.error),
            ),
          ),
        ),
      ],
    );
  }
}

/// Formats card number with spaces every 4 digits (e.g., 1234 5678 9012 3456).
class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if ((i + 1) % 4 == 0 && i + 1 != text.length) {
        buffer.write(' ');
      }
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// Formats expiry date as MM/YY.
class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll('/', '');
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if (i == 1 && text.length > 2) {
        buffer.write('/');
      }
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

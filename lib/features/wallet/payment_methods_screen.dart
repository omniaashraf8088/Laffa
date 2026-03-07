import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/colors.dart';
import '../../core/constants/fonts.dart';
import '../../core/localization/app_strings_ar.dart';
import '../../core/localization/app_strings_en.dart';
import '../../core/localization/localization_provider.dart';

class PaymentMethodsScreen extends ConsumerStatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  ConsumerState<PaymentMethodsScreen> createState() =>
      _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends ConsumerState<PaymentMethodsScreen> {
  int _selectedIndex = 0;

  final List<_PaymentMethodData> _methods = const [
    _PaymentMethodData(
      id: 'visa_1',
      type: 'Visa',
      icon: Icons.credit_card_rounded,
      label: '**** **** **** 4532',
      sublabel: 'Expires 09/27',
    ),
    _PaymentMethodData(
      id: 'wallet',
      type: 'Wallet',
      icon: Icons.account_balance_wallet_rounded,
      label: 'Laffa Wallet',
      sublabel: '125.00 EGP',
    ),
    _PaymentMethodData(
      id: 'cash',
      type: 'Cash',
      icon: Icons.money_rounded,
      label: 'Cash',
      sublabel: 'Pay on spot',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final localization = ref.watch(localizationProvider);
    final isArabic = localization.language == AppLanguage.ar;

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
          isArabic ? AppStringsAr.paymentMethods : AppStringsEn.paymentMethods,
          style: AppFonts.title(isArabic: isArabic, color: AppColors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isArabic
                  ? AppStringsAr.selectDefaultPayment
                  : AppStringsEn.selectDefaultPayment,
              style: AppFonts.style(
                isArabic: isArabic,
                fontSize: AppFonts.sizeMedium,
                fontWeight: AppFonts.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 16),
            ...List.generate(_methods.length, (index) {
              final method = _methods[index];
              final isSelected = index == _selectedIndex;
              return _buildMethodCard(method, isSelected, isArabic, () {
                setState(() => _selectedIndex = index);
              });
            }),
            const SizedBox(height: 20),
            // Add new card button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isArabic
                            ? AppStringsAr.comingSoon
                            : AppStringsEn.comingSoon,
                      ),
                      backgroundColor: AppColors.info,
                    ),
                  );
                },
                icon: const Icon(Icons.add_rounded, size: 20),
                label: Text(
                  isArabic ? AppStringsAr.addNewCard : AppStringsEn.addNewCard,
                  style: AppFonts.label(
                    isArabic: isArabic,
                    color: AppColors.primary,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: BorderSide(
                    color: AppColors.primary.withValues(alpha: 0.4),
                    style: BorderStyle.solid,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMethodCard(
    _PaymentMethodData method,
    bool isSelected,
    bool isArabic,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderLight,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: (isSelected ? AppColors.primary : AppColors.grey)
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                method.icon,
                color: isSelected ? AppColors.primary : AppColors.grey,
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
                  const SizedBox(height: 2),
                  Text(
                    method.sublabel,
                    style: AppFonts.caption(
                      isArabic: isArabic,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle_rounded,
                color: AppColors.primary,
                size: 22,
              ),
          ],
        ),
      ),
    );
  }
}

class _PaymentMethodData {
  final String id;
  final String type;
  final IconData icon;
  final String label;
  final String sublabel;

  const _PaymentMethodData({
    required this.id,
    required this.type,
    required this.icon,
    required this.label,
    required this.sublabel,
  });
}

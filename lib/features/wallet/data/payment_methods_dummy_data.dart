import 'package:flutter/material.dart';

import '../../../core/localization/app_strings_en.dart';

/// Dummy payment method data.
/// TODO: Replace with actual API data.
class PaymentMethodData {
  final String id;
  final String type;
  final IconData icon;
  final String label;
  final String sublabel;

  const PaymentMethodData({
    required this.id,
    required this.type,
    required this.icon,
    required this.label,
    required this.sublabel,
  });
}

const List<PaymentMethodData> dummyPaymentMethods = [
  PaymentMethodData(
    id: 'visa_1',
    type: 'Visa',
    icon: Icons.credit_card_rounded,
    label: '**** **** **** 4532',
    sublabel: 'Expires 09/27',
  ),
  PaymentMethodData(
    id: 'wallet',
    type: 'Wallet',
    icon: Icons.account_balance_wallet_rounded,
    label: 'Laffa Wallet',
    // ignore: prefer_interpolation_to_compose_strings
    sublabel: '125.00 ' + AppStringsEn.currency,
  ),
  PaymentMethodData(
    id: 'cash',
    type: 'Cash',
    icon: Icons.money_rounded,
    label: 'Cash',
    sublabel: 'Pay on spot',
  ),
];

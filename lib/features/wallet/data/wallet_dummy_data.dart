import 'package:flutter/material.dart';

import '../../../core/localization/app_strings_en.dart';

/// Dummy transaction data for wallet screen.
/// TODO: Replace with actual API data.
class WalletTransaction {
  final IconData icon;
  final String titleEn;
  final String titleAr;
  final String date;
  final String amount;
  final bool isDebit;

  const WalletTransaction({
    required this.icon,
    required this.titleEn,
    required this.titleAr,
    required this.date,
    required this.amount,
    required this.isDebit,
  });

  String title(bool isArabic) => isArabic ? titleAr : titleEn;
}

const List<WalletTransaction> dummyTransactions = [
  WalletTransaction(
    icon: Icons.electric_scooter_rounded,
    titleEn: 'Ride - City Glide',
    titleAr: 'رحلة - City Glide',
    date: '2026-03-05',
    // ignore: prefer_interpolation_to_compose_strings
    amount: '-62.5 ' + AppStringsEn.currency,
    isDebit: true,
  ),
  WalletTransaction(
    icon: Icons.account_balance_wallet_rounded,
    titleEn: 'Top Up',
    titleAr: 'شحن رصيد',
    date: '2026-03-04',
    // ignore: prefer_interpolation_to_compose_strings
    amount: '+200.0 ' + AppStringsEn.currency,
    isDebit: false,
  ),
  WalletTransaction(
    icon: Icons.electric_scooter_rounded,
    titleEn: 'Ride - Metro Flash',
    titleAr: 'رحلة - Metro Flash',
    date: '2026-03-04',
    // ignore: prefer_interpolation_to_compose_strings
    amount: '-54.0 ' + AppStringsEn.currency,
    isDebit: true,
  ),
  WalletTransaction(
    icon: Icons.card_giftcard_rounded,
    titleEn: 'Coupon Discount',
    titleAr: 'كوبون خصم',
    date: '2026-03-02',
    // ignore: prefer_interpolation_to_compose_strings
    amount: '+15.0 ' + AppStringsEn.currency,
    isDebit: false,
  ),
  WalletTransaction(
    icon: Icons.electric_scooter_rounded,
    titleEn: 'Ride - Pharaoh Ride',
    titleAr: 'رحلة - Pharaoh Ride',
    date: '2026-03-01',
    // ignore: prefer_interpolation_to_compose_strings
    amount: '-100.0 ' + AppStringsEn.currency,
    isDebit: true,
  ),
];

import 'package:flutter/foundation.dart';

/// Represents a payment method stored by the user.
@immutable
class PaymentMethod {
  final String id;
  final String type; // 'card', 'wallet', 'cash'
  final String label;
  final String? lastFourDigits;
  final bool isDefault;

  const PaymentMethod({
    required this.id,
    required this.type,
    required this.label,
    this.lastFourDigits,
    this.isDefault = false,
  });

  /// Returns display text for the payment method.
  String get displayName {
    if (lastFourDigits != null) {
      return '$label •••• $lastFourDigits';
    }
    return label;
  }

  @override
  String toString() => 'PaymentMethod(id: $id, type: $type, label: $label)';
}

/// Represents a payment transaction.
@immutable
class Payment {
  final String id;
  final String bookingId;
  final double amount;
  final String currency;
  final PaymentStatus status;
  final String paymentMethodId;
  final DateTime createdAt;
  final String? transactionRef;

  const Payment({
    required this.id,
    required this.bookingId,
    required this.amount,
    this.currency = 'EGP',
    this.status = PaymentStatus.pending,
    required this.paymentMethodId,
    required this.createdAt,
    this.transactionRef,
  });

  @override
  String toString() =>
      'Payment(id: $id, amount: $amount $currency, status: $status)';
}

/// Possible statuses for a payment.
enum PaymentStatus { pending, processing, completed, failed, refunded }

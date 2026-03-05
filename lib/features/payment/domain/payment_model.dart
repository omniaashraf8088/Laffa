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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'label': label,
      'lastFourDigits': lastFourDigits,
      'isDefault': isDefault,
    };
  }

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'] as String,
      type: json['type'] as String,
      label: json['label'] as String,
      lastFourDigits: json['lastFourDigits'] as String?,
      isDefault: json['isDefault'] as bool? ?? false,
    );
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
  final String? companyId;

  const Payment({
    required this.id,
    required this.bookingId,
    required this.amount,
    this.currency = 'EGP',
    this.status = PaymentStatus.pending,
    required this.paymentMethodId,
    required this.createdAt,
    this.transactionRef,
    this.companyId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookingId': bookingId,
      'amount': amount,
      'currency': currency,
      'status': status.name,
      'paymentMethodId': paymentMethodId,
      'createdAt': createdAt.toIso8601String(),
      'transactionRef': transactionRef,
      'companyId': companyId,
    };
  }

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'] as String,
      bookingId: json['bookingId'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'EGP',
      status: PaymentStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => PaymentStatus.pending,
      ),
      paymentMethodId: json['paymentMethodId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      transactionRef: json['transactionRef'] as String?,
      companyId: json['companyId'] as String?,
    );
  }

  @override
  String toString() =>
      'Payment(id: $id, amount: $amount $currency, status: $status)';
}

/// Possible statuses for a payment.
enum PaymentStatus { pending, processing, completed, failed, refunded }

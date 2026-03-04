import '../domain/payment_model.dart';

/// Repository responsible for payment-related data operations.
/// Currently uses mock data; replace with real payment gateway in production.
class PaymentRepository {
  /// Fetches saved payment methods for the current user.
  Future<List<PaymentMethod>> getPaymentMethods() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return const [
      PaymentMethod(
        id: 'pm_1',
        type: 'card',
        label: 'Visa',
        lastFourDigits: '4242',
        isDefault: true,
      ),
      PaymentMethod(
        id: 'pm_2',
        type: 'card',
        label: 'Mastercard',
        lastFourDigits: '8888',
      ),
      PaymentMethod(id: 'pm_3', type: 'wallet', label: 'Digital Wallet'),
      PaymentMethod(id: 'pm_4', type: 'cash', label: 'Cash on Delivery'),
    ];
  }

  /// Processes a payment for a booking.
  Future<Payment> processPayment({
    required String bookingId,
    required double amount,
    required String paymentMethodId,
  }) async {
    // Simulate payment processing delay
    await Future.delayed(const Duration(seconds: 2));

    return Payment(
      id: 'pay_${DateTime.now().millisecondsSinceEpoch}',
      bookingId: bookingId,
      amount: amount,
      paymentMethodId: paymentMethodId,
      createdAt: DateTime.now(),
      status: PaymentStatus.completed,
      transactionRef: 'TXN${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  /// Validates a card number (basic Luhn check simulation).
  bool validateCardNumber(String cardNumber) {
    final cleaned = cardNumber.replaceAll(RegExp(r'\s+'), '');
    return cleaned.length >= 13 && cleaned.length <= 19;
  }

  /// Validates an expiry date string (MM/YY format).
  bool validateExpiryDate(String expiry) {
    final parts = expiry.split('/');
    if (parts.length != 2) return false;

    final month = int.tryParse(parts[0]);
    final year = int.tryParse(parts[1]);
    if (month == null || year == null) return false;
    if (month < 1 || month > 12) return false;

    final now = DateTime.now();
    final expiryDate = DateTime(2000 + year, month + 1, 0);
    return expiryDate.isAfter(now);
  }

  /// Validates a CVV code.
  bool validateCVV(String cvv) {
    return cvv.length >= 3 && cvv.length <= 4;
  }
}

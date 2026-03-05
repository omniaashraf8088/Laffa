import '../../../core/network/api_client.dart';
import '../domain/payment_model.dart';

/// Repository responsible for payment-related data operations.
/// All operations are scoped to a companyId for multi-tenant isolation.
class PaymentRepository {
  final ApiClient _apiClient;

  PaymentRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  /// Fetches saved payment methods for the current user.
  Future<List<PaymentMethod>> getPaymentMethods({
    required String companyId,
    required String userId,
  }) async {
    try {
      final response = await _apiClient.get(
        '/companies/$companyId/users/$userId/payment-methods',
      );
      final list = response['data'] as List<dynamic>? ?? [];
      return list
          .map((e) => PaymentMethod.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// Processes a payment for a booking within a company.
  Future<Payment> processPayment({
    required String companyId,
    required String bookingId,
    required double amount,
    required String paymentMethodId,
    required String currency,
  }) async {
    final response = await _apiClient.post(
      '/companies/$companyId/payments',
      body: {
        'bookingId': bookingId,
        'amount': amount,
        'paymentMethodId': paymentMethodId,
        'currency': currency,
      },
    );
    return Payment.fromJson(response);
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

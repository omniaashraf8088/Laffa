import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/injection_container.dart';
import '../../../core/network/api_client.dart';
import '../../../core/tenant/tenant_service.dart';
import '../data/payment_repository.dart';
import '../domain/payment_model.dart';

/// State for the payment feature.
class PaymentState {
  final List<PaymentMethod> paymentMethods;
  final PaymentMethod? selectedMethod;
  final Payment? lastPayment;
  final double amount;
  final String? bookingId;
  final bool isLoading;
  final bool isProcessing;
  final String? error;
  final bool paymentSuccess;

  // Card form fields state
  final String cardNumber;
  final String expiryDate;
  final String cvv;
  final String cardHolderName;

  const PaymentState({
    this.paymentMethods = const [],
    this.selectedMethod,
    this.lastPayment,
    this.amount = 0.0,
    this.bookingId,
    this.isLoading = false,
    this.isProcessing = false,
    this.error,
    this.paymentSuccess = false,
    this.cardNumber = '',
    this.expiryDate = '',
    this.cvv = '',
    this.cardHolderName = '',
  });

  PaymentState copyWith({
    List<PaymentMethod>? paymentMethods,
    PaymentMethod? selectedMethod,
    Payment? lastPayment,
    double? amount,
    String? bookingId,
    bool? isLoading,
    bool? isProcessing,
    String? error,
    bool? paymentSuccess,
    String? cardNumber,
    String? expiryDate,
    String? cvv,
    String? cardHolderName,
  }) {
    return PaymentState(
      paymentMethods: paymentMethods ?? this.paymentMethods,
      selectedMethod: selectedMethod ?? this.selectedMethod,
      lastPayment: lastPayment ?? this.lastPayment,
      amount: amount ?? this.amount,
      bookingId: bookingId ?? this.bookingId,
      isLoading: isLoading ?? this.isLoading,
      isProcessing: isProcessing ?? this.isProcessing,
      error: error,
      paymentSuccess: paymentSuccess ?? this.paymentSuccess,
      cardNumber: cardNumber ?? this.cardNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      cvv: cvv ?? this.cvv,
      cardHolderName: cardHolderName ?? this.cardHolderName,
    );
  }
}

/// Notifier that manages payment state and business logic.
class PaymentNotifier extends StateNotifier<PaymentState> {
  final PaymentRepository _repository;
  final Ref _ref;

  PaymentNotifier(this._repository, this._ref) : super(const PaymentState());

  String get _companyId => _ref.read(tenantProvider).activeCompany?.id ?? '';

  String get _userId => _ref.read(tenantProvider).currentUser?.id ?? '';

  String get _currency =>
      _ref.read(tenantProvider).activeCompany?.pricing.currency ?? 'EGP';

  /// Initializes payment with booking details and loads payment methods.
  Future<void> initialize({
    required String bookingId,
    required double amount,
  }) async {
    state = state.copyWith(
      isLoading: true,
      bookingId: bookingId,
      amount: amount,
    );

    try {
      final methods = await _repository.getPaymentMethods(
        companyId: _companyId,
        userId: _userId,
      );
      // Auto-select the default payment method
      final defaultMethod = methods.where((m) => m.isDefault).firstOrNull;

      state = state.copyWith(
        paymentMethods: methods,
        selectedMethod:
            defaultMethod ?? (methods.isNotEmpty ? methods.first : null),
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load payment methods: $e',
      );
    }
  }

  /// Selects a payment method.
  void selectPaymentMethod(PaymentMethod method) {
    state = state.copyWith(selectedMethod: method);
  }

  /// Updates card form field values.
  void updateCardNumber(String value) {
    state = state.copyWith(cardNumber: value);
  }

  void updateExpiryDate(String value) {
    state = state.copyWith(expiryDate: value);
  }

  void updateCVV(String value) {
    state = state.copyWith(cvv: value);
  }

  void updateCardHolderName(String value) {
    state = state.copyWith(cardHolderName: value);
  }

  /// Validates card details before processing.
  String? validateCardDetails() {
    if (state.selectedMethod?.type != 'card') return null;

    if (!_repository.validateCardNumber(state.cardNumber)) {
      return 'Invalid card number';
    }
    if (!_repository.validateExpiryDate(state.expiryDate)) {
      return 'Invalid expiry date';
    }
    if (!_repository.validateCVV(state.cvv)) {
      return 'Invalid CVV';
    }
    if (state.cardHolderName.trim().isEmpty) {
      return 'Card holder name is required';
    }
    return null;
  }

  /// Processes the payment.
  Future<void> processPayment() async {
    if (state.selectedMethod == null) {
      state = state.copyWith(error: 'Please select a payment method');
      return;
    }

    if (state.bookingId == null) {
      state = state.copyWith(error: 'No booking found');
      return;
    }

    state = state.copyWith(isProcessing: true, error: null);

    try {
      final payment = await _repository.processPayment(
        companyId: _companyId,
        bookingId: state.bookingId!,
        amount: state.amount,
        paymentMethodId: state.selectedMethod!.id,
        currency: _currency,
      );

      state = state.copyWith(
        lastPayment: payment,
        isProcessing: false,
        paymentSuccess: true,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(isProcessing: false, error: 'Payment failed: $e');
    }
  }

  /// Clears error state.
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Resets the entire payment state.
  void reset() {
    state = const PaymentState();
  }
}

/// Provider for payment repository.
final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  return PaymentRepository(apiClient: sl<ApiClient>());
});

/// Provider for payment state management.
final paymentProvider = StateNotifierProvider<PaymentNotifier, PaymentState>((
  ref,
) {
  final repository = ref.watch(paymentRepositoryProvider);
  return PaymentNotifier(repository, ref);
});

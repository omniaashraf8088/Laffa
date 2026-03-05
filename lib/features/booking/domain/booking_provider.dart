import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/injection_container.dart';
import '../../../core/network/api_client.dart';
import '../../../core/tenant/tenant_service.dart';
import '../data/booking_repository.dart';
import '../domain/booking_model.dart';

/// State for the booking feature.
class BookingState {
  final List<Bike> availableBikes;
  final Bike? selectedBike;
  final Booking? currentBooking;
  final int estimatedMinutes;
  final bool isLoading;
  final String? error;
  final String? stationName;
  final String? stationId;

  const BookingState({
    this.availableBikes = const [],
    this.selectedBike,
    this.currentBooking,
    this.estimatedMinutes = 30,
    this.isLoading = false,
    this.error,
    this.stationName,
    this.stationId,
  });

  BookingState copyWith({
    List<Bike>? availableBikes,
    Bike? selectedBike,
    Booking? currentBooking,
    int? estimatedMinutes,
    bool? isLoading,
    String? error,
    String? stationName,
    String? stationId,
  }) {
    return BookingState(
      availableBikes: availableBikes ?? this.availableBikes,
      selectedBike: selectedBike ?? this.selectedBike,
      currentBooking: currentBooking ?? this.currentBooking,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      stationName: stationName ?? this.stationName,
      stationId: stationId ?? this.stationId,
    );
  }
}

/// Notifier that manages booking state and business logic.
/// All operations are scoped to the active company.
class BookingNotifier extends StateNotifier<BookingState> {
  final BookingRepository _repository;
  final Ref _ref;

  BookingNotifier(this._repository, this._ref) : super(const BookingState());

  String get _companyId {
    final id = _ref.read(tenantProvider).activeCompanyId;
    if (id == null) throw StateError('No active company');
    return id;
  }

  /// Loads available bikes for a station (scoped to active company).
  Future<void> loadBikes({
    required String stationId,
    required String stationName,
  }) async {
    state = state.copyWith(
      isLoading: true,
      stationId: stationId,
      stationName: stationName,
    );

    try {
      final bikes = await _repository.getAvailableBikes(
        companyId: _companyId,
        stationId: stationId,
      );
      state = state.copyWith(
        availableBikes: bikes,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load bikes: $e',
      );
    }
  }

  /// Selects a bike for booking.
  void selectBike(Bike bike) {
    state = state.copyWith(selectedBike: bike);
  }

  /// Updates the estimated ride duration.
  void updateEstimatedMinutes(int minutes) {
    state = state.copyWith(estimatedMinutes: minutes);
  }

  /// Confirms the booking for the selected bike.
  /// Uses company pricing for cost calculation.
  Future<void> confirmBooking() async {
    final bike = state.selectedBike;
    if (bike == null) {
      state = state.copyWith(error: 'No bike selected');
      return;
    }

    // Check subscription
    final tenantState = _ref.read(tenantProvider);
    if (!tenantState.canCreateRides) {
      state = state.copyWith(
        error: 'Rides are currently disabled for this company',
      );
      return;
    }

    final pricing = tenantState.activeCompany?.pricing;
    final pricePerMinute = pricing?.pricePerMinute ?? bike.pricePerMinute;
    final unlockFee = pricing?.unlockFee ?? 0.0;

    state = state.copyWith(isLoading: true);

    try {
      final booking = await _repository.createBooking(
        companyId: _companyId,
        bikeId: bike.id,
        bikeName: bike.name,
        bikeType: bike.type,
        stationName: state.stationName ?? 'Unknown Station',
        pricePerMinute: pricePerMinute,
        estimatedMinutes: state.estimatedMinutes,
        unlockFee: unlockFee,
      );

      state = state.copyWith(
        currentBooking: booking,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to create booking: $e',
      );
    }
  }

  /// Cancels the current booking.
  Future<void> cancelBooking() async {
    final booking = state.currentBooking;
    if (booking == null) return;

    state = state.copyWith(isLoading: true);

    try {
      await _repository.cancelBooking(
        companyId: _companyId,
        bookingId: booking.id,
      );
      state = const BookingState();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to cancel booking: $e',
      );
    }
  }

  /// Clears error state.
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Resets the entire booking state.
  void reset() {
    state = const BookingState();
  }
}

/// Provider for booking repository.
final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  return BookingRepository(apiClient: sl<ApiClient>());
});

/// Provider for booking state management.
final bookingProvider = StateNotifierProvider<BookingNotifier, BookingState>((
  ref,
) {
  final repository = ref.watch(bookingRepositoryProvider);
  return BookingNotifier(repository, ref);
});

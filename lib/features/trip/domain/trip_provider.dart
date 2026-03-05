import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/injection_container.dart';
import '../../../core/network/api_client.dart';
import '../../../core/tenant/tenant_service.dart';
import '../data/trip_repository.dart';
import '../domain/trip_model.dart';

/// State for the trip feature (start trip, active trip, end trip).
class TripState {
  final Trip? activeTrip;
  final Trip? completedTrip;
  final List<Trip> tripHistory;
  final bool isLoading;
  final bool isEnding;
  final String? error;

  const TripState({
    this.activeTrip,
    this.completedTrip,
    this.tripHistory = const [],
    this.isLoading = false,
    this.isEnding = false,
    this.error,
  });

  TripState copyWith({
    Trip? activeTrip,
    Trip? completedTrip,
    List<Trip>? tripHistory,
    bool? isLoading,
    bool? isEnding,
    String? error,
  }) {
    return TripState(
      activeTrip: activeTrip ?? this.activeTrip,
      completedTrip: completedTrip ?? this.completedTrip,
      tripHistory: tripHistory ?? this.tripHistory,
      isLoading: isLoading ?? this.isLoading,
      isEnding: isEnding ?? this.isEnding,
      error: error,
    );
  }
}

/// Notifier that manages trip state and business logic.
/// All operations are scoped to the active company.
class TripNotifier extends StateNotifier<TripState> {
  final TripRepository _repository;
  final Ref _ref;

  TripNotifier(this._repository, this._ref) : super(const TripState());

  String get _companyId {
    final id = _ref.read(tenantProvider).activeCompanyId;
    if (id == null) throw StateError('No active company');
    return id;
  }

  /// Starts a new trip (scoped to active company).
  Future<void> startTrip({
    required String bikeId,
    required String bikeName,
    required String bikeType,
    required String stationName,
  }) async {
    // Check subscription status
    final tenantState = _ref.read(tenantProvider);
    if (!tenantState.canCreateRides) {
      state = state.copyWith(
        error: 'Rides are currently disabled for this company',
      );
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final trip = await _repository.startTrip(
        companyId: _companyId,
        bikeId: bikeId,
        bikeName: bikeName,
        bikeType: bikeType,
        stationName: stationName,
      );

      state = TripState(activeTrip: trip);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to start trip: $e',
      );
    }
  }

  /// Ends the active trip (scoped to active company).
  Future<void> endTrip() async {
    final trip = state.activeTrip;
    if (trip == null) {
      state = state.copyWith(error: 'No active trip to end');
      return;
    }

    state = state.copyWith(isEnding: true, error: null);

    try {
      final completedTrip = await _repository.endTrip(
        companyId: _companyId,
        trip: trip,
      );

      state = TripState(
        activeTrip: null,
        completedTrip: completedTrip,
        tripHistory: [completedTrip, ...state.tripHistory],
      );
    } catch (e) {
      state = state.copyWith(isEnding: false, error: 'Failed to end trip: $e');
    }
  }

  /// Sets the active trip directly (e.g., from a booking confirmation).
  void setActiveTrip(Trip trip) {
    state = TripState(activeTrip: trip);
  }

  /// Clears the completed trip reference (after navigating to rating).
  void clearCompletedTrip() {
    state = state.copyWith(completedTrip: null);
  }

  /// Clears error state.
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Resets the entire trip state.
  void reset() {
    state = const TripState();
  }
}

/// Provider for trip repository.
final tripRepositoryProvider = Provider<TripRepository>((ref) {
  return TripRepository(apiClient: sl<ApiClient>());
});

/// Provider for trip state management.
final tripProvider = StateNotifierProvider<TripNotifier, TripState>((ref) {
  final repository = ref.watch(tripRepositoryProvider);
  return TripNotifier(repository, ref);
});

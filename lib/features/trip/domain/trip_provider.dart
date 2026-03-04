import 'package:flutter_riverpod/flutter_riverpod.dart';

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
class TripNotifier extends StateNotifier<TripState> {
  final TripRepository _repository;

  TripNotifier(this._repository) : super(const TripState());

  /// Starts a new trip with the given bike and station info.
  Future<void> startTrip({
    required String bikeId,
    required String bikeName,
    required String bikeType,
    required String stationName,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final trip = await _repository.startTrip(
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

  /// Ends the active trip.
  Future<void> endTrip() async {
    final trip = state.activeTrip;
    if (trip == null) {
      state = state.copyWith(error: 'No active trip to end');
      return;
    }

    state = state.copyWith(isEnding: true, error: null);

    try {
      final completedTrip = await _repository.endTrip(trip);

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
  return TripRepository();
});

/// Provider for trip state management.
final tripProvider = StateNotifierProvider<TripNotifier, TripState>((ref) {
  final repository = ref.watch(tripRepositoryProvider);
  return TripNotifier(repository);
});

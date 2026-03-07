import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/scooter_finder_repository.dart';
import 'find_best_scooter_usecase.dart';
import 'scooter_suggestion_model.dart';

// ── Dummy scooter data (mirrors ride_provider scooters) ──────────
List<ScooterSuggestion> _dummyScooters() {
  return const [
    ScooterSuggestion(
      id: 'SCT-001',
      name: 'City Glide',
      batteryLevel: 0.85,
      pricePerMinute: 2.5,
      latitude: 30.0444,
      longitude: 31.2357,
    ),
    ScooterSuggestion(
      id: 'SCT-002',
      name: 'Urban Swift',
      batteryLevel: 0.62,
      pricePerMinute: 2.0,
      latitude: 30.0500,
      longitude: 31.2400,
    ),
    ScooterSuggestion(
      id: 'SCT-003',
      name: 'Metro Flash',
      batteryLevel: 0.93,
      pricePerMinute: 3.0,
      latitude: 30.0350,
      longitude: 31.2500,
    ),
    ScooterSuggestion(
      id: 'SCT-004',
      name: 'Nile Cruiser',
      batteryLevel: 0.41,
      pricePerMinute: 1.5,
      latitude: 30.0600,
      longitude: 31.2200,
    ),
    ScooterSuggestion(
      id: 'SCT-005',
      name: 'Pharaoh Ride',
      batteryLevel: 0.78,
      pricePerMinute: 2.5,
      latitude: 30.0300,
      longitude: 31.2300,
    ),
  ];
}

// ── State ─────────────────────────────────────────────────────────
class ScooterFinderState {
  final bool isEnabled;
  final bool isDismissed;
  final ScooterSuggestion? suggestion;

  const ScooterFinderState({
    this.isEnabled = false,
    this.isDismissed = false,
    this.suggestion,
  });

  ScooterFinderState copyWith({
    bool? isEnabled,
    bool? isDismissed,
    ScooterSuggestion? suggestion,
    bool clearSuggestion = false,
  }) {
    return ScooterFinderState(
      isEnabled: isEnabled ?? this.isEnabled,
      isDismissed: isDismissed ?? this.isDismissed,
      suggestion: clearSuggestion ? null : (suggestion ?? this.suggestion),
    );
  }

  /// Whether to show the suggestion card on the map.
  bool get showCard => isEnabled && !isDismissed && suggestion != null;
}

// ── Notifier ──────────────────────────────────────────────────────
class ScooterFinderNotifier extends StateNotifier<ScooterFinderState> {
  ScooterFinderNotifier() : super(const ScooterFinderState());

  final _useCase = FindBestScooterUseCase(ScooterFinderRepository());

  /// Toggle smart suggestions on / off.
  void toggle() {
    final newEnabled = !state.isEnabled;
    if (newEnabled) {
      state = state.copyWith(isEnabled: true, isDismissed: false);
    } else {
      state = state.copyWith(
        isEnabled: false,
        isDismissed: false,
        clearSuggestion: true,
      );
    }
  }

  /// Refresh the suggestion based on the user's current location.
  void refresh({required double userLat, required double userLng}) {
    if (!state.isEnabled) return;

    final best = _useCase(
      userLat: userLat,
      userLng: userLng,
      availableScooters: _dummyScooters(),
    );

    state = state.copyWith(suggestion: best, isDismissed: false);
  }

  /// User tapped "Ignore" — hide the card until next refresh.
  void dismiss() {
    state = state.copyWith(isDismissed: true);
  }

  /// Reset dismissed state (e.g. when user moves significantly).
  void resetDismissed() {
    state = state.copyWith(isDismissed: false);
  }
}

final scooterFinderProvider =
    StateNotifierProvider<ScooterFinderNotifier, ScooterFinderState>(
      (ref) => ScooterFinderNotifier(),
    );

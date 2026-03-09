import 'dart:math';

import 'models/scooter_suggestion_model.dart';

/// Repository that fetches and ranks scooters for smart suggestions.
/// In production this would call a backend API; here it uses local data.
class ScooterFinderRepository {
  /// Returns the single best nearby scooter based on battery, distance, and price.
  ScooterSuggestion? findBestScooter({
    required double userLat,
    required double userLng,
    required List<ScooterSuggestion> availableScooters,
  }) {
    if (availableScooters.isEmpty) return null;

    // Score each scooter: lower distance + higher battery = better
    ScooterSuggestion? best;
    double bestScore = double.negativeInfinity;

    for (final scooter in availableScooters) {
      final distKm = _haversine(
        userLat,
        userLng,
        scooter.latitude,
        scooter.longitude,
      );
      // Score: battery weight (0–100) minus distance penalty (* 20)
      final score = (scooter.batteryPercent) - (distKm * 20);
      if (score > bestScore) {
        bestScore = score;
        best = scooter.copyWith(distanceKm: distKm);
      }
    }
    return best;
  }

  double _haversine(double lat1, double lon1, double lat2, double lon2) {
    const r = 6371.0;
    final dLat = _toRad(lat2 - lat1);
    final dLon = _toRad(lon2 - lon1);
    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRad(lat1)) * cos(_toRad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
    return r * 2 * atan2(sqrt(a), sqrt(1 - a));
  }

  double _toRad(double deg) => deg * pi / 180;
}

import 'package:flutter/foundation.dart';

/// A scooter that can be suggested to the user.
@immutable
class ScooterSuggestion {
  final String id;
  final String name;
  final double batteryLevel; // 0.0 – 1.0
  final double pricePerMinute;
  final double latitude;
  final double longitude;
  final double distanceKm;

  const ScooterSuggestion({
    required this.id,
    required this.name,
    required this.batteryLevel,
    required this.pricePerMinute,
    required this.latitude,
    required this.longitude,
    this.distanceKm = 0.0,
  });

  int get batteryPercent => (batteryLevel * 100).round();

  String get batteryDisplay => '$batteryPercent%';

  String get distanceDisplay => distanceKm < 1
      ? '${(distanceKm * 1000).round()} m'
      : '${distanceKm.toStringAsFixed(1)} km';

  String get estimatedCostDisplay {
    // Estimate a 15-minute ride cost
    final cost = pricePerMinute * 15;
    return '~${cost.toStringAsFixed(0)} EGP';
  }

  ScooterSuggestion copyWith({double? distanceKm}) {
    return ScooterSuggestion(
      id: id,
      name: name,
      batteryLevel: batteryLevel,
      pricePerMinute: pricePerMinute,
      latitude: latitude,
      longitude: longitude,
      distanceKm: distanceKm ?? this.distanceKm,
    );
  }
}

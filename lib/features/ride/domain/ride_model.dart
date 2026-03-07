import 'package:flutter/foundation.dart';

/// Represents a scooter available for riding.
@immutable
class Scooter {
  final String id;
  final String name;
  final double batteryLevel; // 0.0 to 1.0
  final double pricePerMinute;
  final double latitude;
  final double longitude;
  final bool isAvailable;

  const Scooter({
    required this.id,
    required this.name,
    required this.batteryLevel,
    required this.pricePerMinute,
    required this.latitude,
    required this.longitude,
    this.isAvailable = true,
  });

  int get batteryPercent => (batteryLevel * 100).round();

  String get batteryDisplay => '$batteryPercent%';

  String get priceDisplay => '${pricePerMinute.toStringAsFixed(1)} EGP/min';

  @override
  String toString() =>
      'Scooter(id: $id, name: $name, battery: $batteryDisplay)';
}

/// Represents the state of an active ride.
enum RideStatus {
  idle,
  scanning,
  unlocking,
  active,
  paused,
  finishing,
  completed,
  cancelled,
}

/// Represents a ride session from unlock to completion.
@immutable
class RideSession {
  final String id;
  final Scooter scooter;
  final DateTime startTime;
  final DateTime? endTime;
  final double distanceKm;
  final double totalCost;
  final RideStatus status;
  final List<RideRoutePoint> routePoints;

  const RideSession({
    required this.id,
    required this.scooter,
    required this.startTime,
    this.endTime,
    this.distanceKm = 0.0,
    this.totalCost = 0.0,
    this.status = RideStatus.active,
    this.routePoints = const [],
  });

  Duration get duration {
    final end = endTime ?? DateTime.now();
    return end.difference(startTime);
  }

  String get formattedDuration {
    final d = duration;
    final hours = d.inHours.toString().padLeft(2, '0');
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    if (d.inHours > 0) return '$hours:$minutes:$seconds';
    return '$minutes:$seconds';
  }

  double get estimatedCost => duration.inSeconds * scooter.pricePerMinute / 60;

  double get serviceFee => estimatedCost * 0.1; // 10% service fee

  double get grandTotal => estimatedCost + serviceFee;

  RideSession copyWith({
    DateTime? endTime,
    double? distanceKm,
    double? totalCost,
    RideStatus? status,
    List<RideRoutePoint>? routePoints,
  }) {
    return RideSession(
      id: id,
      scooter: scooter,
      startTime: startTime,
      endTime: endTime ?? this.endTime,
      distanceKm: distanceKm ?? this.distanceKm,
      totalCost: totalCost ?? this.totalCost,
      status: status ?? this.status,
      routePoints: routePoints ?? this.routePoints,
    );
  }
}

/// A point on the ride route for drawing the path.
@immutable
class RideRoutePoint {
  final double latitude;
  final double longitude;
  final DateTime timestamp;

  const RideRoutePoint({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });
}

/// Model for trip history items.
@immutable
class RideHistoryItem {
  final String id;
  final String scooterId;
  final String scooterName;
  final DateTime date;
  final Duration duration;
  final double distanceKm;
  final double cost;
  final RideHistoryStatus status;

  const RideHistoryItem({
    required this.id,
    required this.scooterId,
    required this.scooterName,
    required this.date,
    required this.duration,
    required this.distanceKm,
    required this.cost,
    required this.status,
  });

  String get formattedDuration {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours > 0) return '${hours}h ${minutes}m';
    return '${minutes}m';
  }

  String get formattedDate {
    final d = date;
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  String get formattedDistance => '${distanceKm.toStringAsFixed(1)} km';

  String get formattedCost => '${cost.toStringAsFixed(1)} EGP';
}

enum RideHistoryStatus { completed, cancelled }

import 'package:flutter/foundation.dart';

/// Represents a full trip from start to end.
@immutable
class Trip {
  final String id;
  final String bikeId;
  final String bikeName;
  final String bikeType;
  final String startStation;
  final String? endStation;
  final DateTime startTime;
  final DateTime? endTime;
  final double distanceKm;
  final double cost;
  final TripStatus status;

  const Trip({
    required this.id,
    required this.bikeId,
    required this.bikeName,
    required this.bikeType,
    required this.startStation,
    this.endStation,
    required this.startTime,
    this.endTime,
    this.distanceKm = 0.0,
    this.cost = 0.0,
    this.status = TripStatus.active,
  });

  /// Returns the trip duration. If still active, calculates from now.
  Duration get duration {
    final end = endTime ?? DateTime.now();
    return end.difference(startTime);
  }

  /// Returns the duration formatted as HH:MM:SS.
  String get formattedDuration {
    final d = duration;
    final hours = d.inHours.toString().padLeft(2, '0');
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    if (d.inHours > 0) {
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  /// Returns a copy of this trip with updated fields.
  Trip copyWith({
    String? endStation,
    DateTime? endTime,
    double? distanceKm,
    double? cost,
    TripStatus? status,
  }) {
    return Trip(
      id: id,
      bikeId: bikeId,
      bikeName: bikeName,
      bikeType: bikeType,
      startStation: startStation,
      endStation: endStation ?? this.endStation,
      startTime: startTime,
      endTime: endTime ?? this.endTime,
      distanceKm: distanceKm ?? this.distanceKm,
      cost: cost ?? this.cost,
      status: status ?? this.status,
    );
  }

  @override
  String toString() =>
      'Trip(id: $id, bike: $bikeName, status: $status, distance: $distanceKm km)';
}

/// Possible statuses for a trip.
enum TripStatus { active, paused, completed, cancelled }

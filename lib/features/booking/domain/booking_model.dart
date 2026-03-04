import 'package:flutter/foundation.dart';

/// Represents a bike available for booking at a station.
@immutable
class Bike {
  final String id;
  final String name;
  final String type; // 'electric', 'standard', 'premium'
  final double pricePerMinute;
  final double batteryLevel; // 0.0 to 1.0 for electric bikes
  final bool isAvailable;
  final String? imageUrl;

  const Bike({
    required this.id,
    required this.name,
    required this.type,
    required this.pricePerMinute,
    this.batteryLevel = 1.0,
    this.isAvailable = true,
    this.imageUrl,
  });

  /// Returns a display-friendly type name.
  String get displayType {
    switch (type) {
      case 'electric':
        return 'Electric';
      case 'premium':
        return 'Premium';
      default:
        return 'Standard';
    }
  }

  /// Returns battery percentage as integer (0-100).
  int get batteryPercent => (batteryLevel * 100).round();

  @override
  String toString() => 'Bike(id: $id, name: $name, type: $type)';
}

/// Represents a booking made by the user.
@immutable
class Booking {
  final String id;
  final String bikeId;
  final String bikeName;
  final String bikeType;
  final String stationName;
  final double pricePerMinute;
  final DateTime createdAt;
  final BookingStatus status;
  final int estimatedMinutes;

  const Booking({
    required this.id,
    required this.bikeId,
    required this.bikeName,
    required this.bikeType,
    required this.stationName,
    required this.pricePerMinute,
    required this.createdAt,
    this.status = BookingStatus.pending,
    this.estimatedMinutes = 30,
  });

  /// Calculates the estimated total cost.
  double get estimatedCost => pricePerMinute * estimatedMinutes;

  @override
  String toString() => 'Booking(id: $id, bike: $bikeName, status: $status)';
}

/// Possible statuses for a booking.
enum BookingStatus { pending, confirmed, active, completed, cancelled }

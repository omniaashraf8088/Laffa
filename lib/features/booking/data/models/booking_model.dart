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
  final String? companyId;

  const Bike({
    required this.id,
    required this.name,
    required this.type,
    required this.pricePerMinute,
    this.batteryLevel = 1.0,
    this.isAvailable = true,
    this.imageUrl,
    this.companyId,
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'pricePerMinute': pricePerMinute,
      'batteryLevel': batteryLevel,
      'isAvailable': isAvailable,
      'imageUrl': imageUrl,
      'companyId': companyId,
    };
  }

  factory Bike.fromJson(Map<String, dynamic> json) {
    return Bike(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      pricePerMinute: (json['pricePerMinute'] as num).toDouble(),
      batteryLevel: (json['batteryLevel'] as num?)?.toDouble() ?? 1.0,
      isAvailable: json['isAvailable'] as bool? ?? true,
      imageUrl: json['imageUrl'] as String?,
      companyId: json['companyId'] as String?,
    );
  }

  Bike copyWith({
    String? id,
    String? name,
    String? type,
    double? pricePerMinute,
    double? batteryLevel,
    bool? isAvailable,
    String? imageUrl,
    String? companyId,
  }) {
    return Bike(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      pricePerMinute: pricePerMinute ?? this.pricePerMinute,
      batteryLevel: batteryLevel ?? this.batteryLevel,
      isAvailable: isAvailable ?? this.isAvailable,
      imageUrl: imageUrl ?? this.imageUrl,
      companyId: companyId ?? this.companyId,
    );
  }

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
  final String? companyId;
  final double unlockFee;

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
    this.companyId,
    this.unlockFee = 0.0,
  });

  /// Calculates the estimated total cost (unlock fee + ride cost).
  double get estimatedCost => unlockFee + (pricePerMinute * estimatedMinutes);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bikeId': bikeId,
      'bikeName': bikeName,
      'bikeType': bikeType,
      'stationName': stationName,
      'pricePerMinute': pricePerMinute,
      'createdAt': createdAt.toIso8601String(),
      'status': status.name,
      'estimatedMinutes': estimatedMinutes,
      'companyId': companyId,
      'unlockFee': unlockFee,
    };
  }

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as String,
      bikeId: json['bikeId'] as String,
      bikeName: json['bikeName'] as String,
      bikeType: json['bikeType'] as String,
      stationName: json['stationName'] as String,
      pricePerMinute: (json['pricePerMinute'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      status: BookingStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => BookingStatus.pending,
      ),
      estimatedMinutes: json['estimatedMinutes'] as int? ?? 30,
      companyId: json['companyId'] as String?,
      unlockFee: (json['unlockFee'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Booking copyWith({
    String? id,
    String? bikeId,
    String? bikeName,
    String? bikeType,
    String? stationName,
    double? pricePerMinute,
    DateTime? createdAt,
    BookingStatus? status,
    int? estimatedMinutes,
    String? companyId,
    double? unlockFee,
  }) {
    return Booking(
      id: id ?? this.id,
      bikeId: bikeId ?? this.bikeId,
      bikeName: bikeName ?? this.bikeName,
      bikeType: bikeType ?? this.bikeType,
      stationName: stationName ?? this.stationName,
      pricePerMinute: pricePerMinute ?? this.pricePerMinute,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      companyId: companyId ?? this.companyId,
      unlockFee: unlockFee ?? this.unlockFee,
    );
  }

  @override
  String toString() => 'Booking(id: $id, bike: $bikeName, status: $status)';
}

/// Possible statuses for a booking.
enum BookingStatus { pending, confirmed, active, completed, cancelled }

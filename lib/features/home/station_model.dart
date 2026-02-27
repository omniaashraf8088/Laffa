import 'package:flutter/foundation.dart';

@immutable
class Station {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final int availableScooters;

  const Station({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.availableScooters,
  });

  @override
  String toString() =>
      'Station(id: $id, name: $name, lat: $latitude, lng: $longitude, scooters: $availableScooters)';
}

@immutable
class UserLocation {
  final double latitude;
  final double longitude;

  const UserLocation({required this.latitude, required this.longitude});

  @override
  String toString() => 'UserLocation(lat: $latitude, lng: $longitude)';
}

@immutable
class ActiveTrip {
  final String tripId;
  final String stationName;
  final DateTime startTime;
  final double distance; // in km

  const ActiveTrip({
    required this.tripId,
    required this.stationName,
    required this.startTime,
    this.distance = 0.0,
  });

  Duration get duration => DateTime.now().difference(startTime);

  @override
  String toString() =>
      'ActiveTrip(tripId: $tripId, station: $stationName, distance: $distance km)';
}

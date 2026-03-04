import '../domain/trip_model.dart';

/// Repository responsible for trip-related data operations.
/// Currently uses mock data; replace with real API calls in production.
class TripRepository {
  /// Starts a new trip with the given bike and station.
  Future<Trip> startTrip({
    required String bikeId,
    required String bikeName,
    required String bikeType,
    required String stationName,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    return Trip(
      id: 'trip_${DateTime.now().millisecondsSinceEpoch}',
      bikeId: bikeId,
      bikeName: bikeName,
      bikeType: bikeType,
      startStation: stationName,
      startTime: DateTime.now(),
      status: TripStatus.active,
    );
  }

  /// Ends the current trip and calculates final cost.
  Future<Trip> endTrip(Trip trip) async {
    await Future.delayed(const Duration(seconds: 1));

    final endTime = DateTime.now();
    final durationMinutes = endTime.difference(trip.startTime).inMinutes;

    // Simulated cost calculation: base rate depends on bike type
    double rate;
    switch (trip.bikeType) {
      case 'premium':
        rate = 5.0;
        break;
      case 'electric':
        rate = 3.5;
        break;
      default:
        rate = 2.0;
    }

    final cost = durationMinutes * rate;
    // Simulated distance: ~0.3 km per minute average
    final distance = durationMinutes * 0.3;

    return trip.copyWith(
      endStation: trip.startStation, // Same station for demo
      endTime: endTime,
      distanceKm: distance,
      cost: cost,
      status: TripStatus.completed,
    );
  }

  /// Fetches trip history for the current user.
  Future<List<Trip>> getTripHistory() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return []; // Empty for now; populated after real trips
  }
}

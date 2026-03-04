import '../domain/booking_model.dart';

/// Repository responsible for booking-related data operations.
/// Currently uses mock data; replace with real API calls in production.
class BookingRepository {
  /// Fetches available bikes for a given station.
  Future<List<Bike>> getAvailableBikes(String stationId) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 800));

    return _mockBikes;
  }

  /// Creates a new booking for the selected bike.
  Future<Booking> createBooking({
    required String bikeId,
    required String bikeName,
    required String bikeType,
    required String stationName,
    required double pricePerMinute,
    required int estimatedMinutes,
  }) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));

    return Booking(
      id: 'bk_${DateTime.now().millisecondsSinceEpoch}',
      bikeId: bikeId,
      bikeName: bikeName,
      bikeType: bikeType,
      stationName: stationName,
      pricePerMinute: pricePerMinute,
      createdAt: DateTime.now(),
      status: BookingStatus.confirmed,
      estimatedMinutes: estimatedMinutes,
    );
  }

  /// Cancels an existing booking.
  Future<bool> cancelBooking(String bookingId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }
}

/// Mock bikes data for development.
const List<Bike> _mockBikes = [
  Bike(
    id: 'bike_1',
    name: 'City Cruiser',
    type: 'standard',
    pricePerMinute: 2.5,
    batteryLevel: 1.0,
  ),
  Bike(
    id: 'bike_2',
    name: 'E-Rider Pro',
    type: 'electric',
    pricePerMinute: 4.0,
    batteryLevel: 0.85,
  ),
  Bike(
    id: 'bike_3',
    name: 'Urban Swift',
    type: 'electric',
    pricePerMinute: 3.5,
    batteryLevel: 0.62,
  ),
  Bike(
    id: 'bike_4',
    name: 'Latte Express',
    type: 'premium',
    pricePerMinute: 5.0,
    batteryLevel: 0.95,
  ),
  Bike(
    id: 'bike_5',
    name: 'Eco Glide',
    type: 'standard',
    pricePerMinute: 2.0,
    batteryLevel: 1.0,
  ),
];

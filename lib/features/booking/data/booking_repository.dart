import '../../../core/network/api_client.dart';
import '../domain/booking_model.dart';

/// Repository responsible for booking-related data operations.
/// All operations are scoped to a companyId for multi-tenant isolation.
class BookingRepository {
  final ApiClient _apiClient;

  BookingRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  /// Fetches available bikes for a given station within a company.
  Future<List<Bike>> getAvailableBikes({
    required String companyId,
    required String stationId,
  }) async {
    try {
      final response = await _apiClient.get(
        '/companies/$companyId/stations/$stationId/bikes',
      );
      final list = response['data'] as List<dynamic>? ?? [];
      return list.map((e) => Bike.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  /// Creates a new booking scoped to a company.
  Future<Booking> createBooking({
    required String companyId,
    required String bikeId,
    required String bikeName,
    required String bikeType,
    required String stationName,
    required double pricePerMinute,
    required int estimatedMinutes,
    required double unlockFee,
  }) async {
    final response = await _apiClient.post(
      '/companies/$companyId/bookings',
      body: {
        'bikeId': bikeId,
        'bikeName': bikeName,
        'bikeType': bikeType,
        'stationName': stationName,
        'pricePerMinute': pricePerMinute,
        'estimatedMinutes': estimatedMinutes,
        'unlockFee': unlockFee,
      },
    );
    return Booking.fromJson(response);
  }

  /// Cancels an existing booking within a company.
  Future<bool> cancelBooking({
    required String companyId,
    required String bookingId,
  }) async {
    try {
      await _apiClient.delete('/companies/$companyId/bookings/$bookingId');
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Fetches booking history for a user within a company.
  Future<List<Booking>> getBookingHistory({
    required String companyId,
    required String userId,
  }) async {
    try {
      final response = await _apiClient.get(
        '/companies/$companyId/users/$userId/bookings',
      );
      final list = response['data'] as List<dynamic>? ?? [];
      return list
          .map((e) => Booking.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }
}

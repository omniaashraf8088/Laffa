import '../../../core/network/api_client.dart';
import '../domain/trip_model.dart';

/// Repository responsible for trip-related data operations.
/// All operations are scoped to a companyId for multi-tenant isolation.
class TripRepository {
  final ApiClient _apiClient;

  TripRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  /// Starts a new trip within a company.
  Future<Trip> startTrip({
    required String companyId,
    required String bikeId,
    required String bikeName,
    required String bikeType,
    required String stationName,
  }) async {
    final response = await _apiClient.post(
      '/companies/$companyId/rides',
      body: {
        'bikeId': bikeId,
        'bikeName': bikeName,
        'bikeType': bikeType,
        'startStation': stationName,
      },
    );
    return Trip.fromJson(response);
  }

  /// Ends the current trip within a company.
  Future<Trip> endTrip({required String companyId, required Trip trip}) async {
    final response = await _apiClient.put(
      '/companies/$companyId/rides/${trip.id}/end',
    );
    return Trip.fromJson(response);
  }

  /// Fetches trip history for a user within a company.
  Future<List<Trip>> getTripHistory({
    required String companyId,
    required String userId,
  }) async {
    try {
      final response = await _apiClient.get(
        '/companies/$companyId/users/$userId/rides',
      );
      final list = response['data'] as List<dynamic>? ?? [];
      return list.map((e) => Trip.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  /// Fetches all active rides for a company (admin use).
  Future<List<Trip>> getActiveRides({required String companyId}) async {
    try {
      final response = await _apiClient.get(
        '/companies/$companyId/rides?status=active',
      );
      final list = response['data'] as List<dynamic>? ?? [];
      return list.map((e) => Trip.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  /// Fetches ride statistics for a company (admin dashboard).
  Future<Map<String, dynamic>> getRideStats({required String companyId}) async {
    try {
      return await _apiClient.get('/companies/$companyId/rides/stats');
    } catch (_) {
      return {};
    }
  }
}

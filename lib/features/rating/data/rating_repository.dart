import '../../../core/network/api_client.dart';
import '../domain/rating_model.dart';

/// Repository responsible for rating-related data operations.
/// All operations are scoped to a companyId for multi-tenant isolation.
class RatingRepository {
  final ApiClient _apiClient;

  RatingRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  /// Submits a rating for a completed trip within a company.
  Future<Rating> submitRating({
    required String companyId,
    required String tripId,
    required int stars,
    String? comment,
    List<String> tags = const [],
  }) async {
    final response = await _apiClient.post(
      '/companies/$companyId/ratings',
      body: {
        'tripId': tripId,
        'stars': stars,
        'comment': comment,
        'tags': tags,
      },
    );
    return Rating.fromJson(response);
  }

  /// Fetches the user's average rating across all trips within a company.
  Future<double> getUserAverageRating({
    required String companyId,
    required String userId,
  }) async {
    final response = await _apiClient.get(
      '/companies/$companyId/users/$userId/ratings/average',
    );
    return (response['average'] as num?)?.toDouble() ?? 0.0;
  }

  /// Fetches all ratings for a specific trip.
  Future<List<Rating>> getTripRatings({
    required String companyId,
    required String tripId,
  }) async {
    try {
      final response = await _apiClient.get(
        '/companies/$companyId/trips/$tripId/ratings',
      );
      final list = response['data'] as List<dynamic>? ?? [];
      return list
          .map((e) => Rating.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// Fetches rating history for a user within a company.
  Future<List<Rating>> getUserRatings({
    required String companyId,
    required String userId,
  }) async {
    try {
      final response = await _apiClient.get(
        '/companies/$companyId/users/$userId/ratings',
      );
      final list = response['data'] as List<dynamic>? ?? [];
      return list
          .map((e) => Rating.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }
}

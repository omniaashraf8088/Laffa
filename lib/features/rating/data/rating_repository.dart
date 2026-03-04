import '../domain/rating_model.dart';

/// Repository responsible for rating-related data operations.
/// Currently uses mock data; replace with real API calls in production.
class RatingRepository {
  /// Submits a rating for a completed trip.
  Future<Rating> submitRating({
    required String tripId,
    required int stars,
    String? comment,
    List<String> tags = const [],
  }) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));

    return Rating(
      id: 'rat_${DateTime.now().millisecondsSinceEpoch}',
      tripId: tripId,
      stars: stars,
      comment: comment,
      createdAt: DateTime.now(),
      tags: tags,
    );
  }

  /// Fetches the user's average rating across all trips.
  Future<double> getUserAverageRating() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return 4.5; // Mock average
  }
}

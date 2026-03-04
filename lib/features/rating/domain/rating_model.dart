import 'package:flutter/foundation.dart';

/// Represents a user's rating and review for a completed trip.
@immutable
class Rating {
  final String id;
  final String tripId;
  final int stars; // 1 to 5
  final String? comment;
  final DateTime createdAt;
  final List<String> tags; // e.g. ['clean', 'comfortable', 'fast']

  const Rating({
    required this.id,
    required this.tripId,
    required this.stars,
    this.comment,
    required this.createdAt,
    this.tags = const [],
  });

  @override
  String toString() => 'Rating(id: $id, tripId: $tripId, stars: $stars)';
}

/// Predefined feedback tags users can select when rating.
class RatingTags {
  RatingTags._();

  static const List<String> positive = [
    'Clean bike',
    'Smooth ride',
    'Good battery',
    'Easy to use',
    'Great value',
  ];

  static const List<String> negative = [
    'Dirty bike',
    'Uncomfortable',
    'Low battery',
    'Hard to unlock',
    'Too expensive',
  ];
}

import 'package:flutter/foundation.dart';

/// Represents a user's rating and review for a completed trip.
@immutable
class Rating {
  final String id;
  final String companyId;
  final String tripId;
  final int stars; // 1 to 5
  final String? comment;
  final DateTime createdAt;
  final List<String> tags; // e.g. ['clean', 'comfortable', 'fast']

  const Rating({
    required this.id,
    required this.companyId,
    required this.tripId,
    required this.stars,
    this.comment,
    required this.createdAt,
    this.tags = const [],
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      id: json['id'] as String,
      companyId: json['companyId'] as String,
      tripId: json['tripId'] as String,
      stars: json['stars'] as int,
      comment: json['comment'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'companyId': companyId,
      'tripId': tripId,
      'stars': stars,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
      'tags': tags,
    };
  }

  Rating copyWith({
    String? id,
    String? companyId,
    String? tripId,
    int? stars,
    String? comment,
    DateTime? createdAt,
    List<String>? tags,
  }) {
    return Rating(
      id: id ?? this.id,
      companyId: companyId ?? this.companyId,
      tripId: tripId ?? this.tripId,
      stars: stars ?? this.stars,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
      tags: tags ?? this.tags,
    );
  }

  @override
  String toString() =>
      'Rating(id: $id, companyId: $companyId, tripId: $tripId, stars: $stars)';
}

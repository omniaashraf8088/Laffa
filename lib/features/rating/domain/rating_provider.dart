import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/injection_container.dart';
import '../../../core/network/api_client.dart';
import '../../../core/tenant/tenant_service.dart';
import '../data/rating_repository.dart';
import 'rating_model.dart';

/// State for the rating feature.
class RatingState {
  final int stars;
  final String comment;
  final List<String> selectedTags;
  final String? tripId;
  final Rating? submittedRating;
  final bool isSubmitting;
  final bool isSubmitted;
  final String? error;

  const RatingState({
    this.stars = 0,
    this.comment = '',
    this.selectedTags = const [],
    this.tripId,
    this.submittedRating,
    this.isSubmitting = false,
    this.isSubmitted = false,
    this.error,
  });

  RatingState copyWith({
    int? stars,
    String? comment,
    List<String>? selectedTags,
    String? tripId,
    Rating? submittedRating,
    bool? isSubmitting,
    bool? isSubmitted,
    String? error,
  }) {
    return RatingState(
      stars: stars ?? this.stars,
      comment: comment ?? this.comment,
      selectedTags: selectedTags ?? this.selectedTags,
      tripId: tripId ?? this.tripId,
      submittedRating: submittedRating ?? this.submittedRating,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSubmitted: isSubmitted ?? this.isSubmitted,
      error: error,
    );
  }
}

/// Notifier that manages rating state and business logic.
/// All operations are scoped to the active company via TenantState.
class RatingNotifier extends StateNotifier<RatingState> {
  final RatingRepository _repository;
  final Ref _ref;

  RatingNotifier(this._repository, this._ref) : super(const RatingState());

  String get _companyId => _ref.read(activeCompanyIdProvider);

  /// Initializes the rating screen with the trip ID.
  void initialize(String tripId) {
    state = RatingState(tripId: tripId);
  }

  /// Sets the star rating (1-5).
  void setStars(int stars) {
    state = state.copyWith(stars: stars.clamp(1, 5));
  }

  /// Updates the written comment.
  void setComment(String comment) {
    state = state.copyWith(comment: comment);
  }

  /// Toggles a feedback tag on/off.
  void toggleTag(String tag) {
    final tags = List<String>.from(state.selectedTags);
    if (tags.contains(tag)) {
      tags.remove(tag);
    } else {
      tags.add(tag);
    }
    state = state.copyWith(selectedTags: tags);
  }

  /// Submits the rating scoped to the active company.
  Future<void> submitRating() async {
    if (state.stars == 0) {
      state = state.copyWith(error: 'Please select a rating');
      return;
    }

    if (state.tripId == null) {
      state = state.copyWith(error: 'No trip found to rate');
      return;
    }

    state = state.copyWith(isSubmitting: true, error: null);

    try {
      final rating = await _repository.submitRating(
        companyId: _companyId,
        tripId: state.tripId!,
        stars: state.stars,
        comment: state.comment.isNotEmpty ? state.comment : null,
        tags: state.selectedTags,
      );

      state = state.copyWith(
        submittedRating: rating,
        isSubmitting: false,
        isSubmitted: true,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        error: 'Failed to submit rating: $e',
      );
    }
  }

  /// Clears error state.
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Resets the entire rating state.
  void reset() {
    state = const RatingState();
  }
}

/// Provider for rating repository.
final ratingRepositoryProvider = Provider<RatingRepository>((ref) {
  return RatingRepository(apiClient: sl<ApiClient>());
});

/// Provider for rating state management.
final ratingProvider = StateNotifierProvider<RatingNotifier, RatingState>((
  ref,
) {
  final repository = ref.watch(ratingRepositoryProvider);
  return RatingNotifier(repository, ref);
});

import '../data/scooter_finder_repository.dart';
import '../data/models/scooter_suggestion_model.dart';

/// Use case that delegates scooter ranking to the repository.
class FindBestScooterUseCase {
  final ScooterFinderRepository _repository;

  FindBestScooterUseCase(this._repository);

  ScooterSuggestion? call({
    required double userLat,
    required double userLng,
    required List<ScooterSuggestion> availableScooters,
  }) {
    return _repository.findBestScooter(
      userLat: userLat,
      userLng: userLng,
      availableScooters: availableScooters,
    );
  }
}

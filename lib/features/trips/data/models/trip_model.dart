import '../../../../core/localization/app_strings_en.dart';

class TripItem {
  final String id;
  final String stationName;
  final DateTime date;
  final Duration duration;
  final double distance;
  final double cost;

  const TripItem({
    required this.id,
    required this.stationName,
    required this.date,
    required this.duration,
    required this.distance,
    required this.cost,
  });

  String get formattedDuration => '${duration.inMinutes} min';

  String get formattedDistance => '${distance.toStringAsFixed(1)} km';

  String get formattedCost =>
      '${cost.toStringAsFixed(1)} ${AppStringsEn.currency}';

  TripItem copyWith({
    String? id,
    String? stationName,
    DateTime? date,
    Duration? duration,
    double? distance,
    double? cost,
  }) {
    return TripItem(
      id: id ?? this.id,
      stationName: stationName ?? this.stationName,
      date: date ?? this.date,
      duration: duration ?? this.duration,
      distance: distance ?? this.distance,
      cost: cost ?? this.cost,
    );
  }
}

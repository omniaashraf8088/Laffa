import 'models/trip_model.dart';

final List<TripItem> initialTrips = [
  TripItem(
    id: '1',
    stationName: 'Cairo University Station',
    date: DateTime(2026, 3, 3),
    duration: const Duration(minutes: 25),
    distance: 3.2,
    cost: 15.0,
  ),
  TripItem(
    id: '2',
    stationName: 'Tahrir Square Station',
    date: DateTime(2026, 3, 2),
    duration: const Duration(minutes: 18),
    distance: 2.1,
    cost: 10.5,
  ),
  TripItem(
    id: '3',
    stationName: 'Maadi Station',
    date: DateTime(2026, 3, 1),
    duration: const Duration(minutes: 40),
    distance: 5.8,
    cost: 25.0,
  ),
  TripItem(
    id: '4',
    stationName: 'Heliopolis Station',
    date: DateTime(2026, 2, 28),
    duration: const Duration(minutes: 12),
    distance: 1.5,
    cost: 8.0,
  ),
  TripItem(
    id: '5',
    stationName: 'Zamalek Station',
    date: DateTime(2026, 2, 27),
    duration: const Duration(minutes: 30),
    distance: 4.0,
    cost: 18.0,
  ),
];

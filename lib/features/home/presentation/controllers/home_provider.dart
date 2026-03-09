import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../../data/models/station_model.dart';

// Dummy stations data
List<Station> _getDummyStations() {
  return [
    const Station(
      id: 'station_1',
      name: 'Downtown Hub',
      latitude: 30.0444,
      longitude: 31.2357,
      availableScooters: 12,
    ),
    const Station(
      id: 'station_2',
      name: 'Central Park',
      latitude: 30.0500,
      longitude: 31.2400,
      availableScooters: 8,
    ),
    const Station(
      id: 'station_3',
      name: 'Mall Station',
      latitude: 30.0350,
      longitude: 31.2500,
      availableScooters: 15,
    ),
    const Station(
      id: 'station_4',
      name: 'University Point',
      latitude: 30.0600,
      longitude: 31.2200,
      availableScooters: 5,
    ),
    const Station(
      id: 'station_5',
      name: 'Airport Express',
      latitude: 30.0300,
      longitude: 31.2300,
      availableScooters: 20,
    ),
  ];
}

class HomeState {
  final UserLocation? currentLocation;
  final List<Station> stations;
  final List<Station> filteredStations;
  final ActiveTrip? activeTrip;
  final bool isLoading;
  final bool isLoadingLocation;
  final String? error;
  final LocationPermission locationPermission;

  HomeState({
    this.currentLocation,
    this.stations = const [],
    this.filteredStations = const [],
    this.activeTrip,
    this.isLoading = false,
    this.isLoadingLocation = false,
    this.error,
    this.locationPermission = LocationPermission.denied,
  });

  HomeState copyWith({
    UserLocation? currentLocation,
    List<Station>? stations,
    List<Station>? filteredStations,
    ActiveTrip? activeTrip,
    bool? isLoading,
    bool? isLoadingLocation,
    String? error,
    LocationPermission? locationPermission,
  }) {
    return HomeState(
      currentLocation: currentLocation ?? this.currentLocation,
      stations: stations ?? this.stations,
      filteredStations: filteredStations ?? this.filteredStations,
      activeTrip: activeTrip ?? this.activeTrip,
      isLoading: isLoading ?? this.isLoading,
      isLoadingLocation: isLoadingLocation ?? this.isLoadingLocation,
      error: error ?? this.error,
      locationPermission: locationPermission ?? this.locationPermission,
    );
  }

  @override
  String toString() =>
      'HomeState(currentLocation: $currentLocation, stations: ${stations.length}, '
      'activeTrip: $activeTrip, isLoading: $isLoading, error: $error)';
}

class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier() : super(HomeState()) {
    _initializeHome();
  }

  Future<void> _initializeHome() async {
    try {
      state = state.copyWith(isLoadingLocation: true);

      // Check existing permission first, only request if not granted
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      state = state.copyWith(locationPermission: permission);

      // Get current location
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        state = state.copyWith(
          isLoadingLocation: false,
          error: 'Location permission denied',
        );
        return;
      }

      // Check if location services are enabled
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        state = state.copyWith(
          isLoadingLocation: false,
          error: 'Location services disabled',
        );
        return;
      }

      // Get user location with timeout
      final position = await Geolocator.getCurrentPosition(
        timeLimit: const Duration(seconds: 10),
        forceAndroidLocationManager: true,
      );

      final userLocation = UserLocation(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      // Load dummy stations
      final stations = _getDummyStations();

      state = state.copyWith(
        currentLocation: userLocation,
        stations: stations,
        filteredStations: stations,
        isLoadingLocation: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingLocation: false,
        error: 'Failed to get location: $e',
      );
    }
  }

  void searchStations(String query) {
    if (query.isEmpty) {
      state = state.copyWith(filteredStations: state.stations);
      return;
    }

    final filtered = state.stations
        .where(
          (station) => station.name.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();

    state = state.copyWith(filteredStations: filtered);
  }

  void clearSearch() {
    state = state.copyWith(filteredStations: state.stations);
  }

  Future<void> startTrip(Station station) async {
    try {
      state = state.copyWith(isLoading: true);

      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 1500));

      final trip = ActiveTrip(
        tripId: 'trip_${DateTime.now().millisecondsSinceEpoch}',
        stationName: station.name,
        startTime: DateTime.now(),
      );

      state = state.copyWith(activeTrip: trip, isLoading: false, error: null);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to start trip: $e',
      );
    }
  }

  Future<void> endTrip() async {
    try {
      state = state.copyWith(isLoading: true);

      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 1000));

      state = state.copyWith(activeTrip: null, isLoading: false, error: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Failed to end trip: $e');
    }
  }

  Future<void> recenterMap(UserLocation location) async {
    // This will be handled by the map controller from UI
    // Just here as a placeholder for future map-related logic
  }

  void retryLoadLocation() {
    _initializeHome();
  }
}

final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  return HomeNotifier();
});

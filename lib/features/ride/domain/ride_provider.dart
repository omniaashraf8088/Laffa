import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import 'ride_model.dart';

/// State for the ride feature (QR scan → ride tracking → completion).
class RideState {
  final RideSession? activeRide;
  final RideStatus status;
  final String? scannedScooterId;
  final Scooter? scooter;
  final bool isLoading;
  final String? error;
  final double? userLat;
  final double? userLng;
  final List<RideHistoryItem> rideHistory;

  const RideState({
    this.activeRide,
    this.status = RideStatus.idle,
    this.scannedScooterId,
    this.scooter,
    this.isLoading = false,
    this.error,
    this.userLat,
    this.userLng,
    this.rideHistory = const [],
  });

  RideState copyWith({
    RideSession? activeRide,
    RideStatus? status,
    String? scannedScooterId,
    Scooter? scooter,
    bool? isLoading,
    String? error,
    double? userLat,
    double? userLng,
    List<RideHistoryItem>? rideHistory,
    bool clearActiveRide = false,
    bool clearError = false,
  }) {
    return RideState(
      activeRide: clearActiveRide ? null : (activeRide ?? this.activeRide),
      status: status ?? this.status,
      scannedScooterId: scannedScooterId ?? this.scannedScooterId,
      scooter: scooter ?? this.scooter,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      userLat: userLat ?? this.userLat,
      userLng: userLng ?? this.userLng,
      rideHistory: rideHistory ?? this.rideHistory,
    );
  }
}

class RideNotifier extends StateNotifier<RideState> {
  RideNotifier() : super(RideState(rideHistory: _generateDummyHistory()));

  StreamSubscription<Position>? _locationSub;
  Timer? _rideTimer;

  /// Called when a QR code is scanned. Verifies and unlocks the scooter.
  Future<void> onQrScanned(String scooterId) async {
    state = state.copyWith(
      status: RideStatus.unlocking,
      scannedScooterId: scooterId,
      isLoading: true,
      clearError: true,
    );

    // Simulate verification delay
    await Future.delayed(const Duration(seconds: 2));

    // Simulate scooter lookup
    final scooter = _lookupScooter(scooterId);
    if (scooter == null) {
      state = state.copyWith(
        status: RideStatus.idle,
        isLoading: false,
        error: 'Scooter not found: $scooterId',
      );
      return;
    }

    if (!scooter.isAvailable) {
      state = state.copyWith(
        status: RideStatus.idle,
        isLoading: false,
        error: 'Scooter is not available',
      );
      return;
    }

    state = state.copyWith(scooter: scooter, isLoading: false);
  }

  /// Starts the ride after scooter is unlocked.
  Future<void> startRide() async {
    final scooter = state.scooter;
    if (scooter == null) return;

    state = state.copyWith(status: RideStatus.active, isLoading: true);

    // Get user location
    try {
      final pos = await Geolocator.getCurrentPosition(
        timeLimit: const Duration(seconds: 10),
      );

      final session = RideSession(
        id: 'ride_${DateTime.now().millisecondsSinceEpoch}',
        scooter: scooter,
        startTime: DateTime.now(),
        routePoints: [
          RideRoutePoint(
            latitude: pos.latitude,
            longitude: pos.longitude,
            timestamp: DateTime.now(),
          ),
        ],
      );

      state = state.copyWith(
        activeRide: session,
        status: RideStatus.active,
        isLoading: false,
        userLat: pos.latitude,
        userLng: pos.longitude,
      );

      _startLocationTracking();
      _startRideTimer();
    } catch (e) {
      // Fallback to scooter location
      final session = RideSession(
        id: 'ride_${DateTime.now().millisecondsSinceEpoch}',
        scooter: scooter,
        startTime: DateTime.now(),
        routePoints: [
          RideRoutePoint(
            latitude: scooter.latitude,
            longitude: scooter.longitude,
            timestamp: DateTime.now(),
          ),
        ],
      );

      state = state.copyWith(
        activeRide: session,
        status: RideStatus.active,
        isLoading: false,
        userLat: scooter.latitude,
        userLng: scooter.longitude,
      );

      _startRideTimer();
    }
  }

  /// Pauses the ride.
  void pauseRide() {
    if (state.status != RideStatus.active) return;
    state = state.copyWith(status: RideStatus.paused);
    _rideTimer?.cancel();
    _locationSub?.pause();
  }

  /// Resumes the ride.
  void resumeRide() {
    if (state.status != RideStatus.paused) return;
    state = state.copyWith(status: RideStatus.active);
    _startRideTimer();
    _locationSub?.resume();
  }

  /// Cancels the ride.
  Future<void> cancelRide() async {
    _cleanup();

    final ride = state.activeRide;
    if (ride != null) {
      final historyItem = RideHistoryItem(
        id: ride.id,
        scooterId: ride.scooter.id,
        scooterName: ride.scooter.name,
        date: ride.startTime,
        duration: ride.duration,
        distanceKm: ride.distanceKm,
        cost: ride.estimatedCost,
        status: RideHistoryStatus.cancelled,
      );
      state = state.copyWith(
        status: RideStatus.cancelled,
        clearActiveRide: true,
        rideHistory: [historyItem, ...state.rideHistory],
      );
    } else {
      state = state.copyWith(
        status: RideStatus.cancelled,
        clearActiveRide: true,
      );
    }
  }

  /// Finishes the ride and saves to history.
  Future<void> finishRide() async {
    _cleanup();

    final ride = state.activeRide;
    if (ride == null) return;

    state = state.copyWith(status: RideStatus.finishing, isLoading: true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    final completedRide = ride.copyWith(
      endTime: DateTime.now(),
      totalCost: ride.grandTotal,
      status: RideStatus.completed,
    );

    final historyItem = RideHistoryItem(
      id: completedRide.id,
      scooterId: completedRide.scooter.id,
      scooterName: completedRide.scooter.name,
      date: completedRide.startTime,
      duration: completedRide.duration,
      distanceKm: completedRide.distanceKm,
      cost: completedRide.grandTotal,
      status: RideHistoryStatus.completed,
    );

    state = state.copyWith(
      activeRide: completedRide,
      status: RideStatus.completed,
      isLoading: false,
      rideHistory: [historyItem, ...state.rideHistory],
    );
  }

  /// Resets state to idle for next ride.
  void resetRide() {
    _cleanup();
    state = state.copyWith(
      status: RideStatus.idle,
      clearActiveRide: true,
      clearError: true,
    );
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  void _startLocationTracking() {
    _locationSub?.cancel();

    _locationSub =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 5,
          ),
        ).listen((pos) {
          if (!mounted) return;
          final ride = state.activeRide;
          if (ride == null) return;

          final newPoint = RideRoutePoint(
            latitude: pos.latitude,
            longitude: pos.longitude,
            timestamp: DateTime.now(),
          );

          final updatedPoints = [...ride.routePoints, newPoint];
          final newDistance = _calculateTotalDistance(updatedPoints);

          state = state.copyWith(
            activeRide: ride.copyWith(
              routePoints: updatedPoints,
              distanceKm: newDistance,
            ),
            userLat: pos.latitude,
            userLng: pos.longitude,
          );
        }, onError: (_) {});
  }

  void _startRideTimer() {
    _rideTimer?.cancel();
    _rideTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      // Force a state update to refresh the timer display
      final ride = state.activeRide;
      if (ride == null) return;
      state = state.copyWith(
        activeRide: ride.copyWith(
          // Update simulated distance slowly
          distanceKm: ride.distanceKm + 0.002,
        ),
      );
    });
  }

  void _cleanup() {
    _rideTimer?.cancel();
    _rideTimer = null;
    _locationSub?.cancel();
    _locationSub = null;
  }

  @override
  void dispose() {
    _cleanup();
    super.dispose();
  }

  double _calculateTotalDistance(List<RideRoutePoint> points) {
    if (points.length < 2) return 0;
    double total = 0;
    for (var i = 1; i < points.length; i++) {
      total += _haversineDistance(
        points[i - 1].latitude,
        points[i - 1].longitude,
        points[i].latitude,
        points[i].longitude,
      );
    }
    return total;
  }

  double _haversineDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const r = 6371.0; // Earth radius in km
    final dLat = _toRad(lat2 - lat1);
    final dLon = _toRad(lon2 - lon1);
    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRad(lat1)) * cos(_toRad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return r * c;
  }

  double _toRad(double deg) => deg * pi / 180;

  Scooter? _lookupScooter(String id) {
    final scooters = _getDummyScooters();
    try {
      return scooters.firstWhere((s) => s.id == id);
    } catch (_) {
      // If not found by exact ID, return a random one (demo)
      if (scooters.isNotEmpty) {
        return scooters.first.id == id
            ? scooters.first
            : Scooter(
                id: id,
                name:
                    'Scooter ${id.substring(id.length > 4 ? id.length - 4 : 0)}',
                batteryLevel: 0.75,
                pricePerMinute: 2.5,
                latitude: 30.0444,
                longitude: 31.2357,
              );
      }
      return null;
    }
  }
}

List<Scooter> _getDummyScooters() {
  return const [
    Scooter(
      id: 'SCT-001',
      name: 'City Glide',
      batteryLevel: 0.85,
      pricePerMinute: 2.5,
      latitude: 30.0444,
      longitude: 31.2357,
    ),
    Scooter(
      id: 'SCT-002',
      name: 'Urban Swift',
      batteryLevel: 0.62,
      pricePerMinute: 2.0,
      latitude: 30.0500,
      longitude: 31.2400,
    ),
    Scooter(
      id: 'SCT-003',
      name: 'Metro Flash',
      batteryLevel: 0.93,
      pricePerMinute: 3.0,
      latitude: 30.0350,
      longitude: 31.2500,
    ),
    Scooter(
      id: 'SCT-004',
      name: 'Nile Cruiser',
      batteryLevel: 0.41,
      pricePerMinute: 1.5,
      latitude: 30.0600,
      longitude: 31.2200,
    ),
    Scooter(
      id: 'SCT-005',
      name: 'Pharaoh Ride',
      batteryLevel: 0.78,
      pricePerMinute: 2.5,
      latitude: 30.0300,
      longitude: 31.2300,
    ),
  ];
}

List<RideHistoryItem> _generateDummyHistory() {
  return [
    RideHistoryItem(
      id: 'ride_h1',
      scooterId: 'SCT-001',
      scooterName: 'City Glide',
      date: DateTime(2026, 3, 5, 14, 30),
      duration: const Duration(minutes: 25),
      distanceKm: 3.2,
      cost: 62.5,
      status: RideHistoryStatus.completed,
    ),
    RideHistoryItem(
      id: 'ride_h2',
      scooterId: 'SCT-003',
      scooterName: 'Metro Flash',
      date: DateTime(2026, 3, 4, 9, 15),
      duration: const Duration(minutes: 18),
      distanceKm: 2.1,
      cost: 54.0,
      status: RideHistoryStatus.completed,
    ),
    RideHistoryItem(
      id: 'ride_h3',
      scooterId: 'SCT-002',
      scooterName: 'Urban Swift',
      date: DateTime(2026, 3, 3, 17, 0),
      duration: const Duration(minutes: 8),
      distanceKm: 0.5,
      cost: 16.0,
      status: RideHistoryStatus.cancelled,
    ),
    RideHistoryItem(
      id: 'ride_h4',
      scooterId: 'SCT-005',
      scooterName: 'Pharaoh Ride',
      date: DateTime(2026, 3, 1, 11, 45),
      duration: const Duration(minutes: 40),
      distanceKm: 5.8,
      cost: 100.0,
      status: RideHistoryStatus.completed,
    ),
    RideHistoryItem(
      id: 'ride_h5',
      scooterId: 'SCT-004',
      scooterName: 'Nile Cruiser',
      date: DateTime(2026, 2, 28, 16, 20),
      duration: const Duration(minutes: 12),
      distanceKm: 1.5,
      cost: 18.0,
      status: RideHistoryStatus.completed,
    ),
  ];
}

final rideProvider = StateNotifierProvider<RideNotifier, RideState>((ref) {
  return RideNotifier();
});

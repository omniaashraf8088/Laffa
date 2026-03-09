import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/localization/app_strings_ar.dart';
import '../../../../core/localization/app_strings_en.dart';
import '../../../../core/localization/localization_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/station_model.dart';
import '../controllers/home_provider.dart';

/// Map widget using flutter_map with free OpenStreetMap tiles.
/// No API key required - completely free.
class MapViewWidget extends ConsumerStatefulWidget {
  final Function(Station) onStationTapped;

  const MapViewWidget({super.key, required this.onStationTapped});

  @override
  ConsumerState<MapViewWidget> createState() => _MapViewWidgetState();
}

class _MapViewWidgetState extends ConsumerState<MapViewWidget> {
  final MapController _mapController = MapController();
  bool _mapReady = false;

  void _animateToUserLocation(UserLocation location) {
    _mapController.move(LatLng(location.latitude, location.longitude), 15.5);
  }

  /// Builds flutter_map markers from station data.
  List<Marker> _buildMarkers(List<Station> stations) {
    return stations.map((station) {
      return Marker(
        point: LatLng(station.latitude, station.longitude),
        width: 70,
        height: 80,
        child: GestureDetector(
          onTap: () => widget.onStationTapped(station),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Main marker circle
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.electric_scooter_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(height: 2),
              // Count badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Text(
                  '${station.availableScooters}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeProvider);
    final localization = ref.watch(localizationProvider);
    final isArabic = localization.language == AppLanguage.ar;
    final gettingLocationLabel = isArabic
        ? AppStringsAr.gettingLocation
        : AppStringsEn.gettingLocation;
    final retryLabel = isArabic ? AppStringsAr.retry : AppStringsEn.retry;
    final loadingMapLabel = isArabic
        ? AppStringsAr.loadingMap
        : AppStringsEn.loadingMap;

    // Loading location state
    if (homeState.isLoadingLocation) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              gettingLocationLabel,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    // Error state
    if (homeState.error != null && homeState.currentLocation == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_off_rounded,
                size: 64,
                color: Colors.grey,
              ),
              const SizedBox(height: 24),
              Text(
                homeState.error ?? 'Unable to get location',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.text,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  ref.read(homeProvider.notifier).retryLoadLocation();
                },
                icon: const Icon(Icons.refresh_rounded),
                label: Text(retryLabel),
              ),
            ],
          ),
        ),
      );
    }

    // Waiting for location
    if (homeState.currentLocation == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final markers = _buildMarkers(homeState.filteredStations);

    return Stack(
      children: [
        // Flutter Map with free OpenStreetMap tiles
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: LatLng(
              homeState.currentLocation!.latitude,
              homeState.currentLocation!.longitude,
            ),
            initialZoom: 15.0,
            onMapReady: () {
              if (mounted) {
                setState(() {
                  _mapReady = true;
                });
                _animateToUserLocation(homeState.currentLocation!);
              }
            },
          ),
          children: [
            // Free OpenStreetMap tile layer - no API key needed
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.laffa.app',
            ),
            // Station markers
            MarkerLayer(markers: markers),
            // User location marker
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(
                    homeState.currentLocation!.latitude,
                    homeState.currentLocation!.longitude,
                  ),
                  width: 24,
                  height: 24,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.info,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.info.withValues(alpha: 0.3),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        // Loading overlay
        AnimatedOpacity(
          opacity: _mapReady ? 0 : 1,
          duration: const Duration(milliseconds: 400),
          child: IgnorePointer(
            ignoring: _mapReady,
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 54,
                    height: 54,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor,
                      ),
                      strokeWidth: 3,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    loadingMapLabel,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

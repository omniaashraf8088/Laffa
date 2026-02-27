import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/localization/app_strings_ar.dart';
import '../../core/localization/app_strings_en.dart';
import '../../core/localization/localization_provider.dart';
import 'station_marker.dart';
import 'station_model.dart';
import 'home_provider.dart';

class MapViewWidget extends ConsumerStatefulWidget {
  final Function(Station) onStationTapped;

  const MapViewWidget({Key? key, required this.onStationTapped})
    : super(key: key);

  @override
  ConsumerState<MapViewWidget> createState() => _MapViewWidgetState();
}

class _MapViewWidgetState extends ConsumerState<MapViewWidget> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  bool _markersLoaded = false;
  bool _mapReady = false;
  String _lastStationSignature = '';

  @override
  void didUpdateWidget(MapViewWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _loadMarkers();
  }

  Future<void> _loadMarkers() async {
    if (_markersLoaded || _mapController == null) return;

    try {
      final homeState = ref.read(homeProvider);
      final signature = homeState.filteredStations
          .map((station) => station.id)
          .join('|');

      if (signature == _lastStationSignature && _markers.isNotEmpty) {
        _markersLoaded = true;
        return;
      }

      final newMarkers = <Marker>{};

      for (final station in homeState.filteredStations) {
        final markerIcon = await StationMarkerGenerator.generateStationMarker(
          station,
        );

        final marker = StationMarkerGenerator.createStationMarker(
          station: station,
          markerIcon: markerIcon,
          onTap: () => widget.onStationTapped(station),
        );

        newMarkers.add(marker);
      }

      if (mounted) {
        setState(() {
          _markers = newMarkers;
          _markersLoaded = true;
          _lastStationSignature = signature;
        });
      }
    } catch (e) {
      debugPrint('Error loading markers: $e');
    }
  }

  Future<void> _animateToUserLocation(UserLocation location) async {
    if (_mapController == null) return;

    await _mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(location.latitude, location.longitude),
          zoom: 15.5,
        ),
      ),
    );
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
    final loadingMapLabel =
      isArabic ? AppStringsAr.loadingMap : AppStringsEn.loadingMap;

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

    if (homeState.currentLocation == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // Load markers when stations change
    if (!_markersLoaded && homeState.stations.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadMarkers();
      });
    }

    // Update markers when filtered stations change
    if (_markersLoaded &&
        _markers.length != homeState.filteredStations.length) {
      _markersLoaded = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadMarkers();
      });
    }

    final filteredSignature = homeState.filteredStations
        .map((station) => station.id)
        .join('|');
    if (_markersLoaded && filteredSignature != _lastStationSignature) {
      _markersLoaded = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadMarkers();
      });
    }

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(
              homeState.currentLocation!.latitude,
              homeState.currentLocation!.longitude,
            ),
            zoom: 15,
          ),
          onMapCreated: (controller) {
            _mapController = controller;
            _loadMarkers();
            _animateToUserLocation(homeState.currentLocation!);
            if (mounted) {
              setState(() {
                _mapReady = true;
              });
            }
          },
          markers: _markers,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
          liteModeEnabled: false,
          style: _getMapStyle(),
        ),
        AnimatedOpacity(
          opacity: _mapReady ? 0 : 1,
          duration: const Duration(milliseconds: 400),
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
      ],
    );
  }

  String _getMapStyle() {
    return '''[
      {
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#f5ebdd"
          }
        ]
      },
      {
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#616161"
          }
        ]
      },
      {
        "featureType": "administrative",
        "elementType": "geometry.stroke",
        "stylers": [
          {
            "color": "#c4a484"
          }
        ]
      },
      {
        "featureType": "water",
        "elementType": "geometry.fill",
        "stylers": [
          {
            "color": "#d4e4f7"
          }
        ]
      }
    ]''';
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}

// Station marker is now handled inline by MapViewWidget using flutter_map's
// native Marker widget with Flutter widgets as children.
// This file is kept for backward compatibility but the custom bitmap
// rendering is no longer needed since flutter_map supports widget markers.

import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'station_model.dart';

/// Helper to build a station marker widget for flutter_map.
class StationMarkerWidget extends StatelessWidget {
  final Station station;
  final VoidCallback onTap;

  const StationMarkerWidget({
    super.key,
    required this.station,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(8),
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
    );
  }
}

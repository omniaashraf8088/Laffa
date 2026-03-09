import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/localization/localization_provider.dart';
import '../../../../core/localization/app_strings_ar.dart';
import '../../../../core/localization/app_strings_en.dart';
import '../../../../core/router/app_router.dart';
import '../../data/models/ride_model.dart';
import '../controllers/ride_provider.dart';

/// Live ride tracking screen with map, route, and controls.
class RideTrackingScreen extends ConsumerStatefulWidget {
  const RideTrackingScreen({super.key});

  @override
  ConsumerState<RideTrackingScreen> createState() => _RideTrackingScreenState();
}

class _RideTrackingScreenState extends ConsumerState<RideTrackingScreen>
    with TickerProviderStateMixin {
  final MapController _mapController = MapController();
  late AnimationController _statusPulse;
  Timer? _uiTimer;

  @override
  void initState() {
    super.initState();
    _statusPulse = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // Refresh UI every second for timer
    _uiTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _statusPulse.dispose();
    _uiTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rideState = ref.watch(rideProvider);
    final localization = ref.watch(localizationProvider);
    final isArabic = localization.language == AppLanguage.ar;
    final ride = rideState.activeRide;

    // Listen for ride completion/cancellation
    ref.listen<RideState>(rideProvider, (prev, next) {
      if (next.status == RideStatus.completed &&
          prev?.status != RideStatus.completed) {
        context.go(AppRouter.ridePayment);
      }
      if (next.status == RideStatus.cancelled &&
          prev?.status != RideStatus.cancelled) {
        context.go(AppRouter.home);
      }
    });

    return Scaffold(
      body: Stack(
        children: [
          // Map
          _buildMap(rideState),

          // Status indicator at top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildStatusBar(rideState, isArabic),
          ),

          // Bottom control panel
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ride != null
                ? _buildControlPanel(ride, rideState.status, isArabic)
                : _buildLoadingPanel(isArabic),
          ),

          // Recenter button
          Positioned(
            right: 16,
            bottom: 320,
            child: _buildRecenterButton(rideState),
          ),
        ],
      ),
    );
  }

  Widget _buildMap(RideState rideState) {
    final ride = rideState.activeRide;
    final lat = rideState.userLat ?? ride?.scooter.latitude ?? 30.0444;
    final lng = rideState.userLng ?? ride?.scooter.longitude ?? 31.2357;

    final routePoints =
        ride?.routePoints
            .map((p) => LatLng(p.latitude, p.longitude))
            .toList() ??
        [];

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(initialCenter: LatLng(lat, lng), initialZoom: 16.0),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.laffa.app',
        ),
        // Route polyline
        if (routePoints.length >= 2)
          PolylineLayer(
            polylines: [
              Polyline(
                points: routePoints,
                color: AppColors.primary,
                strokeWidth: 4,
              ),
            ],
          ),
        // User marker
        MarkerLayer(
          markers: [
            Marker(
              point: LatLng(lat, lng),
              width: 48,
              height: 48,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.electric_scooter_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
            // Start point marker
            if (routePoints.isNotEmpty)
              Marker(
                point: routePoints.first,
                width: 24,
                height: 24,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 12,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusBar(RideState rideState, bool isArabic) {
    final statusConfig = _getStatusConfig(rideState.status, isArabic);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            // Back button
            GestureDetector(
              onTap: () => _showCancelDialog(context, isArabic),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.close_rounded,
                  color: AppColors.text,
                  size: 22,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Status pill
            Expanded(
              child: AnimatedBuilder(
                animation: _statusPulse,
                builder: (context, child) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: statusConfig.color.withValues(
                              alpha: 0.5 + (_statusPulse.value * 0.5),
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          statusConfig.label,
                          style: AppTextStyles.label(
                            isArabic: isArabic,
                            color: statusConfig.color,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlPanel(
    RideSession ride,
    RideStatus status,
    bool isArabic,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.greyLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),

              // Scooter info row
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.electric_scooter_rounded,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ride.scooter.name,
                          style: AppTextStyles.sectionTitle(
                            isArabic: isArabic,
                            color: AppColors.text,
                          ),
                        ),
                        Text(
                          'ID: ${ride.scooter.id}',
                          style: AppTextStyles.smallMedium(
                            isArabic: isArabic,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Battery badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color:
                          (ride.scooter.batteryLevel > 0.5
                                  ? AppColors.success
                                  : AppColors.warning)
                              .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.battery_std_rounded,
                          color: ride.scooter.batteryLevel > 0.5
                              ? AppColors.success
                              : AppColors.warning,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          ride.scooter.batteryDisplay,
                          style: AppTextStyles.smallLabel(
                            isArabic: isArabic,
                            color: AppColors.text,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Stats row
              Row(
                children: [
                  _buildStatItem(
                    icon: Icons.timer_rounded,
                    label: isArabic ? AppStringsAr.time : AppStringsEn.time,
                    value: ride.formattedDuration,
                    color: AppColors.info,
                    isArabic: isArabic,
                  ),
                  _buildStatDivider(),
                  _buildStatItem(
                    icon: Icons.straighten_rounded,
                    label: isArabic
                        ? AppStringsAr.distance
                        : AppStringsEn.distance,
                    value: '${ride.distanceKm.toStringAsFixed(1)} km',
                    color: AppColors.success,
                    isArabic: isArabic,
                  ),
                  _buildStatDivider(),
                  _buildStatItem(
                    icon: Icons.payments_rounded,
                    label: isArabic ? AppStringsAr.cost : AppStringsEn.cost,
                    value:
                        '${ride.estimatedCost.toStringAsFixed(1)} ${AppStringsEn.currency}',
                    color: AppColors.primary,
                    isArabic: isArabic,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Action buttons
              Row(
                children: [
                  // Pause/Resume
                  Expanded(
                    child: _buildActionButton(
                      icon: status == RideStatus.paused
                          ? Icons.play_arrow_rounded
                          : Icons.pause_rounded,
                      label: status == RideStatus.paused
                          ? (isArabic
                                ? AppStringsAr.resume
                                : AppStringsEn.resume)
                          : (isArabic
                                ? AppStringsAr.pause
                                : AppStringsEn.pause),
                      color: AppColors.warning,
                      isArabic: isArabic,
                      onTap: () {
                        if (status == RideStatus.paused) {
                          ref.read(rideProvider.notifier).resumeRide();
                        } else {
                          ref.read(rideProvider.notifier).pauseRide();
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Cancel
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.cancel_rounded,
                      label: isArabic
                          ? AppStringsAr.cancel
                          : AppStringsEn.cancel,
                      color: AppColors.error,
                      isArabic: isArabic,
                      onTap: () => _showCancelDialog(context, isArabic),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Finish ride button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ref.read(rideProvider.notifier).finishRide();
                  },
                  icon: const Icon(Icons.flag_rounded),
                  label: Text(
                    isArabic
                        ? AppStringsAr.finishRide
                        : AppStringsEn.finishRide,
                    style: AppTextStyles.button(
                      isArabic: isArabic,
                      color: AppColors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingPanel(bool isArabic) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          const SizedBox(height: 16),
          Text(
            isArabic
                ? AppStringsAr.searchingScooter
                : AppStringsEn.searchingScooter,
            style: AppTextStyles.subtitle(
              isArabic: isArabic,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required bool isArabic,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppTextStyles.sectionTitle(
              isArabic: isArabic,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.captionMedium(
              isArabic: isArabic,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatDivider() {
    return Container(width: 1, height: 40, color: AppColors.borderLight);
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required bool isArabic,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: AppTextStyles.label(isArabic: isArabic, color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecenterButton(RideState rideState) {
    return GestureDetector(
      onTap: () {
        final lat = rideState.userLat ?? 30.0444;
        final lng = rideState.userLng ?? 31.2357;
        _mapController.move(LatLng(lat, lng), 16.0);
      },
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(
          Icons.my_location_rounded,
          color: AppColors.primary,
          size: 22,
        ),
      ),
    );
  }

  void _showCancelDialog(BuildContext context, bool isArabic) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.warning_rounded,
                color: AppColors.error,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                isArabic ? AppStringsAr.cancelRide : AppStringsEn.cancelRide,
                style: AppTextStyles.title(
                  isArabic: isArabic,
                  color: AppColors.text,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          isArabic
              ? AppStringsAr.cancelRideConfirm
              : AppStringsEn.cancelRideConfirm,
          style: AppTextStyles.body(
            isArabic: isArabic,
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              isArabic ? AppStringsAr.continueRide : AppStringsEn.continueRide,
              style: AppTextStyles.label(
                isArabic: isArabic,
                color: AppColors.primary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ref.read(rideProvider.notifier).cancelRide();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              isArabic ? AppStringsAr.cancelRide : AppStringsEn.cancelRide,
            ),
          ),
        ],
      ),
    );
  }

  _StatusConfig _getStatusConfig(RideStatus status, bool isArabic) {
    switch (status) {
      case RideStatus.scanning:
        return _StatusConfig(
          label: isArabic ? AppStringsAr.scanning : AppStringsEn.scanning,
          color: AppColors.info,
        );
      case RideStatus.unlocking:
        return _StatusConfig(
          label: isArabic ? AppStringsAr.unlocking : AppStringsEn.unlocking,
          color: AppColors.warning,
        );
      case RideStatus.active:
        return _StatusConfig(
          label: isArabic ? AppStringsAr.rideActive : AppStringsEn.rideActive,
          color: AppColors.success,
        );
      case RideStatus.paused:
        return _StatusConfig(
          label: isArabic ? AppStringsAr.paused : AppStringsEn.paused,
          color: AppColors.warning,
        );
      case RideStatus.finishing:
        return _StatusConfig(
          label: isArabic ? AppStringsAr.finishing : AppStringsEn.finishing,
          color: AppColors.primary,
        );
      default:
        return _StatusConfig(
          label: isArabic ? AppStringsAr.ready : AppStringsEn.ready,
          color: AppColors.textSecondary,
        );
    }
  }
}

class _StatusConfig {
  final String label;
  final Color color;

  const _StatusConfig({required this.label, required this.color});
}

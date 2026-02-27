import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/localization/app_strings_ar.dart';
import '../../core/localization/app_strings_en.dart';
import '../../core/localization/localization_provider.dart';
import '../../core/theme/app_theme.dart';
import 'home_provider.dart';
import 'map_view_widget.dart';
import 'search_bar_widget.dart';
import 'station_card_widget.dart';
import 'station_model.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Station? _selectedStation;

  String _stationHeroTag(Station station) => 'station_${station.id}';

  Future<void> _openStationSheet(Station station) async {
    setState(() {
      _selectedStation = station;
    });

    await Future.delayed(const Duration(milliseconds: 40));
    if (!mounted) return;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StationCardWidget(
          station: station,
          heroTag: _stationHeroTag(station),
          onStartRidePressed: () {
            ref.read(homeProvider.notifier).startTrip(station);
          },
        );
      },
    );

    if (mounted) {
      setState(() {
        _selectedStation = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeProvider);
    final localization = ref.watch(localizationProvider);
    final isArabic = localization.language == AppLanguage.ar;
    final nearbyLabel =
        isArabic ? AppStringsAr.nearbyScooters : AppStringsEn.nearbyScooters;
    final noStationsLabel =
        isArabic ? AppStringsAr.noScootersFound : AppStringsEn.noScootersFound;
    final activeTripLabel =
        isArabic ? AppStringsAr.activeTrip : AppStringsEn.activeTrip;
    final noActiveTripLabel =
        isArabic ? AppStringsAr.noActiveTrip : AppStringsEn.noActiveTrip;
    final tripHistoryLabel =
        isArabic ? AppStringsAr.tripHistory : AppStringsEn.tripHistory;
    final couponsLabel = isArabic ? AppStringsAr.coupons : AppStringsEn.coupons;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth > 720
              ? 720.0
              : constraints.maxWidth;

          return Stack(
            children: [
              Positioned.fill(
                child: MapViewWidget(
                  onStationTapped: _openStationSheet,
                ),
              ),
              SafeArea(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: maxWidth,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                        16,
                        12,
                        16,
                        0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SearchBarWidget(),
                          const SizedBox(height: 12),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (child, animation) {
                              final offsetAnimation = Tween<Offset>(
                                begin: const Offset(0, -0.2),
                                end: Offset.zero,
                              ).animate(animation);
                              return FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: offsetAnimation,
                                  child: child,
                                ),
                              );
                            },
                            child: _buildResultsPill(
                              key: ValueKey<int>(
                                homeState.filteredStations.length,
                              ),
                              label: homeState.filteredStations.isEmpty
                                  ? noStationsLabel
                                  : '$nearbyLabel · ${homeState.filteredStations.length}',
                              isArabic: isArabic,
                            ),
                          ),
                          const SizedBox(height: 10),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 350),
                            transitionBuilder: (child, animation) {
                              final offsetAnimation = Tween<Offset>(
                                begin: const Offset(0, -0.25),
                                end: Offset.zero,
                              ).animate(animation);
                              return FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: offsetAnimation,
                                  child: child,
                                ),
                              );
                            },
                            child: _selectedStation == null
                                ? const SizedBox.shrink()
                                : _buildStationPreviewChip(
                                    _selectedStation!,
                                    isArabic: isArabic,
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SafeArea(
                  top: false,
                  child: SizedBox(
                    width: maxWidth,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                        16,
                        0,
                        16,
                        16,
                      ),
                      child: _buildBottomSection(
                        context,
                        homeState: homeState,
                        isArabic: isArabic,
                        activeTripLabel: activeTripLabel,
                        noActiveTripLabel: noActiveTripLabel,
                        tripHistoryLabel: tripHistoryLabel,
                        couponsLabel: couponsLabel,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildResultsPill({
    required String label,
    required Key key,
    required bool isArabic,
  }) {
    return Container(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: GoogleFonts.getFont(
          isArabic ? 'Cairo' : 'Poppins',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.text,
        ),
      ),
    );
  }

  Widget _buildStationPreviewChip(Station station, {required bool isArabic}) {
    return Hero(
      tag: _stationHeroTag(station),
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.location_on_rounded,
                color: AppColors.primary,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                station.name,
                style: GoogleFonts.getFont(
                  isArabic ? 'Cairo' : 'Poppins',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSection(
    BuildContext context, {
    required HomeState homeState,
    required bool isArabic,
    required String activeTripLabel,
    required String noActiveTripLabel,
    required String tripHistoryLabel,
    required String couponsLabel,
  }) {
    final activeTrip = homeState.activeTrip;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                activeTripLabel,
                style: GoogleFonts.getFont(
                  isArabic ? 'Cairo' : 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              if (activeTrip == null)
                Text(
                  noActiveTripLabel,
                  style: GoogleFonts.getFont(
                    isArabic ? 'Cairo' : 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                )
              else
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            activeTrip.stationName,
                            style: GoogleFonts.getFont(
                              isArabic ? 'Cairo' : 'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.text,
                            ),
                          ),
                          const SizedBox(height: 4),
                          StreamBuilder<int>(
                            stream: Stream<int>.periodic(
                              const Duration(seconds: 1),
                              (value) => value,
                            ),
                            builder: (context, snapshot) {
                              final duration =
                                  DateTime.now().difference(activeTrip.startTime);
                              return Text(
                                _formatDuration(duration),
                                style: GoogleFonts.getFont(
                                  isArabic ? 'Cairo' : 'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: homeState.isLoading
                          ? null
                          : () {
                              ref.read(homeProvider.notifier).endTrip();
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        isArabic ? AppStringsAr.endRide : AppStringsEn.endRide,
                        style: GoogleFonts.getFont(
                          isArabic ? 'Cairo' : 'Poppins',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                context,
                label: tripHistoryLabel,
                icon: Icons.history_rounded,
                isArabic: isArabic,
                onTap: () {
                  _showComingSoon(context);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                context,
                label: couponsLabel,
                icon: Icons.local_offer_rounded,
                isArabic: isArabic,
                onTap: () {
                  _showComingSoon(context);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required String label,
    required IconData icon,
    required bool isArabic,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.primary, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.getFont(
                    isArabic ? 'Cairo' : 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    final hours = duration.inHours;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:$minutes:$seconds';
    }

    return '$minutes:$seconds';
  }

  void _showComingSoon(BuildContext context) {
    final localization = ref.read(localizationProvider);
    final isArabic = localization.language == AppLanguage.ar;
    final label =
        isArabic ? AppStringsAr.comingSoon : AppStringsEn.comingSoon;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          label,
          style: GoogleFonts.getFont(
            isArabic ? 'Cairo' : 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

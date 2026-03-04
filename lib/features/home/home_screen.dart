import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/fonts.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
            Navigator.of(context).pop(); // Close bottom sheet
            this.context.push(
              '/booking?stationId=${station.id}&stationName=${Uri.encodeComponent(station.name)}',
            );
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
    final nearbyLabel = isArabic
        ? AppStringsAr.nearbyScooters
        : AppStringsEn.nearbyScooters;
    final noStationsLabel = isArabic
        ? AppStringsAr.noScootersFound
        : AppStringsEn.noScootersFound;
    final activeTripLabel = isArabic
        ? AppStringsAr.activeTrip
        : AppStringsEn.activeTrip;
    final noActiveTripLabel = isArabic
        ? AppStringsAr.noActiveTrip
        : AppStringsEn.noActiveTrip;
    final tripHistoryLabel = isArabic
        ? AppStringsAr.tripHistory
        : AppStringsEn.tripHistory;
    final couponsLabel = isArabic ? AppStringsAr.coupons : AppStringsEn.coupons;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      // Navigation drawer for Profile, Settings, etc.
      drawer: _buildDrawer(context, isArabic: isArabic),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth > 720
              ? 720.0
              : constraints.maxWidth;

          return Stack(
            children: [
              Positioned.fill(
                child: MapViewWidget(onStationTapped: _openStationSheet),
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
                          // Menu button + Search bar row
                          Row(
                            children: [
                              // Menu button to open drawer
                              _buildMenuButton(),
                              const SizedBox(width: 10),
                              const Expanded(child: SearchBarWidget()),
                            ],
                          ),
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

  /// Builds the menu button that opens the navigation drawer.
  Widget _buildMenuButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => _scaffoldKey.currentState?.openDrawer(),
          child: const Padding(
            padding: EdgeInsets.all(12),
            child: Icon(Icons.menu_rounded, color: AppColors.primary, size: 22),
          ),
        ),
      ),
    );
  }

  /// Navigation drawer with links to all screens.
  Widget _buildDrawer(BuildContext context, {required bool isArabic}) {
    return Drawer(
      backgroundColor: AppColors.background,
      child: SafeArea(
        child: Column(
          children: [
            // Drawer header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(color: AppColors.primary),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isArabic ? 'مرحبا بك' : 'Welcome',
                    style: AppFonts.style(
                      isArabic: isArabic,
                      fontSize: AppFonts.sizeXLarge,
                      fontWeight: AppFonts.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Laffa',
                    style: AppFonts.style(
                      isArabic: isArabic,
                      fontSize: AppFonts.sizeSmall,
                      fontWeight: AppFonts.medium,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Menu items
            _buildDrawerItem(
              icon: Icons.home_rounded,
              label: isArabic ? 'الرئيسية' : 'Home',
              isArabic: isArabic,
              onTap: () => Navigator.of(context).pop(),
            ),
            _buildDrawerItem(
              icon: Icons.person_rounded,
              label: isArabic ? 'الملف الشخصي' : 'Profile',
              isArabic: isArabic,
              onTap: () {
                Navigator.of(context).pop();
                context.push('/profile');
              },
            ),
            _buildDrawerItem(
              icon: Icons.history_rounded,
              label: isArabic ? 'سجل الرحلات' : 'Trip History',
              isArabic: isArabic,
              onTap: () {
                Navigator.of(context).pop();
                context.push('/trips');
              },
            ),
            _buildDrawerItem(
              icon: Icons.local_offer_rounded,
              label: isArabic ? 'الكوبونات' : 'Coupons',
              isArabic: isArabic,
              onTap: () {
                Navigator.of(context).pop();
                context.push('/coupons');
              },
            ),
            _buildDrawerItem(
              icon: Icons.chat_rounded,
              label: isArabic ? 'الدعم' : 'Support',
              isArabic: isArabic,
              onTap: () {
                Navigator.of(context).pop();
                context.push('/chat');
              },
            ),
            _buildDrawerItem(
              icon: Icons.settings_rounded,
              label: isArabic ? 'الإعدادات' : 'Settings',
              isArabic: isArabic,
              onTap: () {
                Navigator.of(context).pop();
                context.push('/settings');
              },
            ),
            const Spacer(),
            // Language toggle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildDrawerItem(
                icon: Icons.language_rounded,
                label: isArabic ? 'English' : 'العربية',
                isArabic: isArabic,
                onTap: () {
                  ref
                      .read(localizationProvider.notifier)
                      .setLanguage(isArabic ? AppLanguage.en : AppLanguage.ar);
                },
              ),
            ),
            // Theme toggle
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildDrawerItem(
                icon: Icons.dark_mode_rounded,
                label: isArabic ? 'تغيير المظهر' : 'Toggle Theme',
                isArabic: isArabic,
                onTap: () {
                  ref.read(localizationProvider.notifier).toggleTheme();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String label,
    required bool isArabic,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary, size: 22),
      title: Text(
        label,
        style: AppFonts.style(
          isArabic: isArabic,
          fontSize: AppFonts.sizeBody,
          fontWeight: AppFonts.medium,
          color: AppColors.text,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
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
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: AppFonts.style(
          isArabic: isArabic,
          fontSize: AppFonts.sizeSmall,
          fontWeight: AppFonts.semiBold,
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
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.location_on_rounded,
                color: AppColors.primary,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                station.name,
                style: AppFonts.style(
                  isArabic: isArabic,
                  fontSize: 13,
                  fontWeight: AppFonts.semiBold,
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
                color: Colors.black.withValues(alpha: 0.12),
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
                style: AppFonts.style(
                  isArabic: isArabic,
                  fontSize: AppFonts.sizeBody,
                  fontWeight: AppFonts.semiBold,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              if (activeTrip == null)
                Text(
                  noActiveTripLabel,
                  style: AppFonts.style(
                    isArabic: isArabic,
                    fontSize: 15,
                    fontWeight: AppFonts.semiBold,
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
                            style: AppFonts.style(
                              isArabic: isArabic,
                              fontSize: AppFonts.sizeMedium,
                              fontWeight: AppFonts.bold,
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
                              final duration = DateTime.now().difference(
                                activeTrip.startTime,
                              );
                              return Text(
                                _formatDuration(duration),
                                style: AppFonts.style(
                                  isArabic: isArabic,
                                  fontSize: AppFonts.sizeBody,
                                  fontWeight: AppFonts.semiBold,
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
                        style: AppFonts.style(
                          isArabic: isArabic,
                          fontSize: 13,
                          fontWeight: AppFonts.semiBold,
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
                onTap: () => context.push('/trips'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                context,
                label: couponsLabel,
                icon: Icons.local_offer_rounded,
                isArabic: isArabic,
                onTap: () => context.push('/coupons'),
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
                color: Colors.black.withValues(alpha: 0.08),
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
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.primary, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: AppFonts.style(
                    isArabic: isArabic,
                    fontSize: 13,
                    fontWeight: AppFonts.semiBold,
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
}

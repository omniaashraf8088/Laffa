import 'package:flutter/material.dart';

import '../../../../core/localization/app_strings_ar.dart';
import '../../../../core/localization/app_strings_en.dart';
import '../../../../core/theme/app_theme.dart';
import '../controllers/home_provider.dart';
import '../../data/models/station_model.dart';
import 'search_bar_widget.dart';
import 'results_pill.dart';
import 'station_preview_chip.dart';

class HomeTopOverlay extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final HomeState homeState;
  final Station? selectedStation;
  final bool isArabic;
  final String? stationHeroTag;

  const HomeTopOverlay({
    super.key,
    required this.scaffoldKey,
    required this.homeState,
    required this.selectedStation,
    required this.isArabic,
    this.stationHeroTag,
  });

  @override
  Widget build(BuildContext context) {
    final nearbyLabel = isArabic
        ? AppStringsAr.nearbyScooters
        : AppStringsEn.nearbyScooters;
    final noStationsLabel = isArabic
        ? AppStringsAr.noScootersFound
        : AppStringsEn.noScootersFound;

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _MenuButton(scaffoldKey: scaffoldKey),
              const SizedBox(width: 10),
              const Expanded(child: SearchBarWidget()),
            ],
          ),
          const SizedBox(height: 12),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: _slideTransition(beginY: -0.2),
            child: ResultsPill(
              key: ValueKey<int>(homeState.filteredStations.length),
              label: homeState.filteredStations.isEmpty
                  ? noStationsLabel
                  : '$nearbyLabel · ${homeState.filteredStations.length}',
              isArabic: isArabic,
            ),
          ),
          const SizedBox(height: 10),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            transitionBuilder: _slideTransition(beginY: -0.25),
            child: selectedStation == null
                ? const SizedBox.shrink()
                : StationPreviewChip(
                    station: selectedStation!,
                    heroTag: stationHeroTag!,
                    isArabic: isArabic,
                  ),
          ),
        ],
      ),
    );
  }

  Widget Function(Widget, Animation<double>) _slideTransition({
    required double beginY,
  }) {
    return (child, animation) {
      final offsetAnimation = Tween<Offset>(
        begin: Offset(0, beginY),
        end: Offset.zero,
      ).animate(animation);
      return FadeTransition(
        opacity: animation,
        child: SlideTransition(position: offsetAnimation, child: child),
      );
    };
  }
}

class _MenuButton extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const _MenuButton({required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
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
          onTap: () => scaffoldKey.currentState?.openDrawer(),
          child: const Padding(
            padding: EdgeInsets.all(12),
            child: Icon(Icons.menu_rounded, color: AppColors.primary, size: 22),
          ),
        ),
      ),
    );
  }
}

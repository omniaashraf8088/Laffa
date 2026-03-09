import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/localization_provider.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../controllers/home_provider.dart';
import '../../data/models/station_model.dart';
import '../widgets/home_drawer.dart';
import '../widgets/home_bottom_section.dart';
import '../widgets/home_top_overlay.dart';
import '../widgets/map_view_widget.dart';
import '../widgets/station_card_widget.dart';

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
    setState(() => _selectedStation = station);

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
            Navigator.of(context).pop();
            this.context.push(
              '${AppRouter.booking}?stationId=${station.id}&stationName=${Uri.encodeComponent(station.name)}',
            );
          },
        );
      },
    );

    if (mounted) {
      setState(() => _selectedStation = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeProvider);
    final localization = ref.watch(localizationProvider);
    final isArabic = localization.language == AppLanguage.ar;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      drawer: HomeDrawer(isArabic: isArabic),
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
                    child: HomeTopOverlay(
                      scaffoldKey: _scaffoldKey,
                      homeState: homeState,
                      selectedStation: _selectedStation,
                      isArabic: isArabic,
                      stationHeroTag: _selectedStation != null
                          ? _stationHeroTag(_selectedStation!)
                          : null,
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
                      child: HomeBottomSection(
                        homeState: homeState,
                        isArabic: isArabic,
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
}

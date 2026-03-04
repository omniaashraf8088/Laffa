import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/colors.dart';
import '../../core/constants/fonts.dart';
import '../../core/localization/app_strings_ar.dart';
import '../../core/localization/app_strings_en.dart';
import '../../core/localization/localization_provider.dart';

class _TripItem {
  final String id;
  final String stationName;
  final String date;
  final String duration;
  final String distance;
  final double cost;

  const _TripItem({
    required this.id,
    required this.stationName,
    required this.date,
    required this.duration,
    required this.distance,
    required this.cost,
  });
}

const _initialTrips = [
  _TripItem(
    id: '1',
    stationName: 'Cairo University Station',
    date: '2026-03-03',
    duration: '25 min',
    distance: '3.2 km',
    cost: 15.0,
  ),
  _TripItem(
    id: '2',
    stationName: 'Tahrir Square Station',
    date: '2026-03-02',
    duration: '18 min',
    distance: '2.1 km',
    cost: 10.5,
  ),
  _TripItem(
    id: '3',
    stationName: 'Maadi Station',
    date: '2026-03-01',
    duration: '40 min',
    distance: '5.8 km',
    cost: 25.0,
  ),
  _TripItem(
    id: '4',
    stationName: 'Heliopolis Station',
    date: '2026-02-28',
    duration: '12 min',
    distance: '1.5 km',
    cost: 8.0,
  ),
  _TripItem(
    id: '5',
    stationName: 'Zamalek Station',
    date: '2026-02-27',
    duration: '30 min',
    distance: '4.0 km',
    cost: 18.0,
  ),
];

class TripsScreen extends ConsumerStatefulWidget {
  const TripsScreen({super.key});

  @override
  ConsumerState<TripsScreen> createState() => _TripsScreenState();
}

class _TripsScreenState extends ConsumerState<TripsScreen> {
  late List<_TripItem> _trips;

  @override
  void initState() {
    super.initState();
    _trips = List.from(_initialTrips);
  }

  void _removeTrip(int index, {required bool isArabic}) {
    final removed = _trips[index];
    setState(() {
      _trips.removeAt(index);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isArabic ? AppStringsAr.tripDeleted : AppStringsEn.tripDeleted,
        ),
        action: SnackBarAction(
          label: isArabic ? AppStringsAr.undo : AppStringsEn.undo,
          onPressed: () {
            setState(() {
              _trips.insert(index, removed);
            });
          },
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> _clearAllTrips({required bool isArabic}) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          isArabic ? AppStringsAr.clearAllTrips : AppStringsEn.clearAllTrips,
          style: AppFonts.title(isArabic: isArabic, color: AppColors.text),
        ),
        content: Text(
          isArabic
              ? AppStringsAr.clearAllTripsConfirm
              : AppStringsEn.clearAllTripsConfirm,
          style: AppFonts.bodyMedium(
            isArabic: isArabic,
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              isArabic ? AppStringsAr.cancel : AppStringsEn.cancel,
              style: AppFonts.label(
                isArabic: isArabic,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              isArabic ? AppStringsAr.delete : AppStringsEn.delete,
              style: AppFonts.label(isArabic: isArabic, color: AppColors.error),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      final backup = List<_TripItem>.from(_trips);
      setState(() {
        _trips.clear();
      });
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isArabic ? AppStringsAr.clearAll : AppStringsEn.clearAll,
          ),
          action: SnackBarAction(
            label: isArabic ? AppStringsAr.undo : AppStringsEn.undo,
            onPressed: () {
              setState(() {
                _trips = backup;
              });
            },
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = ref.watch(localizationProvider);
    final isArabic = localization.language == AppLanguage.ar;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          isArabic ? AppStringsAr.tripHistory : AppStringsEn.tripHistory,
          style: AppFonts.title(isArabic: isArabic, color: AppColors.white),
        ),
        centerTitle: true,
        actions: [
          if (_trips.isNotEmpty)
            IconButton(
              icon: const Icon(
                Icons.delete_sweep_rounded,
                color: AppColors.white,
              ),
              tooltip: isArabic ? AppStringsAr.clearAll : AppStringsEn.clearAll,
              onPressed: () => _clearAllTrips(isArabic: isArabic),
            ),
        ],
      ),
      body: _trips.isEmpty
          ? _buildEmptyState(isArabic)
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: _trips.length,
              separatorBuilder: (_, _2) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final trip = _trips[index];
                return Dismissible(
                  key: ValueKey(trip.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => _removeTrip(index, isArabic: isArabic),
                  background: Container(
                    alignment: AlignmentDirectional.centerEnd,
                    padding: const EdgeInsetsDirectional.only(end: 24),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.delete_rounded,
                      color: AppColors.white,
                      size: 28,
                    ),
                  ),
                  child: _buildTripCard(trip, isArabic),
                );
              },
            ),
    );
  }

  Widget _buildEmptyState(bool isArabic) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.history_rounded,
              color: AppColors.primary,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isArabic ? 'لا توجد رحلات بعد' : 'No trips yet',
            style: AppFonts.title(isArabic: isArabic, color: AppColors.text),
          ),
          const SizedBox(height: 8),
          Text(
            isArabic
                ? 'ابدأ رحلتك الأولى من الخريطة'
                : 'Start your first ride from the map',
            style: AppFonts.bodyMedium(
              isArabic: isArabic,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripCard(_TripItem trip, bool isArabic) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.tripCompleted.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.electric_scooter_rounded,
                  color: AppColors.tripCompleted,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trip.stationName,
                      style: AppFonts.label(
                        isArabic: isArabic,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      trip.date,
                      style: AppFonts.caption(
                        isArabic: isArabic,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.successLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isArabic ? 'مكتملة' : 'Completed',
                  style: AppFonts.caption(
                    isArabic: isArabic,
                    color: AppColors.success,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTripStat(
                  Icons.timer_rounded,
                  trip.duration,
                  isArabic ? 'المدة' : 'Duration',
                  isArabic,
                ),
                Container(width: 1, height: 30, color: AppColors.border),
                _buildTripStat(
                  Icons.straighten_rounded,
                  trip.distance,
                  isArabic ? 'المسافة' : 'Distance',
                  isArabic,
                ),
                Container(width: 1, height: 30, color: AppColors.border),
                _buildTripStat(
                  Icons.payments_rounded,
                  '${trip.cost.toStringAsFixed(1)} EGP',
                  isArabic ? 'التكلفة' : 'Cost',
                  isArabic,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripStat(
    IconData icon,
    String value,
    String label,
    bool isArabic,
  ) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 16),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppFonts.style(
            isArabic: isArabic,
            fontSize: AppFonts.sizeSmall,
            fontWeight: AppFonts.bold,
            color: AppColors.text,
          ),
        ),
        Text(
          label,
          style: AppFonts.caption(
            isArabic: isArabic,
            color: AppColors.textTertiary,
          ),
        ),
      ],
    );
  }
}

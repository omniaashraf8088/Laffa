import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/localization/app_strings_ar.dart';
import '../../../../core/localization/app_strings_en.dart';
import '../../../../core/localization/localization_provider.dart';
import '../../data/trips_dummy_data.dart';
import '../../data/models/trip_model.dart';
import '../widgets/trip_card.dart';
import '../widgets/trips_empty_state.dart';

class TripsScreen extends ConsumerStatefulWidget {
  const TripsScreen({super.key});

  @override
  ConsumerState<TripsScreen> createState() => _TripsScreenState();
}

class _TripsScreenState extends ConsumerState<TripsScreen> {
  late List<TripItem> _trips;

  @override
  void initState() {
    super.initState();
    _trips = List.from(initialTrips);
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
          style: AppTextStyles.title(isArabic: isArabic, color: AppColors.text),
        ),
        content: Text(
          isArabic
              ? AppStringsAr.clearAllTripsConfirm
              : AppStringsEn.clearAllTripsConfirm,
          style: AppTextStyles.body(
            isArabic: isArabic,
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              isArabic ? AppStringsAr.cancel : AppStringsEn.cancel,
              style: AppTextStyles.label(
                isArabic: isArabic,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              isArabic ? AppStringsAr.delete : AppStringsEn.delete,
              style: AppTextStyles.label(
                isArabic: isArabic,
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      final backup = List<TripItem>.from(_trips);
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
          style: AppTextStyles.title(
            isArabic: isArabic,
            color: AppColors.white,
          ),
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
          ? TripsEmptyState(isArabic: isArabic)
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: _trips.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
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
                  child: TripCard(trip: trip, isArabic: isArabic),
                );
              },
            ),
    );
  }
}

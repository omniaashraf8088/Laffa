import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/localization/app_strings_ar.dart';
import '../../../../core/localization/app_strings_en.dart';
import '../../../../core/localization/localization_provider.dart';

class _SavedPlace {
  final String id;
  final String name;
  final String nameAr;
  final String address;
  final String addressAr;
  final IconData icon;

  const _SavedPlace({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.address,
    required this.addressAr,
    required this.icon,
  });
}

class SavedPlacesScreen extends ConsumerStatefulWidget {
  const SavedPlacesScreen({super.key});

  @override
  ConsumerState<SavedPlacesScreen> createState() => _SavedPlacesScreenState();
}

class _SavedPlacesScreenState extends ConsumerState<SavedPlacesScreen> {
  final List<_SavedPlace> _places = [
    const _SavedPlace(
      id: '1',
      name: AppStringsEn.homePlaceName,
      nameAr: AppStringsAr.homePlaceName,
      address: AppStringsEn.homeAddress,
      addressAr: AppStringsAr.homeAddress,
      icon: Icons.home_rounded,
    ),
    const _SavedPlace(
      id: '2',
      name: AppStringsEn.workPlaceName,
      nameAr: AppStringsAr.workPlaceName,
      address: AppStringsEn.workAddress,
      addressAr: AppStringsAr.workAddress,
      icon: Icons.work_rounded,
    ),
    const _SavedPlace(
      id: '3',
      name: AppStringsEn.universityPlaceName,
      nameAr: AppStringsAr.universityPlaceName,
      address: AppStringsEn.universityAddress,
      addressAr: AppStringsAr.universityAddress,
      icon: Icons.school_rounded,
    ),
  ];

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
          isArabic ? AppStringsAr.savedPlaces : AppStringsEn.savedPlaces,
          style: AppTextStyles.title(
            isArabic: isArabic,
            color: AppColors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: _places.isEmpty
          ? _buildEmptyState(isArabic)
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: _places.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return _buildPlaceCard(_places[index], isArabic);
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isArabic
                    ? AppStringsAr.addNewPlaceComingSoon
                    : AppStringsEn.addNewPlaceComingSoon,
              ),
              backgroundColor: AppColors.info,
            ),
          );
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_rounded, color: AppColors.white),
        label: Text(
          isArabic ? AppStringsAr.addPlace : AppStringsEn.addPlace,
          style: AppTextStyles.label(
            isArabic: isArabic,
            color: AppColors.white,
          ),
        ),
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
              color: AppColors.success.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.location_off_rounded,
              color: AppColors.success,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isArabic ? AppStringsAr.noSavedPlaces : AppStringsEn.noSavedPlaces,
            style: AppTextStyles.button(
              isArabic: isArabic,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isArabic
                ? AppStringsAr.addFavoritePlaces
                : AppStringsEn.addFavoritePlaces,
            style: AppTextStyles.body(
              isArabic: isArabic,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceCard(_SavedPlace place, bool isArabic) {
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
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(place.icon, color: AppColors.success, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isArabic ? place.nameAr : place.name,
                  style: AppTextStyles.button(
                    isArabic: isArabic,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isArabic ? place.addressAr : place.address,
                  style: AppTextStyles.caption(
                    isArabic: isArabic,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert_rounded,
              color: AppColors.textSecondary,
            ),
            onSelected: (value) {
              if (value == 'delete') {
                setState(() {
                  _places.removeWhere((p) => p.id == place.id);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isArabic
                          ? AppStringsAr.placeRemoved
                          : AppStringsEn.placeRemoved,
                    ),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    const Icon(
                      Icons.delete_rounded,
                      color: AppColors.error,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isArabic ? AppStringsAr.delete : AppStringsEn.delete,
                      style: AppTextStyles.body(
                        isArabic: isArabic,
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

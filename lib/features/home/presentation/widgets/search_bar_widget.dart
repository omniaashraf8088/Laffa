import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/localization/app_strings_ar.dart';
import '../../../../core/localization/app_strings_en.dart';
import '../../../../core/localization/localization_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../controllers/home_provider.dart';

class SearchBarWidget extends ConsumerStatefulWidget {
  const SearchBarWidget({super.key});

  @override
  ConsumerState<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends ConsumerState<SearchBarWidget> {
  late TextEditingController _searchController;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = ref.watch(localizationProvider);
    final isArabic = localization.language == AppLanguage.ar;
    final searchHint = isArabic
        ? AppStringsAr.searchStations
        : AppStringsEn.searchStations;

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SearchBar(
        controller: _searchController,
        onChanged: (query) {
          ref.read(homeProvider.notifier).searchStations(query);
          setState(() {
            _isSearching = query.isNotEmpty;
          });
        },
        onSubmitted: (query) {
          ref.read(homeProvider.notifier).searchStations(query);
        },
        backgroundColor: WidgetStateProperty.all(Colors.white),
        shadowColor: WidgetStateProperty.all(Colors.transparent),
        hintText: searchHint,
        hintStyle: WidgetStateProperty.all(
          AppTextStyles.bodyMedium(
            isArabic: isArabic,
            color: AppColors.textSecondary,
          ),
        ),
        textStyle: WidgetStateProperty.all(
          AppTextStyles.bodyMedium(isArabic: isArabic, color: AppColors.text),
        ),
        elevation: WidgetStateProperty.all(0),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.border, width: 1),
          ),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Icon(
            Icons.search_rounded,
            color: _isSearching ? AppColors.primary : AppColors.textTertiary,
            size: 20,
          ),
        ),
        trailing: _isSearching
            ? [
                GestureDetector(
                  onTap: () {
                    _searchController.clear();
                    ref.read(homeProvider.notifier).clearSearch();
                    setState(() {
                      _isSearching = false;
                    });
                  },
                  child: const Icon(
                    Icons.close_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
              ]
            : [],
      ),
    );
  }
}

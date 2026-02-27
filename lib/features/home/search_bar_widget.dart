import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/localization/app_strings_ar.dart';
import '../../core/localization/app_strings_en.dart';
import '../../core/localization/localization_provider.dart';
import '../../core/theme/app_theme.dart';
import 'home_provider.dart';

class SearchBarWidget extends ConsumerStatefulWidget {
  const SearchBarWidget({Key? key}) : super(key: key);

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
    final searchHint =
      isArabic ? AppStringsAr.searchStations : AppStringsEn.searchStations;

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
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
        backgroundColor: MaterialStateProperty.all(Colors.white),
        shadowColor: MaterialStateProperty.all(Colors.transparent),
        hintText: searchHint,
        hintStyle: MaterialStateProperty.all(
          GoogleFonts.getFont(
            isArabic ? 'Cairo' : 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        textStyle: MaterialStateProperty.all(
          GoogleFonts.getFont(
            isArabic ? 'Cairo' : 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.text,
          ),
        ),
        elevation: MaterialStateProperty.all(0),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.border, width: 1),
          ),
        ),
        padding: MaterialStateProperty.all(
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
                  child: Icon(
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

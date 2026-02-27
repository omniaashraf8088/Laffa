import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/localization/app_strings_ar.dart';
import '../../core/localization/app_strings_en.dart';
import '../../core/localization/localization_provider.dart';
import '../../core/theme/app_theme.dart';
import 'home_provider.dart';
import 'station_model.dart';

class StationCardWidget extends ConsumerStatefulWidget {
  final Station station;
  final VoidCallback onStartRidePressed;
  final String? heroTag;

  const StationCardWidget({
    Key? key,
    required this.station,
    required this.onStartRidePressed,
    this.heroTag,
  }) : super(key: key);

  @override
  ConsumerState<StationCardWidget> createState() => _StationCardWidgetState();
}

class _StationCardWidgetState extends ConsumerState<StationCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideAnimation = Tween<double>(begin: 100, end: 0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = ref.watch(localizationProvider);
    final isArabic = localization.language == AppLanguage.ar;
    final availableScootersLabel = isArabic
      ? AppStringsAr.availableScooters
      : AppStringsEn.availableScooters;
    final startRideLabel =
      isArabic ? AppStringsAr.startRide : AppStringsEn.startRide;
    final noHiddenFeesLabel =
      isArabic ? AppStringsAr.noHiddenFees : AppStringsEn.noHiddenFees;
    final homeState = ref.watch(homeProvider);
    final isLoading = homeState.isLoading;

    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: child,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with divider
                Center(
                  child: Container(
                    width: 48,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Station name
                widget.heroTag == null
                    ? Text(
                        widget.station.name,
                        style: GoogleFonts.getFont(
                          isArabic ? 'Cairo' : 'Poppins',
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                      )
                    : Hero(
                        tag: widget.heroTag!,
                        child: Material(
                          color: Colors.transparent,
                          child: Text(
                            widget.station.name,
                            style: GoogleFonts.getFont(
                              isArabic ? 'Cairo' : 'Poppins',
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.text,
                            ),
                          ),
                        ),
                      ),
                const SizedBox(height: 8),

                // Station details row
                Row(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      color: AppColors.primary,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${widget.station.latitude.toStringAsFixed(4)}, ${widget.station.longitude.toStringAsFixed(4)}',
                        style: GoogleFonts.getFont(
                          isArabic ? 'Cairo' : 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Available scooters card
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border, width: 1),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.two_wheeler_rounded,
                          color: AppColors.primary,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              availableScootersLabel,
                              style: GoogleFonts.getFont(
                                isArabic ? 'Cairo' : 'Poppins',
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${widget.station.availableScooters}',
                              style: GoogleFonts.getFont(
                                isArabic ? 'Cairo' : 'Poppins',
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Start ride button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : widget.onStartRidePressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      disabledBackgroundColor: AppColors.primary.withOpacity(
                        0.5,
                      ),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: isLoading
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white.withOpacity(0.8),
                              ),
                              strokeWidth: 2.5,
                            ),
                          )
                        : Text(
                            startRideLabel,
                            style: GoogleFonts.getFont(
                              isArabic ? 'Cairo' : 'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16),

                // Info text
                Center(
                  child: Text(
                    noHiddenFeesLabel,
                    style: GoogleFonts.getFont(
                      isArabic ? 'Cairo' : 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

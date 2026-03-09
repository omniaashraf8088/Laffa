import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/fonts.dart';
import '../../../../core/localization/app_strings_ar.dart';
import '../../../../core/localization/app_strings_en.dart';

/// Widget that displays a live timer for the current trip.
/// Uses a Stream to update every second.
class TripTimerWidget extends StatelessWidget {
  final DateTime startTime;
  final bool isArabic;
  final bool isLarge;

  const TripTimerWidget({
    super.key,
    required this.startTime,
    required this.isArabic,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: Stream<int>.periodic(
        const Duration(seconds: 1),
        (count) => count,
      ),
      builder: (context, snapshot) {
        final duration = DateTime.now().difference(startTime);
        final formatted = _formatDuration(duration);

        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: isLarge ? 32 : 20,
            vertical: isLarge ? 20 : 12,
          ),
          decoration: BoxDecoration(
            color: AppColors.tripTimerBackground,
            borderRadius: BorderRadius.circular(isLarge ? 24 : 16),
            boxShadow: [
              BoxShadow(
                color: AppColors.tripTimerBackground.withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isArabic
                    ? AppStringsAr.tripDuration
                    : AppStringsEn.tripDuration,
                style: AppFonts.style(
                  isArabic: isArabic,
                  fontSize: isLarge ? AppFonts.sizeBody : AppFonts.sizeSmall,
                  color: AppColors.white.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                formatted,
                style: AppFonts.style(
                  isArabic: false, // Always use monospace-like font for timer
                  fontSize: isLarge ? AppFonts.sizeHero : AppFonts.sizeHeading,
                  fontWeight: AppFonts.bold,
                  color: AppColors.white,
                  letterSpacing: 2.0,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Formats a duration as HH:MM:SS or MM:SS.
  String _formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');

    if (duration.inHours > 0) {
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/localization/localization_provider.dart';
import '../../../../core/localization/app_strings_ar.dart';
import '../../../../core/localization/app_strings_en.dart';
import '../../../../core/router/app_router.dart';
import '../../data/rating_tags.dart';
import '../controllers/rating_provider.dart';
import '../widgets/star_rating_widget.dart';
import '../widgets/feedback_tags_widget.dart';
import '../widgets/review_text_field.dart';

/// Rating screen where users rate their completed trip.
/// Includes interactive star rating, feedback tags, and optional comment.
class RatingScreen extends ConsumerStatefulWidget {
  final String tripId;

  const RatingScreen({super.key, required this.tripId});

  @override
  ConsumerState<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends ConsumerState<RatingScreen> {
  final _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(ratingProvider.notifier).initialize(widget.tripId);
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ratingState = ref.watch(ratingProvider);
    final localization = ref.watch(localizationProvider);
    final isArabic = localization.language == AppLanguage.ar;

    // Listen for submission success
    ref.listen(ratingProvider, (previous, next) {
      if (next.isSubmitted && !(previous?.isSubmitted ?? false)) {
        _showSuccessDialog(context, isArabic);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          isArabic ? AppStringsAr.rateYourTrip : AppStringsEn.rateYourTrip,
          style: AppTextStyles.title(
            isArabic: isArabic,
            color: AppColors.white,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: AppColors.white),
          onPressed: () {
            ref.read(ratingProvider.notifier).reset();
            context.go(AppRouter.home);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  // Illustration / emoji area
                  _buildHeader(ratingState.stars, isArabic),

                  const SizedBox(height: 32),

                  // Star rating
                  StarRatingWidget(
                    rating: ratingState.stars,
                    isArabic: isArabic,
                    onRatingChanged: (stars) {
                      ref.read(ratingProvider.notifier).setStars(stars);
                    },
                  ),

                  const SizedBox(height: 32),

                  // Feedback tags
                  _buildFeedbackSection(ratingState, isArabic),

                  const SizedBox(height: 24),

                  // Review text field
                  ReviewTextField(
                    controller: _commentController,
                    isArabic: isArabic,
                    onChanged: (value) {
                      ref.read(ratingProvider.notifier).setComment(value);
                    },
                  ),

                  const SizedBox(height: 16),

                  // Error message
                  if (ratingState.error != null)
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.errorLight,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.error.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: AppColors.error,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              ratingState.error!,
                              style: AppTextStyles.bodySmall(
                                isArabic: isArabic,
                                color: AppColors.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Submit button at bottom
          _buildSubmitButton(ratingState, isArabic),
        ],
      ),
    );
  }

  /// Builds the header area with a contextual icon based on rating.
  Widget _buildHeader(int stars, bool isArabic) {
    IconData icon;
    Color color;
    String message;

    if (stars >= 4) {
      icon = Icons.sentiment_very_satisfied_rounded;
      color = AppColors.success;
      message = isArabic ? AppStringsAr.happyToHear : AppStringsEn.happyToHear;
    } else if (stars >= 3) {
      icon = Icons.sentiment_satisfied_rounded;
      color = AppColors.warning;
      message = isArabic
          ? AppStringsAr.thanksForFeedback
          : AppStringsEn.thanksForFeedback;
    } else if (stars >= 1) {
      icon = Icons.sentiment_dissatisfied_rounded;
      color = AppColors.error;
      message = isArabic
          ? AppStringsAr.sorryExperience
          : AppStringsEn.sorryExperience;
    } else {
      icon = Icons.sentiment_neutral_rounded;
      color = AppColors.greyMedium;
      message = isArabic ? AppStringsAr.howWasRide : AppStringsEn.howWasRide;
    }

    return Column(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Icon(icon, key: ValueKey(stars), size: 80, color: color),
        ),
        const SizedBox(height: 12),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Text(
            message,
            key: ValueKey(message),
            style: AppTextStyles.subheading(
              isArabic: isArabic,
              color: AppColors.text,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  /// Builds the feedback tags section, choosing positive or negative tags
  /// based on the current rating.
  Widget _buildFeedbackSection(RatingState state, bool isArabic) {
    final tags = state.stars >= 3
        ? RatingTags.positive(isArabic)
        : state.stars > 0
        ? RatingTags.negative(isArabic)
        : <String>[];

    if (tags.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isArabic
              ? AppStringsAr.whatMadeYouRate
              : AppStringsEn.whatMadeYouRate,
          style: AppTextStyles.label(isArabic: isArabic, color: AppColors.text),
        ),
        const SizedBox(height: 12),
        FeedbackTagsWidget(
          tags: tags,
          selectedTags: state.selectedTags,
          isArabic: isArabic,
          onTagToggled: (tag) {
            ref.read(ratingProvider.notifier).toggleTag(tag);
          },
        ),
      ],
    );
  }

  /// Builds the submit button.
  Widget _buildSubmitButton(RatingState state, bool isArabic) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: state.isSubmitting || state.stars == 0
                ? null
                : () {
                    ref.read(ratingProvider.notifier).submitRating();
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              disabledBackgroundColor: AppColors.greyMedium,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
            child: state.isSubmitting
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.white,
                      ),
                    ),
                  )
                : Text(
                    isArabic
                        ? AppStringsAr.submitRating
                        : AppStringsEn.submitRating,
                    style: AppTextStyles.button(
                      isArabic: isArabic,
                      color: AppColors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  /// Shows a success dialog after rating submission.
  void _showSuccessDialog(BuildContext context, bool isArabic) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.ratingBackground,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.star_rounded,
                  color: AppColors.ratingStar,
                  size: 40,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                isArabic
                    ? AppStringsAr.thanksForRating
                    : AppStringsEn.thanksForRating,
                style: AppTextStyles.title(
                  isArabic: isArabic,
                  color: AppColors.text,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                isArabic
                    ? AppStringsAr.feedbackHelps
                    : AppStringsEn.feedbackHelps,
                style: AppTextStyles.body(
                  isArabic: isArabic,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    ref.read(ratingProvider.notifier).reset();
                    context.go(AppRouter.home);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    isArabic
                        ? AppStringsAr.backToHome
                        : AppStringsEn.backToHome,
                    style: AppTextStyles.button(
                      isArabic: isArabic,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

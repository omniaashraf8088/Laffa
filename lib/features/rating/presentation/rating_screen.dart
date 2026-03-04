import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/fonts.dart';
import '../../../core/localization/localization_provider.dart';
import '../domain/rating_model.dart';
import '../domain/rating_provider.dart';
import 'widgets/star_rating_widget.dart';
import 'widgets/feedback_tags_widget.dart';
import 'widgets/review_text_field.dart';

/// Rating screen where users rate their completed trip.
/// Includes interactive star rating, feedback tags, and optional comment.
class RatingScreen extends ConsumerStatefulWidget {
  final String tripId;

  const RatingScreen({
    super.key,
    required this.tripId,
  });

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
          isArabic ? 'تقييم الرحلة' : 'Rate Your Trip',
          style: AppFonts.title(isArabic: isArabic, color: AppColors.white),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: AppColors.white),
          onPressed: () {
            ref.read(ratingProvider.notifier).reset();
            context.go('/home');
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
                          color: AppColors.error.withOpacity(0.3),
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
                              style: AppFonts.bodySmall(
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
      message = isArabic ? 'سعداء بسماع ذلك!' : 'Happy to hear that!';
    } else if (stars >= 3) {
      icon = Icons.sentiment_satisfied_rounded;
      color = AppColors.warning;
      message = isArabic ? 'شكراً لتقييمك' : 'Thanks for your feedback';
    } else if (stars >= 1) {
      icon = Icons.sentiment_dissatisfied_rounded;
      color = AppColors.error;
      message = isArabic ? 'نأسف لتجربتك' : 'Sorry about your experience';
    } else {
      icon = Icons.sentiment_neutral_rounded;
      color = AppColors.greyMedium;
      message = isArabic ? 'كيف كانت رحلتك؟' : 'How was your ride?';
    }

    return Column(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Icon(
            icon,
            key: ValueKey(stars),
            size: 80,
            color: color,
          ),
        ),
        const SizedBox(height: 12),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Text(
            message,
            key: ValueKey(message),
            style: AppFonts.subheading(
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
        ? RatingTags.positive
        : state.stars > 0
            ? RatingTags.negative
            : <String>[];

    if (tags.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isArabic ? 'ما سبب تقييمك؟' : 'What made you rate this way?',
          style: AppFonts.style(
            isArabic: isArabic,
            fontSize: AppFonts.sizeBody,
            fontWeight: AppFonts.semiBold,
            color: AppColors.text,
          ),
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
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.white),
                    ),
                  )
                : Text(
                    isArabic ? 'إرسال التقييم' : 'Submit Rating',
                    style: AppFonts.button(
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
                isArabic ? 'شكراً لتقييمك!' : 'Thanks for Rating!',
                style: AppFonts.title(
                  isArabic: isArabic,
                  color: AppColors.text,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                isArabic
                    ? 'تقييمك يساعدنا على تحسين الخدمة'
                    : 'Your feedback helps us improve',
                style: AppFonts.bodyMedium(
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
                    context.go('/home');
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
                    isArabic ? 'العودة للرئيسية' : 'Back to Home',
                    style: AppFonts.button(
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

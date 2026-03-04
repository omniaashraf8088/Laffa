import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/fonts.dart';
import '../../core/theme/app_theme.dart';
import 'onboarding_model.dart';

/// Individual onboarding page widget with animations
class OnboardingPageWidget extends StatefulWidget {
  final OnboardingModel page;
  final bool isArabic;
  final int pageIndex;

  const OnboardingPageWidget({
    super.key,
    required this.page,
    required this.isArabic,
    required this.pageIndex,
  });

  @override
  State<OnboardingPageWidget> createState() => _OnboardingPageWidgetState();
}

class _OnboardingPageWidgetState extends State<OnboardingPageWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _animationController.forward();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.8, curve: Curves.elasticOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
          ),
        );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final animationSize = isSmallScreen ? size.width * 0.6 : 300.0;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            widget.page.backgroundColor,
            widget.page.backgroundColor.withValues(alpha: 0.8),
            AppColors.background,
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen
                ? AppDimensions.paddingLarge
                : AppDimensions.paddingXLarge,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 1),

              // Animation Section
              _buildAnimationSection(animationSize),

              const SizedBox(height: AppDimensions.paddingXLarge * 1.5),

              // Content Section
              _buildContentSection(isSmallScreen),

              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimationSection(double size) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Hero(
          tag: 'onboarding_animation_${widget.pageIndex}',
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white.withValues(alpha: 0.9),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                  spreadRadius: 5,
                ),
              ],
            ),
            child: _buildAnimationContent(size),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimationContent(double size) {
    // Check if Lottie file exists, otherwise use fallback icon
    if (widget.page.lottieAssetPath != null) {
      // Placeholder for Lottie animation
      // TODO: Replace with actual Lottie widget when assets are added
      // return Lottie.asset(
      //   widget.page.lottieAssetPath!,
      //   width: size * 0.8,
      //   height: size * 0.8,
      //   fit: BoxFit.contain,
      // );

      // For now, use the fallback icon with a note
      return _buildFallbackIcon(size);
    }

    return _buildFallbackIcon(size);
  }

  Widget _buildFallbackIcon(double size) {
    return Center(
      child: Icon(
        widget.page.fallbackIcon ?? Icons.electric_scooter_rounded,
        size: size * 0.5,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildContentSection(bool isSmallScreen) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Title
            Text(
              widget.page.getTitle(widget.isArabic),
              style: AppFonts.style(
                isArabic: widget.isArabic,
                fontSize: isSmallScreen ? 28 : 36,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
                height: widget.isArabic ? 1.3 : 1.2,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppDimensions.paddingMedium),

            // Description
            Container(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Text(
                widget.page.getDescription(widget.isArabic),
                style: AppFonts.style(
                  isArabic: widget.isArabic,
                  fontSize: isSmallScreen ? 16 : 18,
                  fontWeight: FontWeight.w400,
                  color: AppColors.greyDark,
                  height: widget.isArabic ? 1.6 : 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

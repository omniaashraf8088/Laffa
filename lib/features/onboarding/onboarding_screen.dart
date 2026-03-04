import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/fonts.dart';
import '../../core/localization/localization_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/common_widgets.dart';
import 'onboarding_model.dart';
import 'onboarding_page.dart';

/// Professional Onboarding Screen with PageView and smooth animations
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  int _currentPage = 0;
  late AnimationController _buttonAnimationController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _buttonAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _buttonAnimationController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });

    // Animate button change on last page
    if (index == OnboardingData.pages.length - 1) {
      _buttonAnimationController.forward();
    } else {
      _buttonAnimationController.reverse();
    }
  }

  void _navigateToNextPage() {
    if (_currentPage < OnboardingData.pages.length - 1) {
      _pageController.nextPage(
        duration: AppConstants.pageTransitionDuration,
        curve: Curves.easeInOutCubic,
      );
    } else {
      _navigateToAuth();
    }
  }

  void _navigateToAuth() {
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final localization = ref.watch(localizationProvider);
    final isArabic = localization.language == AppLanguage.ar;
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // PageView with onboarding pages
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: OnboardingData.pages.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return OnboardingPageWidget(
                page: OnboardingData.pages[index],
                isArabic: isArabic,
                pageIndex: index,
              );
            },
          ),

          // Skip button (Top Right/Left based on RTL)
          _buildSkipButton(isArabic, isSmallScreen),

          // Bottom navigation section
          _buildBottomNavigation(isArabic, isSmallScreen),
        ],
      ),
    );
  }

  Widget _buildSkipButton(bool isArabic, bool isSmallScreen) {
    // Don't show skip button on last page
    if (_currentPage == OnboardingData.pages.length - 1) {
      return const SizedBox.shrink();
    }

    return Positioned(
      top: MediaQuery.of(context).padding.top + AppDimensions.paddingMedium,
      right: isArabic ? null : AppDimensions.paddingMedium,
      left: isArabic ? AppDimensions.paddingMedium : null,
      child: SafeArea(
        child: AnimatedOpacity(
          opacity: _currentPage == OnboardingData.pages.length - 1 ? 0.0 : 1.0,
          duration: const Duration(milliseconds: 300),
          child: TextButton(
            onPressed: _navigateToAuth,
            style: TextButton.styleFrom(
              backgroundColor: AppColors.white.withValues(alpha: 0.9),
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingLarge,
                vertical: AppDimensions.paddingSmall,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
              ),
            ),
            child: Text(
              isArabic ? 'تخطي' : 'Skip',
              style: AppFonts.style(
                isArabic: isArabic,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigation(bool isArabic, bool isSmallScreen) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.all(
          isSmallScreen
              ? AppDimensions.paddingLarge
              : AppDimensions.paddingXLarge,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(AppDimensions.radiusXLarge),
            topRight: Radius.circular(AppDimensions.radiusXLarge),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
              spreadRadius: 2,
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Page indicators
              _buildPageIndicators(),

              SizedBox(
                height: isSmallScreen
                    ? AppDimensions.paddingLarge
                    : AppDimensions.paddingXLarge,
              ),

              // Action buttons
              _buildActionButtons(isArabic),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        OnboardingData.pages.length,
        (index) => _buildIndicatorDot(index),
      ),
    );
  }

  Widget _buildIndicatorDot(int index) {
    final isActive = _currentPage == index;

    return AnimatedContainer(
      duration: AppConstants.cardAnimationDuration,
      curve: Curves.easeInOut,
      height: 8,
      width: isActive ? 32 : 8,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.primary
            : AppColors.grey.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
    );
  }

  Widget _buildActionButtons(bool isArabic) {
    final isLastPage = _currentPage == OnboardingData.pages.length - 1;

    return Row(
      children: [
        // Back button (only show if not on first page and not on last page)
        if (_currentPage > 0 && !isLastPage)
          Expanded(
            child: SecondaryButton(
              label: isArabic ? 'السابق' : 'Back',
              onPressed: () {
                _pageController.previousPage(
                  duration: AppConstants.pageTransitionDuration,
                  curve: Curves.easeInOutCubic,
                );
              },
            ),
          ),

        // Spacer if back button is shown
        if (_currentPage > 0 && !isLastPage)
          const SizedBox(width: AppDimensions.paddingMedium),

        // Next or Get Started button
        Expanded(
          flex: isLastPage ? 1 : (_currentPage > 0 ? 1 : 2),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return ScaleTransition(
                scale: animation,
                child: FadeTransition(opacity: animation, child: child),
              );
            },
            child: PrimaryButton(
              key: ValueKey<bool>(isLastPage),
              label: isLastPage
                  ? (isArabic ? 'ابدأ الآن' : 'Get Started')
                  : (isArabic ? 'التالي' : 'Next'),
              onPressed: _navigateToNextPage,
              backgroundColor: isLastPage
                  ? AppColors.accent
                  : AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}

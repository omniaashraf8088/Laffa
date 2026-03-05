import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/fonts.dart';
import '../../core/localization/localization_provider.dart';
import '../../core/theme/app_theme.dart';
import 'onboarding_model.dart';
import 'onboarding_page.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  int _currentPage = 0;
  double _pageOffset = 0;

  late AnimationController _enterCtrl;
  late Animation<double> _bottomSlide;
  late Animation<double> _bottomFade;

  late AnimationController _pulseCtrl;
  late AnimationController _swipeHintCtrl;

  @override
  void initState() {
    super.initState();
    _pageController = PageController()
      ..addListener(() {
        setState(() => _pageOffset = _pageController.page ?? 0);
      });

    // Bottom panel entrance
    _enterCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _bottomSlide = Tween<double>(begin: 120, end: 0).animate(
      CurvedAnimation(
        parent: _enterCtrl,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
      ),
    );
    _bottomFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _enterCtrl,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    // Continuous pulse for active indicator
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    // Swipe hint arrow bounce (only on first page)
    _swipeHintCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _enterCtrl.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _enterCtrl.dispose();
    _pulseCtrl.dispose();
    _swipeHintCtrl.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() => _currentPage = index);
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
          // Floating background shapes (parallax with page offset)
          _buildParallaxShapes(size),

          // PageView
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

          // Skip button top
          _buildSkipButton(isArabic, isSmallScreen),

          // Page counter top-center
          _buildPageCounter(isSmallScreen),

          // Swipe hint on first page
          if (_currentPage == 0) _buildSwipeHint(isArabic, size),

          // Bottom panel
          _buildBottomPanel(isArabic, isSmallScreen),
        ],
      ),
    );
  }

  // ── Parallax floating shapes ──
  Widget _buildParallaxShapes(Size screenSize) {
    return AnimatedBuilder(
      animation: _pulseCtrl,
      builder: (context, _) {
        final pulse = math.sin(_pulseCtrl.value * math.pi);
        return Stack(
          children: [
            // Large circle top-right
            Positioned(
              top: -60 + _pageOffset * -20,
              right: -40 + _pageOffset * 15,
              child: Opacity(
                opacity: 0.04 + pulse * 0.01,
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            // Medium circle bottom-left
            Positioned(
              bottom: 180 + _pageOffset * 10,
              left: -50 + _pageOffset * -12,
              child: Opacity(
                opacity: 0.03 + pulse * 0.01,
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.secondary,
                  ),
                ),
              ),
            ),
            // Small diamond center-right
            Positioned(
              top: screenSize.height * 0.35 + _pageOffset * -8,
              right: 30 + _pageOffset * 20,
              child: Opacity(
                opacity: 0.05,
                child: Transform.rotate(
                  angle: math.pi / 4 + _pageOffset * 0.1,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.bookingHighlight,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ── Page counter (1 / 5) ──
  Widget _buildPageCounter(bool isSmallScreen) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + AppDimensions.paddingMedium,
      left: 0,
      right: 0,
      child: AnimatedBuilder(
        animation: _enterCtrl,
        builder: (context, _) {
          return Opacity(
            opacity: _bottomFade.value,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Text(
                    '${_currentPage + 1} / ${OnboardingData.pages.length}',
                    key: ValueKey(_currentPage),
                    style: TextStyle(
                      fontSize: isSmallScreen ? 13 : 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Skip button ──
  Widget _buildSkipButton(bool isArabic, bool isSmallScreen) {
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
          child: GestureDetector(
            onTap: _navigateToAuth,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingLarge,
                vertical: AppDimensions.paddingSmall,
              ),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.1),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isArabic ? 'تخطي' : 'Skip',
                    style: AppFonts.style(
                      isArabic: isArabic,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    isArabic
                        ? Icons.keyboard_arrow_left_rounded
                        : Icons.keyboard_arrow_right_rounded,
                    size: 18,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Swipe hint on first page ──
  Widget _buildSwipeHint(bool isArabic, Size screenSize) {
    return Positioned(
      bottom: 210,
      left: 0,
      right: 0,
      child: AnimatedBuilder(
        animation: _swipeHintCtrl,
        builder: (context, _) {
          final t = _swipeHintCtrl.value;
          final bounce = math.sin(t * math.pi) * 8;
          final opacity = (0.3 + 0.4 * math.sin(t * math.pi)).clamp(0.0, 1.0);

          return Opacity(
            opacity: opacity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.translate(
                  offset: Offset(isArabic ? bounce : -bounce, 0),
                  child: Icon(
                    isArabic
                        ? Icons.chevron_left_rounded
                        : Icons.chevron_right_rounded,
                    size: 28,
                    color: AppColors.primary.withValues(alpha: 0.4),
                  ),
                ),
                Text(
                  isArabic ? 'اسحب للمتابعة' : 'Swipe to continue',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
                Transform.translate(
                  offset: Offset(isArabic ? bounce : -bounce, 0),
                  child: Icon(
                    isArabic
                        ? Icons.chevron_left_rounded
                        : Icons.chevron_right_rounded,
                    size: 28,
                    color: AppColors.primary.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ── Bottom navigation panel ──
  Widget _buildBottomPanel(bool isArabic, bool isSmallScreen) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: AnimatedBuilder(
        animation: _enterCtrl,
        builder: (context, _) {
          return Transform.translate(
            offset: Offset(0, _bottomSlide.value),
            child: Opacity(
              opacity: _bottomFade.value,
              child: Container(
                padding: EdgeInsets.all(
                  isSmallScreen
                      ? AppDimensions.paddingLarge
                      : AppDimensions.paddingXLarge,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      blurRadius: 30,
                      offset: const Offset(0, -8),
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildPageIndicators(),
                      SizedBox(
                        height: isSmallScreen
                            ? AppDimensions.paddingLarge
                            : AppDimensions.paddingXLarge,
                      ),
                      _buildActionButtons(isArabic),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Indicators with animated active dot ──
  Widget _buildPageIndicators() {
    return AnimatedBuilder(
      animation: _pulseCtrl,
      builder: (context, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            OnboardingData.pages.length,
            (index) => _buildIndicatorDot(index),
          ),
        );
      },
    );
  }

  Widget _buildIndicatorDot(int index) {
    final isActive = _currentPage == index;
    final pulse = isActive ? math.sin(_pulseCtrl.value * math.pi) : 0.0;

    // Calculate distance to active page for nearby glow
    final distance = (_currentPage - index).abs();
    final isNear = distance == 1;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      height: isActive ? 10 : 8,
      width: isActive ? 36 : (isNear ? 12 : 8),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.primary
            : isNear
            ? AppColors.primary.withValues(alpha: 0.25)
            : AppColors.grey.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(5),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(
                    alpha: 0.3 + pulse * 0.15,
                  ),
                  blurRadius: 10 + pulse * 4,
                  offset: const Offset(0, 2),
                  spreadRadius: pulse * 1,
                ),
              ]
            : null,
      ),
    );
  }

  // ── Action buttons ──
  Widget _buildActionButtons(bool isArabic) {
    final isLastPage = _currentPage == OnboardingData.pages.length - 1;

    return Row(
      children: [
        // Back button
        if (_currentPage > 0 && !isLastPage)
          Expanded(
            child: _AnimatedBackButton(
              label: isArabic ? 'السابق' : 'Back',
              isArabic: isArabic,
              onPressed: () {
                _pageController.previousPage(
                  duration: AppConstants.pageTransitionDuration,
                  curve: Curves.easeInOutCubic,
                );
              },
            ),
          ),

        if (_currentPage > 0 && !isLastPage)
          const SizedBox(width: AppDimensions.paddingMedium),

        // Next / Get Started
        Expanded(
          flex: isLastPage ? 1 : (_currentPage > 0 ? 1 : 2),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            switchInCurve: Curves.easeOutBack,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (child, animation) {
              return ScaleTransition(
                scale: animation,
                child: FadeTransition(opacity: animation, child: child),
              );
            },
            child: isLastPage
                ? _GetStartedButton(
                    key: const ValueKey('getStarted'),
                    label: isArabic ? 'ابدأ الآن' : 'Get Started',
                    isArabic: isArabic,
                    onPressed: _navigateToAuth,
                  )
                : _NextButton(
                    key: ValueKey('next_$_currentPage'),
                    label: isArabic ? 'التالي' : 'Next',
                    isArabic: isArabic,
                    onPressed: _navigateToNextPage,
                    progress: (_currentPage + 1) / OnboardingData.pages.length,
                  ),
          ),
        ),
      ],
    );
  }
}

// ── Next button with progress ring ──
class _NextButton extends StatelessWidget {
  final String label;
  final bool isArabic;
  final VoidCallback onPressed;
  final double progress;

  const _NextButton({
    super.key,
    required this.label,
    required this.isArabic,
    required this.onPressed,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: AppDimensions.buttonHeight,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: AppFonts.style(
                isArabic: isArabic,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
            const SizedBox(width: 8),
            // Small circular progress indicator
            SizedBox(
              width: 22,
              height: 22,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 2,
                    backgroundColor: AppColors.white.withValues(alpha: 0.2),
                    valueColor: const AlwaysStoppedAnimation(AppColors.white),
                  ),
                  Icon(
                    isArabic
                        ? Icons.arrow_back_ios_rounded
                        : Icons.arrow_forward_ios_rounded,
                    size: 10,
                    color: AppColors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Get Started button with gradient + shine ──
class _GetStartedButton extends StatefulWidget {
  final String label;
  final bool isArabic;
  final VoidCallback onPressed;

  const _GetStartedButton({
    super.key,
    required this.label,
    required this.isArabic,
    required this.onPressed,
  });

  @override
  State<_GetStartedButton> createState() => _GetStartedButtonState();
}

class _GetStartedButtonState extends State<_GetStartedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _shineCtrl;

  @override
  void initState() {
    super.initState();
    _shineCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _shineCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shineCtrl,
      builder: (context, _) {
        final shinePos = _shineCtrl.value;
        return GestureDetector(
          onTap: widget.onPressed,
          child: Container(
            height: AppDimensions.buttonHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.accent,
                  AppColors.primaryLight,
                  AppColors.primary,
                ],
                stops: const [0.0, 0.35, 0.65, 1.0],
              ),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                  spreadRadius: 1,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Shine sweep
                  Positioned(
                    left:
                        -80 +
                        (MediaQuery.of(context).size.width + 80) * shinePos,
                    child: Transform.rotate(
                      angle: 0.3,
                      child: Container(
                        width: 40,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.white.withValues(alpha: 0),
                              AppColors.white.withValues(alpha: 0.12),
                              AppColors.white.withValues(alpha: 0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Label + icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.label,
                        style: AppFonts.style(
                          isArabic: widget.isArabic,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.white.withValues(alpha: 0.2),
                        ),
                        child: Icon(
                          widget.isArabic
                              ? Icons.arrow_back_rounded
                              : Icons.arrow_forward_rounded,
                          size: 18,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ── Animated back button ──
class _AnimatedBackButton extends StatelessWidget {
  final String label;
  final bool isArabic;
  final VoidCallback onPressed;

  const _AnimatedBackButton({
    required this.label,
    required this.isArabic,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: AppDimensions.buttonHeight,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isArabic
                  ? Icons.arrow_forward_ios_rounded
                  : Icons.arrow_back_ios_rounded,
              size: 14,
              color: AppColors.primary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppFonts.style(
                isArabic: isArabic,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

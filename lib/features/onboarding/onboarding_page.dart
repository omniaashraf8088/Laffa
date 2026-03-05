import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/fonts.dart';
import '../../core/theme/app_theme.dart';
import 'onboarding_model.dart';

/// Individual onboarding page widget with rich icon animations
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
    with TickerProviderStateMixin {
  // Entry animation
  late AnimationController _entryCtrl;
  late Animation<double> _fadeIn;
  late Animation<double> _scaleIn;

  // Continuous loop for icon effects
  late AnimationController _loopCtrl;

  // One-shot icon entrance (bounce / burst)
  late AnimationController _iconEntryCtrl;
  late Animation<double> _iconBounce;
  late Animation<double> _iconRotate;

  // Ring / ripple burst on icon land
  late AnimationController _rippleCtrl;

  // Staggered text animations
  late AnimationController _textCtrl;
  late Animation<double> _titleFade;
  late Animation<double> _titleSlide;
  late Animation<double> _descFade;
  late Animation<double> _descSlide;

  @override
  void initState() {
    super.initState();

    // ── Entry (page-level fade, scale, slide) ──
    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeIn = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entryCtrl,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );
    _scaleIn = Tween<double>(begin: 0.4, end: 1).animate(
      CurvedAnimation(
        parent: _entryCtrl,
        curve: const Interval(0.0, 0.7, curve: Curves.elasticOut),
      ),
    );

    // ── Continuous loop (hover, pulse, rotate for different pages) ──
    _loopCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );

    // ── Icon entrance burst ──
    _iconEntryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _iconBounce = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.15), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.15, end: 0.92), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 0.92, end: 1.04), weight: 15),
      TweenSequenceItem(tween: Tween(begin: 1.04, end: 1.0), weight: 20),
    ]).animate(CurvedAnimation(parent: _iconEntryCtrl, curve: Curves.easeOut));
    _iconRotate = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: -0.05, end: 0.04), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 0.04, end: -0.02), weight: 30),
      TweenSequenceItem(tween: Tween(begin: -0.02, end: 0.0), weight: 30),
    ]).animate(CurvedAnimation(parent: _iconEntryCtrl, curve: Curves.easeOut));

    // ── Ripple rings that expand out ──
    _rippleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // ── Staggered text entrance ──
    _textCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _titleFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _textCtrl,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );
    _titleSlide = Tween<double>(begin: 25, end: 0).animate(
      CurvedAnimation(
        parent: _textCtrl,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOutCubic),
      ),
    );
    _descFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _textCtrl,
        curve: const Interval(0.35, 0.8, curve: Curves.easeIn),
      ),
    );
    _descSlide = Tween<double>(begin: 20, end: 0).animate(
      CurvedAnimation(
        parent: _textCtrl,
        curve: const Interval(0.35, 0.85, curve: Curves.easeOutCubic),
      ),
    );

    // Start sequence
    _entryCtrl.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _iconEntryCtrl.forward();
        _rippleCtrl.forward();
      }
    });
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        _loopCtrl.repeat(reverse: true);
        _textCtrl.forward();
      }
    });
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    _loopCtrl.dispose();
    _iconEntryCtrl.dispose();
    _rippleCtrl.dispose();
    _textCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final animSize = isSmallScreen ? size.width * 0.6 : 300.0;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            widget.page.backgroundColor,
            widget.page.backgroundColor.withValues(alpha: 0.7),
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
              _buildIconSection(animSize),
              const SizedBox(height: AppDimensions.paddingXLarge * 1.5),
              _buildContentSection(isSmallScreen),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }

  // ───────────────────────── Icon Section ─────────────────────────

  Widget _buildIconSection(double size) {
    return FadeTransition(
      opacity: _fadeIn,
      child: ScaleTransition(
        scale: _scaleIn,
        child: SizedBox(
          width: size * 1.3,
          height: size * 1.3,
          child: AnimatedBuilder(
            animation: Listenable.merge([
              _loopCtrl,
              _iconEntryCtrl,
              _rippleCtrl,
            ]),
            builder: (context, _) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  // Expanding ripple rings
                  ..._buildRipples(size),

                  // Decorative orbiting particles
                  ..._buildOrbitParticles(size),

                  // Main icon container with glass morphism
                  _buildIconContainer(size),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildIconContainer(double size) {
    final hover = math.sin(_loopCtrl.value * math.pi) * 6;

    return Transform.translate(
      offset: Offset(0, hover),
      child: Transform.scale(
        scale: _iconBounce.value,
        child: Transform.rotate(
          angle: _iconRotate.value,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white.withValues(alpha: 0.92),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  blurRadius: 40,
                  offset: const Offset(0, 12),
                  spreadRadius: 8,
                ),
                BoxShadow(
                  color: _accentForPage().withValues(alpha: 0.08),
                  blurRadius: 60,
                  spreadRadius: 15,
                ),
              ],
              border: Border.all(
                color: AppColors.white.withValues(alpha: 0.6),
                width: 2,
              ),
            ),
            child: _buildPageIcon(size),
          ),
        ),
      ),
    );
  }

  // ───────────────── Per-page icon compositions ─────────────────

  Widget _buildPageIcon(double size) {
    switch (widget.pageIndex) {
      case 0:
        return _buildScooterIcon(size);
      case 1:
        return _buildLocationIcon(size);
      case 2:
        return _buildScanIcon(size);
      case 3:
        return _buildRouteIcon(size);
      case 4:
        return _buildCouponIcon(size);
      default:
        return _buildGenericIcon(size);
    }
  }

  // ── Page 0: Scooter with motion lines ──
  Widget _buildScooterIcon(double size) {
    final t = _loopCtrl.value;
    final wheelSpin = t * math.pi * 2;
    final speedLineOpacity = (0.3 + 0.4 * math.sin(t * math.pi));

    return Stack(
      alignment: Alignment.center,
      children: [
        // Speed/wind lines behind
        for (int i = 0; i < 4; i++)
          Positioned(
            left: size * 0.12,
            top: size * (0.38 + i * 0.08),
            child: Opacity(
              opacity: speedLineOpacity * (0.4 + i * 0.15),
              child: Transform.translate(
                offset: Offset(-10 * t + i * 3, 0),
                child: Container(
                  width: size * (0.12 + i * 0.03),
                  height: 2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1),
                    gradient: LinearGradient(
                      colors: [
                        AppColors.secondary.withValues(alpha: 0),
                        AppColors.secondary.withValues(
                          alpha: speedLineOpacity * 0.6,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

        // Main scooter icon
        Icon(
          Icons.electric_scooter_rounded,
          size: size * 0.42,
          color: AppColors.primary,
        ),

        // Animated wheel dots
        Positioned(
          bottom: size * 0.26,
          left: size * 0.32,
          child: Transform.rotate(
            angle: wheelSpin,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.secondary.withValues(alpha: 0.5),
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: size * 0.26,
          right: size * 0.32,
          child: Transform.rotate(
            angle: wheelSpin,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.secondary.withValues(alpha: 0.5),
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),

        // Small sparkle
        Positioned(
          top: size * 0.22,
          right: size * 0.25,
          child: _buildSparkle(6, t, 0.0),
        ),
      ],
    );
  }

  // ── Page 1: Location pin with radar pulse ──
  Widget _buildLocationIcon(double size) {
    final t = _loopCtrl.value;
    final pulseScale = 1.0 + 0.3 * math.sin(t * math.pi);
    final pulseOpacity = 0.15 + 0.15 * math.sin(t * math.pi);

    return Stack(
      alignment: Alignment.center,
      children: [
        // Radar rings
        for (int i = 0; i < 3; i++)
          Transform.scale(
            scale: pulseScale + i * 0.25,
            child: Container(
              width: size * 0.5,
              height: size * 0.5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.bookingHighlight.withValues(
                    alpha: (pulseOpacity - i * 0.04).clamp(0, 1),
                  ),
                  width: 1.5 - i * 0.3,
                ),
              ),
            ),
          ),

        // Pin icon
        Icon(
          Icons.location_on_rounded,
          size: size * 0.42,
          color: AppColors.primary,
        ),

        // Small bouncing dot at pin tip
        Positioned(
          bottom: size * 0.28 + math.sin(t * math.pi * 2) * 4,
          child: Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.bookingHighlight,
              boxShadow: [
                BoxShadow(
                  color: AppColors.bookingHighlight.withValues(alpha: 0.5),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
        ),

        // Sparkles
        Positioned(
          top: size * 0.2,
          left: size * 0.22,
          child: _buildSparkle(5, t, 0.3),
        ),
        Positioned(
          top: size * 0.3,
          right: size * 0.18,
          child: _buildSparkle(4, t, 0.6),
        ),
      ],
    );
  }

  // ── Page 2: QR Scanner with scanning beam ──
  Widget _buildScanIcon(double size) {
    final t = _loopCtrl.value;
    final beamY = size * 0.25 + (size * 0.4) * t;
    final cornerSize = size * 0.15;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Corner brackets
        ..._buildScanCorners(size, cornerSize),

        // Scanning beam (horizontal line moving vertically)
        Positioned(
          top: beamY,
          child: Container(
            width: size * 0.5,
            height: 2.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              gradient: LinearGradient(
                colors: [
                  AppColors.bookingHighlight.withValues(alpha: 0),
                  AppColors.bookingHighlight.withValues(alpha: 0.8),
                  AppColors.bookingHighlight.withValues(alpha: 0),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.bookingHighlight.withValues(alpha: 0.3),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        ),

        // QR icon
        Icon(
          Icons.qr_code_scanner_rounded,
          size: size * 0.38,
          color: AppColors.primary,
        ),

        // Sparkle effect on beam position
        Positioned(
          top: beamY - 4,
          right: size * 0.28,
          child: _buildSparkle(5, t, 0.2),
        ),
      ],
    );
  }

  List<Widget> _buildScanCorners(double size, double cornerSize) {
    final opacity = 0.5 + 0.3 * math.sin(_loopCtrl.value * math.pi);
    final color = AppColors.primary.withValues(alpha: opacity);
    const width = 2.5;
    const radius = Radius.circular(4);

    return [
      // Top-left
      Positioned(
        top: size * 0.2,
        left: size * 0.2,
        child: Container(
          width: cornerSize,
          height: cornerSize,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: color, width: width),
              left: BorderSide(color: color, width: width),
            ),
            borderRadius: const BorderRadius.only(topLeft: radius),
          ),
        ),
      ),
      // Top-right
      Positioned(
        top: size * 0.2,
        right: size * 0.2,
        child: Container(
          width: cornerSize,
          height: cornerSize,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: color, width: width),
              right: BorderSide(color: color, width: width),
            ),
            borderRadius: const BorderRadius.only(topRight: radius),
          ),
        ),
      ),
      // Bottom-left
      Positioned(
        bottom: size * 0.2,
        left: size * 0.2,
        child: Container(
          width: cornerSize,
          height: cornerSize,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: color, width: width),
              left: BorderSide(color: color, width: width),
            ),
            borderRadius: const BorderRadius.only(bottomLeft: radius),
          ),
        ),
      ),
      // Bottom-right
      Positioned(
        bottom: size * 0.2,
        right: size * 0.2,
        child: Container(
          width: cornerSize,
          height: cornerSize,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: color, width: width),
              right: BorderSide(color: color, width: width),
            ),
            borderRadius: const BorderRadius.only(bottomRight: radius),
          ),
        ),
      ),
    ];
  }

  // ── Page 3: Route with animated dot traveling along path ──
  Widget _buildRouteIcon(double size) {
    final t = _loopCtrl.value;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Dashed path segments
        CustomPaint(
          size: Size(size * 0.65, size * 0.55),
          painter: _RoutePainter(
            progress: t,
            color: AppColors.secondaryLight,
            dotColor: AppColors.bookingHighlight,
          ),
        ),

        // Route icon
        Icon(Icons.route_rounded, size: size * 0.4, color: AppColors.primary),

        // Start point
        Positioned(
          top: size * 0.22,
          left: size * 0.25,
          child: _buildRoutePoint(8, AppColors.success, t, 0.0),
        ),

        // End point
        Positioned(
          bottom: size * 0.22,
          right: size * 0.25,
          child: _buildRoutePoint(8, AppColors.bookingHighlight, t, 0.5),
        ),

        // Sparkles along path
        Positioned(
          top: size * 0.32,
          right: size * 0.28,
          child: _buildSparkle(4, t, 0.4),
        ),
      ],
    );
  }

  Widget _buildRoutePoint(
    double pointSize,
    Color color,
    double t,
    double phase,
  ) {
    final pulse = 1.0 + 0.2 * math.sin((t + phase) * math.pi * 2);
    return Transform.scale(
      scale: pulse,
      child: Container(
        width: pointSize,
        height: pointSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.4),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
      ),
    );
  }

  // ── Page 4: Coupon with shine & floating stars ──
  Widget _buildCouponIcon(double size) {
    final t = _loopCtrl.value;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Shine sweep across icon area
        ClipOval(
          child: SizedBox(
            width: size,
            height: size,
            child: Transform.translate(
              offset: Offset(size * (t - 0.5) * 1.5, 0),
              child: Transform.rotate(
                angle: 0.3,
                child: Container(
                  width: size * 0.2,
                  height: size * 1.5,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        AppColors.bookingHighlight.withValues(alpha: 0),
                        AppColors.bookingHighlight.withValues(alpha: 0.08),
                        AppColors.bookingHighlight.withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        // Tag icon
        Icon(
          Icons.local_offer_rounded,
          size: size * 0.42,
          color: AppColors.primary,
        ),

        // Floating sparkle stars around
        Positioned(
          top: size * 0.18,
          right: size * 0.2,
          child: _buildStar(10, t, 0.0),
        ),
        Positioned(
          top: size * 0.32,
          left: size * 0.18,
          child: _buildStar(7, t, 0.33),
        ),
        Positioned(
          bottom: size * 0.24,
          right: size * 0.24,
          child: _buildStar(8, t, 0.66),
        ),
        Positioned(
          bottom: size * 0.18,
          left: size * 0.28,
          child: _buildSparkle(5, t, 0.5),
        ),

        // Percentage badge
        Positioned(
          top: size * 0.22,
          left: size * 0.22,
          child: Transform.scale(
            scale: 0.8 + 0.1 * math.sin(t * math.pi * 2),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.success,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.success.withValues(alpha: 0.3),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: const Text(
                '%',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenericIcon(double size) {
    return Center(
      child: Icon(
        widget.page.fallbackIcon ?? Icons.electric_scooter_rounded,
        size: size * 0.42,
        color: AppColors.primary,
      ),
    );
  }

  // ───────────────── Shared decorative elements ─────────────────

  /// Expanding ripple rings on icon entrance
  List<Widget> _buildRipples(double size) {
    return List.generate(2, (i) {
      final t = (_rippleCtrl.value - i * 0.2).clamp(0.0, 1.0);
      final scale = 0.6 + t * 0.8;
      final opacity = (1.0 - t) * 0.25;
      return Transform.scale(
        scale: scale,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: _accentForPage().withValues(alpha: opacity),
              width: 1.5,
            ),
          ),
        ),
      );
    });
  }

  /// Small particles orbiting around the icon
  List<Widget> _buildOrbitParticles(double size) {
    const count = 5;
    final radius = size * 0.58;
    final t = _loopCtrl.value;

    return List.generate(count, (i) {
      final baseAngle = (i / count) * math.pi * 2;
      final angle = baseAngle + t * math.pi * 2;
      final x = math.cos(angle) * radius * (0.9 + 0.1 * math.sin(i.toDouble()));
      final y = math.sin(angle) * radius * 0.5;
      final dotSize = 3.0 + (i % 3);
      final opacity = (0.2 + 0.3 * math.sin((t + i * 0.2) * math.pi)).clamp(
        0.0,
        1.0,
      );

      return Positioned(
        left: size * 0.65 + x - dotSize / 2,
        top: size * 0.65 + y - dotSize / 2,
        child: Opacity(
          opacity: opacity,
          child: Container(
            width: dotSize,
            height: dotSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _accentForPage().withValues(alpha: 0.6),
            ),
          ),
        ),
      );
    });
  }

  /// Twinkling sparkle effect
  Widget _buildSparkle(double maxSize, double t, double phase) {
    final s = (math.sin((t + phase) * math.pi * 2) * 0.5 + 0.5);
    final size = maxSize * (0.4 + 0.6 * s);
    final opacity = (0.3 + 0.7 * s).clamp(0.0, 1.0);

    return Opacity(
      opacity: opacity,
      child: Icon(
        Icons.auto_awesome,
        size: size,
        color: AppColors.bookingHighlight.withValues(alpha: 0.7),
      ),
    );
  }

  /// Floating star for coupon page
  Widget _buildStar(double maxSize, double t, double phase) {
    final s = math.sin((t + phase) * math.pi * 2);
    final yOff = s * 5;
    final opacity = (0.4 + 0.5 * (s * 0.5 + 0.5)).clamp(0.0, 1.0);
    final scale = 0.7 + 0.3 * (s * 0.5 + 0.5);

    return Transform.translate(
      offset: Offset(0, yOff),
      child: Transform.scale(
        scale: scale,
        child: Opacity(
          opacity: opacity,
          child: Icon(
            Icons.star_rounded,
            size: maxSize,
            color: AppColors.bookingHighlight,
          ),
        ),
      ),
    );
  }

  /// Accent color per page for variety
  Color _accentForPage() {
    const accents = [
      AppColors.secondary,
      AppColors.bookingHighlight,
      AppColors.info,
      AppColors.success,
      AppColors.bookingHighlight,
    ];
    return accents[widget.pageIndex % accents.length];
  }

  // ───────────────── Content Section ─────────────────

  Widget _buildContentSection(bool isSmallScreen) {
    return AnimatedBuilder(
      animation: _textCtrl,
      builder: (context, _) {
        return Column(
          children: [
            // Title with staggered entrance
            Transform.translate(
              offset: Offset(0, _titleSlide.value),
              child: Opacity(
                opacity: _titleFade.value,
                child: Text(
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
              ),
            ),
            const SizedBox(height: AppDimensions.paddingMedium),
            // Description with later stagger
            Transform.translate(
              offset: Offset(0, _descSlide.value),
              child: Opacity(
                opacity: _descFade.value,
                child: Container(
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
              ),
            ),
          ],
        );
      },
    );
  }
}

// ── Custom painter for route path with traveling dot ──
class _RoutePainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color dotColor;

  _RoutePainter({
    required this.progress,
    required this.color,
    required this.dotColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Draw a wavy dashed path
    final path = Path();
    path.moveTo(0, size.height * 0.8);
    path.cubicTo(
      size.width * 0.3,
      size.height * 0.2,
      size.width * 0.7,
      size.height * 0.8,
      size.width,
      size.height * 0.2,
    );

    // Dash effect
    const dashLength = 6.0;
    const gapLength = 4.0;
    final metrics = path.computeMetrics().first;
    var distance = 0.0;
    while (distance < metrics.length) {
      final end = (distance + dashLength).clamp(0, metrics.length).toDouble();
      final segment = metrics.extractPath(distance, end);
      canvas.drawPath(segment, paint);
      distance += dashLength + gapLength;
    }

    // Traveling dot
    final dotPos = metrics.getTangentForOffset(metrics.length * progress);
    if (dotPos != null) {
      final dotPaint = Paint()
        ..color = dotColor
        ..style = PaintingStyle.fill;
      canvas.drawCircle(dotPos.position, 4, dotPaint);

      // Glow
      final glowPaint = Paint()
        ..color = dotColor.withValues(alpha: 0.3)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(dotPos.position, 8, glowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RoutePainter old) => old.progress != progress;
}

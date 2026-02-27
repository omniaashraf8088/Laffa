import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _loopController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _ringRotation;
  late Animation<double> _scooterShift;
  late Animation<double> _scooterTilt;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppConstants.splashDuration,
      vsync: this,
    );

    _loopController = AnimationController(
      duration: const Duration(seconds: 3),
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
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
          ),
        );

    _ringRotation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _loopController, curve: Curves.linear),
    );

    _scooterShift = Tween<double>(begin: -6, end: 6).animate(
      CurvedAnimation(parent: _loopController, curve: Curves.easeInOut),
    );

    _scooterTilt = Tween<double>(begin: -0.04, end: 0.04).animate(
      CurvedAnimation(parent: _loopController, curve: Curves.easeInOut),
    );

    _animationController.forward();
    _loopController.repeat();

    // Navigate after splash duration
    Future.delayed(AppConstants.splashDuration, () {
      if (mounted) {
        context.go('/onboarding');
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _loopController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated Electric Wheel Logo
            FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: _buildAnimatedWheel(isMobile),
              ),
            ),
            const SizedBox(height: AppDimensions.paddingXLarge),
            // App Name
            SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    Text(
                      'Laffa',
                      style: Theme.of(context).textTheme.displayMedium
                          ?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppDimensions.paddingSmall),
                    Text(
                      'Your Smart Scooter Solution',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(color: AppColors.accent),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedWheel(bool isMobile) {
    final wheelSize = isMobile ? 120.0 : 160.0;
    final ringStroke = isMobile ? 6.0 : 8.0;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer rotating ring with a subtle gap for a premium feel
        AnimatedBuilder(
          animation: _ringRotation,
          builder: (context, child) {
            return Transform.rotate(
              angle: _ringRotation.value * math.pi * 2,
              child: CustomPaint(
                size: Size.square(wheelSize),
                painter: _RingPainter(
                  strokeWidth: ringStroke,
                  color: AppColors.secondary,
                  gapDegrees: 28,
                ),
              ),
            );
          },
        ),
        // Inner static glow ring
        Container(
          width: wheelSize * 0.74,
          height: wheelSize * 0.74,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.accent, width: ringStroke * 0.4),
          ),
        ),
        // Scooter motion
        AnimatedBuilder(
          animation: _loopController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(_scooterShift.value, 0),
              child: Transform.rotate(
                angle: _scooterTilt.value,
                child: child,
              ),
            );
          },
          child: Container(
            width: wheelSize * 0.42,
            height: wheelSize * 0.42,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
            ),
            child: Icon(
              Icons.electric_scooter,
              color: AppColors.white,
              size: wheelSize * 0.22,
            ),
          ),
        ),
      ],
    );
  }
}

class _RingPainter extends CustomPainter {
  final double strokeWidth;
  final Color color;
  final double gapDegrees;

  _RingPainter({
    required this.strokeWidth,
    required this.color,
    required this.gapDegrees,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = color;

    final gapRadians = gapDegrees * math.pi / 180;
    final startAngle = gapRadians / 2;
    final sweepAngle = math.pi * 2 - gapRadians;

    canvas.drawArc(rect.deflate(strokeWidth / 2), startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.gapDegrees != gapDegrees;
  }
}

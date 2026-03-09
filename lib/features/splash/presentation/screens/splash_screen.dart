import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/localization/app_strings_en.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  static const _totalDuration = Duration(milliseconds: 4500);

  late final AnimationController _main;
  late final AnimationController _pulse;
  late final AnimationController _particles;

  // Phase 1: BG gradient reveal
  late final Animation<double> _bgReveal;

  // Phase 2: Scooter rides in from left
  late final Animation<double> _scooterSlideX;
  late final Animation<double> _scooterFade;
  late final Animation<double> _scooterTilt; // tilt while riding

  // Phase 3: Scooter bounce settle
  late final Animation<double> _scooterScale;

  // Phase 4: Dust particles burst on landing
  late final Animation<double> _dustBurst;

  // Phase 5: Road line draws
  late final Animation<double> _roadWidth;

  // Phase 6: Shimmer ring expands
  late final Animation<double> _shimmerRingScale;
  late final Animation<double> _shimmerRingOpacity;

  // Phase 7: Title letter-by-letter
  late final Animation<double> _titleProgress;
  late final Animation<double> _titleSlideY;

  // Phase 8: Title shimmer sweep
  late final Animation<double> _titleShimmer;

  // Phase 9: Tagline
  late final Animation<double> _tagFade;
  late final Animation<double> _tagSlideY;

  // Phase 10: Orbiting dots around scooter
  late final Animation<double> _orbitAngle;
  late final Animation<double> _orbitFade;

  // Phase 11: Second glow pulse
  late final Animation<double> _glowPulse;

  // Continuous hover
  late final Animation<double> _hover;

  // Particle system
  late final List<_Particle> _dustParticles;
  final _rng = math.Random(42);

  @override
  void initState() {
    super.initState();

    _main = AnimationController(vsync: this, duration: _totalDuration);

    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    _hover = Tween<double>(
      begin: -6,
      end: 6,
    ).animate(CurvedAnimation(parent: _pulse, curve: Curves.easeInOut));

    _particles = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // Generate dust particles
    _dustParticles = List.generate(12, (_) => _Particle.random(_rng));

    // Phase 1 — BG (0→12%)
    _bgReveal = _tween(0.0, 0.12, Curves.easeOut);

    // Phase 2 — Scooter rides in (8→38%)
    _scooterSlideX = Tween<double>(begin: -1.4, end: 0.0).animate(
      CurvedAnimation(
        parent: _main,
        curve: const Interval(0.08, 0.38, curve: Curves.easeOutCubic),
      ),
    );
    _scooterFade = _tween(0.08, 0.18, Curves.easeIn);
    _scooterTilt =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 0.0, end: -0.08), weight: 15),
          TweenSequenceItem(tween: Tween(begin: -0.08, end: -0.08), weight: 55),
          TweenSequenceItem(tween: Tween(begin: -0.08, end: 0.0), weight: 30),
        ]).animate(
          CurvedAnimation(
            parent: _main,
            curve: const Interval(0.08, 0.40, curve: Curves.easeInOut),
          ),
        );

    // Phase 3 — Bounce settle (36→50%)
    _scooterScale =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.12), weight: 30),
          TweenSequenceItem(tween: Tween(begin: 1.12, end: 0.94), weight: 25),
          TweenSequenceItem(tween: Tween(begin: 0.94, end: 1.03), weight: 20),
          TweenSequenceItem(tween: Tween(begin: 1.03, end: 1.0), weight: 25),
        ]).animate(
          CurvedAnimation(
            parent: _main,
            curve: const Interval(0.36, 0.50, curve: Curves.easeOut),
          ),
        );

    // Phase 4 — Dust burst (37→52%)
    _dustBurst = _tween(0.37, 0.52, Curves.easeOut);

    // Phase 5 — Road line (36→52%)
    _roadWidth = _tween(0.36, 0.52, Curves.easeOutCubic);

    // Phase 6 — Shimmer ring (40→58%)
    _shimmerRingScale = Tween<double>(begin: 0.3, end: 2.5).animate(
      CurvedAnimation(
        parent: _main,
        curve: const Interval(0.40, 0.58, curve: Curves.easeOut),
      ),
    );
    _shimmerRingOpacity =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.6), weight: 25),
          TweenSequenceItem(tween: Tween(begin: 0.6, end: 0.0), weight: 75),
        ]).animate(
          CurvedAnimation(
            parent: _main,
            curve: const Interval(0.40, 0.58, curve: Curves.easeOut),
          ),
        );

    // Phase 7 — Title letter reveal (50→68%)
    _titleProgress = _tween(0.50, 0.68, Curves.easeOutCubic);
    _titleSlideY = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(
        parent: _main,
        curve: const Interval(0.50, 0.62, curve: Curves.easeOutCubic),
      ),
    );

    // Phase 8 — Title shimmer (65→80%)
    _titleShimmer = Tween<double>(begin: -0.5, end: 1.5).animate(
      CurvedAnimation(
        parent: _main,
        curve: const Interval(0.65, 0.80, curve: Curves.easeInOut),
      ),
    );

    // Phase 9 — Tagline (66→78%)
    _tagFade = _tween(0.66, 0.76, Curves.easeIn);
    _tagSlideY = Tween<double>(begin: 18, end: 0).animate(
      CurvedAnimation(
        parent: _main,
        curve: const Interval(0.66, 0.78, curve: Curves.easeOutCubic),
      ),
    );

    // Phase 10 — Orbiting dots (55→85%)
    _orbitAngle = Tween<double>(begin: 0, end: math.pi * 2).animate(
      CurvedAnimation(
        parent: _main,
        curve: const Interval(0.55, 0.88, curve: Curves.linear),
      ),
    );
    _orbitFade =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.7), weight: 20),
          TweenSequenceItem(tween: Tween(begin: 0.7, end: 0.7), weight: 50),
          TweenSequenceItem(tween: Tween(begin: 0.7, end: 0.0), weight: 30),
        ]).animate(
          CurvedAnimation(
            parent: _main,
            curve: const Interval(0.55, 0.88, curve: Curves.easeInOut),
          ),
        );

    // Phase 11 — Glow pulse (75→90%)
    _glowPulse =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.5), weight: 40),
          TweenSequenceItem(tween: Tween(begin: 0.5, end: 0.0), weight: 60),
        ]).animate(
          CurvedAnimation(
            parent: _main,
            curve: const Interval(0.75, 0.92, curve: Curves.easeInOut),
          ),
        );

    _main.forward();
    _pulse.repeat(reverse: true);

    _main.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        _pulse.stop();
        _particles.stop();
        context.go(AppRouter.onboarding);
      }
    });
  }

  Animation<double> _tween(double start, double end, Curve curve) {
    return Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _main,
        curve: Interval(start, end, curve: curve),
      ),
    );
  }

  @override
  void dispose() {
    _main.dispose();
    _pulse.dispose();
    _particles.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;
    final scooterSize = isMobile ? 180.0 : 240.0;

    return AnimatedBuilder(
      animation: Listenable.merge([_main, _pulse]),
      builder: (context, _) {
        return Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.lerp(
                    AppColors.background,
                    AppColors.primaryLight,
                    _bgReveal.value * 0.18,
                  )!,
                  AppColors.background,
                  Color.lerp(
                    AppColors.background,
                    AppColors.secondaryLight,
                    _bgReveal.value * 0.25,
                  )!,
                ],
                stops: const [0.0, 0.45, 1.0],
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 3),

                  // ── Scooter zone ──
                  SizedBox(
                    width: scooterSize * 2.4,
                    height: scooterSize * 1.6,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // ── Glow aura behind scooter ──
                        if (_glowPulse.value > 0.01)
                          Container(
                            width: scooterSize * 1.3,
                            height: scooterSize * 1.3,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.secondary.withValues(
                                    alpha: _glowPulse.value * 0.35,
                                  ),
                                  blurRadius: 100,
                                  spreadRadius: 30,
                                ),
                              ],
                            ),
                          ),

                        // ── Shimmer ring ──
                        if (_shimmerRingOpacity.value > 0.01)
                          Transform.scale(
                            scale: _shimmerRingScale.value,
                            child: Container(
                              width: scooterSize * 0.6,
                              height: scooterSize * 0.6,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.bookingHighlight.withValues(
                                    alpha: _shimmerRingOpacity.value,
                                  ),
                                  width: 2,
                                ),
                              ),
                            ),
                          ),

                        // ── Orbiting dots ──
                        if (_orbitFade.value > 0.01)
                          ..._buildOrbitingDots(scooterSize),

                        // ── Soft ground shadow ──
                        Positioned(
                          bottom: scooterSize * 0.06,
                          child: Opacity(
                            opacity: _scooterFade.value * 0.3,
                            child: Container(
                              width: scooterSize * 0.5 * _roadWidth.value,
                              height: 10,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primaryDark.withValues(
                                      alpha: 0.2,
                                    ),
                                    blurRadius: 28,
                                    spreadRadius: 8,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // ── Dust particles on landing ──
                        if (_dustBurst.value > 0.01 && _dustBurst.value < 0.99)
                          ..._buildDustParticles(scooterSize),

                        // ── Speed lines while riding ──
                        if (_scooterSlideX.value < -0.05 &&
                            _scooterSlideX.value > -1.3)
                          ..._buildSpeedLines(scooterSize),

                        // ── Scooter image ──
                        Transform.translate(
                          offset: Offset(
                            _scooterSlideX.value * scooterSize * 1.5,
                            _scooterFade.value > 0.9 ? _hover.value : 0,
                          ),
                          child: Transform.scale(
                            scale: _scooterScale.value,
                            child: Transform.rotate(
                              angle: _scooterTilt.value,
                              child: Opacity(
                                opacity: _scooterFade.value,
                                child: Image.asset(
                                  AppAssets.laffaScooter,
                                  width: scooterSize,
                                  height: scooterSize,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Road accent line ──
                  Opacity(
                    opacity: _roadWidth.value,
                    child: Container(
                      width: (isMobile ? 160 : 220) * _roadWidth.value,
                      height: 2.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        gradient: LinearGradient(
                          colors: [
                            AppColors.secondary.withValues(alpha: 0.0),
                            AppColors.primary.withValues(alpha: 0.8),
                            AppColors.primary,
                            AppColors.primary.withValues(alpha: 0.8),
                            AppColors.secondary.withValues(alpha: 0.0),
                          ],
                          stops: const [0.0, 0.2, 0.5, 0.8, 1.0],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: isMobile ? 32 : 40),

                  // ── "Laffa" brand with letter-by-letter reveal + shimmer ──
                  Transform.translate(
                    offset: Offset(0, _titleSlideY.value),
                    child: _buildAnimatedTitle(isMobile),
                  ),

                  const SizedBox(height: 12),

                  // ── Tagline ──
                  Transform.translate(
                    offset: Offset(0, _tagSlideY.value),
                    child: Opacity(
                      opacity: _tagFade.value,
                      child: Text(
                        AppStringsEn.tagline,
                        style: TextStyle(
                          fontSize: isMobile ? 13 : 16,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textSecondary,
                          letterSpacing: 2.5,
                        ),
                      ),
                    ),
                  ),

                  const Spacer(flex: 4),

                  // ── Bottom loading dots ──
                  Opacity(
                    opacity: _tagFade.value,
                    child: _LoadingDots(progress: _main.value),
                  ),

                  SizedBox(height: isMobile ? 40 : 56),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ── Letter-by-letter title with shimmer sweep ──
  Widget _buildAnimatedTitle(bool isMobile) {
    const text = AppStringsEn.appName;
    final fontSize = isMobile ? 40.0 : 50.0;
    final revealedCount = (_titleProgress.value * text.length).ceil();

    return ShaderMask(
      shaderCallback: (bounds) {
        return LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: const [
            Colors.white,
            Colors.white,
            AppColors.splashShaderWhite,
            Colors.white,
            Colors.white,
          ],
          stops: [
            0.0,
            (_titleShimmer.value - 0.15).clamp(0.0, 1.0),
            _titleShimmer.value.clamp(0.0, 1.0),
            (_titleShimmer.value + 0.15).clamp(0.0, 1.0),
            1.0,
          ],
        ).createShader(bounds);
      },
      blendMode: BlendMode.modulate,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(text.length, (i) {
          final visible = i < revealedCount;
          final letterProgress = ((_titleProgress.value * text.length - i))
              .clamp(0.0, 1.0);

          return Transform.translate(
            offset: Offset(0, visible ? (1.0 - letterProgress) * 12 : 20),
            child: Opacity(
              opacity: visible ? letterProgress : 0.0,
              child: Transform.scale(
                scale: visible ? 0.8 + 0.2 * letterProgress : 0.8,
                child: Text(
                  text[i],
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                    letterSpacing: 6,
                    height: 1.1,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ── Speed lines while scooter rides in ──
  List<Widget> _buildSpeedLines(double scooterSize) {
    final progress = (_scooterSlideX.value + 1.3) / 1.25;
    final lineOpacity = (1.0 - progress).clamp(0.0, 0.7);

    return List.generate(5, (i) {
      final yOff = (i - 2) * 14.0;
      final xOff = _scooterSlideX.value * scooterSize * 1.5 - 25 - (i * 10);
      final w = 20 + i * 10.0 + (1.0 - progress) * 20;
      return Positioned(
        left: scooterSize * 1.2 + xOff - 50,
        top: scooterSize * 0.8 + yOff - 8,
        child: Opacity(
          opacity: lineOpacity * (0.5 + i * 0.1),
          child: Container(
            width: w,
            height: 1.5 + (i % 2) * 0.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1),
              gradient: LinearGradient(
                colors: [
                  AppColors.secondary.withValues(alpha: 0.0),
                  AppColors.secondary.withValues(alpha: lineOpacity * 0.6),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  // ── Dust particles that burst out when scooter lands ──
  List<Widget> _buildDustParticles(double scooterSize) {
    return _dustParticles.map((p) {
      final t = _dustBurst.value;
      final x = p.dx * t * scooterSize * 0.8;
      final y = p.dy * t * scooterSize * 0.4 - (t * t * scooterSize * 0.3);
      final opacity = (1.0 - t).clamp(0.0, 1.0) * 0.6 * p.opacity;
      final size = p.size * (1.0 + t * 0.5);

      return Positioned(
        left: scooterSize * 1.2 + x,
        bottom: scooterSize * 0.12 + y,
        child: Opacity(
          opacity: opacity,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color.lerp(
                AppColors.secondary,
                AppColors.secondaryLight,
                p.colorMix,
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  // ── Orbiting dots around scooter ──
  List<Widget> _buildOrbitingDots(double scooterSize) {
    const count = 6;
    final radius = scooterSize * 0.65;

    return List.generate(count, (i) {
      final baseAngle = (i / count) * math.pi * 2;
      final angle = baseAngle + _orbitAngle.value;
      final x = math.cos(angle) * radius;
      final y = math.sin(angle) * radius * 0.4; // elliptical orbit
      final dotSize = 4.0 + (i % 3) * 1.5;
      final dotOpacity = _orbitFade.value * (0.4 + (i % 3) * 0.2);

      return Positioned(
        left: scooterSize * 1.2 + x - dotSize / 2,
        top: scooterSize * 0.8 + y - dotSize / 2,
        child: Opacity(
          opacity: dotOpacity.clamp(0.0, 1.0),
          child: Container(
            width: dotSize,
            height: dotSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.bookingHighlight,
              boxShadow: [
                BoxShadow(
                  color: AppColors.bookingHighlight.withValues(alpha: 0.4),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

// ── Particle data ──
class _Particle {
  final double dx;
  final double dy;
  final double size;
  final double opacity;
  final double colorMix;

  const _Particle({
    required this.dx,
    required this.dy,
    required this.size,
    required this.opacity,
    required this.colorMix,
  });

  factory _Particle.random(math.Random rng) {
    return _Particle(
      dx: (rng.nextDouble() - 0.5) * 2,
      dy: rng.nextDouble() * 0.6 + 0.2,
      size: rng.nextDouble() * 4 + 2,
      opacity: rng.nextDouble() * 0.5 + 0.3,
      colorMix: rng.nextDouble(),
    );
  }
}

// ── Loading dots ──
class _LoadingDots extends StatelessWidget {
  final double progress;
  const _LoadingDots({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        final phase = (progress * 4 + i * 0.35) % 1.0;
        final scale = 0.5 + 0.5 * math.sin(phase * math.pi);
        final opacity = 0.3 + 0.7 * math.sin(phase * math.pi);
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          child: Transform.scale(
            scale: scale,
            child: Opacity(
              opacity: opacity.clamp(0.0, 1.0),
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.7),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

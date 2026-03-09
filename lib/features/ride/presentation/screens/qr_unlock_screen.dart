import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/localization/localization_provider.dart';
import '../../../../core/localization/app_strings_ar.dart';
import '../../../../core/localization/app_strings_en.dart';
import '../../../../core/router/app_router.dart';
import '../../data/models/ride_model.dart';
import '../controllers/ride_provider.dart';

/// QR scanning screen to unlock scooters.
class QrUnlockScreen extends ConsumerStatefulWidget {
  const QrUnlockScreen({super.key});

  @override
  ConsumerState<QrUnlockScreen> createState() => _QrUnlockScreenState();
}

class _QrUnlockScreenState extends ConsumerState<QrUnlockScreen>
    with SingleTickerProviderStateMixin {
  MobileScannerController? _scannerController;
  bool _hasScanned = false;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _scannerController?.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_hasScanned) return;
    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final code = barcodes.first.rawValue;
    if (code == null || code.isEmpty) return;

    setState(() => _hasScanned = true);
    _scannerController?.stop();

    ref.read(rideProvider.notifier).onQrScanned(code);
  }

  @override
  Widget build(BuildContext context) {
    final rideState = ref.watch(rideProvider);
    final localization = ref.watch(localizationProvider);
    final isArabic = localization.language == AppLanguage.ar;

    // Navigate to ride tracking when scooter is unlocked
    ref.listen<RideState>(rideProvider, (prev, next) {
      if (next.scooter != null &&
          next.status == RideStatus.unlocking &&
          !next.isLoading) {
        _showUnlockSuccess(context, next.scooter!, isArabic);
      }
      if (next.error != null && prev?.error == null) {
        setState(() => _hasScanned = false);
        _scannerController?.start();
      }
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera preview
          if (rideState.status != RideStatus.unlocking || rideState.isLoading)
            _buildCameraPreview(),

          // Overlay with scan frame
          _buildScanOverlay(isArabic),

          // Top bar
          _buildTopBar(context, isArabic),

          // Bottom info section
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomSection(rideState, isArabic),
          ),

          // Loading overlay
          if (rideState.isLoading) _buildLoadingOverlay(isArabic),
        ],
      ),
    );
  }

  Widget _buildCameraPreview() {
    return Positioned.fill(
      child: MobileScanner(
        controller: _scannerController!,
        onDetect: _onDetect,
      ),
    );
  }

  Widget _buildScanOverlay(bool isArabic) {
    return Positioned.fill(
      child: CustomPaint(
        painter: _ScanOverlayPainter(),
        child: Center(
          child: AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: AppColors.secondary.withValues(
                      alpha: 0.5 + (_pulseController.value * 0.5),
                    ),
                    width: 3,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, bool isArabic) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              _buildCircleButton(
                icon: Icons.close_rounded,
                onTap: () => context.pop(),
              ),
              const Spacer(),
              Text(
                isArabic ? AppStringsAr.scanQrCode : AppStringsEn.scanQrCode,
                style: AppTextStyles.title(
                  isArabic: isArabic,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              _buildCircleButton(
                icon: Icons.flash_on_rounded,
                onTap: () => _scannerController?.toggleTorch(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.5),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }

  Widget _buildBottomSection(RideState rideState, bool isArabic) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withValues(alpha: 0.8),
            Colors.black.withValues(alpha: 0.95),
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.qr_code_scanner_rounded,
            color: AppColors.secondary,
            size: 40,
          ),
          const SizedBox(height: 16),
          Text(
            isArabic
                ? 'وجّه الكاميرا نحو رمز QR\nعلى السكوتر'
                : 'Point camera at the QR code\non the scooter',
            textAlign: TextAlign.center,
            style: AppTextStyles.subtitle(
              isArabic: isArabic,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          if (rideState.error != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.error.withValues(alpha: 0.4),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_rounded,
                    color: AppColors.error,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      rideState.error!,
                      style: AppTextStyles.smallMedium(
                        isArabic: isArabic,
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 20),
          // Manual entry button
          TextButton.icon(
            onPressed: () => _showManualEntry(context, isArabic),
            icon: const Icon(
              Icons.keyboard_rounded,
              color: AppColors.secondary,
            ),
            label: Text(
              isArabic
                  ? AppStringsAr.enterCodeManually
                  : AppStringsEn.enterCodeManually,
              style: AppTextStyles.bodyMedium(
                isArabic: isArabic,
                color: AppColors.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingOverlay(bool isArabic) {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withValues(alpha: 0.8),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.secondary,
                  ),
                  strokeWidth: 3,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                isArabic
                    ? AppStringsAr.unlockingScooter
                    : AppStringsEn.unlockingScooter,
                style: AppTextStyles.title(
                  isArabic: isArabic,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showUnlockSuccess(
    BuildContext context,
    Scooter scooter,
    bool isArabic,
  ) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.greyMedium,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.successLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_open_rounded,
                color: AppColors.success,
                size: 36,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isArabic
                  ? AppStringsAr.scooterUnlocked
                  : AppStringsEn.scooterUnlocked,
              style: AppTextStyles.heading(
                isArabic: isArabic,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 20),
            // Scooter info card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.electric_scooter_rounded,
                      color: AppColors.primary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          scooter.name,
                          style: AppTextStyles.sectionTitle(
                            isArabic: isArabic,
                            color: AppColors.text,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'ID: ${scooter.id}',
                          style: AppTextStyles.smallMedium(
                            isArabic: isArabic,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.battery_std_rounded,
                            color: scooter.batteryLevel > 0.5
                                ? AppColors.success
                                : AppColors.warning,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            scooter.batteryDisplay,
                            style: AppTextStyles.smallLabel(
                              isArabic: isArabic,
                              color: AppColors.text,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        scooter.priceDisplay,
                        style: AppTextStyles.smallMedium(
                          isArabic: isArabic,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  ref.read(rideProvider.notifier).startRide();
                  context.go(AppRouter.rideTracking);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  isArabic ? AppStringsAr.startRide : AppStringsEn.startRide,
                  style: AppTextStyles.button(
                    isArabic: isArabic,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showManualEntry(BuildContext context, bool isArabic) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          isArabic
              ? AppStringsAr.enterScooterCode
              : AppStringsEn.enterScooterCode,
          style: AppTextStyles.title(isArabic: isArabic, color: AppColors.text),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.characters,
          decoration: InputDecoration(
            hintText: isArabic ? 'مثال: SCT-001' : 'e.g. SCT-001',
            prefixIcon: const Icon(
              Icons.qr_code_rounded,
              color: AppColors.primary,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              isArabic ? AppStringsAr.cancel : AppStringsEn.cancel,
              style: AppTextStyles.label(
                isArabic: isArabic,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final code = controller.text.trim();
              if (code.isNotEmpty) {
                Navigator.of(ctx).pop();
                ref.read(rideProvider.notifier).onQrScanned(code);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(isArabic ? AppStringsAr.unlock : AppStringsEn.unlock),
          ),
        ],
      ),
    );
  }
}

/// Paints a dark overlay with a transparent rectangle in the center.
class _ScanOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withValues(alpha: 0.55);
    final center = Offset(size.width / 2, size.height / 2);
    const scanSize = 260.0;
    final scanRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: scanSize, height: scanSize),
      const Radius.circular(24),
    );

    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(scanRect)
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

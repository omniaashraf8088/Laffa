import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_theme.dart';
import 'station_model.dart';

class StationMarkerGenerator {
  static Future<BitmapDescriptor> generateStationMarker(Station station) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    const size = 110.0;

    // Draw outer circle with shadow effect
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.15)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    canvas.drawCircle(
      const Offset(size / 2, size / 2),
      size / 2.2,
      shadowPaint,
    );

    // Draw main marker circle - Latte Brown gradient
    final paint = Paint()
      ..shader =
          RadialGradient(
            colors: [AppColors.primary, AppColors.primary.withOpacity(0.85)],
          ).createShader(
            Rect.fromCircle(
              center: const Offset(size / 2, size / 2),
              radius: size / 2,
            ),
          );

    canvas.drawCircle(const Offset(size / 2, size / 2), size / 2, paint);

    // Draw inner white circle for contrast
    final whitePaint = Paint()..color = Colors.white;
    canvas.drawCircle(const Offset(size / 2, size / 2), size / 2.4, whitePaint);

    // Draw icon - scooter
    final iconPainter = TextPainter(
      text: TextSpan(
        text: '🛴',
        style: GoogleFonts.notoColorEmoji(fontSize: 28),
      ),
      textDirection: TextDirection.ltr,
    );
    iconPainter.layout();
    iconPainter.paint(
      canvas,
      Offset(
        size / 2 - iconPainter.width / 2,
        size / 2 - iconPainter.height / 2 - 8,
      ),
    );

    // Draw scooter count badge
    final badgePaint = Paint()..color = AppColors.secondary;
    const badgeRadius = 14.0;
    canvas.drawCircle(
      const Offset(size / 2 + 18, size / 2 + 22),
      badgeRadius,
      badgePaint,
    );

    // Draw count number
    final textPainter = TextPainter(
      text: TextSpan(
        text: '${station.availableScooters}',
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        size / 2 + 18 - textPainter.width / 2,
        size / 2 + 22 - textPainter.height / 2,
      ),
    );

    final image = await recorder.endRecording().toImage(
      size.toInt(),
      size.toInt(),
    );
    final data = await image.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  static Marker createStationMarker({
    required Station station,
    required BitmapDescriptor markerIcon,
    required VoidCallback onTap,
  }) {
    return Marker(
      markerId: MarkerId(station.id),
      position: LatLng(station.latitude, station.longitude),
      icon: markerIcon,
      infoWindow: InfoWindow(
        title: station.name,
        snippet: '${station.availableScooters} scooters available',
      ),
      onTap: onTap,
    );
  }
}

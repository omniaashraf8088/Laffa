import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/splash/splash_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/signup_screen.dart';
import '../../features/auth/forgot_password_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/trips/trips_screen.dart';
import '../../features/coupons/coupons_screen.dart';
import '../../features/chat/chat_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/booking/presentation/booking_screen.dart';
import '../../features/payment/presentation/payment_screen.dart';
import '../../features/trip/presentation/start_trip_screen.dart';
import '../../features/trip/presentation/end_trip_screen.dart';
import '../../features/rating/presentation/rating_screen.dart';

/// Centralized router configuration for all app navigation.
/// Uses GoRouter with named routes and query parameter support.
class AppRouter {
  // Existing routes
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String trips = '/trips';
  static const String coupons = '/coupons';
  static const String chat = '/chat';
  static const String settings = '/settings';

  // New feature routes
  static const String booking = '/booking';
  static const String payment = '/payment';
  static const String startTrip = '/start-trip';
  static const String endTrip = '/end-trip';
  static const String rating = '/rating';

  static final GoRouter router = GoRouter(
    routes: [
      // ── Existing Routes ──────────────────────────
      GoRoute(path: splash, builder: (context, state) => const SplashScreen()),
      GoRoute(
        path: onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(path: login, builder: (context, state) => const LoginScreen()),
      GoRoute(path: signup, builder: (context, state) => const SignupScreen()),
      GoRoute(
        path: forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(path: home, builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(path: trips, builder: (context, state) => const TripsScreen()),
      GoRoute(
        path: coupons,
        builder: (context, state) => const CouponsScreen(),
      ),
      GoRoute(path: chat, builder: (context, state) => const ChatScreen()),
      GoRoute(
        path: settings,
        builder: (context, state) => const SettingsScreen(),
      ),

      // ── Booking Route ────────────────────────────
      // Expects query params: stationId, stationName
      GoRoute(
        path: booking,
        builder: (context, state) {
          final stationId =
              state.uri.queryParameters['stationId'] ?? 'unknown';
          final stationName =
              state.uri.queryParameters['stationName'] ?? 'Unknown Station';
          return BookingScreen(
            stationId: stationId,
            stationName: stationName,
          );
        },
      ),

      // ── Payment Route ────────────────────────────
      // Expects query params: bookingId, amount
      GoRoute(
        path: payment,
        builder: (context, state) {
          final bookingId =
              state.uri.queryParameters['bookingId'] ?? 'unknown';
          final amount =
              double.tryParse(state.uri.queryParameters['amount'] ?? '0') ??
                  0.0;
          return PaymentScreen(
            bookingId: bookingId,
            amount: amount,
          );
        },
      ),

      // ── Start Trip Route ─────────────────────────
      GoRoute(
        path: startTrip,
        builder: (context, state) => const StartTripScreen(),
      ),

      // ── End Trip Route ───────────────────────────
      GoRoute(
        path: endTrip,
        builder: (context, state) => const EndTripScreen(),
      ),

      // ── Rating Route ─────────────────────────────
      // Expects query param: tripId
      GoRoute(
        path: rating,
        builder: (context, state) {
          final tripId =
              state.uri.queryParameters['tripId'] ?? 'unknown';
          return RatingScreen(tripId: tripId);
        },
      ),
    ],
    initialLocation: splash,
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(child: Text('Page not found: ${state.fullPath}')),
    ),
  );
}

// Provider for easy access to router
final goRouterProvider = Provider<GoRouter>((ref) {
  return AppRouter.router;
});

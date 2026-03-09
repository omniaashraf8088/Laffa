import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/trips/presentation/screens/trips_screen.dart';
import '../../features/coupons/presentation/screens/coupons_screen.dart';
import '../../features/chat/presentation/screens/chat_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/booking/presentation/screens/booking_screen.dart';
import '../../features/payment/presentation/screens/payment_screen.dart';
import '../../features/trip/presentation/screens/start_trip_screen.dart';
import '../../features/trip/presentation/screens/end_trip_screen.dart';
import '../../features/rating/presentation/screens/rating_screen.dart';
import '../../features/ride/presentation/screens/qr_unlock_screen.dart';
import '../../features/ride/presentation/screens/ride_tracking_screen.dart';
import '../../features/ride/presentation/screens/ride_payment_screen.dart';
import '../../features/ride/presentation/screens/ride_history_screen.dart';
import '../../features/wallet/presentation/screens/wallet_screen.dart';
import '../../features/wallet/presentation/screens/payment_methods_screen.dart';
import '../../features/wallet/presentation/screens/referral_screen.dart';
import '../../features/saved_places/presentation/screens/saved_places_screen.dart';
import '../../features/safety_center/presentation/screens/safety_center_screen.dart';
import '../tenant/tenant_service.dart';
import '../tenant/models/user_role.dart';

/// Centralized router configuration for all app navigation.
/// Uses GoRouter with named routes, query parameter support,
/// and role-based redirect guards.
class AppRouter {
  // ── Public Routes ────────────────────────────────
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';

  // ── Rider Routes ─────────────────────────────────
  static const String home = '/home';
  static const String profile = '/profile';
  static const String trips = '/trips';
  static const String coupons = '/coupons';
  static const String chat = '/chat';
  static const String settings = '/settings';
  static const String booking = '/booking';
  static const String payment = '/payment';
  static const String startTrip = '/start-trip';
  static const String endTrip = '/end-trip';
  static const String rating = '/rating';

  // ── Wallet & Payment Routes ──────────────────────
  static const String wallet = '/wallet';
  static const String paymentMethods = '/payment-methods';
  static const String referral = '/referral';

  // ── Saved Places & Safety ───────────────────────
  static const String savedPlaces = '/saved-places';
  static const String safetyCenter = '/safety-center';

  // ── Ride Feature Routes ──────────────────────────
  static const String qrUnlock = '/qr-unlock';
  static const String rideTracking = '/ride-tracking';
  static const String ridePayment = '/ride-payment';
  static const String rideHistory = '/ride-history';
}

// Provider for easy access to router
final goRouterProvider = Provider<GoRouter>((ref) {
  final tenantState = ref.watch(tenantProvider);

  return GoRouter(
    routes: [
      // ── Public Routes ──────────────────────────────
      GoRoute(
        path: AppRouter.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRouter.onboarding,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const OnboardingScreen(),
          transitionDuration: const Duration(milliseconds: 600),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: AppRouter.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRouter.signup,
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: AppRouter.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),

      // ── Rider Routes ──────────────────────────────
      GoRoute(
        path: AppRouter.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRouter.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: AppRouter.trips,
        builder: (context, state) => const TripsScreen(),
      ),
      GoRoute(
        path: AppRouter.coupons,
        builder: (context, state) => const CouponsScreen(),
      ),
      GoRoute(
        path: AppRouter.chat,
        builder: (context, state) => const ChatScreen(),
      ),
      GoRoute(
        path: AppRouter.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRouter.booking,
        builder: (context, state) {
          final stationId = state.uri.queryParameters['stationId'] ?? 'unknown';
          final stationName =
              state.uri.queryParameters['stationName'] ?? 'Unknown Station';
          return BookingScreen(stationId: stationId, stationName: stationName);
        },
      ),
      GoRoute(
        path: AppRouter.payment,
        builder: (context, state) {
          final bookingId = state.uri.queryParameters['bookingId'] ?? 'unknown';
          final amount =
              double.tryParse(state.uri.queryParameters['amount'] ?? '0') ??
              0.0;
          return PaymentScreen(bookingId: bookingId, amount: amount);
        },
      ),
      GoRoute(
        path: AppRouter.startTrip,
        builder: (context, state) => const StartTripScreen(),
      ),
      GoRoute(
        path: AppRouter.endTrip,
        builder: (context, state) => const EndTripScreen(),
      ),
      GoRoute(
        path: AppRouter.rating,
        builder: (context, state) {
          final tripId = state.uri.queryParameters['tripId'] ?? 'unknown';
          return RatingScreen(tripId: tripId);
        },
      ),

      // ── Wallet & Payment ─────────────────────────
      GoRoute(
        path: AppRouter.wallet,
        builder: (context, state) => const WalletScreen(),
      ),
      GoRoute(
        path: AppRouter.paymentMethods,
        builder: (context, state) => const PaymentMethodsScreen(),
      ),
      GoRoute(
        path: AppRouter.referral,
        builder: (context, state) => const ReferralScreen(),
      ),

      // ── Ride Feature ──────────────────────────────
      GoRoute(
        path: AppRouter.qrUnlock,
        builder: (context, state) => const QrUnlockScreen(),
      ),
      GoRoute(
        path: AppRouter.rideTracking,
        builder: (context, state) => const RideTrackingScreen(),
      ),
      GoRoute(
        path: AppRouter.ridePayment,
        builder: (context, state) => const RidePaymentScreen(),
      ),
      GoRoute(
        path: AppRouter.rideHistory,
        builder: (context, state) => const RideHistoryScreen(),
      ),

      // ── Saved Places & Safety ─────────────────────
      GoRoute(
        path: AppRouter.savedPlaces,
        builder: (context, state) => const SavedPlacesScreen(),
      ),
      GoRoute(
        path: AppRouter.safetyCenter,
        builder: (context, state) => const SafetyCenterScreen(),
      ),
    ],

    redirect: (context, state) {
      final location = state.matchedLocation;
      final isAuthenticated = tenantState.isAuthenticated;
      final role = tenantState.role;
      final hasCompany = tenantState.hasActiveCompany;

      // Allow splash & onboarding always
      if (location == '/' || location == '/onboarding') return null;

      // Not authenticated → login (unless already on auth screens)
      if (!isAuthenticated) {
        const authRoutes = ['/login', '/signup', '/forgot-password'];
        if (authRoutes.contains(location)) return null;
        return AppRouter.login;
      }

      // Authenticated → redirect away from auth screens
      const authRoutes = ['/login', '/signup', '/forgot-password'];
      if (authRoutes.contains(location)) {
        return _homeRouteForRole(role, hasCompany);
      }

      // Super admin → settings only
      if (role.isSuperAdmin) {
        if (location == '/settings') return null;
        return AppRouter.home;
      }

      // Company admin
      if (role.isCompanyAdmin) {
        if (location == '/settings') return null;
        return AppRouter.home;
      }

      // Rider
      if (role.isRider) {
        // Allow all rider routes (company selection is optional)
        return null;
      }

      return null;
    },

    initialLocation: AppRouter.splash,
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(child: Text('Page not found: ${state.fullPath}')),
    ),
  );
});

String _homeRouteForRole(UserRole role, bool hasCompany) {
  switch (role) {
    case UserRole.superAdmin:
      return AppRouter.home;
    case UserRole.companyAdmin:
      return AppRouter.home;
    case UserRole.rider:
      return AppRouter.home;
  }
}

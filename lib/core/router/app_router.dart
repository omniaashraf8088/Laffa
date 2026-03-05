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
import '../../features/company_selection/company_selection_screen.dart';
import '../../features/admin_dashboard/super_admin/super_admin_dashboard_screen.dart';
import '../../features/admin_dashboard/company_admin/company_admin_dashboard_screen.dart';
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

  // ── Company Selection ────────────────────────────
  static const String companySelect = '/company-select';

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

  // ── Admin Routes ─────────────────────────────────
  static const String superAdmin = '/super-admin';
  static const String companyAdmin = '/company-admin';
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

      // ── Company Selection ──────────────────────────
      GoRoute(
        path: AppRouter.companySelect,
        builder: (context, state) => const CompanySelectionScreen(),
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

      // ── Super Admin Dashboard ─────────────────────
      GoRoute(
        path: AppRouter.superAdmin,
        builder: (context, state) => const SuperAdminDashboardScreen(),
      ),

      // ── Company Admin Dashboard ───────────────────
      GoRoute(
        path: AppRouter.companyAdmin,
        builder: (context, state) => const CompanyAdminDashboardScreen(),
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

      // Company selection is allowed for all authenticated users
      if (location == AppRouter.companySelect) return null;

      // Super admin → only super admin routes
      if (role.isSuperAdmin) {
        if (location.startsWith('/super-admin') || location == '/settings') {
          return null;
        }
        return AppRouter.superAdmin;
      }

      // Company admin
      if (role.isCompanyAdmin) {
        if (!hasCompany) return AppRouter.companySelect;
        if (location.startsWith('/company-admin') || location == '/settings') {
          return null;
        }
        return AppRouter.companyAdmin;
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
      return AppRouter.superAdmin;
    case UserRole.companyAdmin:
      return hasCompany ? AppRouter.companyAdmin : AppRouter.companySelect;
    case UserRole.rider:
      return AppRouter.home;
  }
}

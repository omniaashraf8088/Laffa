import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../tenant/models/user_role.dart';
import '../tenant/tenant_service.dart';

/// Determines which route group the user should be redirected to
/// based on their authentication state, role, and company selection.
class RouteGuard {
  final Ref _ref;

  RouteGuard(this._ref);

  /// Returns the redirect path if the user should not access [location],
  /// or null if access is allowed.
  String? redirect(String location) {
    final tenantState = _ref.read(tenantProvider);

    // Not authenticated → go to login (except public routes)
    if (!tenantState.isAuthenticated) {
      if (_isPublicRoute(location)) return null;
      return '/login';
    }

    final role = tenantState.role;
    final hasCompany = tenantState.hasActiveCompany;

    // Authenticated but on a public route → redirect to role-appropriate home
    if (_isPublicRoute(location)) {
      return _homeRouteForRole(role, hasCompany);
    }

    // Super admin trying to access non-super-admin routes
    if (role.isSuperAdmin) {
      if (_isSuperAdminRoute(location)) return null;
      return '/super-admin';
    }

    // Company admin without company selected
    if (role.isCompanyAdmin) {
      if (!hasCompany) {
        if (location == '/company-select') return null;
        return '/company-select';
      }
      if (_isCompanyAdminRoute(location)) return null;
      return '/company-admin';
    }

    // Rider without company selected
    if (role.isRider) {
      if (!hasCompany) {
        if (location == '/company-select') return null;
        return '/company-select';
      }
      if (_isRiderRoute(location)) return null;
      return '/home';
    }

    return null;
  }

  String _homeRouteForRole(UserRole role, bool hasCompany) {
    switch (role) {
      case UserRole.superAdmin:
        return '/super-admin';
      case UserRole.companyAdmin:
        return hasCompany ? '/company-admin' : '/company-select';
      case UserRole.rider:
        return hasCompany ? '/home' : '/company-select';
    }
  }

  bool _isPublicRoute(String location) {
    const publicRoutes = [
      '/',
      '/onboarding',
      '/login',
      '/signup',
      '/forgot-password',
    ];
    return publicRoutes.contains(location);
  }

  bool _isSuperAdminRoute(String location) {
    return location.startsWith('/super-admin');
  }

  bool _isCompanyAdminRoute(String location) {
    return location.startsWith('/company-admin') ||
        location == '/company-select' ||
        location == '/settings';
  }

  bool _isRiderRoute(String location) {
    const riderRoutes = [
      '/home',
      '/booking',
      '/payment',
      '/start-trip',
      '/end-trip',
      '/rating',
      '/profile',
      '/trips',
      '/coupons',
      '/chat',
      '/settings',
      '/company-select',
    ];
    return riderRoutes.any((r) => location.startsWith(r));
  }
}

final routeGuardProvider = Provider<RouteGuard>((ref) {
  return RouteGuard(ref);
});

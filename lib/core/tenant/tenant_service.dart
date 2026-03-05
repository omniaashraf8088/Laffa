import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/injection_container.dart';
import '../../core/storage/local_storage_service.dart';
import 'models/company_model.dart';
import 'models/global_user_model.dart';
import 'models/user_role.dart';
import 'repositories/company_repository.dart';
import 'repositories/global_user_repository.dart';

/// State that tracks the current tenant context.
/// Every scoped query in the app reads from this state.
class TenantState {
  final GlobalUser? currentUser;
  final Company? activeCompany;
  final List<Company> availableCompanies;
  final bool isLoading;
  final String? error;

  const TenantState({
    this.currentUser,
    this.activeCompany,
    this.availableCompanies = const [],
    this.isLoading = false,
    this.error,
  });

  bool get isAuthenticated => currentUser != null;
  bool get hasActiveCompany => activeCompany != null;

  UserRole get role => currentUser?.role ?? UserRole.rider;

  String? get activeCompanyId => activeCompany?.id;

  bool get canCreateRides =>
      hasActiveCompany && (activeCompany?.canCreateRides ?? false);

  bool get isSubscriptionExpired =>
      activeCompany?.isSubscriptionExpired ?? false;

  TenantState copyWith({
    GlobalUser? currentUser,
    Company? activeCompany,
    List<Company>? availableCompanies,
    bool? isLoading,
    String? error,
  }) {
    return TenantState(
      currentUser: currentUser ?? this.currentUser,
      activeCompany: activeCompany ?? this.activeCompany,
      availableCompanies: availableCompanies ?? this.availableCompanies,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Manages the tenant context — which user is logged in,
/// which company is active, and provides company-scoped access.
class TenantNotifier extends StateNotifier<TenantState> {
  final CompanyRepository _companyRepository;
  final GlobalUserRepository _userRepository;
  final LocalStorageService _storage;

  static const String _activeCompanyKey = 'active_company_id';

  TenantNotifier({
    required CompanyRepository companyRepository,
    required GlobalUserRepository userRepository,
    required LocalStorageService storage,
  }) : _companyRepository = companyRepository,
       _userRepository = userRepository,
       _storage = storage,
       super(const TenantState());

  /// Initializes tenant context after authentication.
  /// Loads the user profile and restores the last active company.
  Future<void> initialize(String userId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await _userRepository.getUser(userId);
      if (user == null) {
        state = state.copyWith(
          isLoading: false,
          error: 'User profile not found',
        );
        return;
      }

      state = state.copyWith(currentUser: user);

      // Load available companies for this user
      final companies = await _loadCompaniesForRole(user);
      state = state.copyWith(availableCompanies: companies);

      // Restore last active company
      final savedCompanyId = _storage.getString(_activeCompanyKey);
      final companyIdToUse = savedCompanyId ?? user.activeCompanyId;

      if (companyIdToUse != null) {
        await setActiveCompany(companyIdToUse);
      }

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to initialize tenant: $e',
      );
    }
  }

  Future<List<Company>> _loadCompaniesForRole(GlobalUser user) async {
    switch (user.role) {
      case UserRole.superAdmin:
        return _companyRepository.getAllCompanies();
      case UserRole.companyAdmin:
        if (user.companyIds.isEmpty) return [];
        return _companyRepository.getCompaniesByIds(user.companyIds);
      case UserRole.rider:
        return _companyRepository.getActiveCompanies();
    }
  }

  /// Sets the active company for the current session.
  /// All subsequent scoped queries will use this companyId.
  Future<void> setActiveCompany(String companyId) async {
    try {
      final company = await _companyRepository.getCompany(companyId);
      if (company == null) {
        state = state.copyWith(error: 'Company not found');
        return;
      }

      await _storage.setString(_activeCompanyKey, companyId);

      // Update user's active company in backend
      if (state.currentUser != null) {
        await _userRepository.updateActiveCompany(
          userId: state.currentUser!.id,
          companyId: companyId,
        );
      }

      state = state.copyWith(
        activeCompany: company,
        currentUser: state.currentUser?.copyWith(activeCompanyId: companyId),
        error: null,
      );
    } catch (e) {
      state = state.copyWith(error: 'Failed to set active company: $e');
    }
  }

  /// Refreshes the active company data (e.g., pricing updates).
  Future<void> refreshActiveCompany() async {
    final companyId = state.activeCompany?.id;
    if (companyId == null) return;

    try {
      final company = await _companyRepository.getCompany(companyId);
      if (company != null) {
        state = state.copyWith(activeCompany: company);
      }
    } catch (_) {
      // Silently fail on refresh
    }
  }

  /// Refreshes the available companies list.
  Future<void> refreshCompanies() async {
    final user = state.currentUser;
    if (user == null) return;

    try {
      final companies = await _loadCompaniesForRole(user);
      state = state.copyWith(availableCompanies: companies);
    } catch (_) {
      // Silently fail on refresh
    }
  }

  /// Clears tenant context on logout.
  void clear() {
    _storage.remove(_activeCompanyKey);
    state = const TenantState();
  }
}

// ── Providers ──────────────────────────────────────────────────

final companyRepositoryProvider = Provider<CompanyRepository>((ref) {
  return CompanyRepository(apiClient: sl());
});

final globalUserRepositoryProvider = Provider<GlobalUserRepository>((ref) {
  return GlobalUserRepository(apiClient: sl());
});

final tenantProvider = StateNotifierProvider<TenantNotifier, TenantState>((
  ref,
) {
  return TenantNotifier(
    companyRepository: ref.watch(companyRepositoryProvider),
    userRepository: ref.watch(globalUserRepositoryProvider),
    storage: sl<LocalStorageService>(),
  );
});

/// Convenience provider for current company ID.
/// Throws if no active company is set.
final activeCompanyIdProvider = Provider<String>((ref) {
  final tenantState = ref.watch(tenantProvider);
  final companyId = tenantState.activeCompanyId;
  if (companyId == null) {
    throw StateError('No active company selected');
  }
  return companyId;
});

/// Convenience provider for current user role.
final currentUserRoleProvider = Provider<UserRole>((ref) {
  return ref.watch(tenantProvider).role;
});

/// Convenience provider for active company pricing.
final activeCompanyPricingProvider = Provider<CompanyPricing?>((ref) {
  return ref.watch(tenantProvider).activeCompany?.pricing;
});

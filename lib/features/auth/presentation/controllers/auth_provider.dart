import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Authentication state
class AuthState {
  final bool isLoading;
  final String? errorMessage;
  final bool isAuthenticated;
  final AuthUser? user;

  AuthState({
    required this.isLoading,
    this.errorMessage,
    required this.isAuthenticated,
    this.user,
  });

  AuthState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isAuthenticated,
    AuthUser? user,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
    );
  }

  // Initial state
  factory AuthState.initial() {
    return AuthState(
      isLoading: false,
      errorMessage: null,
      isAuthenticated: false,
      user: null,
    );
  }

  // Loading state
  factory AuthState.loading() {
    return AuthState(
      isLoading: true,
      errorMessage: null,
      isAuthenticated: false,
      user: null,
    );
  }

  // Success state
  factory AuthState.success(AuthUser user) {
    return AuthState(
      isLoading: false,
      errorMessage: null,
      isAuthenticated: true,
      user: user,
    );
  }

  // Error state
  factory AuthState.error(String message) {
    return AuthState(
      isLoading: false,
      errorMessage: message,
      isAuthenticated: false,
      user: null,
    );
  }
}

/// Authenticated user model
class AuthUser {
  final String id;
  final String email;
  final String name;
  final String? phone;

  AuthUser({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
  });
}

/// Auth state notifier that handles authentication logic
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState.initial());

  /// Simulate login with dummy backend
  Future<void> login({required String email, required String password}) async {
    state = AuthState.loading();

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      // Dummy validation - accept any email/password for demo
      if (email.isEmpty || password.isEmpty) {
        state = AuthState.error('Invalid email or password');
        return;
      }

      // Create dummy user
      final user = AuthUser(
        id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        name: email.split('@').first,
        phone: null,
      );

      state = AuthState.success(user);
    } catch (e) {
      state = AuthState.error('An error occurred. Please try again');
    }
  }

  /// Simulate signup with dummy backend
  Future<void> signup({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    state = AuthState.loading();

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      // Dummy validation
      if (name.isEmpty || email.isEmpty || password.isEmpty || phone.isEmpty) {
        state = AuthState.error('All fields are required');
        return;
      }

      // Create dummy user
      final user = AuthUser(
        id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        name: name,
        phone: phone,
      );

      state = AuthState.success(user);
    } catch (e) {
      state = AuthState.error('An error occurred. Please try again');
    }
  }

  /// Simulate password reset with dummy backend
  Future<void> resetPassword({required String email}) async {
    state = AuthState.loading();

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      if (email.isEmpty) {
        state = AuthState.error('Invalid email');
        return;
      }

      // Just return to initial state - reset link sent
      state = AuthState.initial();
    } catch (e) {
      state = AuthState.error('An error occurred. Please try again');
    }
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(errorMessage: '');
  }

  /// Logout
  void logout() {
    state = AuthState.initial();
  }
}

/// Riverpod providers
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(),
);

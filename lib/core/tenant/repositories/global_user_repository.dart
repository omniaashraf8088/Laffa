import '../../network/api_client.dart';
import '../models/global_user_model.dart';

/// Repository for global user operations.
/// Users are stored at: globalUsers/{userId}
class GlobalUserRepository {
  final ApiClient _apiClient;

  GlobalUserRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  /// Fetches a user by their ID.
  Future<GlobalUser?> getUser(String userId) async {
    try {
      final response = await _apiClient.get('/users/$userId');
      return GlobalUser.fromJson(response);
    } catch (_) {
      return null;
    }
  }

  /// Creates a new global user profile after authentication.
  Future<GlobalUser> createUser(GlobalUser user) async {
    final response = await _apiClient.post('/users', body: user.toJson());
    return GlobalUser.fromJson(response);
  }

  /// Updates the user's active company.
  Future<void> updateActiveCompany({
    required String userId,
    required String companyId,
  }) async {
    await _apiClient.put(
      '/users/$userId',
      body: {'activeCompanyId': companyId},
    );
  }

  /// Updates user profile information.
  Future<GlobalUser> updateUser(GlobalUser user) async {
    final response = await _apiClient.put(
      '/users/${user.id}',
      body: user.toJson(),
    );
    return GlobalUser.fromJson(response);
  }

  /// Fetches all users for a specific company (admin use).
  Future<List<GlobalUser>> getUsersByCompany(String companyId) async {
    try {
      final response = await _apiClient.get('/companies/$companyId/users');
      final list = response['data'] as List<dynamic>? ?? [];
      return list
          .map((e) => GlobalUser.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// Fetches all users on the platform (super admin only).
  Future<List<GlobalUser>> getAllUsers() async {
    try {
      final response = await _apiClient.get('/users');
      final list = response['data'] as List<dynamic>? ?? [];
      return list
          .map((e) => GlobalUser.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }
}

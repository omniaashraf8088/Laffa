import '../../network/api_client.dart';
import '../models/company_model.dart';

/// Repository for company (tenant) CRUD operations.
/// Used by super admins and the tenant service.
class CompanyRepository {
  final ApiClient _apiClient;

  CompanyRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  /// Fetches a single company by its ID.
  Future<Company?> getCompany(String companyId) async {
    try {
      final response = await _apiClient.get('/companies/$companyId');
      return Company.fromJson(response);
    } catch (_) {
      return null;
    }
  }

  /// Fetches all companies (super admin only).
  Future<List<Company>> getAllCompanies() async {
    try {
      final response = await _apiClient.get('/companies');
      final list = response['data'] as List<dynamic>? ?? [];
      return list
          .map((e) => Company.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// Fetches only active companies (for rider company selection).
  Future<List<Company>> getActiveCompanies() async {
    try {
      final response = await _apiClient.get('/companies?isActive=true');
      final list = response['data'] as List<dynamic>? ?? [];
      return list
          .map((e) => Company.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// Fetches companies by a list of IDs (for company admins).
  Future<List<Company>> getCompaniesByIds(List<String> companyIds) async {
    try {
      final ids = companyIds.join(',');
      final response = await _apiClient.get('/companies?ids=$ids');
      final list = response['data'] as List<dynamic>? ?? [];
      return list
          .map((e) => Company.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// Creates a new company (super admin only).
  Future<Company> createCompany(Company company) async {
    final response = await _apiClient.post(
      '/companies',
      body: company.toJson(),
    );
    return Company.fromJson(response);
  }

  /// Updates an existing company.
  Future<Company> updateCompany(Company company) async {
    final response = await _apiClient.put(
      '/companies/${company.id}',
      body: company.toJson(),
    );
    return Company.fromJson(response);
  }

  /// Activates or deactivates a company (super admin only).
  Future<void> setCompanyActive({
    required String companyId,
    required bool isActive,
  }) async {
    await _apiClient.put('/companies/$companyId', body: {'isActive': isActive});
  }

  /// Updates company pricing configuration.
  Future<void> updatePricing({
    required String companyId,
    required CompanyPricing pricing,
  }) async {
    await _apiClient.put(
      '/companies/$companyId/pricing',
      body: pricing.toJson(),
    );
  }

  /// Deletes a company (super admin only, soft delete).
  Future<void> deleteCompany(String companyId) async {
    await _apiClient.delete('/companies/$companyId');
  }
}

/// Roles available in the Laffa SaaS platform.
///
/// Role hierarchy:
/// - superAdmin: Platform owner - manages all companies
/// - companyAdmin: Company-level admin - manages own company resources
/// - rider: End user - books and rides scooters
enum UserRole {
  superAdmin,
  companyAdmin,
  rider;

  String get displayName {
    switch (this) {
      case UserRole.superAdmin:
        return 'Super Admin';
      case UserRole.companyAdmin:
        return 'Company Admin';
      case UserRole.rider:
        return 'Rider';
    }
  }

  bool get isAdmin =>
      this == UserRole.superAdmin || this == UserRole.companyAdmin;

  bool get isSuperAdmin => this == UserRole.superAdmin;

  bool get isCompanyAdmin => this == UserRole.companyAdmin;

  bool get isRider => this == UserRole.rider;
}

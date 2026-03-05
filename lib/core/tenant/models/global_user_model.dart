import 'package:flutter/foundation.dart';

import 'user_role.dart';

/// Represents a user in the global users collection.
/// Stored at: globalUsers/{userId}
///
/// This model links users to their active company and role.
/// A user can be a rider in multiple companies but only has
/// one active company at a time.
@immutable
class GlobalUser {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final UserRole role;
  final String? activeCompanyId;
  final List<String> companyIds;
  final DateTime createdAt;
  final DateTime? lastLoginAt;

  const GlobalUser({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    this.role = UserRole.rider,
    this.activeCompanyId,
    this.companyIds = const [],
    required this.createdAt,
    this.lastLoginAt,
  });

  bool get hasActiveCompany => activeCompanyId != null;

  bool get needsCompanySelection =>
      role == UserRole.rider && activeCompanyId == null;

  GlobalUser copyWith({
    String? email,
    String? name,
    String? phone,
    UserRole? role,
    String? activeCompanyId,
    List<String>? companyIds,
    DateTime? lastLoginAt,
  }) {
    return GlobalUser(
      id: id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      activeCompanyId: activeCompanyId ?? this.activeCompanyId,
      companyIds: companyIds ?? this.companyIds,
      createdAt: createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'role': role.name,
      'activeCompanyId': activeCompanyId,
      'companyIds': companyIds,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
    };
  }

  factory GlobalUser.fromJson(Map<String, dynamic> json) {
    return GlobalUser(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String?,
      role: UserRole.values.firstWhere(
        (e) => e.name == json['role'],
        orElse: () => UserRole.rider,
      ),
      activeCompanyId: json['activeCompanyId'] as String?,
      companyIds:
          (json['companyIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.parse(json['lastLoginAt'] as String)
          : null,
    );
  }

  @override
  String toString() =>
      'GlobalUser(id: $id, name: $name, role: $role, activeCompanyId: $activeCompanyId)';
}

import 'package:flutter/foundation.dart';

import 'subscription_plan.dart';

/// Represents a company (tenant) on the Laffa SaaS platform.
/// Stored at: companies/{companyId}
@immutable
class Company {
  final String id;
  final String name;
  final String? logo;
  final SubscriptionPlan subscriptionPlan;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? subscriptionExpiresAt;
  final CompanyPricing pricing;
  final List<String> cities;
  final CompanySettings settings;

  const Company({
    required this.id,
    required this.name,
    this.logo,
    this.subscriptionPlan = SubscriptionPlan.free,
    this.isActive = true,
    required this.createdAt,
    this.subscriptionExpiresAt,
    this.pricing = const CompanyPricing(),
    this.cities = const [],
    this.settings = const CompanySettings(),
  });

  bool get isSubscriptionExpired {
    if (subscriptionExpiresAt == null) return false;
    return DateTime.now().isAfter(subscriptionExpiresAt!);
  }

  bool get canCreateRides => isActive && !isSubscriptionExpired;

  Company copyWith({
    String? name,
    String? logo,
    SubscriptionPlan? subscriptionPlan,
    bool? isActive,
    DateTime? subscriptionExpiresAt,
    CompanyPricing? pricing,
    List<String>? cities,
    CompanySettings? settings,
  }) {
    return Company(
      id: id,
      name: name ?? this.name,
      logo: logo ?? this.logo,
      subscriptionPlan: subscriptionPlan ?? this.subscriptionPlan,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
      subscriptionExpiresAt:
          subscriptionExpiresAt ?? this.subscriptionExpiresAt,
      pricing: pricing ?? this.pricing,
      cities: cities ?? this.cities,
      settings: settings ?? this.settings,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logo': logo,
      'subscriptionPlan': subscriptionPlan.name,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'subscriptionExpiresAt': subscriptionExpiresAt?.toIso8601String(),
      'pricing': pricing.toJson(),
      'cities': cities,
      'settings': settings.toJson(),
    };
  }

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'] as String,
      name: json['name'] as String,
      logo: json['logo'] as String?,
      subscriptionPlan: SubscriptionPlan.values.firstWhere(
        (e) => e.name == json['subscriptionPlan'],
        orElse: () => SubscriptionPlan.free,
      ),
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      subscriptionExpiresAt: json['subscriptionExpiresAt'] != null
          ? DateTime.parse(json['subscriptionExpiresAt'] as String)
          : null,
      pricing: json['pricing'] != null
          ? CompanyPricing.fromJson(json['pricing'] as Map<String, dynamic>)
          : const CompanyPricing(),
      cities:
          (json['cities'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      settings: json['settings'] != null
          ? CompanySettings.fromJson(json['settings'] as Map<String, dynamic>)
          : const CompanySettings(),
    );
  }

  @override
  String toString() => 'Company(id: $id, name: $name, plan: $subscriptionPlan)';
}

/// Pricing configuration for a company.
/// Stored inside the company document.
@immutable
class CompanyPricing {
  final double unlockFee;
  final double pricePerMinute;
  final double surgeMultiplier;
  final String currency;

  const CompanyPricing({
    this.unlockFee = 5.0,
    this.pricePerMinute = 2.5,
    this.surgeMultiplier = 1.0,
    this.currency = 'EGP',
  });

  double calculateRideCost({
    required int durationMinutes,
    bool isSurge = false,
  }) {
    final multiplier = isSurge ? surgeMultiplier : 1.0;
    return unlockFee + (pricePerMinute * durationMinutes * multiplier);
  }

  Map<String, dynamic> toJson() {
    return {
      'unlockFee': unlockFee,
      'pricePerMinute': pricePerMinute,
      'surgeMultiplier': surgeMultiplier,
      'currency': currency,
    };
  }

  factory CompanyPricing.fromJson(Map<String, dynamic> json) {
    return CompanyPricing(
      unlockFee: (json['unlockFee'] as num?)?.toDouble() ?? 5.0,
      pricePerMinute: (json['pricePerMinute'] as num?)?.toDouble() ?? 2.5,
      surgeMultiplier: (json['surgeMultiplier'] as num?)?.toDouble() ?? 1.0,
      currency: json['currency'] as String? ?? 'EGP',
    );
  }
}

/// Company-level settings for customization and feature flags.
@immutable
class CompanySettings {
  final bool allowMultiCity;
  final bool enableChat;
  final bool enableCoupons;
  final bool enableWallet;
  final int maxActiveRidesPerUser;
  final String? supportEmail;
  final String? supportPhone;

  const CompanySettings({
    this.allowMultiCity = false,
    this.enableChat = true,
    this.enableCoupons = true,
    this.enableWallet = false,
    this.maxActiveRidesPerUser = 1,
    this.supportEmail,
    this.supportPhone,
  });

  Map<String, dynamic> toJson() {
    return {
      'allowMultiCity': allowMultiCity,
      'enableChat': enableChat,
      'enableCoupons': enableCoupons,
      'enableWallet': enableWallet,
      'maxActiveRidesPerUser': maxActiveRidesPerUser,
      'supportEmail': supportEmail,
      'supportPhone': supportPhone,
    };
  }

  factory CompanySettings.fromJson(Map<String, dynamic> json) {
    return CompanySettings(
      allowMultiCity: json['allowMultiCity'] as bool? ?? false,
      enableChat: json['enableChat'] as bool? ?? true,
      enableCoupons: json['enableCoupons'] as bool? ?? true,
      enableWallet: json['enableWallet'] as bool? ?? false,
      maxActiveRidesPerUser: json['maxActiveRidesPerUser'] as int? ?? 1,
      supportEmail: json['supportEmail'] as String?,
      supportPhone: json['supportPhone'] as String?,
    );
  }
}

/// Subscription plans available for companies on the Laffa platform.
enum SubscriptionPlan {
  free,
  pro,
  enterprise;

  String get displayName {
    switch (this) {
      case SubscriptionPlan.free:
        return 'Free';
      case SubscriptionPlan.pro:
        return 'Pro';
      case SubscriptionPlan.enterprise:
        return 'Enterprise';
    }
  }

  int get maxScooters {
    switch (this) {
      case SubscriptionPlan.free:
        return 10;
      case SubscriptionPlan.pro:
        return 100;
      case SubscriptionPlan.enterprise:
        return -1; // Unlimited
    }
  }

  int get maxAdmins {
    switch (this) {
      case SubscriptionPlan.free:
        return 1;
      case SubscriptionPlan.pro:
        return 5;
      case SubscriptionPlan.enterprise:
        return -1; // Unlimited
    }
  }

  bool get hasSurgeSupport {
    switch (this) {
      case SubscriptionPlan.free:
        return false;
      case SubscriptionPlan.pro:
      case SubscriptionPlan.enterprise:
        return true;
    }
  }

  bool get hasAnalytics {
    switch (this) {
      case SubscriptionPlan.free:
        return false;
      case SubscriptionPlan.pro:
      case SubscriptionPlan.enterprise:
        return true;
    }
  }

  bool get hasCustomBranding {
    switch (this) {
      case SubscriptionPlan.free:
      case SubscriptionPlan.pro:
        return false;
      case SubscriptionPlan.enterprise:
        return true;
    }
  }
}

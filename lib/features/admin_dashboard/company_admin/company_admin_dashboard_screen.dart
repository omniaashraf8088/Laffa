import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/tenant/tenant_service.dart';
import '../../../core/router/app_router.dart';
import '../../../core/constants/colors.dart';
import '../widgets/subscription_banner.dart';
import 'package:go_router/go_router.dart';

/// Company Admin Dashboard — scoped to the active company.
/// Shows: rides today, active rides, revenue, scooter management.
class CompanyAdminDashboardScreen extends ConsumerWidget {
  const CompanyAdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tenantState = ref.watch(tenantProvider);
    final company = tenantState.activeCompany;

    if (company == null) {
      return const Scaffold(body: Center(child: Text('No company selected')));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(company.name),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_horiz),
            tooltip: 'Switch Company',
            onPressed: () => context.go(AppRouter.companySelect),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.go(AppRouter.settings),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(tenantProvider.notifier).refreshActiveCompany();
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Subscription status banner
            if (company.isSubscriptionExpired) const SubscriptionBanner(),
            const SizedBox(height: 16),

            // KPI Cards Row 1
            Row(
              children: [
                Expanded(
                  child: _KpiCard(
                    title: 'Rides Today',
                    value: '--',
                    icon: Icons.directions_bike,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _KpiCard(
                    title: 'Active Rides',
                    value: '--',
                    icon: Icons.play_circle_fill,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // KPI Cards Row 2
            Row(
              children: [
                Expanded(
                  child: _KpiCard(
                    title: 'Revenue',
                    value: '${company.pricing.currency} --',
                    icon: Icons.attach_money,
                    color: Colors.amber.shade700,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _KpiCard(
                    title: 'Total Scooters',
                    value: '--',
                    icon: Icons.electric_scooter,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Pricing section
            _SectionHeader(title: 'Pricing Configuration'),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _PricingRow(
                      label: 'Unlock Fee',
                      value:
                          '${company.pricing.currency} ${company.pricing.unlockFee}',
                    ),
                    const Divider(),
                    _PricingRow(
                      label: 'Price per Minute',
                      value:
                          '${company.pricing.currency} ${company.pricing.pricePerMinute}',
                    ),
                    const Divider(),
                    _PricingRow(
                      label: 'Surge Multiplier',
                      value: '${company.pricing.surgeMultiplier}x',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Quick actions
            _SectionHeader(title: 'Quick Actions'),
            const SizedBox(height: 8),
            _ActionTile(
              icon: Icons.add_circle_outline,
              title: 'Add Scooter',
              subtitle: 'Register a new scooter to your fleet',
              onTap: () {
                // TODO: Navigate to add scooter screen
              },
            ),
            _ActionTile(
              icon: Icons.battery_alert,
              title: 'Battery Warnings',
              subtitle: 'View scooters with low battery',
              onTap: () {
                // TODO: Navigate to battery warnings
              },
            ),
            _ActionTile(
              icon: Icons.block,
              title: 'Disable Scooter',
              subtitle: 'Take a scooter out of service',
              onTap: () {
                // TODO: Navigate to disable scooter
              },
            ),
            _ActionTile(
              icon: Icons.analytics_outlined,
              title: 'View Analytics',
              subtitle: 'Detailed ride and revenue analytics',
              onTap: () {
                // TODO: Navigate to analytics
              },
            ),
            const SizedBox(height: 24),

            // Subscription info
            _SectionHeader(title: 'Subscription'),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Plan',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Chip(
                          label: Text(company.subscriptionPlan.displayName),
                          backgroundColor: AppColors.primary.withValues(
                            alpha: 0.1,
                          ),
                          labelStyle: TextStyle(color: AppColors.primary),
                        ),
                      ],
                    ),
                    if (company.subscriptionExpiresAt != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Expires',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            _formatDate(company.subscriptionExpiresAt!),
                            style: TextStyle(
                              color: company.isSubscriptionExpired
                                  ? Colors.red
                                  : null,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _KpiCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}

class _PricingRow extends StatelessWidget {
  final String label;
  final String value;

  const _PricingRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

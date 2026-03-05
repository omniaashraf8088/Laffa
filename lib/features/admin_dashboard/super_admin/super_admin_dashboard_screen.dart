import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/colors.dart';
import '../../../core/router/app_router.dart';
import '../../../core/tenant/tenant_service.dart';

/// Super Admin Dashboard — platform-level overview.
/// Shows: total companies, active subscriptions, platform revenue, growth.
class SuperAdminDashboardScreen extends ConsumerWidget {
  const SuperAdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tenantState = ref.watch(tenantProvider);
    final companies = tenantState.availableCompanies;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Platform Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.go(AppRouter.settings),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(tenantProvider.notifier).refreshCompanies();
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Platform KPIs
            Row(
              children: [
                Expanded(
                  child: _KpiCard(
                    title: 'Total Companies',
                    value: '${companies.length}',
                    icon: Icons.business,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _KpiCard(
                    title: 'Active',
                    value: '${companies.where((c) => c.isActive).length}',
                    icon: Icons.check_circle,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _KpiCard(
                    title: 'Platform Revenue',
                    value: '--',
                    icon: Icons.trending_up,
                    color: Colors.amber.shade700,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _KpiCard(
                    title: 'Total Riders',
                    value: '--',
                    icon: Icons.people,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Companies list
            _SectionHeader(title: 'Companies'),
            const SizedBox(height: 8),
            if (companies.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: Text('No companies registered yet')),
                ),
              )
            else
              ...companies.map(
                (company) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      child: Icon(
                        Icons.electric_scooter,
                        color: AppColors.primary,
                      ),
                    ),
                    title: Text(company.name),
                    subtitle: Row(
                      children: [
                        _StatusChip(
                          label: company.isActive ? 'Active' : 'Inactive',
                          isActive: company.isActive,
                        ),
                        const SizedBox(width: 8),
                        _StatusChip(
                          label: company.subscriptionPlan.displayName,
                          isActive: !company.isSubscriptionExpired,
                        ),
                      ],
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        switch (value) {
                          case 'toggle':
                            ref
                                .read(companyRepositoryProvider)
                                .setCompanyActive(
                                  companyId: company.id,
                                  isActive: !company.isActive,
                                )
                                .then((_) {
                                  ref
                                      .read(tenantProvider.notifier)
                                      .refreshCompanies();
                                });
                          case 'view':
                            ref
                                .read(tenantProvider.notifier)
                                .setActiveCompany(company.id)
                                .then((_) {
                                  context.go(AppRouter.companyAdmin);
                                });
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'toggle',
                          child: Text(
                            company.isActive ? 'Deactivate' : 'Activate',
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'view',
                          child: Text('View Dashboard'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 24),

            // Quick actions
            _SectionHeader(title: 'Platform Actions'),
            const SizedBox(height: 8),
            _ActionTile(
              icon: Icons.add_business,
              title: 'Add Company',
              subtitle: 'Register a new scooter company',
              onTap: () {
                // TODO: Navigate to add company
              },
            ),
            _ActionTile(
              icon: Icons.analytics_outlined,
              title: 'Growth Analytics',
              subtitle: 'Platform growth and usage stats',
              onTap: () {
                // TODO: Navigate to analytics
              },
            ),
            _ActionTile(
              icon: Icons.subscriptions,
              title: 'Subscription Management',
              subtitle: 'Manage company subscriptions',
              onTap: () {
                // TODO: Navigate to subscription management
              },
            ),
          ],
        ),
      ),
    );
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

class _StatusChip extends StatelessWidget {
  final String label;
  final bool isActive;

  const _StatusChip({required this.label, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.green.withValues(alpha: 0.1)
            : Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isActive ? Colors.green.shade700 : Colors.red.shade700,
        ),
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

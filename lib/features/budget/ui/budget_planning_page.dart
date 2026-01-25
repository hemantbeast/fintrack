import 'package:fintrack/core/extensions/context_extensions.dart';
import 'package:fintrack/features/budget/domain/entities/budget.dart';
import 'package:fintrack/features/budget/ui/providers/budget_planning_provider.dart';
import 'package:fintrack/features/budget/ui/states/budget_planning_state.dart';
import 'package:fintrack/generated/l10n.dart';
import 'package:fintrack/routes/app_router.dart';
import 'package:fintrack/routes/route_enum.dart';
import 'package:fintrack/themes/colors.dart';
import 'package:fintrack/themes/custom_theme.dart';
import 'package:fintrack/widgets/app_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BudgetPlanningPage extends ConsumerWidget {
  const BudgetPlanningPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(budgetPlanningProvider);
    final notifier = ref.read(budgetPlanningProvider.notifier);
    final l10n = S.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          l10n.budgetPlanning,
          style: context.navigationTitleStyle,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              AppRouter.pushNamed(RouteEnum.addBudgetScreen.name);
            },
          ),
        ],
      ),
      body: state.budgets.when(
        data: (budgets) {
          if (budgets.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  NoDataWidget(text: l10n.noBudgetsFound),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      AppRouter.pushNamed(RouteEnum.addBudgetScreen.name);
                    },
                    icon: const Icon(Icons.add),
                    label: Text(l10n.addBudget),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: notifier.refresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Total Budget Overview Card
                  _TotalBudgetCard(stats: state.stats),

                  const SizedBox(height: 24),

                  // Category Budgets Header
                  Text(
                    l10n.categoryBudgets,
                    style: semiboldTextStyle(
                      color: context.theme.textTheme.bodyLarge?.color,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Budget List
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: budgets.length,
                    itemBuilder: (context, index) {
                      return _BudgetCard(
                        budget: budgets[index],
                        onTap: () => _showBudgetOptions(
                          context,
                          budgets[index],
                          notifier,
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 12);
                    },
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const LoadingWidget(),
        error: (error, stack) => Center(
          child: NoDataWidget(text: l10n.noDataFound),
        ),
      ),
    );
  }

  void _showBudgetOptions(
    BuildContext context,
    Budget budget,
    BudgetPlanningNotifier notifier,
  ) {
    final l10n = S.of(context);

    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: Text(l10n.editBudget),
                onTap: () {
                  Navigator.pop(context);
                  AppRouter.pushNamed(
                    RouteEnum.addBudgetScreen.name,
                    args: budget,
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: accentColor),
                title: Text(
                  l10n.deleteBudget,
                  style: const TextStyle(color: accentColor),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDelete(context, budget, notifier);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmDelete(
    BuildContext context,
    Budget budget,
    BudgetPlanningNotifier notifier,
  ) {
    final l10n = S.of(context);

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.deleteBudget),
          content: Text(l10n.confirmDeleteBudget),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                notifier.deleteBudget(budget.id);
              },
              child: Text(
                l10n.yes,
                style: const TextStyle(color: accentColor),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TotalBudgetCard extends StatelessWidget {
  const _TotalBudgetCard({required this.stats});

  final BudgetStats stats;

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final percentage = stats.percentage.clamp(0.0, 100.0);
    final progressColor = _getProgressColor(percentage);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [primaryColor, Color(0xFF8B7FFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.totalBudget,
            style: defaultTextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${stats.totalSpent.toStringAsFixed(0)} / \$${stats.totalLimit.toStringAsFixed(0)}',
                style: semiboldTextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${percentage.toStringAsFixed(0)}%',
                  style: semiboldTextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: Colors.white.withValues(alpha: 0.3),
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '\$${stats.remaining.toStringAsFixed(2)} ${l10n.remaining}',
            style: defaultTextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Color _getProgressColor(double percentage) {
    if (percentage >= 90) return accentColor;
    if (percentage >= 75) return warningColor;
    return secondaryColor;
  }
}

class _BudgetCard extends StatelessWidget {
  const _BudgetCard({
    required this.budget,
    required this.onTap,
  });

  final Budget budget;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final percentage = budget.percentage;
    final progressColor = _getProgressColor(percentage);
    final isWarning = percentage >= 75;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: grayF5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: progressColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    budget.emoji,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        budget.category,
                        style: semiboldTextStyle(
                          color: context.theme.textTheme.bodyLarge?.color,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${budget.spent.toStringAsFixed(0)} / \$${budget.limit.toStringAsFixed(0)}',
                        style: defaultTextStyle(
                          color: gray98,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${percentage.toStringAsFixed(0)}%',
                      style: semiboldTextStyle(
                        color: progressColor,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (isWarning)
                      Row(
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            size: 14,
                            color: progressColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '\$${budget.remaining.toStringAsFixed(0)} ${l10n.remaining}',
                            style: defaultTextStyle(
                              color: progressColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      )
                    else
                      Text(
                        '\$${budget.remaining.toStringAsFixed(0)} ${l10n.remaining}',
                        style: defaultTextStyle(
                          color: secondaryColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percentage / 100,
                backgroundColor: grayF5,
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                minHeight: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getProgressColor(double percentage) {
    if (percentage >= 90) return accentColor;
    if (percentage >= 75) return warningColor;
    return secondaryColor;
  }
}

import 'package:fintrack/core/extensions/context_extensions.dart';
import 'package:fintrack/features/budget/domain/entities/budget.dart';
import 'package:fintrack/features/settings/ui/providers/currency_formatter_provider.dart';
import 'package:fintrack/generated/l10n.dart';
import 'package:fintrack/themes/colors.dart';
import 'package:fintrack/themes/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BudgetOverview extends StatelessWidget {
  const BudgetOverview({required this.budgets, super.key});

  final List<Budget> budgets;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).budgetOverview,
          style: semiboldTextStyle(
            color: context.theme.textTheme.bodyLarge?.color,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: budgets.length,
          itemBuilder: (context, index) {
            return _BudgetItem(budget: budgets[index]);
          },
          separatorBuilder: (context, index) {
            return const SizedBox(height: 12);
          },
        ),
      ],
    );
  }
}

class _BudgetItem extends ConsumerWidget {
  const _BudgetItem({required this.budget});

  final Budget budget;

  Color _getProgressColor() {
    if (budget.percentage < 50) return secondaryColor;
    if (budget.percentage < 80) return warningColor;
    return accentColor;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencyFormatter = ref.watch(currencyFormatterProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: grayF5),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _getProgressColor().withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
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
                      '${currencyFormatter.formatCompact(budget.spent, decimalPlaces: 0)} / ${currencyFormatter.formatCompact(budget.limit, decimalPlaces: 0)}',
                      style: defaultTextStyle(
                        color: gray98,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${budget.percentage.toStringAsFixed(0)}%',
                style: semiboldTextStyle(
                  color: _getProgressColor(),
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: budget.percentage / 100,
              backgroundColor: grayF5,
              valueColor: AlwaysStoppedAnimation<Color>(_getProgressColor()),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}

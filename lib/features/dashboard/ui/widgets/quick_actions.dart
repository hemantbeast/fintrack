import 'package:fintrack/core/extensions/context_extensions.dart';
import 'package:fintrack/generated/l10n.dart';
import 'package:fintrack/routes/app_router.dart';
import 'package:fintrack/routes/route_enum.dart';
import 'package:fintrack/themes/colors.dart';
import 'package:fintrack/themes/custom_theme.dart';
import 'package:flutter/material.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).quickActions,
          style: semiboldTextStyle(
            color: context.theme.textTheme.bodyLarge?.color,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _QuickActionButton(
                icon: Icons.add,
                label: S.of(context).add,
                color: primaryColor,
                onTap: () {
                  AppRouter.pushNamed(RouteEnum.addExpenseScreen.name);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionButton(
                icon: Icons.bar_chart,
                label: S.of(context).view,
                color: secondaryColor,
                onTap: () {
                  AppRouter.pushNamed(RouteEnum.allTransactionsScreen.name);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionButton(
                icon: Icons.account_balance_wallet,
                label: S.of(context).budget,
                color: const Color(0xFFFF9800),
                onTap: () {
                  AppRouter.pushNamed(RouteEnum.budgetPlanningScreen.name);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionButton(
                icon: Icons.trending_up,
                label: S.of(context).stats,
                color: accentColor,
                onTap: () {
                  // TODO: Navigate to stats screen
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: defaultTextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

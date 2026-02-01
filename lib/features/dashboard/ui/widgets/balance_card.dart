import 'package:fintrack/features/dashboard/domain/entities/balance.dart';
import 'package:fintrack/generated/l10n.dart';
import 'package:fintrack/themes/colors.dart';
import 'package:fintrack/themes/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fintrack/features/settings/ui/providers/currency_formatter_provider.dart';

class BalanceCard extends ConsumerWidget {
  const BalanceCard({required this.balance, super.key});

  final Balance balance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencyFormatter = ref.watch(currencyFormatterProvider);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [primaryColor, Color(0xFF8A84FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).currentBalance,
            style: defaultTextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            currencyFormatter.format(balance.currentBalance),
            style: boldTextStyle(
              color: Colors.white,
              fontSize: 32,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white24, height: 1),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildBalanceItem(
                  context,
                  '↑ ${S.of(context).income}',
                  balance.income,
                  secondaryColor,
                  currencyFormatter,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildBalanceItem(
                  context,
                  '↓ ${S.of(context).expenses}',
                  balance.expenses,
                  accentColor,
                  currencyFormatter,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceItem(
    BuildContext context,
    String label,
    double amount,
    Color color,
    CurrencyFormatterHelper formatter,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: defaultTextStyle(
            color: Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          formatter.format(amount),
          style: semiboldTextStyle(
            color: color,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}

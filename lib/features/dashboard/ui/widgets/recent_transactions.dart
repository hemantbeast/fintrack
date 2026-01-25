import 'package:fintrack/core/extensions/context_extensions.dart';
import 'package:fintrack/features/dashboard/domain/entities/transaction.dart';
import 'package:fintrack/generated/l10n.dart';
import 'package:fintrack/routes/app_router.dart';
import 'package:fintrack/routes/route_enum.dart';
import 'package:fintrack/themes/colors.dart';
import 'package:fintrack/themes/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RecentTransactions extends StatelessWidget {
  const RecentTransactions({required this.transactions, super.key});

  final List<Transaction> transactions;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              S.of(context).recentTransactions,
              style: semiboldTextStyle(
                color: context.theme.textTheme.bodyLarge?.color,
                fontSize: 16,
              ),
            ),
            TextButton(
              onPressed: () {
                AppRouter.pushNamed(RouteEnum.allTransactionsScreen.name);
              },
              child: Text(
                S.of(context).viewAll,
                style: defaultTextStyle(
                  color: primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            return _TransactionItem(transaction: transactions[index]);
          },
          separatorBuilder: (context, index) {
            return const SizedBox(height: 8);
          },
        ),
      ],
    );
  }
}

class _TransactionItem extends StatelessWidget {
  const _TransactionItem({required this.transaction});

  final Transaction transaction;

  String _getFormattedDate() {
    final now = DateTime.now();
    final difference = now.difference(transaction.date);

    if (difference.inDays == 0) {
      return 'Today, ${DateFormat('h:mm a').format(transaction.date)}';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else {
      return DateFormat('MMM d').format(transaction.date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == TransactionType.income;
    final amountColor = isIncome ? secondaryColor : accentColor;
    final amountPrefix = isIncome ? '+' : '-';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: grayF5),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: amountColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              transaction.emoji,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: semiboldTextStyle(
                    color: context.theme.textTheme.bodyLarge?.color,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${transaction.category} • ${_getFormattedDate()}',
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
            '$amountPrefix\$${transaction.amount.toStringAsFixed(2)}',
            style: semiboldTextStyle(
              color: amountColor,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:fintrack/core/extensions/context_extensions.dart';
import 'package:fintrack/features/dashboard/domain/entities/transaction.dart';
import 'package:fintrack/features/dashboard/ui/providers/all_transactions_provider.dart';
import 'package:fintrack/features/dashboard/ui/states/all_transactions_state.dart';
import 'package:fintrack/features/settings/ui/providers/currency_formatter_provider.dart';
import 'package:fintrack/generated/l10n.dart';
import 'package:fintrack/themes/colors.dart';
import 'package:fintrack/themes/custom_theme.dart';
import 'package:fintrack/widgets/app_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class AllTransactionsPage extends ConsumerWidget {
  const AllTransactionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(allTransactionsProvider);
    final notifier = ref.read(allTransactionsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          S.of(context).allTransactions,
          style: context.navigationTitleStyle,
        ),
      ),
      body: Column(
        children: [
          _FilterChips(
            selectedFilter: state.filter,
            onFilterChanged: notifier.setFilter,
          ),
          Expanded(
            child: state.transactions.when(
              data: (transactions) {
                if (transactions.isEmpty) {
                  return Center(
                    child: NoDataWidget(
                      text: S.of(context).noTransactionsFound,
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: notifier.refresh,
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      return _TransactionItem(
                        transaction: transactions[index],
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 8);
                    },
                  ),
                );
              },
              loading: () => const LoadingWidget(),
              error: (error, stack) => Center(
                child: NoDataWidget(text: S.of(context).noDataFound),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips({
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  final TransactionFilter selectedFilter;
  final ValueChanged<TransactionFilter> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          _FilterChip(
            label: S.of(context).all,
            isSelected: selectedFilter == TransactionFilter.all,
            onTap: () => onFilterChanged(TransactionFilter.all),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: S.of(context).income,
            isSelected: selectedFilter == TransactionFilter.income,
            onTap: () => onFilterChanged(TransactionFilter.income),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: S.of(context).expenses,
            isSelected: selectedFilter == TransactionFilter.expense,
            onTap: () => onFilterChanged(TransactionFilter.expense),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : context.theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? primaryColor : grayF5,
          ),
        ),
        child: Text(
          label,
          style: defaultTextStyle(
            color: isSelected ? Colors.white : gray98,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _TransactionItem extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final isIncome = transaction.type == TransactionType.income;
    final amountColor = isIncome ? secondaryColor : accentColor;
    final amountPrefix = isIncome ? '+' : '-';
    final currencyFormatter = ref.watch(currencyFormatterProvider);

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
            '$amountPrefix${currencyFormatter.format(transaction.amount)}',
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

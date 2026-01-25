import 'package:fintrack/features/dashboard/domain/entities/transaction.dart';
import 'package:fintrack/features/dashboard/ui/states/all_transactions_state.dart';
import 'package:fintrack/providers/transactions_stream_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final allTransactionsProvider = NotifierProvider.autoDispose<AllTransactionsNotifier, AllTransactionsState>(
  AllTransactionsNotifier.new,
);

class AllTransactionsNotifier extends Notifier<AllTransactionsState> {
  List<Transaction>? _allTransactions;

  @override
  AllTransactionsState build() {
    // Listen to shared transactions provider for reactive updates
    Future.delayed(Duration.zero, () {
      ref.listen<AsyncValue<List<Transaction>>>(
        transactionsStreamProvider,
        (previous, next) {
          next.when(
            data: (transactions) {
              _allTransactions = transactions;
              _updateState();
            },
            loading: () {
              state = state.copyWith(transactions: const AsyncLoading());
            },
            error: (error, stack) {
              state = state.copyWith(transactions: AsyncError(error, stack));
            },
          );
        },
        fireImmediately: true,
      );
    });

    return AllTransactionsState.initial();
  }

  void _updateState() {
    if (_allTransactions == null) {
      state = state.copyWith(transactions: const AsyncLoading());
      return;
    }

    final filteredTransactions = _filterTransactions(_allTransactions!);
    state = state.copyWith(
      transactions: AsyncData(filteredTransactions),
    );
  }

  List<Transaction> _filterTransactions(List<Transaction> transactions) {
    switch (state.filter) {
      case TransactionFilter.all:
        return transactions;
      case TransactionFilter.income:
        return transactions.where((t) => t.type == TransactionType.income).toList();
      case TransactionFilter.expense:
        return transactions.where((t) => t.type == TransactionType.expense).toList();
    }
  }

  void setFilter(TransactionFilter filter) {
    state = state.copyWith(filter: filter);
    _updateState();
  }

  Future<void> refresh() async {
    _allTransactions = null;
    state = state.copyWith(transactions: const AsyncLoading());

    await ref.read(transactionsStreamProvider.notifier).refresh();
  }
}

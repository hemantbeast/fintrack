import 'dart:async';

import 'package:fintrack/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:fintrack/features/dashboard/domain/entities/transaction.dart';
import 'package:fintrack/features/dashboard/ui/states/all_transactions_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final allTransactionsProvider = NotifierProvider.autoDispose<AllTransactionsNotifier, AllTransactionsState>(
  AllTransactionsNotifier.new,
);

class AllTransactionsNotifier extends Notifier<AllTransactionsState> {
  StreamSubscription<List<Transaction>>? _transactionsSubscription;
  List<Transaction>? _allTransactions;

  @override
  AllTransactionsState build() {
    ref.onDispose(() {
      _transactionsSubscription?.cancel();
    });

    Future.delayed(Duration.zero, _setupStreams);
    return AllTransactionsState.initial();
  }

  void _setupStreams() {
    final repository = ref.read(dashboardRepositoryProvider);

    _transactionsSubscription = repository.watchTransactions().listen(
      (transactions) {
        _allTransactions = transactions;
        _updateState();
      },
      onError: (Object error, StackTrace stack) {
        state = state.copyWith(
          transactions: AsyncError(error, stack),
        );
      },
    );
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
    await _transactionsSubscription?.cancel();

    _allTransactions = null;
    state = state.copyWith(transactions: const AsyncLoading());

    _setupStreams();
  }
}

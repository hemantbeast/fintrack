import 'dart:async';

import 'package:fintrack/features/dashboard/data/models/transaction_model.dart';
import 'package:fintrack/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:fintrack/features/dashboard/domain/entities/balance.dart';
import 'package:fintrack/features/dashboard/domain/entities/transaction.dart';
import 'package:fintrack/hive/hive_keys.dart';
import 'package:fintrack/hive/hive_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A shared notifier that provides reactive transaction updates across the app.
/// When a transaction is added, updated, or deleted, all listeners are notified.
final transactionsStreamProvider = NotifierProvider<TransactionsStreamNotifier, AsyncValue<List<Transaction>>>(
  TransactionsStreamNotifier.new,
);

class TransactionsStreamNotifier extends Notifier<AsyncValue<List<Transaction>>> {
  late HiveStorage _storage;
  StreamSubscription<List<Transaction>>? _transactionsSubscription;

  @override
  AsyncValue<List<Transaction>> build() {
    _storage = ref.read(hiveStorageProvider);

    // Setup subscription to repository stream for stale-while-revalidate
    _setupStream();

    // Cleanup when provider is disposed
    ref.onDispose(() {
      _transactionsSubscription?.cancel();
    });

    return const AsyncLoading();
  }

  void _setupStream() {
    final repository = ref.read(dashboardRepositoryProvider);

    _transactionsSubscription = repository.watchTransactions().listen(
      (transactions) {
        final sortedTransactions = transactions..sort((a, b) => b.date.compareTo(a.date));
        state = AsyncData(sortedTransactions);
      },
      onError: (Object error, StackTrace stackTrace) {
        state = AsyncError(error, stackTrace);
      },
    );
  }

  /// Add a new transaction and notify all listeners
  Future<void> addTransaction(Transaction transaction) async {
    final model = TransactionModel.fromEntity(transaction);
    await _storage.saveAllItems<TransactionModel>(
      HiveBoxes.transactions,
      [model],
      keyExtractor: (item) => item.id ?? '',
    );

    // Update state with new transaction
    final currentTransactions = state.hasValue ? state.value! : <Transaction>[];
    final updatedTransactions = [transaction, ...currentTransactions]..sort((a, b) => b.date.compareTo(a.date));
    state = AsyncData(updatedTransactions);
  }

  /// Delete a transaction and notify all listeners
  Future<void> deleteTransaction(String transactionId) async {
    final box = await _storage.getBox<TransactionModel>(HiveBoxes.transactions);
    await box.delete(transactionId);

    // Update state without deleted transaction
    final currentTransactions = state.hasValue ? state.value! : <Transaction>[];
    final updatedTransactions = currentTransactions.where((t) => t.id != transactionId).toList();
    state = AsyncData(updatedTransactions);
  }

  /// Refresh transactions from repository (fetches fresh data with stale-while-revalidate)
  Future<void> refresh() async {
    // Cancel current subscription and create a new one
    // This will trigger a fresh fetch from the repository
    await _transactionsSubscription?.cancel();

    state = const AsyncLoading();
    _setupStream();
  }

  /// Get computed balance from transactions
  Balance computeBalance() {
    final transactions = state.hasValue ? state.value! : <Transaction>[];

    double income = 0;
    double expenses = 0;

    for (final transaction in transactions) {
      if (transaction.type == TransactionType.income) {
        income += transaction.amount;
      } else {
        expenses += transaction.amount;
      }
    }

    return Balance(
      income: income,
      expenses: expenses,
      currentBalance: income - expenses,
    );
  }
}

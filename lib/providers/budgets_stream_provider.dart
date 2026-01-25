import 'dart:async';

import 'package:fintrack/features/budget/data/repositories/budget_repository_impl.dart';
import 'package:fintrack/features/budget/domain/entities/budget.dart';
import 'package:fintrack/features/budget/ui/states/budget_planning_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A shared notifier that provides reactive budget updates across the app.
/// When a budget is added, updated, or deleted, all listeners are notified.
final budgetsStreamProvider = NotifierProvider<BudgetsStreamNotifier, AsyncValue<List<Budget>>>(
  BudgetsStreamNotifier.new,
);

class BudgetsStreamNotifier extends Notifier<AsyncValue<List<Budget>>> {
  StreamSubscription<List<Budget>>? _budgetSubscription;
  List<Budget>? _latestBudgets;

  @override
  AsyncValue<List<Budget>> build() {
    // Setup the repository stream
    _setupStream();
    return const AsyncLoading();
  }

  void _setupStream() {
    final repository = ref.read(budgetRepositoryProvider);

    _budgetSubscription = repository.watchBudgets().listen(
      (budgets) {
        _latestBudgets = budgets..sort((a, b) => b.percentage.compareTo(a.percentage));
        state = AsyncData(_latestBudgets!);
      },
      onError: (Object error, StackTrace stack) {
        state = AsyncError(error, stack);
      },
    );

    ref.onDispose(() => _budgetSubscription?.cancel());
  }

  /// Add or update a budget and notify all listeners
  Future<void> saveBudget(Budget budget) async {
    final repository = ref.read(budgetRepositoryProvider);
    await repository.saveBudget(budget);
    // Stream will automatically update
  }

  /// Delete a budget and notify all listeners
  Future<void> deleteBudget(String budgetId) async {
    final repository = ref.read(budgetRepositoryProvider);
    await repository.deleteBudget(budgetId);
    // Stream will automatically update
  }

  /// Refresh budgets from repository
  Future<void> refresh() async {
    // Cancel and restart subscription to trigger fresh fetch
    await _budgetSubscription?.cancel();
    state = const AsyncLoading();
    _setupStream();
  }

  /// Get total budget stats
  BudgetStats computeStats() {
    final budgets = _latestBudgets ?? [];

    double totalSpent = 0;
    double totalLimit = 0;

    for (final budget in budgets) {
      totalSpent += budget.spent;
      totalLimit += budget.limit;
    }

    return BudgetStats(
      totalSpent: totalSpent,
      totalLimit: totalLimit,
      percentage: totalLimit > 0 ? (totalSpent / totalLimit * 100) : 0,
    );
  }
}

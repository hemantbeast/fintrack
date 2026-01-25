import 'dart:async';

import 'package:fintrack/features/budget/data/repositories/budget_repository_impl.dart';
import 'package:fintrack/features/budget/domain/entities/budget.dart';
import 'package:fintrack/features/budget/ui/states/budget_planning_state.dart';
import 'package:riverpod/riverpod.dart';

final budgetPlanningProvider = NotifierProvider.autoDispose<BudgetPlanningNotifier, BudgetPlanningState>(
  BudgetPlanningNotifier.new,
);

class BudgetPlanningNotifier extends Notifier<BudgetPlanningState> {
  StreamSubscription<List<Budget>>? _budgetsSubscription;
  List<Budget>? _latestBudgets;

  @override
  BudgetPlanningState build() {
    ref.onDispose(() => _budgetsSubscription?.cancel());

    // Setup subscription to repository for stale-while-revalidate
    _setupStreams();

    return BudgetPlanningState.initial();
  }

  void _setupStreams() {
    final repository = ref.read(budgetRepositoryProvider);

    _budgetsSubscription = repository.watchBudgets().listen(
      (budgets) {
        _latestBudgets = budgets;
        _updateState();
      },
      onError: (Object error, StackTrace stack) {
        state = state.copyWith(budgets: AsyncError(error, stack));
      },
    );
  }

  void _updateState() {
    if (_latestBudgets == null) {
      state = state.copyWith(budgets: const AsyncLoading());
      return;
    }

    final stats = _computeStats();
    state = state.copyWith(
      budgets: AsyncData(_latestBudgets!),
      stats: stats,
    );
  }

  BudgetStats _computeStats() {
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

  Future<void> deleteBudget(String budgetId) async {
    final repository = ref.read(budgetRepositoryProvider);
    await repository.deleteBudget(budgetId);
    // Stream will automatically update
  }

  Future<void> refresh() async {
    // Cancel subscription and restart to trigger fresh fetch
    await _budgetsSubscription?.cancel();

    state = state.copyWith(budgets: const AsyncLoading());
    _setupStreams();
  }
}

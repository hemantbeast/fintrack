import 'package:fintrack/features/budget/ui/states/budget_planning_state.dart';
import 'package:fintrack/features/dashboard/domain/entities/budget.dart';
import 'package:fintrack/providers/budgets_stream_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final budgetPlanningProvider = NotifierProvider.autoDispose<BudgetPlanningNotifier, BudgetPlanningState>(
  BudgetPlanningNotifier.new,
);

class BudgetPlanningNotifier extends Notifier<BudgetPlanningState> {
  @override
  BudgetPlanningState build() {
    // Get initial data synchronously
    final initialBudgets = ref.read(budgetsStreamProvider);
    final initialStats = ref.read(budgetsStreamProvider.notifier).computeStats();

    // Listen to shared budgets provider for future updates
    ref.listen<AsyncValue<List<Budget>>>(
      budgetsStreamProvider,
      (previous, next) {
        next.when(
          data: (List<Budget> budgets) {
            final stats = ref.read(budgetsStreamProvider.notifier).computeStats();
            state = state.copyWith(
              budgets: AsyncData(budgets),
              stats: stats,
            );
          },
          loading: () {
            state = state.copyWith(budgets: const AsyncLoading());
          },
          error: (Object error, StackTrace stack) {
            state = state.copyWith(budgets: AsyncError(error, stack));
          },
        );
      },
    );

    return BudgetPlanningState(
      budgets: initialBudgets,
      stats: initialStats,
    );
  }

  Future<void> deleteBudget(String budgetId) async {
    await ref.read(budgetsStreamProvider.notifier).deleteBudget(budgetId);
  }

  Future<void> refresh() async {
    state = state.copyWith(budgets: const AsyncLoading());
    await ref.read(budgetsStreamProvider.notifier).refresh();
  }
}

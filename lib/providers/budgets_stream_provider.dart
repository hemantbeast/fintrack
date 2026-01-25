import 'package:fintrack/features/dashboard/data/models/budget_model.dart';
import 'package:fintrack/features/dashboard/domain/entities/budget.dart';
import 'package:fintrack/hive/hive_keys.dart';
import 'package:fintrack/hive/hive_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A shared notifier that provides reactive budget updates across the app.
/// When a budget is added, updated, or deleted, all listeners are notified.
final budgetsStreamProvider = NotifierProvider<BudgetsStreamNotifier, AsyncValue<List<Budget>>>(
  BudgetsStreamNotifier.new,
);

class BudgetsStreamNotifier extends Notifier<AsyncValue<List<Budget>>> {
  late HiveStorage _storage;

  @override
  AsyncValue<List<Budget>> build() {
    _storage = ref.read(hiveStorageProvider);
    _loadBudgets();
    return const AsyncLoading();
  }

  Future<void> _loadBudgets() async {
    try {
      final models = await _storage.getAllItems<BudgetModel>(HiveBoxes.budgets);
      final budgets = models.map((m) => m.toEntity()).toList()..sort((a, b) => b.percentage.compareTo(a.percentage));

      state = AsyncData(budgets);
    } on Exception catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  /// Add or update a budget and notify all listeners
  Future<void> saveBudget(Budget budget) async {
    final model = BudgetModel.fromEntity(budget);

    await _storage.saveAllItems<BudgetModel>(
      HiveBoxes.budgets,
      [model],
      keyExtractor: (item) => item.id ?? '',
    );

    // Update state with new/updated budget
    final currentBudgets = state.hasValue ? state.value! : <Budget>[];
    final existingIndex = currentBudgets.indexWhere((b) => b.id == budget.id);

    List<Budget> updatedBudgets;
    if (existingIndex >= 0) {
      updatedBudgets = [...currentBudgets];
      updatedBudgets[existingIndex] = budget;
    } else {
      updatedBudgets = [budget, ...currentBudgets];
    }

    updatedBudgets.sort((a, b) => b.percentage.compareTo(a.percentage));
    state = AsyncData(updatedBudgets);
  }

  /// Delete a budget and notify all listeners
  Future<void> deleteBudget(String budgetId) async {
    final box = await _storage.getBox<BudgetModel>(HiveBoxes.budgets);
    await box.delete(budgetId);

    // Update state without deleted budget
    final currentBudgets = state.hasValue ? state.value! : <Budget>[];
    final updatedBudgets = currentBudgets.where((b) => b.id != budgetId).toList();
    state = AsyncData(updatedBudgets);
  }

  /// Refresh budgets from storage
  Future<void> refresh() async {
    state = const AsyncLoading();
    await _loadBudgets();
  }

  /// Get total budget stats
  BudgetStats computeStats() {
    final budgets = state.hasValue ? state.value! : <Budget>[];

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

class BudgetStats {
  const BudgetStats({
    required this.totalSpent,
    required this.totalLimit,
    required this.percentage,
  });

  final double totalSpent;
  final double totalLimit;
  final double percentage;

  double get remaining => (totalLimit - totalSpent).clamp(0, totalLimit);
}

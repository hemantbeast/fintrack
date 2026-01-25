import 'package:fintrack/features/budget/data/models/budget_model.dart';
import 'package:fintrack/hive/hive_keys.dart';
import 'package:fintrack/hive/hive_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final budgetLocalProvider = Provider<BudgetLocal>((ref) {
  return BudgetLocal(ref: ref);
});

class BudgetLocal {
  BudgetLocal({required this.ref}) {
    _storage = ref.read(hiveStorageProvider);
  }

  final Ref ref;
  late final HiveStorage _storage;

  /// Get all budgets from local storage
  Future<List<BudgetModel>?> getBudgets() async {
    return _storage.getAllItems<BudgetModel>(HiveBoxes.budgets);
  }

  /// Save all budgets to local storage
  Future<void> saveBudgets(List<BudgetModel> budgets) async {
    await _storage.saveAllItems<BudgetModel>(
      HiveBoxes.budgets,
      budgets,
      keyExtractor: (item) => item.id ?? '',
    );
  }

  /// Save a single budget
  Future<void> saveBudget(BudgetModel budget) async {
    await _storage.saveAllItems<BudgetModel>(
      HiveBoxes.budgets,
      [budget],
      keyExtractor: (item) => item.id ?? '',
    );
  }

  /// Delete a budget by ID
  Future<void> deleteBudget(String budgetId) async {
    final box = await _storage.getBox<BudgetModel>(HiveBoxes.budgets);
    await box.delete(budgetId);
  }
}

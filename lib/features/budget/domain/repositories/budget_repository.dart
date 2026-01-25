import 'package:fintrack/features/budget/domain/entities/budget.dart';

/// Abstract repository interface for budget operations
abstract class BudgetRepository {
  /// Watch budgets with stale-while-revalidate strategy
  Stream<List<Budget>> watchBudgets();

  /// Save or update a budget
  Future<void> saveBudget(Budget budget);

  /// Delete a budget by ID
  Future<void> deleteBudget(String budgetId);
}

import 'dart:async';

import 'package:fintrack/features/budget/data/models/budget_model.dart';
import 'package:fintrack/features/budget/data/sources/local/budget_local.dart';
import 'package:fintrack/features/budget/data/sources/remote/budget_service.dart';
import 'package:fintrack/features/budget/domain/entities/budget.dart';
import 'package:fintrack/features/budget/domain/repositories/budget_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final budgetRepositoryProvider = Provider<BudgetRepository>((ref) {
  final service = ref.read(budgetServiceProvider);
  final local = ref.read(budgetLocalProvider);
  return BudgetRepositoryImpl(service: service, local: local);
});

class BudgetRepositoryImpl implements BudgetRepository {
  BudgetRepositoryImpl({
    required this.service,
    required this.local,
  });

  final BudgetService service;
  final BudgetLocal local;

  /// Watch budgets with stale-while-revalidate strategy
  @override
  Stream<List<Budget>> watchBudgets() async* {
    // Get cached data from local storage
    final cachedBudgets = await local.getBudgets();

    if (cachedBudgets != null) {
      yield cachedBudgets.map((m) => m.toEntity()).toList();
    }

    try {
      // Fetch fresh data from API
      final freshBudgets = await service.getBudgets();
      await local.saveBudgets(freshBudgets);

      // Yield fresh data
      yield freshBudgets.map((m) => m.toEntity()).toList();
    } on Exception catch (_) {
      // Throw error if fetching fails and no cached data
      if (cachedBudgets == null) {
        rethrow;
      }
    }
  }

  /// Save or update a budget
  @override
  Future<void> saveBudget(Budget budget) async {
    final model =BudgetModel.fromEntity(budget);
    await local.saveBudget(model);

    // TODO: Sync with API when API is implemented
    // await service.saveBudget(model);
  }

  /// Delete a budget by ID
  @override
  Future<void> deleteBudget(String budgetId) async {
    await local.deleteBudget(budgetId);

    // TODO: Sync with API when API is implemented
    // await service.deleteBudget(budgetId);
  }
}

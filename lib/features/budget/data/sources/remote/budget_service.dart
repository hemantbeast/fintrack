import 'dart:convert';

import 'package:fintrack/core/utils/typedefs.dart';
import 'package:fintrack/features/budget/data/mock/mock_data.dart';
import 'package:fintrack/features/budget/data/models/budget_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final budgetServiceProvider = Provider<BudgetService>((ref) {
  return BudgetService(ref: ref);
});

class BudgetService {
  BudgetService({required this.ref});

  final Ref ref;

  /// Fetches budgets from API (currently mocked)
  Future<List<BudgetModel>> getBudgets() async {
    // Simulate API delay
    await Future<void>.delayed(const Duration(milliseconds: 250));

    final jsonList = json.decode(budgetsMockJson) as List<dynamic>;
    return jsonList.map((json) => BudgetModel.fromJson(json as JSON)).toList();
  }
}

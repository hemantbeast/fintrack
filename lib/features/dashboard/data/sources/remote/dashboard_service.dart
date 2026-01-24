import 'dart:convert';

import 'package:fintrack/core/utils/json_utils.dart';
import 'package:fintrack/core/utils/typedefs.dart';
import 'package:fintrack/features/dashboard/data/mock/mock_data.dart';
import 'package:fintrack/features/dashboard/data/models/balance_model.dart';
import 'package:fintrack/features/dashboard/data/models/budget_model.dart';
import 'package:fintrack/features/dashboard/data/models/transaction_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dashboardServiceProvider = Provider<DashboardService>((ref) {
  return DashboardService(ref: ref);
});

class DashboardService {
  DashboardService({required this.ref});

  final Ref ref;

  /// Fetches balance data from API
  Future<BalanceModel> getBalance() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return JsonUtils.parseJson(balanceMockJson, BalanceModel.fromJson);
  }

  /// Fetches transactions data from API
  Future<List<TransactionModel>> getTransactions() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final jsonList = json.decode(transactionsMockJson) as List<dynamic>;
    return jsonList.map((json) => TransactionModel.fromJson(json as JSON)).toList();
  }

  /// Fetches budgets data from API
  Future<List<BudgetModel>> getBudgets() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final jsonList = json.decode(budgetsMockJson) as List<dynamic>;
    return jsonList.map((json) => BudgetModel.fromJson(json as JSON)).toList();
  }
}

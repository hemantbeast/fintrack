import 'package:fintrack/features/dashboard/data/models/balance_model.dart';
import 'package:fintrack/features/dashboard/data/models/budget_model.dart';
import 'package:fintrack/features/dashboard/data/models/transaction_model.dart';
import 'package:fintrack/hive/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dashboardLocalProvider = Provider<DashboardLocal>((ref) {
  return DashboardLocal(ref: ref);
});

class DashboardLocal {
  DashboardLocal({required this.ref}) {
    _storage = ref.read(hiveStorageProvider);
  }

  final Ref ref;

  late HiveStorage _storage;

  /// Get local balance data
  Future<BalanceModel?> getBalance() async {
    final balance = await _storage.getItemByKey<BalanceModel>(HiveBoxes.balance);
    return balance;
  }

  /// Save balance data to local storage
  Future<void> saveBalance(BalanceModel balance) async {
    await _storage.saveItem<BalanceModel>(HiveBoxes.balance, balance);
  }

  /// Get local transactions data
  Future<List<TransactionModel>?> getTransactions() async {
    final transactions = await _storage.getAllItems<TransactionModel>(HiveBoxes.transactions);
    return transactions.isEmpty ? null : transactions;
  }

  /// Save transactions data to local storage
  Future<void> saveTransactions(List<TransactionModel> transactions) async {
    await _storage.saveAllItems<TransactionModel>(
      HiveBoxes.transactions,
      transactions,
      keyExtractor: (item) => item.id,
    );
  }

  /// Get local budgets data
  Future<List<BudgetModel>?> getBudgets() async {
    final budgets = await _storage.getAllItems<BudgetModel>(HiveBoxes.budgets);
    return budgets.isEmpty ? null : budgets;
  }

  /// Save budgets data to local storage
  Future<void> saveBudgets(List<BudgetModel> budgets) async {
    await _storage.saveAllItems<BudgetModel>(
      HiveBoxes.budgets,
      budgets,
      keyExtractor: (item) => item.id,
    );
  }
}

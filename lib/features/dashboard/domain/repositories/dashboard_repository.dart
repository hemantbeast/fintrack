import 'package:fintrack/features/dashboard/domain/entities/balance.dart';
import 'package:fintrack/features/dashboard/domain/entities/budget.dart';
import 'package:fintrack/features/dashboard/domain/entities/currency_rate.dart';
import 'package:fintrack/features/dashboard/domain/entities/transaction.dart';

abstract class DashboardRepository {
  /// Returns a stream of balance data (cache-first with background refresh)
  Stream<Balance> watchBalance();

  /// Returns a stream of transactions data (cache-first with background refresh)
  Stream<List<Transaction>> watchTransactions();

  /// Returns a stream of budgets data (cache-first with background refresh)
  Stream<List<Budget>> watchBudgets();

  /// Get currency rate
  CurrencyRate getCurrencyRate({required String from, required String to});
}

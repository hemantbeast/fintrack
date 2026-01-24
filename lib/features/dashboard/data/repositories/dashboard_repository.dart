import 'package:fintrack/features/dashboard/domain/entities/balance.dart';
import 'package:fintrack/features/dashboard/domain/entities/budget.dart';
import 'package:fintrack/features/dashboard/domain/entities/currency_rate.dart';
import 'package:fintrack/features/dashboard/domain/entities/transaction.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepository();
});

class DashboardRepository {
  // Mock Balance Data
  Balance getBalance() {
    return Balance(
      currentBalance: 5234.50,
      income: 6500,
      expenses: 1265.50,
    );
  }

  // Mock Recent Transactions
  List<Transaction> getRecentTransactions() {
    final now = DateTime.now();
    return [
      Transaction(
        id: '1',
        title: 'Lunch at Cafe',
        category: 'Food',
        amount: 25.50,
        date: now,
        type: TransactionType.expense,
        emoji: '🍔',
      ),
      Transaction(
        id: '2',
        title: 'Uber Ride',
        category: 'Transport',
        amount: 18,
        date: now.subtract(const Duration(days: 1)),
        type: TransactionType.expense,
        emoji: '🚕',
      ),
      Transaction(
        id: '3',
        title: 'Salary Deposit',
        category: 'Income',
        amount: 3500,
        date: now.subtract(const Duration(days: 1)),
        type: TransactionType.income,
        emoji: '💵',
      ),
      Transaction(
        id: '4',
        title: 'Grocery Shopping',
        category: 'Food',
        amount: 85.50,
        date: now.subtract(const Duration(days: 2)),
        type: TransactionType.expense,
        emoji: '🏪',
      ),
      Transaction(
        id: '5',
        title: 'Netflix Subscription',
        category: 'Entertainment',
        amount: 15.99,
        date: now.subtract(const Duration(days: 3)),
        type: TransactionType.expense,
        emoji: '🎮',
      ),
    ];
  }

  // Mock Budget Overview
  List<Budget> getBudgetOverview() {
    return [
      Budget(
        id: '1',
        category: 'Food',
        emoji: '🍔',
        spent: 450,
        limit: 600,
      ),
      Budget(
        id: '2',
        category: 'Transport',
        emoji: '🚗',
        spent: 240,
        limit: 400,
      ),
      Budget(
        id: '3',
        category: 'Entertainment',
        emoji: '🎮',
        spent: 135,
        limit: 300,
      ),
    ];
  }

  // Mock Currency Rate
  CurrencyRate getCurrencyRate({required String from, required String to}) {
    // Mock rates
    final rates = {
      'USD-EUR': 0.92,
      'USD-GBP': 0.79,
      'USD-JPY': 149.50,
      'EUR-USD': 1.09,
      'GBP-USD': 1.27,
    };

    return CurrencyRate(
      fromCurrency: from,
      toCurrency: to,
      rate: rates['$from-$to'] ?? 1.0,
    );
  }
}

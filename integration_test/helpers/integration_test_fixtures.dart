import 'dart:math';

import 'package:fintrack/features/budget/data/models/budget_model.dart';
import 'package:fintrack/features/dashboard/data/models/balance_model.dart';
import 'package:fintrack/features/dashboard/data/models/exchange_rate_model.dart';
import 'package:fintrack/features/dashboard/data/models/transaction_model.dart';
import 'package:fintrack/features/settings/data/models/user_preferences_model.dart';

/// Fixtures for integration tests
/// These provide realistic test data that spans multiple layers
class IntegrationTestFixtures {
  static final _random = Random(42); // Seeded for reproducibility

  // ==================== Balance Fixtures ====================

  static BalanceModel createBalanceModel({
    double? current,
    double? income,
    double? expenses,
  }) {
    return BalanceModel(
      current: current ?? 5000.0 + _random.nextDouble() * 1000,
      income: income ?? 8000.0 + _random.nextDouble() * 2000,
      expenses: expenses ?? 3000.0 + _random.nextDouble() * 1000,
    );
  }

  // ==================== Transaction Fixtures ====================

  static TransactionModel createTransactionModel({
    String? id,
    String? title,
    String? category,
    double? amount,
    DateTime? date,
    String? type,
  }) {
    final categories = [
      'Food',
      'Transport',
      'Shopping',
      'Entertainment',
      'Bills',
    ];
    final titles = [
      'Grocery Shopping',
      'Uber Ride',
      'Netflix Subscription',
      'Coffee',
      'Electric Bill',
    ];

    return TransactionModel(
      id: id ?? 'tx-${_random.nextInt(10000)}',
      title: title ?? titles[_random.nextInt(titles.length)],
      category: category ?? categories[_random.nextInt(categories.length)],
      amount: amount ?? (10.0 + _random.nextDouble() * 200),
      date:
          date ?? DateTime.now().subtract(Duration(days: _random.nextInt(30))),
      type: type ?? (_random.nextBool() ? 'expense' : 'income'),
      emoji: _getEmojiForCategory(
        category ?? categories[_random.nextInt(categories.length)],
      ),
      description: 'Test transaction description',
    );
  }

  static List<TransactionModel> createTransactionModelList(int count) {
    return List.generate(
      count,
      (index) => createTransactionModel(
        id: 'tx-${index + 1}',
      ),
    );
  }

  static String _getEmojiForCategory(String category) {
    final emojiMap = {
      'Food': '🍔',
      'Transport': '🚗',
      'Shopping': '🛍️',
      'Entertainment': '🎬',
      'Bills': '💡',
    };
    return emojiMap[category] ?? '💰';
  }

  // ==================== Budget Fixtures ====================

  static BudgetModel createBudgetModel({
    String? id,
    String? category,
    double? spent,
    double? limit,
  }) {
    final categories = ['Food', 'Transport', 'Shopping', 'Entertainment'];
    final categoryName =
        category ?? categories[_random.nextInt(categories.length)];
    final budgetLimit = limit ?? (500.0 + _random.nextDouble() * 500);

    return BudgetModel(
      id: id ?? 'budget-${_random.nextInt(10000)}',
      category: categoryName,
      emoji: _getEmojiForCategory(categoryName),
      spent: spent ?? (budgetLimit * (_random.nextDouble() * 0.8)),
      limit: budgetLimit,
    );
  }

  static List<BudgetModel> createBudgetModelList(int count) {
    final categories = [
      'Food',
      'Transport',
      'Shopping',
      'Entertainment',
      'Health',
      'Education',
    ];
    return List.generate(
      count,
      (index) => createBudgetModel(
        id: 'budget-${index + 1}',
        category: categories[index % categories.length],
      ),
    );
  }

  // ==================== Exchange Rate Fixtures ====================

  static ExchangeRateModel createExchangeRateModel({
    String? baseCode,
    Map<String, double>? conversionRates,
  }) {
    return ExchangeRateModel(
      result: 'success',
      baseCode: baseCode ?? 'INR',
      conversionRates:
          conversionRates ??
          {
            'USD': 0.012,
            'EUR': 0.011,
            'GBP': 0.0095,
            'JPY': 1.78,
            'AUD': 0.018,
          },
      timeLastUpdateUnix: DateTime.now().millisecondsSinceEpoch ~/ 1000,
    );
  }

  // ==================== User Preferences Fixtures ====================

  static UserPreferencesModel createUserPreferencesModel({
    String? currency,
    String? theme,
    bool? notificationsEnabled,
  }) {
    return UserPreferencesModel(
      currency: currency ?? 'INR',
      theme: theme ?? 'system',
      notificationsEnabled: notificationsEnabled ?? true,
      budgetAlertsEnabled: true,
      recurringExpenseAlertsEnabled: true,
      weeklySummaryEnabled: true,
    );
  }
}

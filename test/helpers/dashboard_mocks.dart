import 'package:fintrack/features/dashboard/data/models/balance_model.dart';
import 'package:fintrack/features/dashboard/data/models/exchange_rate_model.dart';
import 'package:fintrack/features/dashboard/data/models/transaction_model.dart';
import 'package:fintrack/features/dashboard/data/sources/local/dashboard_local.dart';
import 'package:fintrack/features/dashboard/data/sources/remote/dashboard_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mocks for Dashboard Service
class MockDashboardService extends Mock implements DashboardService {}

class MockDashboardLocal extends Mock implements DashboardLocal {}

// Test fixtures for Dashboard
class DashboardTestFixtures {
  static BalanceModel createBalanceModel({
    double current = 1000.0,
    double income = 5000.0,
    double expenses = 4000.0,
  }) {
    return BalanceModel(
      current: current,
      income: income,
      expenses: expenses,
    );
  }

  static TransactionModel createTransactionModel({
    String id = 'tx-123',
    String title = 'Test Transaction',
    String category = 'Food',
    double amount = 100.0,
    String description = 'Test',
    DateTime? date,
    String type = 'expense',
    String emoji = '🍔',
    bool isRecurring = false,
    String? frequency,
  }) {
    return TransactionModel(
      id: id,
      title: title,
      category: category,
      amount: amount,
      description: description,
      date: date ?? DateTime(2024, 1, 15),
      type: type,
      emoji: emoji,
      isRecurring: isRecurring,
      frequency: frequency,
    );
  }

  static List<TransactionModel> createTransactionModelList(int count) {
    return List.generate(
      count,
      (index) => createTransactionModel(
        id: 'tx-$index',
        title: 'Transaction $index',
        amount: (index + 1) * 100.0,
      ),
    );
  }

  static ExchangeRateModel createExchangeRateModel({
    String baseCurrency = 'INR',
    Map<String, dynamic>? rates,
  }) {
    return ExchangeRateModel(
      result: 'success',
      baseCode: baseCurrency,
      conversionRates:
          rates ??
          {
            'USD': 0.012,
            'EUR': 0.011,
            'GBP': 0.0095,
          },
      timeLastUpdateUnix: DateTime.now().millisecondsSinceEpoch ~/ 1000,
    );
  }
}

// Helper to verify mock calls
void verifyNeverSaveBalance(MockDashboardLocal local) {
  verifyNever(() => local.saveBalance(any()));
}

void verifySaveBalanceCalledOnce(MockDashboardLocal local, BalanceModel model) {
  verify(() => local.saveBalance(model)).called(1);
}

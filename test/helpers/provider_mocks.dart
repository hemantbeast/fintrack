import 'dart:async';

import 'package:fintrack/features/budget/domain/entities/budget.dart';
import 'package:fintrack/features/budget/domain/repositories/budget_repository.dart';
import 'package:fintrack/features/dashboard/domain/entities/balance.dart';
import 'package:fintrack/features/dashboard/domain/entities/exchange_rates.dart';
import 'package:fintrack/features/dashboard/domain/entities/transaction.dart';
import 'package:fintrack/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Repository mocks
class MockDashboardRepository extends Mock implements DashboardRepository {}

class MockBudgetRepository extends Mock implements BudgetRepository {}

// Provider test helpers
class ProviderTestFixtures {
  static Balance createBalance({
    double current = 1000.0,
    double income = 5000.0,
    double expenses = 4000.0,
  }) {
    return Balance(
      currentBalance: current,
      income: income,
      expenses: expenses,
    );
  }

  static Transaction createTransaction({
    String id = 'tx-123',
    String title = 'Test Transaction',
    String category = 'Food',
    double amount = 100.0,
    TransactionType type = TransactionType.expense,
  }) {
    return Transaction(
      id: id,
      title: title,
      category: category,
      amount: amount,
      description: 'Test description',
      date: DateTime(2024, 1, 15),
      type: type,
      emoji: '🍔',
    );
  }

  static List<Transaction> createTransactionList(int count) {
    return List.generate(
      count,
      (index) => createTransaction(
        id: 'tx-$index',
        title: 'Transaction $index',
        amount: (index + 1) * 100.0,
      ),
    );
  }

  static Budget createBudget({
    String id = 'budget-123',
    String category = 'Food',
    double spent = 300.0,
    double limit = 500.0,
  }) {
    return Budget(
      id: id,
      category: category,
      emoji: '🍔',
      spent: spent,
      limit: limit,
    );
  }

  static List<Budget> createBudgetList(int count) {
    return List.generate(
      count,
      (index) => createBudget(
        id: 'budget-$index',
        category: 'Category $index',
        spent: (index + 1) * 50.0,
        limit: (index + 1) * 100.0,
      ),
    );
  }

  static ExchangeRates createExchangeRates({
    String baseCurrency = 'INR',
    Map<String, double>? rates,
  }) {
    return ExchangeRates(
      baseCurrency: baseCurrency,
      rates:
          rates ??
          {
            'USD': 0.012,
            'EUR': 0.011,
            'GBP': 0.0095,
          },
      lastUpdated: DateTime.now(),
    );
  }
}

// Mock stream controller helper
class MockStreamHelper<T> {
  late StreamController<T> controller;

  MockStreamHelper() {
    controller = StreamController<T>.broadcast();
  }

  Stream<T> get stream => controller.stream;

  void emit(T value) => controller.add(value);

  void close() => controller.close();
}

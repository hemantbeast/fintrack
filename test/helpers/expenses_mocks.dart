import 'package:fintrack/features/expenses/data/models/category_model.dart';
import 'package:fintrack/features/dashboard/data/models/transaction_model.dart';
import 'package:fintrack/features/expenses/data/sources/local/expenses_local.dart';
import 'package:fintrack/features/expenses/data/sources/remote/expenses_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mocks for Expenses Service
class MockExpensesService extends Mock implements ExpensesService {}

class MockExpensesLocal extends Mock implements ExpensesLocal {}

// Test fixtures for Expenses
class ExpensesTestFixtures {
  static ExpenseCategoryModel createCategoryModel({
    String id = 'cat-123',
    String name = 'Food',
    String icon = '🍔',
    String color = '#FF5733',
  }) {
    return ExpenseCategoryModel(
      id: id,
      name: name,
      icon: icon,
      color: color,
    );
  }

  static List<ExpenseCategoryModel> createCategoryModelList(int count) {
    final categories = [
      {'name': 'Food', 'icon': '🍔', 'color': '#FF5733'},
      {'name': 'Transport', 'icon': '🚗', 'color': '#33FF57'},
      {'name': 'Shopping', 'icon': '🛍️', 'color': '#3357FF'},
      {'name': 'Entertainment', 'icon': '🎬', 'color': '#FF33F5'},
      {'name': 'Bills', 'icon': '💡', 'color': '#F5FF33'},
      {'name': 'Health', 'icon': '⚕️', 'color': '#33FFF5'},
      {'name': 'Education', 'icon': '📚', 'color': '#FF8033'},
      {'name': 'Travel', 'icon': '✈️', 'color': '#8033FF'},
    ];

    return List.generate(
      count,
      (index) => createCategoryModel(
        id: 'cat-$index',
        name: categories[index % categories.length]['name']!,
        icon: categories[index % categories.length]['icon']!,
        color: categories[index % categories.length]['color']!,
      ),
    );
  }

  static TransactionModel createTransactionModel({
    String id = 'tx-123',
    String title = 'Test Transaction',
    String category = 'Food',
    double amount = 100.0,
    String description = 'Test description',
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
        amount: (index + 1) * 50.0,
        category: index % 2 == 0 ? 'Food' : 'Transport',
        type: index % 3 == 0 ? 'income' : 'expense',
      ),
    );
  }

  static List<TransactionModel> createMixedTransactionList() {
    return [
      createTransactionModel(
        id: 'tx-income-1',
        title: 'Salary',
        amount: 5000.0,
        type: 'income',
        category: 'Income',
        emoji: '💰',
      ),
      createTransactionModel(
        id: 'tx-expense-1',
        title: 'Grocery Shopping',
        amount: 150.0,
        type: 'expense',
        category: 'Food',
        emoji: '🍔',
      ),
      createTransactionModel(
        id: 'tx-expense-2',
        title: 'Gas',
        amount: 50.0,
        type: 'expense',
        category: 'Transport',
        emoji: '🚗',
      ),
    ];
  }
}

// Helper verification functions
void verifyNeverSaveCategory(MockExpensesLocal local) {
  verifyNever(() => local.saveCategory(any()));
}

void verifyNeverSaveTransaction(MockExpensesLocal local) {
  verifyNever(() => local.saveTransaction(any()));
}

void verifySaveCategoryCalledOnce(
  MockExpensesLocal local,
  ExpenseCategoryModel model,
) {
  verify(() => local.saveCategory(model)).called(1);
}

void verifySaveTransactionCalledOnce(
  MockExpensesLocal local,
  TransactionModel model,
) {
  verify(() => local.saveTransaction(model)).called(1);
}

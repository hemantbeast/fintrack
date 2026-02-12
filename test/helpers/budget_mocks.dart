import 'package:fintrack/features/budget/data/models/budget_model.dart';
import 'package:fintrack/features/budget/data/sources/local/budget_local.dart';
import 'package:fintrack/features/budget/data/sources/remote/budget_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mocks for Budget
class MockBudgetService extends Mock implements BudgetService {}

class MockBudgetLocal extends Mock implements BudgetLocal {}

// Test fixtures for Budget
class BudgetTestFixtures {
  static BudgetModel createBudgetModel({
    String id = 'budget-123',
    String category = 'Food',
    String emoji = '🍔',
    double spent = 300.0,
    double limit = 500.0,
  }) {
    return BudgetModel(
      id: id,
      category: category,
      emoji: emoji,
      spent: spent,
      limit: limit,
    );
  }

  static List<BudgetModel> createBudgetModelList(int count) {
    final categories = [
      'Food',
      'Transport',
      'Entertainment',
      'Shopping',
      'Bills',
    ];
    final emojis = ['🍔', '🚌', '🎬', '🛍️', '💡'];

    return List.generate(
      count,
      (index) => createBudgetModel(
        id: 'budget-$index',
        category: categories[index % categories.length],
        emoji: emojis[index % emojis.length],
        spent: (index + 1) * 50.0,
        limit: (index + 1) * 100.0,
      ),
    );
  }
}

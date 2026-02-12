import 'package:fintrack/features/budget/data/models/budget_model.dart';
import 'package:fintrack/features/budget/domain/entities/budget.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BudgetModel', () {
    test('should create BudgetModel with all fields', () {
      // Arrange & Act
      final model = BudgetModel(
        id: 'budget-123',
        category: 'Food',
        emoji: '🍔',
        spent: 300,
        limit: 500,
      );

      // Assert
      expect(model.id, equals('budget-123'));
      expect(model.category, equals('Food'));
      expect(model.emoji, equals('🍔'));
      expect(model.spent, equals(300));
      expect(model.limit, equals(500));
    });

    test('should create BudgetModel with null fields', () {
      // Arrange & Act
      final model = BudgetModel();

      // Assert
      expect(model.id, isNull);
      expect(model.category, isNull);
      expect(model.emoji, isNull);
      expect(model.spent, isNull);
      expect(model.limit, isNull);
    });

    test('should convert from entity correctly', () {
      // Arrange
      final entity = Budget(
        id: 'budget-123',
        category: 'Food',
        emoji: '🍔',
        spent: 300,
        limit: 500,
      );

      // Act
      final model = BudgetModel.fromEntity(entity);

      // Assert
      expect(model.id, equals('budget-123'));
      expect(model.category, equals('Food'));
      expect(model.emoji, equals('🍔'));
      expect(model.spent, equals(300));
      expect(model.limit, equals(500));
    });

    test('should convert to entity correctly', () {
      // Arrange
      final model = BudgetModel(
        id: 'budget-123',
        category: 'Food',
        emoji: '🍔',
        spent: 300,
        limit: 500,
      );

      // Act
      final entity = model.toEntity();

      // Assert
      expect(entity.id, equals('budget-123'));
      expect(entity.category, equals('Food'));
      expect(entity.emoji, equals('🍔'));
      expect(entity.spent, equals(300));
      expect(entity.limit, equals(500));
    });

    test(
      'should handle null values when converting to entity by defaulting to empty/zero',
      () {
        // Arrange
        final model = BudgetModel();

        // Act
        final entity = model.toEntity();

        // Assert
        expect(entity.id, equals(''));
        expect(entity.category, equals(''));
        expect(entity.emoji, equals(''));
        expect(entity.spent, equals(0));
        expect(entity.limit, equals(0));
      },
    );

    test('should convert to and from JSON correctly', () {
      // Arrange
      final json = {
        'id': 'budget-123',
        'category': 'Food',
        'emoji': '🍔',
        'spent': 300,
        'limit': 500,
      };

      // Act
      final model = BudgetModel.fromJson(json);
      final resultJson = model.toJson();

      // Assert
      expect(model.id, equals('budget-123'));
      expect(resultJson['id'], equals('budget-123'));
      expect(resultJson['category'], equals('Food'));
      expect(resultJson['spent'], equals(300));
      expect(resultJson['limit'], equals(500));
    });

    test('should handle round-trip conversion: entity -> model -> entity', () {
      // Arrange
      final originalEntity = Budget(
        id: 'budget-123',
        category: 'Food',
        emoji: '🍔',
        spent: 300,
        limit: 500,
      );

      // Act
      final model = BudgetModel.fromEntity(originalEntity);
      final resultEntity = model.toEntity();

      // Assert
      expect(resultEntity.id, equals(originalEntity.id));
      expect(resultEntity.category, equals(originalEntity.category));
      expect(resultEntity.emoji, equals(originalEntity.emoji));
      expect(resultEntity.spent, equals(originalEntity.spent));
      expect(resultEntity.limit, equals(originalEntity.limit));
    });

    test('should handle zero values correctly', () {
      // Arrange & Act
      final model = BudgetModel(
        id: 'budget-123',
        category: 'Test',
        emoji: '🧪',
        spent: 0,
        limit: 0,
      );

      // Assert
      expect(model.spent, equals(0));
      expect(model.limit, equals(0));
    });

    test('should handle large values correctly', () {
      // Arrange & Act
      final model = BudgetModel(
        id: 'budget-123',
        category: 'Savings',
        emoji: '💰',
        spent: 10000,
        limit: 50000,
      );

      // Assert
      expect(model.spent, equals(10000));
      expect(model.limit, equals(50000));
    });

    test('should be mutable (fields can be changed)', () {
      // Arrange
      final model = BudgetModel(
        id: 'budget-123',
        category: 'Food',
        emoji: '🍔',
        spent: 300,
        limit: 500,
      );

      // Act
      model.spent = 400;
      model.limit = 600;

      // Assert
      expect(model.spent, equals(400));
      expect(model.limit, equals(600));
    });

    test(
      'entity percentage and remaining should work correctly after conversion',
      () {
        // Arrange
        final model = BudgetModel(
          id: 'budget-123',
          category: 'Food',
          emoji: '🍔',
          spent: 300,
          limit: 500,
        );

        // Act
        final entity = model.toEntity();

        // Assert
        expect(entity.percentage, equals(60));
        expect(entity.remaining, equals(200));
      },
    );
  });
}

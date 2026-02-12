import 'package:fintrack/features/budget/domain/entities/budget.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Budget Entity', () {
    test('should create a Budget instance with all required fields', () {
      // Arrange
      const id = 'budget-123';
      const category = 'Food';
      const emoji = '🍔';
      const spent = 300.0;
      const limit = 500.0;

      // Act
      final budget = Budget(
        id: id,
        category: category,
        emoji: emoji,
        spent: spent,
        limit: limit,
      );

      // Assert
      expect(budget.id, equals(id));
      expect(budget.category, equals(category));
      expect(budget.emoji, equals(emoji));
      expect(budget.spent, equals(spent));
      expect(budget.limit, equals(limit));
    });

    group('percentage getter', () {
      test('should calculate correct percentage when spent < limit', () {
        // Arrange
        final budget = Budget(
          id: '1',
          category: 'Food',
          emoji: '🍔',
          spent: 300.0,
          limit: 500.0,
        );

        // Assert
        expect(budget.percentage, equals(60.0));
      });

      test('should return 100 when spent equals limit', () {
        // Arrange
        final budget = Budget(
          id: '1',
          category: 'Food',
          emoji: '🍔',
          spent: 500.0,
          limit: 500.0,
        );

        // Assert
        expect(budget.percentage, equals(100.0));
      });

      test('should cap percentage at 100 when spent > limit', () {
        // Arrange
        final budget = Budget(
          id: '1',
          category: 'Food',
          emoji: '🍔',
          spent: 600.0,
          limit: 500.0,
        );

        // Assert
        expect(budget.percentage, equals(100.0));
      });

      test('should return 0 when spent is 0', () {
        // Arrange
        final budget = Budget(
          id: '1',
          category: 'Food',
          emoji: '🍔',
          spent: 0.0,
          limit: 500.0,
        );

        // Assert
        expect(budget.percentage, equals(0.0));
      });
    });

    group('remaining getter', () {
      test('should calculate correct remaining when spent < limit', () {
        // Arrange
        final budget = Budget(
          id: '1',
          category: 'Food',
          emoji: '🍔',
          spent: 300.0,
          limit: 500.0,
        );

        // Assert
        expect(budget.remaining, equals(200.0));
      });

      test('should return 0 when spent equals limit', () {
        // Arrange
        final budget = Budget(
          id: '1',
          category: 'Food',
          emoji: '🍔',
          spent: 500.0,
          limit: 500.0,
        );

        // Assert
        expect(budget.remaining, equals(0.0));
      });

      test('should cap remaining at 0 when spent > limit', () {
        // Arrange
        final budget = Budget(
          id: '1',
          category: 'Food',
          emoji: '🍔',
          spent: 600.0,
          limit: 500.0,
        );

        // Assert
        expect(budget.remaining, equals(0.0));
      });

      test('should return full limit when spent is 0', () {
        // Arrange
        final budget = Budget(
          id: '1',
          category: 'Food',
          emoji: '🍔',
          spent: 0.0,
          limit: 500.0,
        );

        // Assert
        expect(budget.remaining, equals(500.0));
      });
    });

    test('should handle zero limit correctly', () {
      // Arrange
      final budget = Budget(
        id: '1',
        category: 'Food',
        emoji: '🍔',
        spent: 0.0,
        limit: 0.0,
      );

      // Assert
      // When limit is 0, percentage is clamped to 100 (division by zero results in infinity)
      expect(budget.percentage, equals(100.0));
      expect(budget.remaining, equals(0.0));
    });

    test('should handle empty string fields correctly', () {
      // Arrange
      final budget = Budget(
        id: '',
        category: '',
        emoji: '',
        spent: 0.0,
        limit: 100.0,
      );

      // Assert
      expect(budget.id, equals(''));
      expect(budget.category, equals(''));
      expect(budget.emoji, equals(''));
    });
  });
}

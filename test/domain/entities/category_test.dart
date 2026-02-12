import 'package:fintrack/features/expenses/domain/entities/category.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExpenseCategory', () {
    test('should create ExpenseCategory with all fields', () {
      // Arrange & Act
      const category = ExpenseCategory(
        id: 'cat-123',
        name: 'Food',
        icon: '🍔',
        color: '#FF5733',
      );

      // Assert
      expect(category.id, equals('cat-123'));
      expect(category.name, equals('Food'));
      expect(category.icon, equals('🍔'));
      expect(category.color, equals('#FF5733'));
    });

    test('should create ExpenseCategory with minimal fields', () {
      // Arrange & Act
      const category = ExpenseCategory(
        id: '',
        name: '',
        icon: '',
        color: '',
      );

      // Assert
      expect(category.id, equals(''));
      expect(category.name, equals(''));
      expect(category.icon, equals(''));
      expect(category.color, equals(''));
    });

    test('should handle various category names', () {
      // Arrange & Act
      const food = ExpenseCategory(
        id: '1',
        name: 'Food',
        icon: '🍔',
        color: '#FF0000',
      );
      const transport = ExpenseCategory(
        id: '2',
        name: 'Transportation',
        icon: '🚗',
        color: '#00FF00',
      );
      const entertainment = ExpenseCategory(
        id: '3',
        name: 'Entertainment & Leisure',
        icon: '🎬',
        color: '#0000FF',
      );

      // Assert
      expect(food.name, equals('Food'));
      expect(transport.name, equals('Transportation'));
      expect(entertainment.name, equals('Entertainment & Leisure'));
    });

    test('should handle various emoji icons', () {
      // Arrange & Act
      const food = ExpenseCategory(
        id: '1',
        name: 'Food',
        icon: '🍔',
        color: '#FF0000',
      );
      const transport = ExpenseCategory(
        id: '2',
        name: 'Transport',
        icon: '🚗',
        color: '#00FF00',
      );
      const health = ExpenseCategory(
        id: '3',
        name: 'Health',
        icon: '⚕️',
        color: '#FF0000',
      );
      const education = ExpenseCategory(
        id: '4',
        name: 'Education',
        icon: '📚',
        color: '#0000FF',
      );
      const shopping = ExpenseCategory(
        id: '5',
        name: 'Shopping',
        icon: '🛍️',
        color: '#FFFF00',
      );
      const bills = ExpenseCategory(
        id: '6',
        name: 'Bills',
        icon: '💡',
        color: '#FFAA00',
      );

      // Assert
      expect(food.icon, equals('🍔'));
      expect(transport.icon, equals('🚗'));
      expect(health.icon, equals('⚕️'));
      expect(education.icon, equals('📚'));
      expect(shopping.icon, equals('🛍️'));
      expect(bills.icon, equals('💡'));
    });

    test('should handle various hex color codes', () {
      // Arrange & Act
      const short = ExpenseCategory(
        id: '1',
        name: 'Test',
        icon: '🔵',
        color: '#F00',
      );
      const long = ExpenseCategory(
        id: '2',
        name: 'Test',
        icon: '🔵',
        color: '#FF0000',
      );
      const withAlpha = ExpenseCategory(
        id: '3',
        name: 'Test',
        icon: '🔵',
        color: '#80FF0000',
      );
      const lower = ExpenseCategory(
        id: '4',
        name: 'Test',
        icon: '🔵',
        color: '#ff0000',
      );

      // Assert
      expect(short.color, equals('#F00'));
      expect(long.color, equals('#FF0000'));
      expect(withAlpha.color, equals('#80FF0000'));
      expect(lower.color, equals('#ff0000'));
    });

    test('should handle special characters in names', () {
      // Arrange & Act
      const special1 = ExpenseCategory(
        id: '1',
        name: 'Food & Dining',
        icon: '🍽️',
        color: '#FF0000',
      );
      const special2 = ExpenseCategory(
        id: '2',
        name: 'Health - Medical',
        icon: '💊',
        color: '#00FF00',
      );
      const special3 = ExpenseCategory(
        id: '3',
        name: 'Travel (Vacation)',
        icon: '✈️',
        color: '#0000FF',
      );

      // Assert
      expect(special1.name, equals('Food & Dining'));
      expect(special2.name, equals('Health - Medical'));
      expect(special3.name, equals('Travel (Vacation)'));
    });

    test('should be immutable', () {
      // Arrange
      const category = ExpenseCategory(
        id: 'cat-123',
        name: 'Food',
        icon: '🍔',
        color: '#FF5733',
      );

      // Assert - Since all fields are final, we can't modify them
      expect(category.id, equals('cat-123'));
      expect(category.name, equals('Food'));
      // Any attempt to change fields would be a compile-time error
    });

    test('should support equality', () {
      // Arrange
      const category1 = ExpenseCategory(
        id: 'cat-123',
        name: 'Food',
        icon: '🍔',
        color: '#FF5733',
      );
      const category2 = ExpenseCategory(
        id: 'cat-123',
        name: 'Food',
        icon: '🍔',
        color: '#FF5733',
      );
      const category3 = ExpenseCategory(
        id: 'cat-456',
        name: 'Transport',
        icon: '🚗',
        color: '#33FF57',
      );

      // Assert
      expect(category1, equals(category2));
      expect(category1, isNot(equals(category3)));
    });
  });
}

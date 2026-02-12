import 'package:fintrack/features/expenses/data/models/category_model.dart';
import 'package:fintrack/features/expenses/domain/entities/category.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExpenseCategoryModel', () {
    test('should create ExpenseCategoryModel with all fields', () {
      // Arrange & Act
      final model = ExpenseCategoryModel(
        id: 'cat-123',
        name: 'Food',
        icon: '🍔',
        color: '#FF5733',
      );

      // Assert
      expect(model.id, equals('cat-123'));
      expect(model.name, equals('Food'));
      expect(model.icon, equals('🍔'));
      expect(model.color, equals('#FF5733'));
    });

    test('should create ExpenseCategoryModel with null fields', () {
      // Arrange & Act
      final model = ExpenseCategoryModel();

      // Assert
      expect(model.id, isNull);
      expect(model.name, isNull);
      expect(model.icon, isNull);
      expect(model.color, isNull);
    });

    test('fromEntity should create model from ExpenseCategory', () {
      // Arrange
      const entity = ExpenseCategory(
        id: 'cat-456',
        name: 'Transport',
        icon: '🚗',
        color: '#33FF57',
      );

      // Act
      final model = ExpenseCategoryModel.fromEntity(entity);

      // Assert
      expect(model.id, equals('cat-456'));
      expect(model.name, equals('Transport'));
      expect(model.icon, equals('🚗'));
      expect(model.color, equals('#33FF57'));
    });

    test('toEntity should convert to ExpenseCategory with defaults', () {
      // Arrange
      final model = ExpenseCategoryModel(
        id: 'cat-789',
        name: 'Shopping',
        icon: '🛍️',
        color: '#3357FF',
      );

      // Act
      final entity = model.toEntity();

      // Assert
      expect(entity.id, equals('cat-789'));
      expect(entity.name, equals('Shopping'));
      expect(entity.icon, equals('🛍️'));
      expect(entity.color, equals('#3357FF'));
    });

    test('toEntity should use empty strings for null values', () {
      // Arrange
      final model = ExpenseCategoryModel();

      // Act
      final entity = model.toEntity();

      // Assert
      expect(entity.id, equals(''));
      expect(entity.name, equals(''));
      expect(entity.icon, equals(''));
      expect(entity.color, equals(''));
    });

    test('round-trip conversion should preserve data', () {
      // Arrange
      const original = ExpenseCategory(
        id: 'cat-999',
        name: 'Entertainment',
        icon: '🎬',
        color: '#FF33F5',
      );

      // Act
      final model = ExpenseCategoryModel.fromEntity(original);
      final result = model.toEntity();

      // Assert
      expect(result.id, equals(original.id));
      expect(result.name, equals(original.name));
      expect(result.icon, equals(original.icon));
      expect(result.color, equals(original.color));
    });

    test('toJson should serialize correctly', () {
      // Arrange
      final model = ExpenseCategoryModel(
        id: 'cat-123',
        name: 'Bills',
        icon: '💡',
        color: '#F5FF33',
      );

      // Act
      final json = model.toJson();

      // Assert
      expect(json['id'], equals('cat-123'));
      expect(json['name'], equals('Bills'));
      expect(json['icon'], equals('💡'));
      expect(json['color'], equals('#F5FF33'));
    });

    test('should handle various emoji icons', () {
      // Arrange & Act
      final food = ExpenseCategoryModel(
        id: '1',
        name: 'Food',
        icon: '🍔',
        color: '#FF0000',
      );
      final transport = ExpenseCategoryModel(
        id: '2',
        name: 'Transport',
        icon: '🚗',
        color: '#00FF00',
      );
      final health = ExpenseCategoryModel(
        id: '3',
        name: 'Health',
        icon: '⚕️',
        color: '#0000FF',
      );
      final education = ExpenseCategoryModel(
        id: '4',
        name: 'Education',
        icon: '📚',
        color: '#FFFF00',
      );

      // Assert
      expect(food.icon, equals('🍔'));
      expect(transport.icon, equals('🚗'));
      expect(health.icon, equals('⚕️'));
      expect(education.icon, equals('📚'));
    });

    test('should handle hex color codes', () {
      // Arrange & Act
      final shortHex = ExpenseCategoryModel(
        id: '1',
        name: 'Test',
        icon: '🔵',
        color: '#F00',
      );
      final longHex = ExpenseCategoryModel(
        id: '2',
        name: 'Test',
        icon: '🔵',
        color: '#FF0000',
      );
      final withAlpha = ExpenseCategoryModel(
        id: '3',
        name: 'Test',
        icon: '🔵',
        color: '#80FF0000',
      );

      // Assert
      expect(shortHex.color, equals('#F00'));
      expect(longHex.color, equals('#FF0000'));
      expect(withAlpha.color, equals('#80FF0000'));
    });
  });
}

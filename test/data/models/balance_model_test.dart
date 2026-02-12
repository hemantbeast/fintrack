import 'package:fintrack/features/dashboard/data/models/balance_model.dart';
import 'package:fintrack/features/dashboard/domain/entities/balance.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BalanceModel', () {
    test('should create BalanceModel with all fields', () {
      // Arrange & Act
      final model = BalanceModel(
        current: 1000,
        income: 5000,
        expenses: 4000,
      );

      // Assert
      expect(model.current, equals(1000));
      expect(model.income, equals(5000));
      expect(model.expenses, equals(4000));
    });

    test('should create BalanceModel with null fields', () {
      // Arrange & Act
      final model = BalanceModel();

      // Assert
      expect(model.current, isNull);
      expect(model.income, isNull);
      expect(model.expenses, isNull);
    });

    test('should convert from entity correctly', () {
      // Arrange
      final entity = Balance(
        currentBalance: 1000,
        income: 5000,
        expenses: 4000,
      );

      // Act
      final model = BalanceModel.fromEntity(entity);

      // Assert
      expect(model.current, equals(1000));
      expect(model.income, equals(5000));
      expect(model.expenses, equals(4000));
    });

    test('should convert to entity correctly', () {
      // Arrange
      final model = BalanceModel(
        current: 1000,
        income: 5000,
        expenses: 4000,
      );

      // Act
      final entity = model.toEntity();

      // Assert
      expect(entity.currentBalance, equals(1000));
      expect(entity.income, equals(5000));
      expect(entity.expenses, equals(4000));
    });

    test(
      'should handle null values when converting to entity by defaulting to 0',
      () {
        // Arrange
        final model = BalanceModel();

        // Act
        final entity = model.toEntity();

        // Assert
        expect(entity.currentBalance, equals(0));
        expect(entity.income, equals(0));
        expect(entity.expenses, equals(0));
      },
    );

    test('should convert to and from JSON correctly', () {
      // Arrange
      final json = {
        'current': 1000,
        'income': 5000,
        'expenses': 4000,
      };

      // Act
      final model = BalanceModel.fromJson(json);
      final resultJson = model.toJson();

      // Assert
      expect(model.current, equals(1000));
      expect(model.income, equals(5000));
      expect(model.expenses, equals(4000));
      expect(resultJson['current'], equals(1000));
      expect(resultJson['income'], equals(5000));
      expect(resultJson['expenses'], equals(4000));
    });

    test('should handle round-trip conversion: entity -> model -> entity', () {
      // Arrange
      final originalEntity = Balance(
        currentBalance: 1000,
        income: 5000,
        expenses: 4000,
      );

      // Act
      final model = BalanceModel.fromEntity(originalEntity);
      final resultEntity = model.toEntity();

      // Assert
      expect(
        resultEntity.currentBalance,
        equals(originalEntity.currentBalance),
      );
      expect(resultEntity.income, equals(originalEntity.income));
      expect(resultEntity.expenses, equals(originalEntity.expenses));
    });

    test('should handle zero values correctly', () {
      // Arrange & Act
      final model = BalanceModel(
        current: 0,
        income: 0,
        expenses: 0,
      );

      // Assert
      expect(model.current, equals(0));
      expect(model.income, equals(0));
      expect(model.expenses, equals(0));
    });

    test('should handle negative values correctly', () {
      // Arrange & Act
      final model = BalanceModel(
        current: -1000,
        income: 0,
        expenses: 5000,
      );

      // Assert
      expect(model.current, equals(-1000));
      expect(model.income, equals(0));
      expect(model.expenses, equals(5000));
    });

    test('should handle large values correctly', () {
      // Arrange & Act
      final model = BalanceModel(
        current: 1000000,
        income: 5000000,
        expenses: 4000000,
      );

      // Assert
      expect(model.current, equals(1000000));
      expect(model.income, equals(5000000));
      expect(model.expenses, equals(4000000));
    });

    test('should be mutable (fields can be changed)', () {
      // Arrange
      final model = BalanceModel(
        current: 1000,
        income: 5000,
        expenses: 4000,
      );

      // Act
      model.current = 2000;
      model.income = 6000;
      model.expenses = 4000;

      // Assert
      expect(model.current, equals(2000));
      expect(model.income, equals(6000));
      expect(model.expenses, equals(4000));
    });
  });
}

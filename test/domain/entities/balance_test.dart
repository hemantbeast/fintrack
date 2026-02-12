import 'package:fintrack/features/dashboard/domain/entities/balance.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Balance Entity', () {
    test('should create a Balance instance with all required fields', () {
      // Arrange
      const currentBalance = 1000.0;
      const income = 5000.0;
      const expenses = 4000.0;

      // Act
      final balance = Balance(
        currentBalance: currentBalance,
        income: income,
        expenses: expenses,
      );

      // Assert
      expect(balance.currentBalance, equals(currentBalance));
      expect(balance.income, equals(income));
      expect(balance.expenses, equals(expenses));
    });

    test('should handle zero values correctly', () {
      // Act
      final balance = Balance(
        currentBalance: 0,
        income: 0,
        expenses: 0,
      );

      // Assert
      expect(balance.currentBalance, equals(0));
      expect(balance.income, equals(0));
      expect(balance.expenses, equals(0));
    });

    test('should handle negative values correctly', () {
      // Arrange
      const currentBalance = -1000.0;
      const income = 0.0;
      const expenses = 5000.0;

      // Act
      final balance = Balance(
        currentBalance: currentBalance,
        income: income,
        expenses: expenses,
      );

      // Assert
      expect(balance.currentBalance, equals(currentBalance));
      expect(balance.income, equals(income));
      expect(balance.expenses, equals(expenses));
    });

    test('should handle large values correctly', () {
      // Arrange
      const currentBalance = 1000000.0;
      const income = 5000000.0;
      const expenses = 4000000.0;

      // Act
      final balance = Balance(
        currentBalance: currentBalance,
        income: income,
        expenses: expenses,
      );

      // Assert
      expect(balance.currentBalance, equals(currentBalance));
      expect(balance.income, equals(income));
      expect(balance.expenses, equals(expenses));
    });

    test(
      'should calculate balance correctly: income - expenses = currentBalance',
      () {
        // Arrange
        const income = 5000.0;
        const expenses = 4000.0;
        const expectedBalance = 1000.0;

        // Act
        final balance = Balance(
          currentBalance: expectedBalance,
          income: income,
          expenses: expenses,
        );

        // Assert
        expect(balance.currentBalance, equals(income - expenses));
      },
    );

    test('should be equal when all values are equal', () {
      // Arrange & Act
      final balance1 = Balance(
        currentBalance: 1000,
        income: 5000,
        expenses: 4000,
      );
      final balance2 = Balance(
        currentBalance: 1000,
        income: 5000,
        expenses: 4000,
      );

      // Assert
      expect(balance1.currentBalance, equals(balance2.currentBalance));
      expect(balance1.income, equals(balance2.income));
      expect(balance1.expenses, equals(balance2.expenses));
    });
  });
}

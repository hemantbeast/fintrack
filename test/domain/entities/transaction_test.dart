import 'package:fintrack/features/dashboard/domain/entities/transaction.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Transaction Entity', () {
    test('should create a Transaction instance with all required fields', () {
      // Arrange
      const id = 'tx-123';
      const title = 'Salary';
      const category = 'Income';
      const amount = 5000.0;
      const description = 'Monthly salary';
      final date = DateTime(2024, 1, 15);
      const type = TransactionType.income;
      const emoji = '💰';

      // Act
      final transaction = Transaction(
        id: id,
        title: title,
        category: category,
        amount: amount,
        description: description,
        date: date,
        type: type,
        emoji: emoji,
      );

      // Assert
      expect(transaction.id, equals(id));
      expect(transaction.title, equals(title));
      expect(transaction.category, equals(category));
      expect(transaction.amount, equals(amount));
      expect(transaction.description, equals(description));
      expect(transaction.date, equals(date));
      expect(transaction.type, equals(type));
      expect(transaction.emoji, equals(emoji));
      expect(transaction.isRecurring, isFalse);
      expect(transaction.frequency, isNull);
    });

    test('should create a recurring transaction with frequency', () {
      // Arrange
      final date = DateTime(2024, 1, 15);

      // Act
      final transaction = Transaction(
        id: 'tx-124',
        title: 'Rent',
        category: 'Housing',
        amount: 1000.0,
        description: 'Monthly rent',
        date: date,
        type: TransactionType.expense,
        emoji: '🏠',
        isRecurring: true,
        frequency: 'monthly',
      );

      // Assert
      expect(transaction.isRecurring, isTrue);
      expect(transaction.frequency, equals('monthly'));
    });

    test('should handle expense transaction type correctly', () {
      // Act
      final transaction = Transaction(
        id: 'tx-125',
        title: 'Groceries',
        category: 'Food',
        amount: 150.0,
        description: 'Weekly groceries',
        date: DateTime(2024, 1, 15),
        type: TransactionType.expense,
        emoji: '🛒',
      );

      // Assert
      expect(transaction.type, equals(TransactionType.expense));
    });

    test('should handle zero amount correctly', () {
      // Act
      final transaction = Transaction(
        id: 'tx-126',
        title: 'Test',
        category: 'Test',
        amount: 0.0,
        description: 'Test transaction',
        date: DateTime(2024, 1, 15),
        type: TransactionType.expense,
        emoji: '🧪',
      );

      // Assert
      expect(transaction.amount, equals(0.0));
    });

    test('should handle negative amount correctly', () {
      // Act
      final transaction = Transaction(
        id: 'tx-127',
        title: 'Refund',
        category: 'Other',
        amount: -50.0,
        description: 'Refund received',
        date: DateTime(2024, 1, 15),
        type: TransactionType.income,
        emoji: '↩️',
      );

      // Assert
      expect(transaction.amount, equals(-50.0));
    });

    test('should handle empty string fields correctly', () {
      // Act
      final transaction = Transaction(
        id: '',
        title: '',
        category: '',
        amount: 0.0,
        description: '',
        date: DateTime(2024, 1, 15),
        type: TransactionType.expense,
        emoji: '',
      );

      // Assert
      expect(transaction.id, equals(''));
      expect(transaction.title, equals(''));
      expect(transaction.category, equals(''));
      expect(transaction.description, equals(''));
      expect(transaction.emoji, equals(''));
    });
  });

  group('TransactionType enum', () {
    test('should have income and expense values', () {
      // Assert
      expect(TransactionType.values.length, equals(2));
      expect(TransactionType.values, contains(TransactionType.income));
      expect(TransactionType.values, contains(TransactionType.expense));
    });

    test('should distinguish between income and expense', () {
      // Assert
      expect(TransactionType.income, isNot(equals(TransactionType.expense)));
    });
  });
}

import 'package:fintrack/features/dashboard/data/models/transaction_model.dart';
import 'package:fintrack/features/dashboard/domain/entities/transaction.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TransactionModel', () {
    test('should create TransactionModel with all fields', () {
      // Arrange & Act
      final model = TransactionModel(
        id: 'tx-123',
        title: 'Salary',
        category: 'Income',
        amount: 5000,
        description: 'Monthly salary',
        date: DateTime(2024, 1, 15),
        type: 'income',
        emoji: '💰',
        isRecurring: true,
        frequency: 'monthly',
      );

      // Assert
      expect(model.id, equals('tx-123'));
      expect(model.title, equals('Salary'));
      expect(model.category, equals('Income'));
      expect(model.amount, equals(5000));
      expect(model.description, equals('Monthly salary'));
      expect(model.date, equals(DateTime(2024, 1, 15)));
      expect(model.type, equals('income'));
      expect(model.emoji, equals('💰'));
      expect(model.isRecurring, isTrue);
      expect(model.frequency, equals('monthly'));
    });

    test('should create TransactionModel with null fields', () {
      // Arrange & Act
      final model = TransactionModel();

      // Assert
      expect(model.id, isNull);
      expect(model.title, isNull);
      expect(model.category, isNull);
      expect(model.amount, isNull);
      expect(model.description, isNull);
      expect(model.date, isNull);
      expect(model.type, isNull);
      expect(model.emoji, isNull);
      expect(model.isRecurring, isNull);
      expect(model.frequency, isNull);
    });

    test('should convert from entity correctly for income', () {
      // Arrange
      final entity = Transaction(
        id: 'tx-123',
        title: 'Salary',
        category: 'Income',
        amount: 5000,
        description: 'Monthly salary',
        date: DateTime(2024, 1, 15),
        type: TransactionType.income,
        emoji: '💰',
        isRecurring: true,
        frequency: 'monthly',
      );

      // Act
      final model = TransactionModel.fromEntity(entity);

      // Assert
      expect(model.id, equals('tx-123'));
      expect(model.title, equals('Salary'));
      expect(model.category, equals('Income'));
      expect(model.amount, equals(5000));
      expect(model.description, equals('Monthly salary'));
      expect(model.date, equals(DateTime(2024, 1, 15)));
      expect(model.type, equals('income'));
      expect(model.emoji, equals('💰'));
      expect(model.isRecurring, isTrue);
      expect(model.frequency, equals('monthly'));
    });

    test('should convert from entity correctly for expense', () {
      // Arrange
      final entity = Transaction(
        id: 'tx-124',
        title: 'Groceries',
        category: 'Food',
        amount: 150,
        description: 'Weekly groceries',
        date: DateTime(2024, 1, 15),
        type: TransactionType.expense,
        emoji: '🛒',
      );

      // Act
      final model = TransactionModel.fromEntity(entity);

      // Assert
      expect(model.type, equals('expense'));
      expect(model.isRecurring, isFalse);
      expect(model.frequency, isNull);
    });

    test('should convert to entity correctly for income', () {
      // Arrange
      final model = TransactionModel(
        id: 'tx-123',
        title: 'Salary',
        category: 'Income',
        amount: 5000,
        description: 'Monthly salary',
        date: DateTime(2024, 1, 15),
        type: 'income',
        emoji: '💰',
        isRecurring: true,
        frequency: 'monthly',
      );

      // Act
      final entity = model.toEntity();

      // Assert
      expect(entity.id, equals('tx-123'));
      expect(entity.title, equals('Salary'));
      expect(entity.category, equals('Income'));
      expect(entity.amount, equals(5000));
      expect(entity.description, equals('Monthly salary'));
      expect(entity.date, equals(DateTime(2024, 1, 15)));
      expect(entity.type, equals(TransactionType.income));
      expect(entity.emoji, equals('💰'));
      expect(entity.isRecurring, isTrue);
      expect(entity.frequency, equals('monthly'));
    });

    test('should convert to entity correctly for expense', () {
      // Arrange
      final model = TransactionModel(
        id: 'tx-124',
        title: 'Groceries',
        category: 'Food',
        amount: 150,
        description: 'Weekly groceries',
        date: DateTime(2024, 1, 15),
        type: 'expense',
        emoji: '🛒',
        isRecurring: false,
      );

      // Act
      final entity = model.toEntity();

      // Assert
      expect(entity.type, equals(TransactionType.expense));
      expect(entity.isRecurring, isFalse);
    });

    test(
      'should handle null values when converting to entity by defaulting to empty/zero',
      () {
        // Arrange
        final model = TransactionModel();

        // Act
        final entity = model.toEntity();

        // Assert
        expect(entity.id, equals(''));
        expect(entity.title, equals(''));
        expect(entity.category, equals(''));
        expect(entity.amount, equals(0));
        expect(entity.description, equals(''));
        expect(entity.date, equals(DateTime(1970)));
        expect(entity.type, equals(TransactionType.expense));
        expect(entity.emoji, equals(''));
        expect(entity.isRecurring, isFalse);
        expect(entity.frequency, isNull);
      },
    );

    test('should convert to and from JSON correctly', () {
      // Arrange
      final json = {
        'id': 'tx-123',
        'title': 'Salary',
        'category': 'Income',
        'amount': 5000,
        'description': 'Monthly salary',
        'date': '2024-01-15T00:00:00.000',
        'type': 'income',
        'emoji': '💰',
        'is_recurring': true,
        'frequency': 'monthly',
      };

      // Act
      final model = TransactionModel.fromJson(json);
      final resultJson = model.toJson();

      // Assert
      expect(model.id, equals('tx-123'));
      expect(resultJson['id'], equals('tx-123'));
      expect(resultJson['title'], equals('Salary'));
      expect(resultJson['type'], equals('income'));
    });

    test('should handle round-trip conversion: entity -> model -> entity', () {
      // Arrange
      final originalEntity = Transaction(
        id: 'tx-123',
        title: 'Salary',
        category: 'Income',
        amount: 5000,
        description: 'Monthly salary',
        date: DateTime(2024, 1, 15),
        type: TransactionType.income,
        emoji: '💰',
        isRecurring: true,
        frequency: 'monthly',
      );

      // Act
      final model = TransactionModel.fromEntity(originalEntity);
      final resultEntity = model.toEntity();

      // Assert
      expect(resultEntity.id, equals(originalEntity.id));
      expect(resultEntity.title, equals(originalEntity.title));
      expect(resultEntity.type, equals(originalEntity.type));
      expect(resultEntity.isRecurring, equals(originalEntity.isRecurring));
    });

    group('typeEnum getter', () {
      test('should return income when type is income', () {
        // Arrange
        final model = TransactionModel(type: 'income');

        // Assert
        expect(model.typeEnum, equals(TransactionType.income));
      });

      test('should return expense when type is expense', () {
        // Arrange
        final model = TransactionModel(type: 'expense');

        // Assert
        expect(model.typeEnum, equals(TransactionType.expense));
      });

      test('should return expense when type is null', () {
        // Arrange
        final model = TransactionModel();

        // Assert
        expect(model.typeEnum, equals(TransactionType.expense));
      });

      test('should return expense when type is empty', () {
        // Arrange
        final model = TransactionModel(type: '');

        // Assert
        expect(model.typeEnum, equals(TransactionType.expense));
      });
    });
  });
}

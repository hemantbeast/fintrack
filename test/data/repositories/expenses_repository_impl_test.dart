import 'package:fintrack/features/dashboard/data/models/transaction_model.dart';
import 'package:fintrack/features/dashboard/domain/entities/transaction.dart';
import 'package:fintrack/features/expenses/data/models/category_model.dart';
import 'package:fintrack/features/expenses/data/repositories/expenses_repository_impl.dart';
import 'package:fintrack/features/expenses/domain/entities/category.dart';
import 'package:fintrack/features/expenses/domain/repositories/expenses_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/expenses_mocks.dart';

class FakeExpenseCategoryModel extends Fake implements ExpenseCategoryModel {}

class FakeTransactionModel extends Fake implements TransactionModel {}

void main() {
  late ExpensesRepository repository;
  late MockExpensesService mockService;
  late MockExpensesLocal mockLocal;

  setUpAll(() {
    registerFallbackValue(FakeExpenseCategoryModel());
    registerFallbackValue(FakeTransactionModel());
  });

  setUp(() {
    mockService = MockExpensesService();
    mockLocal = MockExpensesLocal();
    repository = ExpensesRepositoryImpl(
      service: mockService,
      local: mockLocal,
    );
  });

  group('ExpensesRepositoryImpl', () {
    group('watchCategories', () {
      test(
        'should emit cached categories immediately when available',
        () async {
          // Arrange
          final cachedCategories = ExpensesTestFixtures.createCategoryModelList(
            3,
          );
          when(
            () => mockLocal.getCategories(),
          ).thenAnswer((_) async => cachedCategories);
          when(
            () => mockService.getCategories(),
          ).thenAnswer((_) async => cachedCategories);
          when(() => mockLocal.saveCategories(any())).thenAnswer((_) async {});

          // Act
          final stream = repository.watchCategories();
          final results = await stream.take(2).toList();

          // Assert
          expect(results.length, greaterThanOrEqualTo(1));
          expect(results.first.length, equals(3));
          verify(() => mockLocal.getCategories()).called(1);
        },
      );

      test(
        'should emit fresh categories after fetching from service',
        () async {
          // Arrange
          final cachedCategories = ExpensesTestFixtures.createCategoryModelList(
            2,
          );
          final freshCategories = ExpensesTestFixtures.createCategoryModelList(
            5,
          );

          when(
            () => mockLocal.getCategories(),
          ).thenAnswer((_) async => cachedCategories);
          when(
            () => mockService.getCategories(),
          ).thenAnswer((_) async => freshCategories);
          when(() => mockLocal.saveCategories(any())).thenAnswer((_) async {});

          // Act
          final stream = repository.watchCategories();
          final results = await stream.take(2).toList();

          // Assert
          expect(results.length, 2);
          expect(results[0].length, equals(2));
          expect(results[1].length, equals(5));
        },
      );

      test(
        'should convert CategoryModel to Category entity correctly',
        () async {
          // Arrange
          final categories = [
            ExpensesTestFixtures.createCategoryModel(
              id: 'cat-1',
            ),
          ];

          when(() => mockLocal.getCategories()).thenAnswer((_) async => []);
          when(
            () => mockService.getCategories(),
          ).thenAnswer((_) async => categories);
          when(() => mockLocal.saveCategories(any())).thenAnswer((_) async {});

          // Act
          final result = await repository.watchCategories().first;

          // Assert
          expect(result.first.id, equals('cat-1'));
          expect(result.first.name, equals('Food'));
          expect(result.first.icon, equals('🍔'));
          expect(result.first.color, equals('#FF5733'));
        },
      );

      test('should throw error when no cache and service fails', () async {
        // Arrange
        when(() => mockLocal.getCategories()).thenAnswer((_) async => []);
        when(
          () => mockService.getCategories(),
        ).thenThrow(Exception('Network error'));

        // Act & Assert
        expect(
          () => repository.watchCategories().toList(),
          throwsException,
        );
      });

      test(
        'should not throw error when service fails but cache exists',
        () async {
          // Arrange
          final cachedCategories = ExpensesTestFixtures.createCategoryModelList(
            3,
          );

          when(
            () => mockLocal.getCategories(),
          ).thenAnswer((_) async => cachedCategories);
          when(
            () => mockService.getCategories(),
          ).thenThrow(Exception('Network error'));

          // Act
          final stream = repository.watchCategories();
          final results = await stream.toList();

          // Assert
          expect(results.length, 1);
          expect(results.first.length, equals(3));
        },
      );

      test('should save fresh categories to local cache', () async {
        // Arrange
        final freshCategories = ExpensesTestFixtures.createCategoryModelList(3);

        when(() => mockLocal.getCategories()).thenAnswer((_) async => []);
        when(
          () => mockService.getCategories(),
        ).thenAnswer((_) async => freshCategories);
        when(() => mockLocal.saveCategories(any())).thenAnswer((_) async {});

        // Act
        await repository.watchCategories().toList();

        // Assert
        verify(() => mockLocal.saveCategories(freshCategories)).called(1);
      });
    });

    group('saveCategory', () {
      test('should save category through service and local', () async {
        // Arrange
        const category = ExpenseCategory(
          id: 'cat-new',
          name: 'New Category',
          icon: '🆕',
          color: '#000000',
        );
        final savedModel = ExpensesTestFixtures.createCategoryModel(
          id: 'cat-new',
          name: 'New Category',
        );

        when(
          () => mockService.saveCategory(any()),
        ).thenAnswer((_) async => savedModel);
        when(() => mockLocal.saveCategory(any())).thenAnswer((_) async {});

        // Act
        await repository.saveCategory(category);

        // Assert
        verify(() => mockService.saveCategory(any())).called(1);
        verify(() => mockLocal.saveCategory(savedModel)).called(1);
      });
    });

    group('deleteCategory', () {
      test('should delete category from both service and local', () async {
        // Arrange
        const categoryId = 'cat-to-delete';
        when(() => mockService.deleteCategory(any())).thenAnswer((_) async {});
        when(() => mockLocal.deleteCategory(any())).thenAnswer((_) async {});

        // Act
        await repository.deleteCategory(categoryId);

        // Assert
        verify(() => mockService.deleteCategory(categoryId)).called(1);
        verify(() => mockLocal.deleteCategory(categoryId)).called(1);
      });
    });

    group('watchTransactions', () {
      test('should emit cached transactions when available', () async {
        // Arrange
        final cachedTransactions = ExpensesTestFixtures.createTransactionModelList(3);
        when(
          () => mockLocal.getTransactions(),
        ).thenAnswer((_) async => cachedTransactions);
        when(
          () => mockService.getTransactions(),
        ).thenAnswer((_) async => cachedTransactions);
        when(() => mockLocal.saveTransactions(any())).thenAnswer((_) async {});

        // Act
        final stream = repository.watchTransactions();
        final results = await stream.take(2).toList();

        // Assert
        expect(results.length, greaterThanOrEqualTo(1));
        expect(results.first.length, equals(3));
      });

      test('should emit fresh transactions after fetching', () async {
        // Arrange
        final cachedTransactions = ExpensesTestFixtures.createTransactionModelList(2);
        final freshTransactions = ExpensesTestFixtures.createTransactionModelList(5);

        when(
          () => mockLocal.getTransactions(),
        ).thenAnswer((_) async => cachedTransactions);
        when(
          () => mockService.getTransactions(),
        ).thenAnswer((_) async => freshTransactions);
        when(() => mockLocal.saveTransactions(any())).thenAnswer((_) async {});

        // Act
        final stream = repository.watchTransactions();
        final results = await stream.take(2).toList();

        // Assert
        expect(results.length, 2);
        expect(results[0].length, equals(2));
        expect(results[1].length, equals(5));
      });

      test('should convert TransactionModel to Transaction entity', () async {
        // Arrange
        final transactions = [
          ExpensesTestFixtures.createTransactionModel(
            id: 'tx-1',
          ),
        ];

        when(() => mockLocal.getTransactions()).thenAnswer((_) async => []);
        when(
          () => mockService.getTransactions(),
        ).thenAnswer((_) async => transactions);
        when(() => mockLocal.saveTransactions(any())).thenAnswer((_) async {});

        // Act
        final result = await repository.watchTransactions().first;

        // Assert
        expect(result.first.id, equals('tx-1'));
        expect(result.first.title, equals('Test Transaction'));
        expect(result.first.amount, equals(100));
        expect(result.first.type, equals(TransactionType.expense));
      });

      test('should handle income and expense transaction types', () async {
        // Arrange
        final mixedTransactions = ExpensesTestFixtures.createMixedTransactionList();

        when(() => mockLocal.getTransactions()).thenAnswer((_) async => []);
        when(
          () => mockService.getTransactions(),
        ).thenAnswer((_) async => mixedTransactions);
        when(() => mockLocal.saveTransactions(any())).thenAnswer((_) async {});

        // Act
        final result = await repository.watchTransactions().first;

        // Assert
        expect(result.length, equals(3));
        expect(
          result.where((t) => t.type == TransactionType.income).length,
          equals(1),
        );
        expect(
          result.where((t) => t.type == TransactionType.expense).length,
          equals(2),
        );
      });
    });

    group('saveTransaction', () {
      test('should save transaction through service and local', () async {
        // Arrange
        final transaction = Transaction(
          id: 'tx-new',
          title: 'New Transaction',
          category: 'Food',
          amount: 50,
          description: 'Test',
          date: DateTime(2024, 1, 15),
          type: TransactionType.expense,
          emoji: '🍔',
        );
        final savedModel = ExpensesTestFixtures.createTransactionModel(
          id: 'tx-new',
          title: 'New Transaction',
        );

        when(
          () => mockService.saveTransaction(any()),
        ).thenAnswer((_) async => savedModel);
        when(() => mockLocal.saveTransaction(any())).thenAnswer((_) async {});

        // Act
        await repository.saveTransaction(transaction);

        // Assert
        verify(() => mockService.saveTransaction(any())).called(1);
        verify(() => mockLocal.saveTransaction(savedModel)).called(1);
      });
    });

    group('deleteTransaction', () {
      test('should delete transaction from both service and local', () async {
        // Arrange
        const transactionId = 'tx-to-delete';
        when(
          () => mockService.deleteTransaction(any()),
        ).thenAnswer((_) async {});
        when(() => mockLocal.deleteTransaction(any())).thenAnswer((_) async {});

        // Act
        await repository.deleteTransaction(transactionId);

        // Assert
        verify(() => mockService.deleteTransaction(transactionId)).called(1);
        verify(() => mockLocal.deleteTransaction(transactionId)).called(1);
      });
    });
  });
}

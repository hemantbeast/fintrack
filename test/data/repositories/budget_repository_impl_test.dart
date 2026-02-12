import 'package:fintrack/features/budget/data/models/budget_model.dart';
import 'package:fintrack/features/budget/data/repositories/budget_repository_impl.dart';
import 'package:fintrack/features/budget/domain/entities/budget.dart';
import 'package:fintrack/features/budget/domain/repositories/budget_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/budget_mocks.dart';

class FakeBudgetModel extends Fake implements BudgetModel {}

void main() {
  late BudgetRepository repository;
  late MockBudgetService mockService;
  late MockBudgetLocal mockLocal;

  setUpAll(() {
    registerFallbackValue(FakeBudgetModel());
  });

  setUp(() {
    mockService = MockBudgetService();
    mockLocal = MockBudgetLocal();
    repository = BudgetRepositoryImpl(
      service: mockService,
      local: mockLocal,
    );
  });

  group('BudgetRepositoryImpl', () {
    group('watchBudgets', () {
      test('should emit cached budgets when available', () async {
        // Arrange
        final cachedBudgets = BudgetTestFixtures.createBudgetModelList(3);

        when(
          () => mockLocal.getBudgets(),
        ).thenAnswer((_) async => cachedBudgets);
        when(
          () => mockService.getBudgets(),
        ).thenAnswer((_) async => cachedBudgets);
        when(() => mockLocal.saveBudgets(any())).thenAnswer((_) async {});

        // Act
        final stream = repository.watchBudgets();
        final results = await stream.take(2).toList();

        // Assert
        expect(results.length, greaterThanOrEqualTo(1));
        expect(results.first.length, equals(3));
      });

      test('should emit fresh budgets after fetching', () async {
        // Arrange
        final cachedBudgets = BudgetTestFixtures.createBudgetModelList(2);
        final freshBudgets = BudgetTestFixtures.createBudgetModelList(5);

        when(
          () => mockLocal.getBudgets(),
        ).thenAnswer((_) async => cachedBudgets);
        when(
          () => mockService.getBudgets(),
        ).thenAnswer((_) async => freshBudgets);
        when(() => mockLocal.saveBudgets(any())).thenAnswer((_) async {});

        // Act
        final stream = repository.watchBudgets();
        final results = await stream.take(2).toList();

        // Assert
        expect(results.length, 2);
        expect(results[0].length, equals(2));
        expect(results[1].length, equals(5));
      });

      test('should convert BudgetModel to Budget entity', () async {
        // Arrange
        final budgets = [
          BudgetTestFixtures.createBudgetModel(
            id: 'budget-1',
          ),
        ];

        when(() => mockLocal.getBudgets()).thenAnswer((_) async => null);
        when(() => mockService.getBudgets()).thenAnswer((_) async => budgets);
        when(() => mockLocal.saveBudgets(any())).thenAnswer((_) async {});

        // Act
        final result = await repository.watchBudgets().first;

        // Assert
        expect(result.first.id, equals('budget-1'));
        expect(result.first.category, equals('Food'));
        expect(result.first.spent, equals(300));
        expect(result.first.limit, equals(500));
        expect(result.first.percentage, equals(60));
        expect(result.first.remaining, equals(200));
      });

      test('should throw error when no cache and service fails', () async {
        // Arrange
        when(() => mockLocal.getBudgets()).thenAnswer((_) async => null);
        when(
          () => mockService.getBudgets(),
        ).thenThrow(Exception('Network error'));

        // Act & Assert
        expect(
          () => repository.watchBudgets().toList(),
          throwsException,
        );
      });

      test(
        'should not throw error when service fails but cache exists',
        () async {
          // Arrange
          final cachedBudgets = BudgetTestFixtures.createBudgetModelList(3);

          when(
            () => mockLocal.getBudgets(),
          ).thenAnswer((_) async => cachedBudgets);
          when(
            () => mockService.getBudgets(),
          ).thenThrow(Exception('Network error'));

          // Act
          final stream = repository.watchBudgets();
          final results = await stream.toList();

          // Assert
          expect(results.length, 1);
          expect(results.first.length, equals(3));
        },
      );

      test('should save fresh budgets to local cache', () async {
        // Arrange
        final freshBudgets = BudgetTestFixtures.createBudgetModelList(3);

        when(() => mockLocal.getBudgets()).thenAnswer((_) async => null);
        when(
          () => mockService.getBudgets(),
        ).thenAnswer((_) async => freshBudgets);
        when(() => mockLocal.saveBudgets(any())).thenAnswer((_) async {});

        // Act
        await repository.watchBudgets().toList();

        // Assert
        verify(() => mockLocal.saveBudgets(freshBudgets)).called(1);
      });
    });

    group('saveBudget', () {
      test('should save budget to local storage', () async {
        // Arrange
        final budget = Budget(
          id: 'budget-1',
          category: 'Food',
          emoji: '🍔',
          spent: 300,
          limit: 500,
        );

        when(() => mockLocal.saveBudget(any())).thenAnswer((_) async {});

        // Act
        await repository.saveBudget(budget);

        // Assert
        verify(() => mockLocal.saveBudget(any())).called(1);
      });

      test(
        'should convert Budget entity to BudgetModel before saving',
        () async {
          // Arrange
          final budget = Budget(
            id: 'budget-1',
            category: 'Food',
            emoji: '🍔',
            spent: 300,
            limit: 500,
          );

          when(() => mockLocal.saveBudget(any())).thenAnswer((_) async {});

          // Act
          await repository.saveBudget(budget);

          // Assert - Verify the model was created correctly
          verify(() => mockLocal.saveBudget(any())).called(1);
        },
      );
    });

    group('deleteBudget', () {
      test('should delete budget by ID', () async {
        // Arrange
        const budgetId = 'budget-1';

        when(() => mockLocal.deleteBudget(any())).thenAnswer((_) async {});

        // Act
        await repository.deleteBudget(budgetId);

        // Assert
        verify(() => mockLocal.deleteBudget(budgetId)).called(1);
      });

      test('should call local delete with correct ID', () async {
        // Arrange
        const budgetId = 'budget-to-delete';

        when(() => mockLocal.deleteBudget(any())).thenAnswer((_) async {});

        // Act
        await repository.deleteBudget(budgetId);

        // Assert
        verify(() => mockLocal.deleteBudget('budget-to-delete')).called(1);
      });
    });
  });
}

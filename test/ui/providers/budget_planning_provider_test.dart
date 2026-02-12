import 'dart:async';

import 'package:fintrack/features/budget/data/repositories/budget_repository_impl.dart';
import 'package:fintrack/features/budget/domain/entities/budget.dart';
import 'package:fintrack/features/budget/domain/repositories/budget_repository.dart';
import 'package:fintrack/features/budget/ui/providers/budget_planning_provider.dart';
import 'package:fintrack/features/budget/ui/states/budget_planning_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/provider_mocks.dart';

// Mock the repository interface
class MockBudgetRepository extends Mock implements BudgetRepository {}

class FakeBudget extends Fake implements Budget {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeBudget());
  });

  group('BudgetPlanningNotifier', () {
    late MockBudgetRepository mockRepository;

    setUp(() {
      mockRepository = MockBudgetRepository();
    });

    ProviderContainer createContainer() {
      return ProviderContainer(
        overrides: [
          budgetRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
    }

    test('initial state should be loading', () {
      // Arrange - Set up mock before creating container
      when(
        () => mockRepository.watchBudgets(),
      ).thenAnswer((_) => const Stream.empty());

      final container = createContainer();
      addTearDown(container.dispose);

      // Act
      final state = container.read(budgetPlanningProvider);

      // Assert
      expect(state.budgets, isA<AsyncLoading>());
    });

    test('should delete budget successfully', () async {
      // Arrange
      const budgetId = 'budget-to-delete';
      final budgets = ProviderTestFixtures.createBudgetList(3);

      when(
        () => mockRepository.watchBudgets(),
      ).thenAnswer((_) => Stream.value(budgets));
      when(() => mockRepository.deleteBudget(any())).thenAnswer((_) async {});

      final container = createContainer();
      addTearDown(container.dispose);

      // Wait for initial load
      await Future.delayed(const Duration(milliseconds: 50));

      // Act
      await container
          .read(budgetPlanningProvider.notifier)
          .deleteBudget(budgetId);

      // Assert
      verify(() => mockRepository.deleteBudget(budgetId)).called(1);
    });

    test('should refresh budgets', () async {
      // Arrange
      final budgets = ProviderTestFixtures.createBudgetList(3);

      when(
        () => mockRepository.watchBudgets(),
      ).thenAnswer((_) => Stream.value(budgets));

      final container = createContainer();
      addTearDown(container.dispose);

      // Wait for initial load
      await Future.delayed(const Duration(milliseconds: 50));

      // Act
      await container.read(budgetPlanningProvider.notifier).refresh();

      // Assert - Repository should be called
      verify(
        () => mockRepository.watchBudgets(),
      ).called(greaterThanOrEqualTo(1));
    });
  });
}

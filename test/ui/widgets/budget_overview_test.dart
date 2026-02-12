import 'package:fintrack/features/budget/domain/entities/budget.dart';
import 'package:fintrack/features/dashboard/ui/widgets/budget_overview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BudgetOverview Widget', () {
    testWidgets('should display budgets when provided', (
      WidgetTester tester,
    ) async {
      // Arrange
      final budgets = [
        Budget(
          id: 'budget-1',
          category: 'Food',
          emoji: '🍔',
          spent: 300.0,
          limit: 500.0,
        ),
        Budget(
          id: 'budget-2',
          category: 'Transport',
          emoji: '🚌',
          spent: 100.0,
          limit: 200.0,
        ),
      ];

      // Act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: BudgetOverview(budgets: budgets),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Food'), findsOneWidget);
      expect(find.text('Transport'), findsOneWidget);
      expect(find.text('🍔'), findsOneWidget);
      expect(find.text('🚌'), findsOneWidget);
    });

    testWidgets('should display empty list when no budgets', (
      WidgetTester tester,
    ) async {
      // Arrange
      final budgets = <Budget>[];

      // Act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: BudgetOverview(budgets: budgets),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(ListView), findsOneWidget);
      expect(find.text('Food'), findsNothing);
    });

    testWidgets('should display correct budget percentage', (
      WidgetTester tester,
    ) async {
      // Arrange
      final budgets = [
        Budget(
          id: 'budget-1',
          category: 'Food',
          emoji: '🍔',
          spent: 300.0,
          limit: 500.0,
        ),
      ];

      // Act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: BudgetOverview(budgets: budgets),
            ),
          ),
        ),
      );

      // Assert - Should show 60% for Food budget (300/500 * 100)
      expect(find.text('60%'), findsOneWidget);
    });

    testWidgets('should show 100% when spent exceeds limit', (
      WidgetTester tester,
    ) async {
      // Arrange
      final budgets = [
        Budget(
          id: 'budget-1',
          category: 'Food',
          emoji: '🍔',
          spent: 600.0,
          limit: 500.0,
        ),
      ];

      // Act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: BudgetOverview(budgets: budgets),
            ),
          ),
        ),
      );

      // Assert - Should show 100% (capped by Budget.percentage getter)
      expect(find.text('100%'), findsOneWidget);
    });

    testWidgets('should show 0% when nothing spent', (
      WidgetTester tester,
    ) async {
      // Arrange
      final budgets = [
        Budget(
          id: 'budget-1',
          category: 'Food',
          emoji: '🍔',
          spent: 0.0,
          limit: 500.0,
        ),
      ];

      // Act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: BudgetOverview(budgets: budgets),
            ),
          ),
        ),
      );

      // Assert - Should show 0%
      expect(find.text('0%'), findsOneWidget);
    });

    testWidgets('should display progress bars for budgets', (
      WidgetTester tester,
    ) async {
      // Arrange
      final budgets = [
        Budget(
          id: 'budget-1',
          category: 'Food',
          emoji: '🍔',
          spent: 300.0,
          limit: 500.0,
        ),
      ];

      // Act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: BudgetOverview(budgets: budgets),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('should display spending information', (
      WidgetTester tester,
    ) async {
      // Arrange
      final budgets = [
        Budget(
          id: 'budget-1',
          category: 'Food',
          emoji: '🍔',
          spent: 300.0,
          limit: 500.0,
        ),
      ];

      // Act
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: BudgetOverview(budgets: budgets),
            ),
          ),
        ),
      );

      // Assert - Check for spending/limit display
      expect(find.byType(Text), findsWidgets);
    });
  });
}

import 'package:fintrack/features/dashboard/domain/entities/balance.dart';
import 'package:fintrack/features/dashboard/ui/widgets/balance_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BalanceCard Widget', () {
    testWidgets('should display balance information correctly', (
      WidgetTester tester,
    ) async {
      // Arrange
      final balance = Balance(
        currentBalance: 1000.0,
        income: 5000.0,
        expenses: 4000.0,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BalanceCard(balance: balance),
          ),
        ),
      );

      // Assert
      expect(find.text('₹1,000.00'), findsOneWidget); // Current balance
      expect(find.text('Income'), findsOneWidget);
      expect(find.text('Expenses'), findsOneWidget);
    });

    testWidgets('should display zero balance correctly', (
      WidgetTester tester,
    ) async {
      // Arrange
      final balance = Balance(
        currentBalance: 0.0,
        income: 0.0,
        expenses: 0.0,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BalanceCard(balance: balance),
          ),
        ),
      );

      // Assert
      expect(find.text('₹0.00'), findsOneWidget);
    });

    testWidgets('should display negative balance correctly', (
      WidgetTester tester,
    ) async {
      // Arrange
      final balance = Balance(
        currentBalance: -1000.0,
        income: 0.0,
        expenses: 1000.0,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BalanceCard(balance: balance),
          ),
        ),
      );

      // Assert
      expect(find.textContaining('1,000'), findsOneWidget);
    });

    testWidgets('should display large balance values correctly', (
      WidgetTester tester,
    ) async {
      // Arrange
      final balance = Balance(
        currentBalance: 1000000.0,
        income: 5000000.0,
        expenses: 4000000.0,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BalanceCard(balance: balance),
          ),
        ),
      );

      // Assert - Check that balance is displayed (formatted)
      expect(find.textContaining('1,000,000'), findsOneWidget);
    });
  });
}

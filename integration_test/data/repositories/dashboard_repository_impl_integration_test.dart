import 'dart:async';

import 'package:fintrack/features/dashboard/data/models/balance_model.dart';
import 'package:fintrack/features/dashboard/data/models/exchange_rate_model.dart';
import 'package:fintrack/features/dashboard/data/models/transaction_model.dart';
import 'package:fintrack/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:fintrack/features/dashboard/data/sources/local/dashboard_local.dart';
import 'package:fintrack/features/dashboard/data/sources/remote/dashboard_service.dart';
import 'package:fintrack/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../test/helpers/dashboard_mocks.dart';
import '../../helpers/integration_test_base.dart';
import '../../helpers/integration_test_fixtures.dart';

// Fake classes for mocktail
class FakeBalanceModel extends Fake implements BalanceModel {}

class FakeTransactionModel extends Fake implements TransactionModel {}

class FakeExchangeRateModel extends Fake implements ExchangeRateModel {}

/// Integration tests for DashboardRepositoryImpl
/// Tests the integration between Repository, Local storage, and Service layers
void main() {
  late DashboardRepository repository;
  late DashboardLocal local;
  late MockDashboardService mockService;
  late ProviderContainer container;

  setUpAll(() async {
    await IntegrationTestBase.initialize();
    await IntegrationTestBase.initializeHive();
    container = IntegrationTestBase.getProviderContainer();
  });

  setUp(() async {
    await IntegrationTestBase.clearHiveBoxes();

    mockService = MockDashboardService();
    local = container.read(dashboardLocalProvider);

    // Register fallback values for mocktail
    registerFallbackValue(FakeBalanceModel());
    registerFallbackValue(FakeTransactionModel());
    registerFallbackValue(FakeExchangeRateModel());

    repository = DashboardRepositoryImpl(
      service: mockService,
      local: local,
    );
  });

  tearDownAll(() async {
    await IntegrationTestBase.cleanup();
  });

  group('DashboardRepositoryImpl Integration', () {
    group('watchBalance', () {
      test('should emit fresh data when cache is empty', () async {
        // Arrange
        final freshBalance = IntegrationTestFixtures.createBalanceModel(
          current: 5000,
        );

        when(
          () => mockService.getBalance(),
        ).thenAnswer((_) async => freshBalance);

        // Act
        final results = await repository.watchBalance().toList();

        // Assert
        expect(results.length, 1);
        expect(results.first.currentBalance, 5000);
      });

      test('should emit cached data immediately then fresh data', () async {
        // Arrange - Pre-populate cache
        final cachedBalance = IntegrationTestFixtures.createBalanceModel(
          current: 3000,
        );
        await local.saveBalance(cachedBalance);

        final freshBalance = IntegrationTestFixtures.createBalanceModel(
          current: 5000,
        );
        when(
          () => mockService.getBalance(),
        ).thenAnswer((_) async => freshBalance);

        // Act
        final results = await repository.watchBalance().take(2).toList();

        // Assert
        expect(results.length, 2);
        expect(results[0].currentBalance, 3000); // Cached
        expect(results[1].currentBalance, 5000); // Fresh
      });

      test('should persist fresh data to cache', () async {
        // Arrange
        final freshBalance = IntegrationTestFixtures.createBalanceModel(
          current: 7500,
        );
        when(
          () => mockService.getBalance(),
        ).thenAnswer((_) async => freshBalance);

        // Act
        await repository.watchBalance().first;

        // Assert - Verify data was saved to local cache
        final cachedData = await local.getBalance();
        expect(cachedData, isNotNull);
        expect(cachedData!.current, 7500);
      });

      test(
        'should handle service failure gracefully when cache exists',
        () async {
          // Arrange - Pre-populate cache
          final cachedBalance = IntegrationTestFixtures.createBalanceModel(
            current: 4000,
          );
          await local.saveBalance(cachedBalance);

          when(
            () => mockService.getBalance(),
          ).thenThrow(Exception('Network error'));

          // Act
          final results = await repository.watchBalance().toList();

          // Assert
          expect(results.length, 1);
          expect(results.first.currentBalance, 4000); // Falls back to cache
        },
      );
    });

    group('watchTransactions', () {
      test('should fetch and cache transactions', () async {
        // Arrange
        final transactions = IntegrationTestFixtures.createTransactionModelList(
          3,
        );
        when(
          () => mockService.getTransactions(),
        ).thenAnswer((_) async => transactions);

        // Act
        final results = await repository.watchTransactions().toList();

        // Assert
        expect(results.first.length, 3);

        // Verify data was cached
        final cachedTransactions = await local.getTransactions();
        expect(cachedTransactions?.length, 3);
      });

      test('should emit cached transactions immediately', () async {
        // Arrange - Pre-populate cache
        final cachedTransactions =
            IntegrationTestFixtures.createTransactionModelList(2);
        await local.saveTransactions(cachedTransactions);

        final freshTransactions =
            IntegrationTestFixtures.createTransactionModelList(5);
        when(
          () => mockService.getTransactions(),
        ).thenAnswer((_) async => freshTransactions);

        // Act
        final results = await repository.watchTransactions().take(2).toList();

        // Assert
        expect(results[0].length, 2); // Cached
        expect(results[1].length, 5); // Fresh
      });
    });

    group('stale-while-revalidate pattern', () {
      test('should provide instant UI response with cache', () async {
        // Arrange - Pre-populate cache
        final cachedBalance = IntegrationTestFixtures.createBalanceModel(
          current: 10000,
        );
        await local.saveBalance(cachedBalance);

        final freshBalance = IntegrationTestFixtures.createBalanceModel(
          current: 15000,
        );
        when(() => mockService.getBalance()).thenAnswer((_) async {
          // Simulate network delay
          await Future.delayed(const Duration(milliseconds: 500));
          return freshBalance;
        });

        // Act - Track timing
        final stopwatch = Stopwatch()..start();
        final firstEmission = await repository.watchBalance().first;
        final firstEmitTime = stopwatch.elapsedMilliseconds;

        final allResults = await repository.watchBalance().take(2).toList();
        final totalTime = stopwatch.elapsedMilliseconds;

        // Assert
        expect(firstEmission.currentBalance, 10000); // Cached value
        expect(firstEmitTime, lessThan(100)); // Should be instant
        expect(
          allResults.last.currentBalance,
          15000,
        ); // Eventually gets fresh data
        expect(totalTime, greaterThan(400)); // Takes time for network
      });
    });
  });
}

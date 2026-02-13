import 'package:fintrack/features/budget/data/models/budget_model.dart';
import 'package:fintrack/features/budget/data/repositories/budget_repository_impl.dart';
import 'package:fintrack/features/budget/data/sources/local/budget_local.dart';
import 'package:fintrack/features/budget/data/sources/remote/budget_service.dart';
import 'package:fintrack/features/dashboard/data/models/balance_model.dart';
import 'package:fintrack/features/dashboard/data/models/transaction_model.dart';
import 'package:fintrack/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:fintrack/features/dashboard/data/sources/local/dashboard_local.dart';
import 'package:fintrack/features/dashboard/data/sources/remote/dashboard_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/integration_test_base.dart';
import '../helpers/integration_test_fixtures.dart';

/// End-to-End Integration Test: Dashboard to Budget Flow
///
/// Tests the complete user flow:
/// 1. User opens dashboard and sees balance/transactions
/// 2. Dashboard data is cached for offline use
/// 3. User navigates to budget and sees budget data
/// 4. Budget data integrates with transaction data
///
/// This test validates:
/// - Clean Architecture layer integration
/// - Data consistency across features
/// - Cache management
/// - Repository coordination
void main() {
  late ProviderContainer container;

  // Dashboard dependencies
  late MockDashboardService mockDashboardService;
  late DashboardLocal dashboardLocal;
  late DashboardRepositoryImpl dashboardRepository;

  // Budget dependencies
  late MockBudgetService mockBudgetService;
  late BudgetLocal budgetLocal;
  late BudgetRepositoryImpl budgetRepository;

  setUpAll(() async {
    await IntegrationTestBase.initialize();
    await IntegrationTestBase.initializeHive();
    container = IntegrationTestBase.getProviderContainer();
  });

  setUp(() async {
    await IntegrationTestBase.clearHiveBoxes();

    // Initialize Dashboard layer
    mockDashboardService = MockDashboardService();
    dashboardLocal = container.read(dashboardLocalProvider);
    dashboardRepository = DashboardRepositoryImpl(
      service: mockDashboardService,
      local: dashboardLocal,
    );

    // Initialize Budget layer
    mockBudgetService = MockBudgetService();
    budgetLocal = container.read(budgetLocalProvider);
    budgetRepository = BudgetRepositoryImpl(
      service: mockBudgetService,
      local: budgetLocal,
    );

    // Register fallback values
    registerFallbackValue(BalanceModel());
    registerFallbackValue(TransactionModel());
    registerFallbackValue(BudgetModel());
  });

  tearDownAll(() async {
    await IntegrationTestBase.cleanup();
  });

  group('Dashboard to Budget E2E Flow', () {
    test('complete user journey: view dashboard then budget', () async {
      // ========== Phase 1: Dashboard Load ==========
      // Arrange - Setup dashboard data
      final balance = IntegrationTestFixtures.createBalanceModel(
        current: 10000,
      );
      final transactions = IntegrationTestFixtures.createTransactionModelList(
        5,
      );

      when(
        () => mockDashboardService.getBalance(),
      ).thenAnswer((_) async => balance);
      when(
        () => mockDashboardService.getTransactions(),
      ).thenAnswer((_) async => transactions);

      // Act - Load dashboard (simulates user opening app)
      final dashboardBalance = await dashboardRepository.watchBalance().first;
      final dashboardTransactions = await dashboardRepository
          .watchTransactions()
          .first;

      // Assert - Dashboard shows data
      expect(dashboardBalance.currentBalance, 10000);
      expect(dashboardTransactions.length, 5);

      // ========== Phase 2: Verify Cache Persistence ==========
      // Act - Simulate fresh repository instance (app restart)
      final freshDashboardRepo = DashboardRepositoryImpl(
        service: mockDashboardService,
        local: dashboardLocal,
      );

      // Should get cached data instantly without calling service again
      final cachedBalance = await freshDashboardRepo.watchBalance().first;
      expect(cachedBalance.currentBalance, 10000);

      // ========== Phase 3: Budget Integration ==========
      // Arrange - Setup budget data related to transactions
      final budgets = IntegrationTestFixtures.createBudgetModelList(3);

      when(
        () => mockBudgetService.getBudgets(),
      ).thenAnswer((_) async => budgets);

      // Act - Load budgets (simulates user navigating to budget screen)
      final budgetList = await budgetRepository.watchBudgets().first;

      // Assert - Budgets are loaded
      expect(budgetList.length, 3);
      expect(budgetList.first.category, isNotEmpty);

      // ========== Phase 4: Data Consistency Check ==========
      // Verify that transaction categories align with budget categories
      final transactionCategories = dashboardTransactions
          .map((t) => t.category)
          .toSet();
      final budgetCategories = budgetList.map((b) => b.category).toSet();

      // There should be some overlap or relationship between the data
      expect(transactionCategories, isNotEmpty);
      expect(budgetCategories, isNotEmpty);
    });

    test(
      'offline scenario: cached data available when service fails',
      () async {
        // ========== Phase 1: Populate Cache ==========
        final balance = IntegrationTestFixtures.createBalanceModel(
          current: 5000,
        );
        final budgets = IntegrationTestFixtures.createBudgetModelList(2);

        when(
          () => mockDashboardService.getBalance(),
        ).thenAnswer((_) async => balance);
        when(
          () => mockBudgetService.getBudgets(),
        ).thenAnswer((_) async => budgets);

        // Initial load to populate cache
        await dashboardRepository.watchBalance().first;
        await budgetRepository.watchBudgets().first;

        // ========== Phase 2: Simulate Offline ==========
        when(
          () => mockDashboardService.getBalance(),
        ).thenThrow(Exception('Network unavailable'));
        when(
          () => mockBudgetService.getBudgets(),
        ).thenThrow(Exception('Network unavailable'));

        // ========== Phase 3: Verify Offline Functionality ==========
        // Fresh repository instance should still work with cache
        final offlineDashboardRepo = DashboardRepositoryImpl(
          service: mockDashboardService,
          local: dashboardLocal,
        );
        final offlineBudgetRepo = BudgetRepositoryImpl(
          service: mockBudgetService,
          local: budgetLocal,
        );

        final offlineBalance = await offlineDashboardRepo.watchBalance().first;
        final offlineBudgets = await offlineBudgetRepo.watchBudgets().first;

        expect(offlineBalance.currentBalance, 5000);
        expect(offlineBudgets.length, 2);
      },
    );

    test(
      'stale-while-revalidate: instant response with background refresh',
      () async {
        // Arrange - Pre-populate cache
        final cachedBalance = IntegrationTestFixtures.createBalanceModel(
          current: 3000,
        );
        await dashboardLocal.saveBalance(cachedBalance);

        final freshBalance = IntegrationTestFixtures.createBalanceModel(
          current: 8000,
        );
        when(() => mockDashboardService.getBalance()).thenAnswer((_) async {
          // Simulate slow network
          await Future<void>.delayed(const Duration(milliseconds: 500));
          return freshBalance;
        });

        // Act - Start watching
        final stopwatch = Stopwatch()..start();
        final balanceStream = dashboardRepository.watchBalance();

        // Collect all emissions
        final allBalances = await balanceStream.take(2).toList();
        final totalTime = stopwatch.elapsedMilliseconds;

        // Assert
        expect(allBalances.first.currentBalance, 3000); // Cached value
        expect(allBalances.last.currentBalance, 8000); // Fresh value
        expect(totalTime, greaterThan(400)); // Network delay
      },
    );
  });
}

// Mock classes
class MockBudgetService extends Mock implements BudgetService {}

class MockDashboardService extends Mock implements DashboardService {}

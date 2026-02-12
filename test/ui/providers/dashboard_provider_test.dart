import 'dart:async';

import 'package:fintrack/features/budget/data/repositories/budget_repository_impl.dart';
import 'package:fintrack/features/budget/domain/entities/budget.dart';
import 'package:fintrack/features/budget/domain/repositories/budget_repository.dart';
import 'package:fintrack/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:fintrack/features/dashboard/domain/entities/balance.dart';
import 'package:fintrack/features/dashboard/domain/entities/exchange_rates.dart';
import 'package:fintrack/features/dashboard/domain/entities/transaction.dart';
import 'package:fintrack/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:fintrack/features/dashboard/ui/providers/dashboard_provider.dart';
import 'package:fintrack/features/dashboard/ui/states/dashboard_state.dart';
import 'package:fintrack/features/settings/ui/providers/settings_provider.dart';
import 'package:fintrack/features/settings/ui/states/settings_state.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/provider_mocks.dart';

class MockBudgetRepository extends Mock implements BudgetRepository {}

class MockDashboardRepository extends Mock implements DashboardRepository {}

class MockSettingsNotifier extends Mock implements SettingsNotifier {}

class FakeBudget extends Fake implements Budget {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(FakeBudget());

    // Mock platform channel for PackageInfo
    const channel = MethodChannel('dev.fluttercommunity.plus/package_info');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          if (methodCall.method == 'getAll') {
            return {
              'appName': 'FinTrack',
              'packageName': 'com.example.fintrack',
              'version': '1.0.0',
              'buildNumber': '1',
            };
          }
          return null;
        });
  });

  group('DashboardNotifier', () {
    late MockBudgetRepository mockBudgetRepository;
    late MockDashboardRepository mockDashboardRepository;

    setUp(() {
      mockBudgetRepository = MockBudgetRepository();
      mockDashboardRepository = MockDashboardRepository();
    });

    tearDown(() {
      reset(mockBudgetRepository);
      reset(mockDashboardRepository);
    });

    ProviderContainer createContainer() {
      return ProviderContainer(
        overrides: [
          budgetRepositoryProvider.overrideWithValue(mockBudgetRepository),
          dashboardRepositoryProvider.overrideWithValue(
            mockDashboardRepository,
          ),
          settingsProvider.overrideWith(_MockSettingsNotifier.new),
        ],
      );
    }

    test('initial state should be loading', () {
      // Arrange - Set up empty streams before creating container
      when(
        mockBudgetRepository.watchBudgets,
      ).thenAnswer((_) => const Stream.empty());
      when(
        () => mockDashboardRepository.watchExchangeRates(
          baseCurrency: any(named: 'baseCurrency'),
        ),
      ).thenAnswer((_) => const Stream.empty());

      final container = createContainer();
      addTearDown(container.dispose);

      // Act
      final state = container.read(dashboardProvider);

      // Assert
      expect(state.screenData, isA<AsyncLoading>());
    });

    test('should refresh dashboard data', () async {
      // Arrange
      final budgets = [ProviderTestFixtures.createBudget()];
      final exchangeRates = ProviderTestFixtures.createExchangeRates();

      when(
        mockBudgetRepository.watchBudgets,
      ).thenAnswer((_) => Stream.value(budgets));
      when(
        () => mockDashboardRepository.watchExchangeRates(
          baseCurrency: any(named: 'baseCurrency'),
        ),
      ).thenAnswer((_) => Stream.value(exchangeRates));

      final container = createContainer();
      addTearDown(container.dispose);

      // Wait for initial load
      await Future.delayed(const Duration(milliseconds: 100));

      // Act
      await container.read(dashboardProvider.notifier).refresh();

      // Assert
      verify(mockBudgetRepository.watchBudgets).called(greaterThanOrEqualTo(1));
    });
  });
}

// Mock settings notifier that provides initial state
class _MockSettingsNotifier extends SettingsNotifier {
  @override
  SettingsState build() {
    // Return initial state without calling super.build() to avoid side effects
    ref.onDispose(() {});
    return SettingsState.initial();
  }

  @override
  void _setupStreams() {
    // Don't set up streams in tests
  }

  @override
  Future<void> _getVersion() async {
    // Don't get version in tests
  }
}

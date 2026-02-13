# Integration Tests

This directory contains integration tests for FinTrack that validate the interaction between multiple layers of the Clean Architecture.

## Overview

Integration tests in FinTrack follow the Clean Architecture principles and test:

1. **Data Layer Integration**: Repository + Service + Local storage
2. **Feature Flows**: End-to-end user journeys across multiple features
3. **Cross-layer Coordination**: Provider + Repository interactions

## Directory Structure

```
integration_test/
├── data/
│   └── repositories/           # Repository integration tests
│       └── *_integration_test.dart
├── flows/                      # End-to-end feature flows
│   └── *_flow_test.dart
├── helpers/
│   ├── integration_test_base.dart    # Base test utilities
│   └── integration_test_fixtures.dart # Test data fixtures
└── README.md
```

## Running Integration Tests

```bash
# Run all integration tests
flutter test integration_test/

# Run a specific integration test
flutter test integration_test/data/repositories/dashboard_repository_impl_integration_test.dart

# Run with coverage
flutter test --coverage integration_test/
```

## Test Patterns

### 1. Repository Integration Tests

Test the integration between Repository, Service, and Local storage layers:

```dart
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
    repository = DashboardRepositoryImpl(
      service: mockService,
      local: local,
    );
  });

  tearDownAll(() async {
    await IntegrationTestBase.cleanup();
  });

  test('should emit cached data immediately then fresh data', () async {
    // Arrange - Pre-populate cache
    final cachedBalance = IntegrationTestFixtures.createBalanceModel(current: 3000);
    await local.saveBalance(cachedBalance);
    
    final freshBalance = IntegrationTestFixtures.createBalanceModel(current: 5000);
    when(() => mockService.getBalance())
        .thenAnswer((_) async => freshBalance);

    // Act
    final results = await repository.watchBalance().take(2).toList();

    // Assert
    expect(results.length, 2);
    expect(results[0].currentBalance, 3000); // Cached
    expect(results[1].currentBalance, 5000); // Fresh
  });
}
```

### 2. End-to-End Flow Tests

Test complete user journeys across multiple features:

```dart
void main() {
  // Setup both Dashboard and Budget repositories
  // Test the full flow: Dashboard → Cache → Budget
  
  test('complete user journey: view dashboard then budget', () async {
    // Phase 1: Dashboard Load
    // Phase 2: Verify Cache Persistence
    // Phase 3: Budget Integration
    // Phase 4: Data Consistency Check
  });
}
```

### 3. Stale-While-Revalidate Pattern Tests

Test the caching strategy works correctly:

```dart
test('stale-while-revalidate: instant response with background refresh', () async {
  // Arrange - Pre-populate cache
  final cachedBalance = IntegrationTestFixtures.createBalanceModel(current: 3000);
  await local.saveBalance(cachedBalance);

  final freshBalance = IntegrationTestFixtures.createBalanceModel(current: 8000);
  when(() => mockService.getBalance())
      .thenAnswer((_) async {
        // Simulate slow network
        await Future.delayed(const Duration(milliseconds: 500));
        return freshBalance;
      });

  // Act - Start watching
  final stopwatch = Stopwatch()..start();
  final balanceStream = repository.watchBalance();
  
  // Get first emission (should be instant from cache)
  final firstBalance = await balanceStream.first;
  final firstEmitTime = stopwatch.elapsedMilliseconds;

  // Assert
  expect(firstBalance.currentBalance, 3000); // Cached value
  expect(firstEmitTime, lessThan(100)); // Should be nearly instant
});
```

## Key Principles

### 1. Real Local Storage

Integration tests use **real** Hive storage (not mocks):

```dart
await IntegrationTestBase.initializeHive();
container = IntegrationTestBase.getProviderContainer();
```

This ensures:
- Actual serialization/deserialization is tested
- Cache behavior is realistic
- Box operations work correctly

### 2. Mocked Services

External dependencies (API calls) are mocked:

```dart
mockService = MockDashboardService();
when(() => mockService.getBalance())
    .thenAnswer((_) async => balance);
```

This ensures:
- Tests are deterministic
- No network calls in tests
- Can simulate errors and edge cases

### 3. Clean State Between Tests

Each test starts with a clean state:

```dart
setUp(() async {
  await IntegrationTestBase.clearHiveBoxes();
  // ... rest of setup
});
```

### 4. Proper Cleanup

Resources are cleaned up after all tests:

```dart
tearDownAll(() async {
  await IntegrationTestBase.cleanup();
});
```

## Testing Scenarios

### Scenario 1: Fresh Load (No Cache)

1. Cache is empty
2. Service returns data
3. Data is emitted
4. Data is saved to cache

### Scenario 2: Cached Data Available

1. Cache has data
2. Cached data emitted immediately
3. Service fetches fresh data
4. Fresh data emitted
5. Cache is updated

### Scenario 3: Offline Mode

1. Cache has data
2. Service throws error
3. Cached data is still available
4. No error is thrown to UI

### Scenario 4: Cache Expiration

1. Cache has stale data (>24 hours for exchange rates)
2. Stale data is ignored
3. Fresh data is fetched
4. Cache is updated

## Best Practices

### ✅ DO

1. **Use IntegrationTestBase**: Always initialize and cleanup properly
2. **Test the full flow**: From service call to cache to entity
3. **Use realistic fixtures**: Test data should represent real scenarios
4. **Test error scenarios**: Network failures, invalid data, etc.
5. **Verify cache persistence**: Ensure data survives across repository instances
6. **Test timing**: Stale-while-revalidate should be instant then fresh

### ❌ DON'T

1. **Don't mock local storage**: Use real Hive to test actual serialization
2. **Don't test implementation details**: Focus on behavior, not internal state
3. **Don't skip cleanup**: Always call IntegrationTestBase.cleanup()
4. **Don't share state between tests**: Clear boxes in setUp()
5. **Don't test UI logic**: That's for widget tests

## Adding New Integration Tests

1. Create test file in appropriate directory
2. Extend IntegrationTestBase for setup
3. Use IntegrationTestFixtures for test data
4. Follow existing patterns for mocking services
5. Test both success and failure scenarios
6. Verify cache behavior
7. Run `flutter test` to ensure tests pass

## Example: Adding Budget Repository Integration Test

```dart
// integration_test/data/repositories/budget_repository_impl_integration_test.dart

import 'package:fintrack/features/budget/data/repositories/budget_repository_impl.dart';
import 'package:fintrack/features/budget/data/sources/local/budget_local.dart';
import 'package:fintrack/features/budget/data/sources/remote/budget_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/integration_test_base.dart';
import '../../helpers/integration_test_fixtures.dart';

class MockBudgetService extends Mock implements BudgetService {}

void main() {
  // ... setup similar to dashboard_repository_impl_integration_test.dart
  
  group('BudgetRepositoryImpl Integration', () {
    test('should fetch and cache budgets', () async {
      // Arrange
      final budgets = IntegrationTestFixtures.createBudgetModelList(3);
      when(() => mockService.getBudgets())
          .thenAnswer((_) async => budgets);

      // Act
      final results = await repository.watchBudgets().toList();

      // Assert
      expect(results.first.length, 3);
      
      // Verify cache
      final cached = await local.getBudgets();
      expect(cached?.length, 3);
    });
  });
}
```

## Troubleshooting

### "Hive not initialized" error

Make sure to call `IntegrationTestBase.initializeHive()` in `setUpAll()`

### "Box already open" error

Ensure you're calling `IntegrationTestBase.clearHiveBoxes()` in `setUp()`, not `setUpAll()`

### Tests are slow

- Use `setUp()` not `setUpAll()` for cache clearing
- Mock services with minimal delays
- Don't use `pumpAndSettle` unnecessarily in integration tests

### Cache data persists between test runs

The `IntegrationTestBase.cleanup()` uses unique directory names with timestamps, but if tests fail mid-run, old directories might persist. Run:

```bash
# Clean up old test directories
rm -rf /tmp/hive_test_*
```

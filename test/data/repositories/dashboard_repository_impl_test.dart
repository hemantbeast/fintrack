import 'package:fintrack/features/dashboard/data/models/balance_model.dart';
import 'package:fintrack/features/dashboard/data/models/exchange_rate_model.dart';
import 'package:fintrack/features/dashboard/data/models/transaction_model.dart';
import 'package:fintrack/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:fintrack/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/dashboard_mocks.dart';

class FakeBalanceModel extends Fake implements BalanceModel {}

class FakeTransactionModel extends Fake implements TransactionModel {}

class FakeExchangeRateModel extends Fake implements ExchangeRateModel {}

void main() {
  late DashboardRepository repository;
  late MockDashboardService mockService;
  late MockDashboardLocal mockLocal;

  setUpAll(() {
    registerFallbackValue(FakeBalanceModel());
    registerFallbackValue(FakeTransactionModel());
    registerFallbackValue(FakeExchangeRateModel());
  });

  setUp(() {
    mockService = MockDashboardService();
    mockLocal = MockDashboardLocal();
    repository = DashboardRepositoryImpl(
      service: mockService,
      local: mockLocal,
    );
  });

  group('DashboardRepositoryImpl', () {
    group('watchBalance', () {
      test('should emit cached data immediately when available', () async {
        // Arrange
        final cachedBalance = DashboardTestFixtures.createBalanceModel();
        when(
          () => mockLocal.getBalance(),
        ).thenAnswer((_) async => cachedBalance);
        when(
          () => mockService.getBalance(),
        ).thenAnswer((_) async => cachedBalance);
        when(() => mockLocal.saveBalance(any())).thenAnswer((_) async {});

        // Act
        final stream = repository.watchBalance();
        final results = await stream.take(2).toList();

        // Assert
        expect(results.length, greaterThanOrEqualTo(1));
        expect(results.first.currentBalance, equals(1000));
        verify(() => mockLocal.getBalance()).called(1);
      });

      test('should emit fresh data after fetching from service', () async {
        // Arrange
        final cachedBalance = DashboardTestFixtures.createBalanceModel();
        final freshBalance = DashboardTestFixtures.createBalanceModel(
          current: 2000,
        );

        when(
          () => mockLocal.getBalance(),
        ).thenAnswer((_) async => cachedBalance);
        when(
          () => mockService.getBalance(),
        ).thenAnswer((_) async => freshBalance);
        when(() => mockLocal.saveBalance(any())).thenAnswer((_) async {});

        // Act
        final stream = repository.watchBalance();
        final results = await stream.take(2).toList();

        // Assert
        expect(results.length, 2);
        expect(results[0].currentBalance, equals(1000)); // Cached
        expect(results[1].currentBalance, equals(2000)); // Fresh
      });

      test('should only emit fresh data when no cache available', () async {
        // Arrange
        final freshBalance = DashboardTestFixtures.createBalanceModel();

        when(() => mockLocal.getBalance()).thenAnswer((_) async => null);
        when(
          () => mockService.getBalance(),
        ).thenAnswer((_) async => freshBalance);
        when(() => mockLocal.saveBalance(any())).thenAnswer((_) async {});

        // Act
        final stream = repository.watchBalance();
        final results = await stream.toList();

        // Assert
        expect(results.length, 1);
        expect(results.first.currentBalance, equals(1000));
      });

      test('should throw error when no cache and service fails', () async {
        // Arrange
        when(() => mockLocal.getBalance()).thenAnswer((_) async => null);
        when(
          () => mockService.getBalance(),
        ).thenThrow(Exception('Network error'));

        // Act & Assert
        expect(
          () => repository.watchBalance().toList(),
          throwsException,
        );
      });

      test(
        'should not throw error when service fails but cache exists',
        () async {
          // Arrange
          final cachedBalance = DashboardTestFixtures.createBalanceModel();

          when(
            () => mockLocal.getBalance(),
          ).thenAnswer((_) async => cachedBalance);
          when(
            () => mockService.getBalance(),
          ).thenThrow(Exception('Network error'));

          // Act
          final stream = repository.watchBalance();
          final results = await stream.toList();

          // Assert
          expect(results.length, 1);
          expect(results.first.currentBalance, equals(1000));
        },
      );

      test('should save fresh data to local cache', () async {
        // Arrange
        final freshBalance = DashboardTestFixtures.createBalanceModel();

        when(() => mockLocal.getBalance()).thenAnswer((_) async => null);
        when(
          () => mockService.getBalance(),
        ).thenAnswer((_) async => freshBalance);
        when(() => mockLocal.saveBalance(any())).thenAnswer((_) async {});

        // Act
        await repository.watchBalance().toList();

        // Assert
        verify(() => mockLocal.saveBalance(freshBalance)).called(1);
      });
    });

    group('watchTransactions', () {
      test('should emit cached transactions when available', () async {
        // Arrange
        final cachedTransactions =
            DashboardTestFixtures.createTransactionModelList(3);

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
        final cachedTransactions =
            DashboardTestFixtures.createTransactionModelList(2);
        final freshTransactions =
            DashboardTestFixtures.createTransactionModelList(5);

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
          DashboardTestFixtures.createTransactionModel(
            id: 'tx-1',
            title: 'Test',
          ),
        ];

        when(() => mockLocal.getTransactions()).thenAnswer((_) async => null);
        when(
          () => mockService.getTransactions(),
        ).thenAnswer((_) async => transactions);
        when(() => mockLocal.saveTransactions(any())).thenAnswer((_) async {});

        // Act
        final result = await repository.watchTransactions().first;

        // Assert
        expect(result.first.id, equals('tx-1'));
        expect(result.first.title, equals('Test'));
        expect(result.first.amount, equals(100));
      });
    });

    group('watchExchangeRates', () {
      test('should emit cached rates when valid', () async {
        // Arrange
        final cachedRates = DashboardTestFixtures.createExchangeRateModel();

        when(
          () => mockLocal.getExchangeRates(),
        ).thenAnswer((_) async => cachedRates);

        // Act
        final stream = repository.watchExchangeRates(baseCurrency: 'INR');
        final results = await stream.toList();

        // Assert
        expect(results.length, 1);
        expect(results.first.baseCurrency, equals('INR'));
        verifyNever(
          () => mockService.getExchangeRates(
            baseCurrency: any(named: 'baseCurrency'),
          ),
        );
      });

      test('should fetch fresh rates when cache is invalid', () async {
        // Arrange
        final invalidCachedRates =
            DashboardTestFixtures.createExchangeRateModel();
        // Set timestamp to more than 24 hours ago
        invalidCachedRates.timeLastUpdateUnix =
            (DateTime.now().millisecondsSinceEpoch ~/ 1000) - 90000;

        final freshRates = DashboardTestFixtures.createExchangeRateModel(
          rates: {'USD': 0.013, 'EUR': 0.012},
        );

        when(
          () => mockLocal.getExchangeRates(),
        ).thenAnswer((_) async => invalidCachedRates);
        when(
          () => mockService.getExchangeRates(
            baseCurrency: any(named: 'baseCurrency'),
          ),
        ).thenAnswer((_) async => freshRates);
        when(() => mockLocal.saveExchangeRates(any())).thenAnswer((_) async {});

        // Act
        final stream = repository.watchExchangeRates(baseCurrency: 'INR');
        final results = await stream.take(2).toList();

        // Assert
        expect(results.length, 2);
        verify(
          () => mockService.getExchangeRates(),
        ).called(1);
      });

      test('should emit fresh rates when no cache exists', () async {
        // Arrange
        final freshRates = DashboardTestFixtures.createExchangeRateModel();

        when(() => mockLocal.getExchangeRates()).thenAnswer((_) async => null);
        when(
          () => mockService.getExchangeRates(
            baseCurrency: any(named: 'baseCurrency'),
          ),
        ).thenAnswer((_) async => freshRates);
        when(() => mockLocal.saveExchangeRates(any())).thenAnswer((_) async {});

        // Act
        final stream = repository.watchExchangeRates(baseCurrency: 'INR');
        final results = await stream.toList();

        // Assert
        expect(results.length, 1);
        expect(results.first.baseCurrency, equals('INR'));
      });
    });

    group('getCurrencyRate', () {
      test('should return rate with correct currency pair', () {
        // Act - getCurrencyRate uses fallback rates when no cache
        final result = repository.getCurrencyRate(from: 'INR', to: 'USD');

        // Assert
        expect(result.fromCurrency, equals('INR'));
        expect(result.toCurrency, equals('USD'));
        expect(result.rate, isA<double>());
      });

      test('should return fallback rate when no cache available', () {
        // Act
        final result = repository.getCurrencyRate(from: 'INR', to: 'USD');

        // Assert
        expect(result.fromCurrency, equals('INR'));
        expect(result.toCurrency, equals('USD'));
        expect(result.rate, equals(0.012)); // Fallback rate
      });

      test('should return default rate 1 for unknown currency pair', () {
        // Act
        final result = repository.getCurrencyRate(from: 'INR', to: 'XYZ');

        // Assert
        expect(result.rate, equals(1));
      });
    });
  });
}

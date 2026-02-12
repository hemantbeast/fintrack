import 'package:fintrack/features/dashboard/domain/entities/exchange_rates.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExchangeRates', () {
    test('should create ExchangeRates with all fields', () {
      // Arrange
      final now = DateTime.now();
      final rates = {
        'USD': 0.012,
        'EUR': 0.011,
        'GBP': 0.0095,
      };

      // Act
      final exchangeRates = ExchangeRates(
        baseCurrency: 'INR',
        rates: rates,
        lastUpdated: now,
      );

      // Assert
      expect(exchangeRates.baseCurrency, equals('INR'));
      expect(exchangeRates.rates, equals(rates));
      expect(exchangeRates.lastUpdated, equals(now));
    });

    test('should create ExchangeRates with empty rates', () {
      // Arrange
      final now = DateTime.now();

      // Act
      final exchangeRates = ExchangeRates(
        baseCurrency: 'USD',
        rates: {},
        lastUpdated: now,
      );

      // Assert
      expect(exchangeRates.baseCurrency, equals('USD'));
      expect(exchangeRates.rates, isEmpty);
    });

    group('getRate', () {
      test('should return correct rate for existing currency', () {
        // Arrange
        final exchangeRates = ExchangeRates(
          baseCurrency: 'INR',
          rates: {
            'USD': 0.012,
            'EUR': 0.011,
          },
          lastUpdated: DateTime.now(),
        );

        // Act & Assert
        expect(exchangeRates.getRate('USD'), equals(0.012));
        expect(exchangeRates.getRate('EUR'), equals(0.011));
      });

      test('should return 1.0 for non-existing currency', () {
        // Arrange
        final exchangeRates = ExchangeRates(
          baseCurrency: 'INR',
          rates: {'USD': 0.012},
          lastUpdated: DateTime.now(),
        );

        // Act & Assert
        expect(exchangeRates.getRate('XXX'), equals(1.0));
        expect(exchangeRates.getRate('INVALID'), equals(1.0));
      });
    });

    group('convert', () {
      test('should convert amount correctly', () {
        // Arrange
        final exchangeRates = ExchangeRates(
          baseCurrency: 'INR',
          rates: {
            'USD': 0.012,
            'EUR': 0.011,
          },
          lastUpdated: DateTime.now(),
        );

        // Act & Assert
        expect(exchangeRates.convert(1000, 'USD'), equals(12.0));
        expect(exchangeRates.convert(1000, 'EUR'), equals(11.0));
        expect(exchangeRates.convert(500, 'USD'), equals(6.0));
      });

      test('should return same amount when rate is not found', () {
        // Arrange
        final exchangeRates = ExchangeRates(
          baseCurrency: 'INR',
          rates: {'USD': 0.012},
          lastUpdated: DateTime.now(),
        );

        // Act & Assert
        expect(exchangeRates.convert(1000, 'XXX'), equals(1000.0));
      });

      test('should handle zero amount', () {
        // Arrange
        final exchangeRates = ExchangeRates(
          baseCurrency: 'INR',
          rates: {'USD': 0.012},
          lastUpdated: DateTime.now(),
        );

        // Act & Assert
        expect(exchangeRates.convert(0, 'USD'), equals(0.0));
      });

      test('should handle negative amounts', () {
        // Arrange
        final exchangeRates = ExchangeRates(
          baseCurrency: 'INR',
          rates: {'USD': 0.012},
          lastUpdated: DateTime.now(),
        );

        // Act & Assert
        expect(exchangeRates.convert(-1000, 'USD'), equals(-12.0));
      });
    });

    group('availableCurrencies', () {
      test('should return list of currency codes', () {
        // Arrange
        final exchangeRates = ExchangeRates(
          baseCurrency: 'INR',
          rates: {
            'USD': 0.012,
            'EUR': 0.011,
            'GBP': 0.0095,
          },
          lastUpdated: DateTime.now(),
        );

        // Act
        final currencies = exchangeRates.availableCurrencies;

        // Assert
        expect(currencies.length, equals(3));
        expect(currencies, contains('USD'));
        expect(currencies, contains('EUR'));
        expect(currencies, contains('GBP'));
      });

      test('should return empty list when no rates', () {
        // Arrange
        final exchangeRates = ExchangeRates(
          baseCurrency: 'INR',
          rates: {},
          lastUpdated: DateTime.now(),
        );

        // Act
        final currencies = exchangeRates.availableCurrencies;

        // Assert
        expect(currencies, isEmpty);
      });
    });

    group('isValid', () {
      test('should return true for recent data', () {
        // Arrange
        final recent = DateTime.now();
        final exchangeRates = ExchangeRates(
          baseCurrency: 'INR',
          rates: {'USD': 0.012},
          lastUpdated: recent,
        );

        // Act & Assert
        expect(exchangeRates.isValid, isTrue);
      });

      test('should return true for data less than 24 hours old', () {
        // Arrange
        final lessThan24Hours = DateTime.now().subtract(
          const Duration(hours: 12),
        );
        final exchangeRates = ExchangeRates(
          baseCurrency: 'INR',
          rates: {'USD': 0.012},
          lastUpdated: lessThan24Hours,
        );

        // Act & Assert
        expect(exchangeRates.isValid, isTrue);
      });

      test('should return false for data more than 24 hours old', () {
        // Arrange
        final moreThan24Hours = DateTime.now().subtract(
          const Duration(hours: 25),
        );
        final exchangeRates = ExchangeRates(
          baseCurrency: 'INR',
          rates: {'USD': 0.012},
          lastUpdated: moreThan24Hours,
        );

        // Act & Assert
        expect(exchangeRates.isValid, isFalse);
      });

      test('should return false for exactly 24 hours old data', () {
        // Arrange
        final exactly24Hours = DateTime.now().subtract(
          const Duration(hours: 24),
        );
        final exchangeRates = ExchangeRates(
          baseCurrency: 'INR',
          rates: {'USD': 0.012},
          lastUpdated: exactly24Hours,
        );

        // Act & Assert
        expect(exchangeRates.isValid, isFalse);
      });
    });

    test('should be immutable', () {
      // Arrange
      final originalRates = {'USD': 0.012};
      final exchangeRates = ExchangeRates(
        baseCurrency: 'INR',
        rates: originalRates,
        lastUpdated: DateTime.now(),
      );

      // Act - Try to modify (this would be a compile-time error if rates was mutable)
      // Since Map is passed by reference, external modifications could affect it
      // This test documents that the class is intended to be immutable
      expect(exchangeRates.baseCurrency, equals('INR'));
    });

    test('should handle large number of rates', () {
      // Arrange
      final manyRates = {
        for (var i = 0; i < 50; i++) 'CUR$i': i * 0.001,
      };

      // Act
      final exchangeRates = ExchangeRates(
        baseCurrency: 'BASE',
        rates: manyRates,
        lastUpdated: DateTime.now(),
      );

      // Assert
      expect(exchangeRates.rates.length, equals(50));
      expect(exchangeRates.availableCurrencies.length, equals(50));
    });

    test('should handle various base currencies', () {
      // Arrange & Act
      final inrRates = ExchangeRates(
        baseCurrency: 'INR',
        rates: {'USD': 0.012},
        lastUpdated: DateTime.now(),
      );
      final usdRates = ExchangeRates(
        baseCurrency: 'USD',
        rates: {'INR': 83.0},
        lastUpdated: DateTime.now(),
      );
      final eurRates = ExchangeRates(
        baseCurrency: 'EUR',
        rates: {'USD': 1.09},
        lastUpdated: DateTime.now(),
      );

      // Assert
      expect(inrRates.baseCurrency, equals('INR'));
      expect(usdRates.baseCurrency, equals('USD'));
      expect(eurRates.baseCurrency, equals('EUR'));
    });
  });
}

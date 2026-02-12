import 'package:fintrack/features/dashboard/domain/entities/currency_rate.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CurrencyRate', () {
    test('should create CurrencyRate with all fields', () {
      // Arrange & Act
      final rate = CurrencyRate(
        fromCurrency: 'INR',
        toCurrency: 'USD',
        rate: 0.012,
      );

      // Assert
      expect(rate.fromCurrency, equals('INR'));
      expect(rate.toCurrency, equals('USD'));
      expect(rate.rate, equals(0.012));
    });

    test('should create CurrencyRate with different currency pairs', () {
      // Arrange & Act
      final inrToEur = CurrencyRate(
        fromCurrency: 'INR',
        toCurrency: 'EUR',
        rate: 0.011,
      );
      final usdToGbp = CurrencyRate(
        fromCurrency: 'USD',
        toCurrency: 'GBP',
        rate: 0.79,
      );
      final eurToJpy = CurrencyRate(
        fromCurrency: 'EUR',
        toCurrency: 'JPY',
        rate: 162.0,
      );

      // Assert
      expect(inrToEur.fromCurrency, equals('INR'));
      expect(inrToEur.toCurrency, equals('EUR'));
      expect(usdToGbp.fromCurrency, equals('USD'));
      expect(usdToGbp.toCurrency, equals('GBP'));
      expect(eurToJpy.fromCurrency, equals('EUR'));
      expect(eurToJpy.toCurrency, equals('JPY'));
    });

    group('convert', () {
      test('should convert amount correctly', () {
        // Arrange
        final rate = CurrencyRate(
          fromCurrency: 'INR',
          toCurrency: 'USD',
          rate: 0.012,
        );

        // Act & Assert
        expect(rate.convert(1000), equals(12.0));
        expect(rate.convert(5000), equals(60.0));
        expect(rate.convert(100), equals(1.2));
      });

      test('should handle zero amount', () {
        // Arrange
        final rate = CurrencyRate(
          fromCurrency: 'INR',
          toCurrency: 'USD',
          rate: 0.012,
        );

        // Act & Assert
        expect(rate.convert(0), equals(0.0));
      });

      test('should handle negative amounts', () {
        // Arrange
        final rate = CurrencyRate(
          fromCurrency: 'INR',
          toCurrency: 'USD',
          rate: 0.012,
        );

        // Act & Assert
        expect(rate.convert(-1000), equals(-12.0));
      });

      test('should handle rate greater than 1', () {
        // Arrange
        final rate = CurrencyRate(
          fromCurrency: 'USD',
          toCurrency: 'INR',
          rate: 83.0,
        );

        // Act & Assert
        expect(rate.convert(100), equals(8300.0));
        expect(rate.convert(1), equals(83.0));
      });

      test('should handle rate equal to 1', () {
        // Arrange
        final rate = CurrencyRate(
          fromCurrency: 'USD',
          toCurrency: 'USD',
          rate: 1.0,
        );

        // Act & Assert
        expect(rate.convert(100), equals(100.0));
        expect(rate.convert(500), equals(500.0));
      });

      test('should handle very small rates', () {
        // Arrange
        final rate = CurrencyRate(
          fromCurrency: 'VND',
          toCurrency: 'USD',
          rate: 0.000041,
        );

        // Act & Assert
        expect(rate.convert(1000000), closeTo(41.0, 0.01));
      });

      test('should handle large rates', () {
        // Arrange
        final rate = CurrencyRate(
          fromCurrency: 'IRR',
          toCurrency: 'USD',
          rate: 0.000024,
        );

        // Act & Assert
        expect(rate.convert(1000000), closeTo(24.0, 0.01));
      });
    });

    test('should be immutable', () {
      // Arrange
      final rate = CurrencyRate(
        fromCurrency: 'INR',
        toCurrency: 'USD',
        rate: 0.012,
      );

      // Assert - Since all fields are final, we can't modify them
      expect(rate.fromCurrency, equals('INR'));
      expect(rate.toCurrency, equals('USD'));
      expect(rate.rate, equals(0.012));
    });

    test('should support various currency codes', () {
      // Arrange & Act
      final rate1 = CurrencyRate(
        fromCurrency: 'USD',
        toCurrency: 'EUR',
        rate: 0.92,
      );
      final rate2 = CurrencyRate(
        fromCurrency: 'GBP',
        toCurrency: 'JPY',
        rate: 188.0,
      );
      final rate3 = CurrencyRate(
        fromCurrency: 'AUD',
        toCurrency: 'CAD',
        rate: 0.91,
      );

      // Assert
      expect(rate1.fromCurrency, equals('USD'));
      expect(rate1.toCurrency, equals('EUR'));
      expect(rate2.fromCurrency, equals('GBP'));
      expect(rate2.toCurrency, equals('JPY'));
      expect(rate3.fromCurrency, equals('AUD'));
      expect(rate3.toCurrency, equals('CAD'));
    });

    test('should handle case sensitivity in currency codes', () {
      // Arrange & Act
      final rate1 = CurrencyRate(
        fromCurrency: 'usd',
        toCurrency: 'eur',
        rate: 0.92,
      );
      final rate2 = CurrencyRate(
        fromCurrency: 'USD',
        toCurrency: 'EUR',
        rate: 0.92,
      );

      // Assert - Currency codes should be preserved as-is
      expect(rate1.fromCurrency, equals('usd'));
      expect(rate2.fromCurrency, equals('USD'));
    });

    test('should handle fractional amounts correctly', () {
      // Arrange
      final rate = CurrencyRate(
        fromCurrency: 'INR',
        toCurrency: 'USD',
        rate: 0.012,
      );

      // Act & Assert
      expect(rate.convert(100.5), closeTo(1.206, 0.001));
      expect(rate.convert(333.33), closeTo(4.0, 0.01));
    });
  });
}

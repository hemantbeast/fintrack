import 'package:fintrack/features/settings/domain/entities/currency.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Currency', () {
    test('should have all expected currencies', () {
      // Assert
      expect(Currency.values.length, equals(30));
      expect(Currency.values, contains(Currency.usd));
      expect(Currency.values, contains(Currency.eur));
      expect(Currency.values, contains(Currency.gbp));
      expect(Currency.values, contains(Currency.inr));
      expect(Currency.values, contains(Currency.jpy));
    });

    test('should have correct codes', () {
      // Assert
      expect(Currency.usd.code, equals('USD'));
      expect(Currency.eur.code, equals('EUR'));
      expect(Currency.gbp.code, equals('GBP'));
      expect(Currency.inr.code, equals('INR'));
      expect(Currency.jpy.code, equals('JPY'));
      expect(Currency.try_.code, equals('TRY'));
    });

    test('should have correct symbols', () {
      // Assert
      expect(Currency.usd.symbol, equals(r'$'));
      expect(Currency.eur.symbol, equals('€'));
      expect(Currency.gbp.symbol, equals('£'));
      expect(Currency.inr.symbol, equals('₹'));
      expect(Currency.jpy.symbol, equals('¥'));
    });

    test('should have correct names', () {
      // Assert
      expect(Currency.usd.name, equals('US Dollar'));
      expect(Currency.eur.name, equals('Euro'));
      expect(Currency.gbp.name, equals('British Pound'));
      expect(Currency.inr.name, equals('Indian Rupee'));
    });

    group('fromCode', () {
      test('should return correct currency for valid codes', () {
        // Assert
        expect(Currency.fromCode('USD'), equals(Currency.usd));
        expect(Currency.fromCode('EUR'), equals(Currency.eur));
        expect(Currency.fromCode('GBP'), equals(Currency.gbp));
        expect(Currency.fromCode('INR'), equals(Currency.inr));
      });

      test('should be case insensitive', () {
        // Assert
        expect(Currency.fromCode('usd'), equals(Currency.usd));
        expect(Currency.fromCode('Usd'), equals(Currency.usd));
        expect(Currency.fromCode('eUr'), equals(Currency.eur));
      });

      test('should return INR for invalid code', () {
        // Assert
        expect(Currency.fromCode('XXX'), equals(Currency.inr));
        expect(Currency.fromCode('INVALID'), equals(Currency.inr));
        expect(Currency.fromCode(''), equals(Currency.inr));
      });
    });

    group('maybeFromCode', () {
      test('should return currency for valid codes', () {
        // Assert
        expect(Currency.maybeFromCode('USD'), equals(Currency.usd));
        expect(Currency.maybeFromCode('EUR'), equals(Currency.eur));
      });

      test('should return null for invalid codes', () {
        // Assert
        expect(Currency.maybeFromCode('XXX'), isNull);
        expect(Currency.maybeFromCode('INVALID'), isNull);
        expect(Currency.maybeFromCode(''), isNull);
      });

      test('should be case insensitive', () {
        // Assert
        expect(Currency.maybeFromCode('usd'), equals(Currency.usd));
        expect(Currency.maybeFromCode('GBP'), equals(Currency.gbp));
      });
    });

    test('allCodes should return all currency codes', () {
      // Arrange
      final codes = Currency.allCodes;

      // Assert
      expect(codes.length, equals(30));
      expect(codes, contains('USD'));
      expect(codes, contains('EUR'));
      expect(codes, contains('INR'));
      expect(codes, contains('TRY'));
    });

    test('majorCodes should return major currency codes', () {
      // Arrange
      final major = Currency.majorCodes;

      // Assert
      expect(major.length, equals(13));
      expect(major, contains('INR'));
      expect(major, contains('USD'));
      expect(major, contains('EUR'));
      expect(major, contains('GBP'));
      expect(major, contains('JPY'));
      expect(major, isNot(contains('TRY'))); // TRY is not in major codes
    });

    group('format', () {
      test('should format amount with symbol', () {
        // Assert
        expect(Currency.usd.format(100), equals(r'$100.00'));
        expect(Currency.eur.format(50.5), equals('€50.50'));
        expect(Currency.gbp.format(0), equals('£0.00'));
        expect(Currency.inr.format(1000), equals('₹1000.00'));
      });

      test('should format negative amounts', () {
        // Assert
        expect(Currency.usd.format(-50), equals(r'$-50.00'));
        expect(Currency.eur.format(-100.5), equals('€-100.50'));
      });

      test('should format with 2 decimal places', () {
        // Assert
        expect(Currency.usd.format(100.999), equals(r'$101.00'));
        expect(Currency.usd.format(100.001), equals(r'$100.00'));
      });
    });

    group('formatWithCode', () {
      test('should format amount with code', () {
        // Assert
        expect(Currency.usd.formatWithCode(100), equals('USD 100.00'));
        expect(Currency.eur.formatWithCode(50.5), equals('EUR 50.50'));
        expect(Currency.inr.formatWithCode(1000), equals('INR 1000.00'));
      });
    });

    test('should support all major world currencies', () {
      // Arrange
      final majorCurrencies = [
        Currency.usd,
        Currency.eur,
        Currency.gbp,
        Currency.jpy,
        Currency.cad,
        Currency.aud,
        Currency.chf,
        Currency.cny,
        Currency.inr,
        Currency.brl,
        Currency.sgd,
        Currency.hkd,
        Currency.nzd,
      ];

      // Assert
      for (final currency in majorCurrencies) {
        expect(currency.code, isNotEmpty);
        expect(currency.symbol, isNotEmpty);
        expect(currency.name, isNotEmpty);
      }
    });
  });
}

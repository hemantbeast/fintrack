import 'package:fintrack/features/dashboard/data/models/exchange_rate_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExchangeRateModel', () {
    test('should create ExchangeRateModel with all fields', () {
      // Arrange & Act
      final model = ExchangeRateModel(
        result: 'success',
        baseCode: 'INR',
        conversionRates: {
          'USD': 0.012,
          'EUR': 0.011,
          'GBP': 0.0095,
        },
        timeLastUpdateUnix: 1705315200,
      );

      // Assert
      expect(model.result, equals('success'));
      expect(model.baseCode, equals('INR'));
      expect(model.conversionRates, isA<Map<String, dynamic>>());
      expect(model.conversionRates!['USD'], equals(0.012));
      expect(model.timeLastUpdateUnix, equals(1705315200));
    });

    test('should create ExchangeRateModel with null fields', () {
      // Arrange & Act
      final model = ExchangeRateModel();

      // Assert
      expect(model.result, isNull);
      expect(model.baseCode, isNull);
      expect(model.conversionRates, isNull);
      expect(model.timeLastUpdateUnix, isNull);
    });

    test('isValid should return true for recent data', () {
      // Arrange
      final now = DateTime.now();
      final recentTimestamp = now.millisecondsSinceEpoch ~/ 1000;
      final model = ExchangeRateModel(
        result: 'success',
        baseCode: 'INR',
        conversionRates: {'USD': 0.012},
        timeLastUpdateUnix: recentTimestamp,
      );

      // Act & Assert
      expect(model.isValid, isTrue);
    });

    test('isValid should return false for old data', () {
      // Arrange
      final oldTimestamp =
          DateTime.now().millisecondsSinceEpoch ~/ 1000 -
          90000; // More than 24 hours ago
      final model = ExchangeRateModel(
        result: 'success',
        baseCode: 'INR',
        conversionRates: {'USD': 0.012},
        timeLastUpdateUnix: oldTimestamp,
      );

      // Act & Assert
      expect(model.isValid, isFalse);
    });

    test('isValid should return false when timeLastUpdateUnix is null', () {
      // Arrange
      final model = ExchangeRateModel(
        result: 'success',
        baseCode: 'INR',
        conversionRates: {'USD': 0.012},
        timeLastUpdateUnix: null,
      );

      // Act & Assert
      expect(model.isValid, isFalse);
    });

    test('toEntity should convert to ExchangeRates correctly', () {
      // Arrange
      final now = DateTime.now();
      final timestamp = now.millisecondsSinceEpoch ~/ 1000;
      final model = ExchangeRateModel(
        result: 'success',
        baseCode: 'USD',
        conversionRates: {
          'INR': 83.0,
          'EUR': 0.92,
          'GBP': 0.79,
        },
        timeLastUpdateUnix: timestamp,
      );

      // Act
      final entity = model.toEntity();

      // Assert
      expect(entity.baseCurrency, equals('USD'));
      expect(entity.rates.length, equals(3));
      expect(entity.rates['INR'], equals(83.0));
      expect(entity.rates['EUR'], equals(0.92));
      expect(entity.rates['GBP'], equals(0.79));
      expect(
        entity.lastUpdated,
        equals(DateTime.fromMillisecondsSinceEpoch(timestamp * 1000)),
      );
    });

    test('toEntity should handle null conversionRates', () {
      // Arrange
      final model = ExchangeRateModel(
        result: 'success',
        baseCode: 'INR',
        conversionRates: null,
        timeLastUpdateUnix: 1705315200,
      );

      // Act
      final entity = model.toEntity();

      // Assert
      expect(entity.baseCurrency, equals('INR'));
      expect(entity.rates, isEmpty);
    });

    test('toEntity should handle null baseCode with default', () {
      // Arrange
      final model = ExchangeRateModel(
        result: 'success',
        baseCode: null,
        conversionRates: {'USD': 0.012},
        timeLastUpdateUnix: 1705315200,
      );

      // Act
      final entity = model.toEntity();

      // Assert
      expect(entity.baseCurrency, equals('INR'));
    });

    test('toEntity should skip non-numeric conversion rates', () {
      // Arrange
      final model = ExchangeRateModel(
        result: 'success',
        baseCode: 'INR',
        conversionRates: {
          'USD': 0.012,
          'INVALID': 'not a number',
          'EUR': 0.011,
        },
        timeLastUpdateUnix: 1705315200,
      );

      // Act
      final entity = model.toEntity();

      // Assert
      expect(entity.rates.length, equals(2));
      expect(entity.rates.containsKey('INVALID'), isFalse);
    });

    test('fromJson should deserialize correctly', () {
      // Arrange
      final json = {
        'result': 'success',
        'base_code': 'USD',
        'conversion_rates': {
          'INR': 83.0,
          'EUR': 0.92,
          'GBP': 0.79,
        },
        'time_last_update_unix': 1705315200,
      };

      // Act
      final model = ExchangeRateModel.fromJson(json);

      // Assert
      expect(model.result, equals('success'));
      expect(model.baseCode, equals('USD'));
      expect(model.conversionRates, isA<Map<String, dynamic>>());
      expect(model.conversionRates!['INR'], equals(83.0));
      expect(model.conversionRates!['EUR'], equals(0.92));
      expect(model.timeLastUpdateUnix, equals(1705315200));
    });

    test('fromJson should handle null values', () {
      // Arrange
      final json = <String, dynamic>{};

      // Act
      final model = ExchangeRateModel.fromJson(json);

      // Assert
      expect(model.result, isNull);
      expect(model.baseCode, isNull);
      expect(model.conversionRates, isNull);
      expect(model.timeLastUpdateUnix, isNull);
    });

    test('round-trip JSON conversion should preserve data', () {
      // Arrange
      final original = ExchangeRateModel(
        result: 'success',
        baseCode: 'EUR',
        conversionRates: {
          'USD': 1.09,
          'GBP': 0.85,
        },
        timeLastUpdateUnix: 1705315200,
      );

      // Act
      final json = original.toJson();
      final result = ExchangeRateModel.fromJson(json);

      // Assert
      expect(result.result, equals(original.result));
      expect(result.baseCode, equals(original.baseCode));
      expect(result.conversionRates, equals(original.conversionRates));
      expect(result.timeLastUpdateUnix, equals(original.timeLastUpdateUnix));
    });

    test('toJson should serialize correctly', () {
      // Arrange
      final model = ExchangeRateModel(
        result: 'success',
        baseCode: 'INR',
        conversionRates: {'USD': 0.012},
        timeLastUpdateUnix: 1705315200,
      );

      // Act
      final json = model.toJson();

      // Assert
      expect(json['result'], equals('success'));
      expect(json['base_code'], equals('INR'));
      expect(json['conversion_rates'], isA<Map<String, dynamic>>());
      expect(json['time_last_update_unix'], equals(1705315200));
    });
  });
}

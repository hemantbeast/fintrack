import 'package:fintrack/features/settings/domain/entities/user_preferences.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserPreferences', () {
    test('should create UserPreferences with default values', () {
      // Arrange & Act
      const preferences = UserPreferences();

      // Assert
      expect(preferences.currency, equals('INR'));
      expect(preferences.theme, equals(ThemeOption.system));
      expect(preferences.notificationsEnabled, isTrue);
      expect(preferences.budgetAlertsEnabled, isTrue);
      expect(preferences.recurringExpenseAlertsEnabled, isTrue);
      expect(preferences.weeklySummaryEnabled, isTrue);
    });

    test('should create UserPreferences with custom values', () {
      // Arrange & Act
      const preferences = UserPreferences(
        currency: 'USD',
        theme: ThemeOption.dark,
        notificationsEnabled: false,
        budgetAlertsEnabled: false,
        recurringExpenseAlertsEnabled: false,
        weeklySummaryEnabled: false,
      );

      // Assert
      expect(preferences.currency, equals('USD'));
      expect(preferences.theme, equals(ThemeOption.dark));
      expect(preferences.notificationsEnabled, isFalse);
      expect(preferences.budgetAlertsEnabled, isFalse);
      expect(preferences.recurringExpenseAlertsEnabled, isFalse);
      expect(preferences.weeklySummaryEnabled, isFalse);
    });

    test('copyWith should update currency', () {
      // Arrange
      const preferences = UserPreferences();

      // Act
      final updated = preferences.copyWith(currency: 'EUR');

      // Assert
      expect(updated.currency, equals('EUR'));
      expect(updated.theme, equals(ThemeOption.system));
      expect(updated.notificationsEnabled, isTrue);
    });

    test('copyWith should update theme', () {
      // Arrange
      const preferences = UserPreferences();

      // Act
      final updated = preferences.copyWith(theme: ThemeOption.light);

      // Assert
      expect(updated.theme, equals(ThemeOption.light));
      expect(updated.currency, equals('INR'));
    });

    test('copyWith should update notification settings', () {
      // Arrange
      const preferences = UserPreferences();

      // Act
      final updated = preferences.copyWith(
        notificationsEnabled: false,
        budgetAlertsEnabled: false,
        recurringExpenseAlertsEnabled: false,
        weeklySummaryEnabled: false,
      );

      // Assert
      expect(updated.notificationsEnabled, isFalse);
      expect(updated.budgetAlertsEnabled, isFalse);
      expect(updated.recurringExpenseAlertsEnabled, isFalse);
      expect(updated.weeklySummaryEnabled, isFalse);
    });

    test('copyWith should preserve unchanged values', () {
      // Arrange
      const preferences = UserPreferences(
        currency: 'GBP',
        theme: ThemeOption.dark,
        notificationsEnabled: false,
      );

      // Act
      final updated = preferences.copyWith(budgetAlertsEnabled: false);

      // Assert
      expect(updated.currency, equals('GBP'));
      expect(updated.theme, equals(ThemeOption.dark));
      expect(updated.notificationsEnabled, isFalse);
      expect(updated.budgetAlertsEnabled, isFalse);
      expect(updated.recurringExpenseAlertsEnabled, isTrue);
    });

    test('should support various currencies', () {
      // Arrange & Act
      const inr = UserPreferences(currency: 'INR');
      const usd = UserPreferences(currency: 'USD');
      const eur = UserPreferences(currency: 'EUR');
      const gbp = UserPreferences(currency: 'GBP');
      const jpy = UserPreferences(currency: 'JPY');

      // Assert
      expect(inr.currency, equals('INR'));
      expect(usd.currency, equals('USD'));
      expect(eur.currency, equals('EUR'));
      expect(gbp.currency, equals('GBP'));
      expect(jpy.currency, equals('JPY'));
    });

    test('should support all theme options', () {
      // Arrange & Act
      const light = UserPreferences(theme: ThemeOption.light);
      const dark = UserPreferences(theme: ThemeOption.dark);
      const system = UserPreferences(theme: ThemeOption.system);

      // Assert
      expect(light.theme, equals(ThemeOption.light));
      expect(dark.theme, equals(ThemeOption.dark));
      expect(system.theme, equals(ThemeOption.system));
    });

    test('should be immutable', () {
      // Arrange
      const preferences = UserPreferences(currency: 'USD');

      // Act
      final updated = preferences.copyWith(currency: 'EUR');

      // Assert
      expect(preferences.currency, equals('USD'));
      expect(updated.currency, equals('EUR'));
      expect(preferences, isNot(same(updated)));
    });
  });

  group('ThemeOption', () {
    test('should have three values', () {
      // Assert
      expect(ThemeOption.values.length, equals(3));
      expect(ThemeOption.values, contains(ThemeOption.light));
      expect(ThemeOption.values, contains(ThemeOption.dark));
      expect(ThemeOption.values, contains(ThemeOption.system));
    });
  });
}

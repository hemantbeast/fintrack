import 'package:fintrack/features/settings/data/models/user_preferences_model.dart';
import 'package:fintrack/features/settings/domain/entities/user_preferences.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserPreferencesModel', () {
    test('should create UserPreferencesModel with all fields', () {
      // Arrange & Act
      final model = UserPreferencesModel(
        currency: 'USD',
        theme: 'dark',
        notificationsEnabled: false,
        budgetAlertsEnabled: true,
        recurringExpenseAlertsEnabled: false,
        weeklySummaryEnabled: true,
      );

      // Assert
      expect(model.currency, equals('USD'));
      expect(model.theme, equals('dark'));
      expect(model.notificationsEnabled, isFalse);
      expect(model.budgetAlertsEnabled, isTrue);
      expect(model.recurringExpenseAlertsEnabled, isFalse);
      expect(model.weeklySummaryEnabled, isTrue);
    });

    test('should create UserPreferencesModel with null fields', () {
      // Arrange & Act
      final model = UserPreferencesModel();

      // Assert
      expect(model.currency, isNull);
      expect(model.theme, isNull);
      expect(model.notificationsEnabled, isNull);
      expect(model.budgetAlertsEnabled, isNull);
      expect(model.recurringExpenseAlertsEnabled, isNull);
      expect(model.weeklySummaryEnabled, isNull);
    });

    test('themeEnum should return correct ThemeOption', () {
      // Arrange
      final lightModel = UserPreferencesModel(theme: 'light');
      final darkModel = UserPreferencesModel(theme: 'dark');
      final systemModel = UserPreferencesModel(theme: 'system');
      final unknownModel = UserPreferencesModel(theme: 'unknown');
      final nullModel = UserPreferencesModel();

      // Act & Assert
      expect(lightModel.themeEnum, equals(ThemeOption.light));
      expect(darkModel.themeEnum, equals(ThemeOption.dark));
      expect(systemModel.themeEnum, equals(ThemeOption.system));
      expect(unknownModel.themeEnum, equals(ThemeOption.system));
      expect(nullModel.themeEnum, equals(ThemeOption.system));
    });

    test('fromEntity should create model from UserPreferences', () {
      // Arrange
      const entity = UserPreferences(
        currency: 'EUR',
        theme: ThemeOption.dark,
        notificationsEnabled: false,
        weeklySummaryEnabled: false,
      );

      // Act
      final model = UserPreferencesModel.fromEntity(entity);

      // Assert
      expect(model.currency, equals('EUR'));
      expect(model.theme, equals('dark'));
      expect(model.notificationsEnabled, isFalse);
      expect(model.budgetAlertsEnabled, isTrue);
      expect(model.recurringExpenseAlertsEnabled, isTrue);
      expect(model.weeklySummaryEnabled, isFalse);
    });

    test('toEntity should convert to UserPreferences with defaults', () {
      // Arrange
      final model = UserPreferencesModel(
        currency: 'GBP',
        theme: 'light',
        notificationsEnabled: true,
        budgetAlertsEnabled: false,
        recurringExpenseAlertsEnabled: false,
        weeklySummaryEnabled: true,
      );

      // Act
      final entity = model.toEntity();

      // Assert
      expect(entity.currency, equals('GBP'));
      expect(entity.theme, equals(ThemeOption.light));
      expect(entity.notificationsEnabled, isTrue);
      expect(entity.budgetAlertsEnabled, isFalse);
      expect(entity.recurringExpenseAlertsEnabled, isFalse);
      expect(entity.weeklySummaryEnabled, isTrue);
    });

    test('toEntity should use defaults for null values', () {
      // Arrange
      final model = UserPreferencesModel();

      // Act
      final entity = model.toEntity();

      // Assert
      expect(entity.currency, equals('INR'));
      expect(entity.theme, equals(ThemeOption.system));
      expect(entity.notificationsEnabled, isTrue);
      expect(entity.budgetAlertsEnabled, isTrue);
      expect(entity.recurringExpenseAlertsEnabled, isTrue);
      expect(entity.weeklySummaryEnabled, isTrue);
    });

    test('round-trip conversion should preserve data', () {
      // Arrange
      const original = UserPreferences(
        currency: 'JPY',
        theme: ThemeOption.dark,
        notificationsEnabled: false,
        budgetAlertsEnabled: false,
        recurringExpenseAlertsEnabled: false,
        weeklySummaryEnabled: false,
      );

      // Act
      final model = UserPreferencesModel.fromEntity(original);
      final result = model.toEntity();

      // Assert
      expect(result.currency, equals(original.currency));
      expect(result.theme, equals(original.theme));
      expect(
        result.notificationsEnabled,
        equals(original.notificationsEnabled),
      );
      expect(result.budgetAlertsEnabled, equals(original.budgetAlertsEnabled));
      expect(
        result.recurringExpenseAlertsEnabled,
        equals(original.recurringExpenseAlertsEnabled),
      );
      expect(
        result.weeklySummaryEnabled,
        equals(original.weeklySummaryEnabled),
      );
    });

    test('toJson should serialize correctly', () {
      // Arrange
      final model = UserPreferencesModel(
        currency: 'USD',
        theme: 'dark',
        notificationsEnabled: false,
        budgetAlertsEnabled: true,
        recurringExpenseAlertsEnabled: false,
        weeklySummaryEnabled: true,
      );

      // Act
      final json = model.toJson();

      // Assert
      expect(json['currency'], equals('USD'));
      expect(json['theme'], equals('dark'));
      expect(json['notifications_enabled'], isFalse);
      expect(json['budget_alerts_enabled'], isTrue);
      expect(json['recurring_expense_alerts_enabled'], isFalse);
      expect(json['weekly_summary_enabled'], isTrue);
    });
  });
}

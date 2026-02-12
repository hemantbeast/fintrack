import 'package:fintrack/features/settings/data/models/user_preferences_model.dart';
import 'package:fintrack/features/settings/data/models/user_profile_model.dart';
import 'package:fintrack/features/settings/data/sources/local/settings_local.dart';
import 'package:fintrack/features/settings/data/sources/remote/settings_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mocks for Settings Service
class MockSettingsService extends Mock implements SettingsService {}

class MockSettingsLocal extends Mock implements SettingsLocal {}

// Test fixtures for Settings
class SettingsTestFixtures {
  static UserProfileModel createUserProfileModel({
    String id = 'user-123',
    String name = 'John Doe',
    String email = 'john@example.com',
    String? avatar = 'https://example.com/avatar.png',
  }) {
    return UserProfileModel(
      id: id,
      name: name,
      email: email,
      avatar: avatar,
    );
  }

  static UserPreferencesModel createUserPreferencesModel({
    String currency = 'INR',
    String theme = 'system',
    bool notificationsEnabled = true,
    bool budgetAlertsEnabled = true,
    bool recurringExpenseAlertsEnabled = true,
    bool weeklySummaryEnabled = true,
  }) {
    return UserPreferencesModel(
      currency: currency,
      theme: theme,
      notificationsEnabled: notificationsEnabled,
      budgetAlertsEnabled: budgetAlertsEnabled,
      recurringExpenseAlertsEnabled: recurringExpenseAlertsEnabled,
      weeklySummaryEnabled: weeklySummaryEnabled,
    );
  }

  static List<UserPreferencesModel> createThemeVariants() {
    return [
      createUserPreferencesModel(theme: 'light'),
      createUserPreferencesModel(theme: 'dark'),
      createUserPreferencesModel(theme: 'system'),
    ];
  }

  static List<UserPreferencesModel> createCurrencyVariants() {
    return [
      createUserPreferencesModel(currency: 'INR'),
      createUserPreferencesModel(currency: 'USD'),
      createUserPreferencesModel(currency: 'EUR'),
      createUserPreferencesModel(currency: 'GBP'),
    ];
  }
}

// Helper verification functions
void verifyNeverSaveProfile(MockSettingsLocal local) {
  verifyNever(() => local.saveProfile(any()));
}

void verifyNeverSavePreferences(MockSettingsLocal local) {
  verifyNever(() => local.savePreferences(any()));
}

void verifySaveProfileCalledOnce(
  MockSettingsLocal local,
  UserProfileModel model,
) {
  verify(() => local.saveProfile(model)).called(1);
}

void verifySavePreferencesCalledOnce(
  MockSettingsLocal local,
  UserPreferencesModel model,
) {
  verify(() => local.savePreferences(model)).called(1);
}

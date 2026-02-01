import 'package:fintrack/core/utils/json_utils.dart';
import 'package:fintrack/features/settings/data/mock/mock_data.dart';
import 'package:fintrack/features/settings/data/models/user_preferences_model.dart';
import 'package:fintrack/features/settings/data/models/user_profile_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final settingsServiceProvider = Provider<SettingsService>((ref) {
  return SettingsService(ref: ref);
});

class SettingsService {
  SettingsService({required this.ref});

  final Ref ref;

  /// Fetches user profile from API
  Future<UserProfileModel> getProfile() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return JsonUtils.parseJson(userProfileMockJson, UserProfileModel.fromJson);
  }

  /// Updates user profile via API
  Future<UserProfileModel> updateProfile(UserProfileModel profile) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return profile;
  }

  /// Fetches user preferences from API
  Future<UserPreferencesModel> getPreferences() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return JsonUtils.parseJson(
      userPreferencesMockJson,
      UserPreferencesModel.fromJson,
    );
  }

  /// Updates user preferences via API
  Future<UserPreferencesModel> updatePreferences(
    UserPreferencesModel preferences,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return preferences;
  }

  /// Clears all user data (for logout/reset)
  Future<void> clearAllData() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }
}

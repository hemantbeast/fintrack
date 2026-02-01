import 'package:fintrack/features/settings/data/models/user_preferences_model.dart';
import 'package:fintrack/features/settings/data/models/user_profile_model.dart';
import 'package:fintrack/hive/hive_keys.dart';
import 'package:fintrack/hive/hive_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final settingsLocalProvider = Provider<SettingsLocal>((ref) {
  return SettingsLocal(ref: ref);
});

class SettingsLocal {
  SettingsLocal({required this.ref}) {
    _storage = ref.read(hiveStorageProvider);
  }

  final Ref ref;
  late HiveStorage _storage;

  /// Get local user profile data
  Future<UserProfileModel?> getProfile() async {
    final profile = await _storage.getItemByKey<UserProfileModel>(
      HiveBoxes.userProfile,
    );
    return profile;
  }

  /// Save user profile data to local storage
  Future<void> saveProfile(UserProfileModel profile) async {
    await _storage.saveItem<UserProfileModel>(HiveBoxes.userProfile, profile);
  }

  /// Get local user preferences data
  Future<UserPreferencesModel?> getPreferences() async {
    final preferences = await _storage.getItemByKey<UserPreferencesModel>(
      HiveBoxes.userPreferences,
    );
    return preferences;
  }

  /// Save user preferences data to local storage
  Future<void> savePreferences(UserPreferencesModel preferences) async {
    await _storage.saveItem<UserPreferencesModel>(
      HiveBoxes.userPreferences,
      preferences,
    );
  }

  /// Clear all settings data
  Future<void> clearAllData() async {
    await _storage.deleteItem<dynamic>(HiveBoxes.userProfile);
    await _storage.deleteItem<dynamic>(HiveBoxes.userPreferences);
  }
}

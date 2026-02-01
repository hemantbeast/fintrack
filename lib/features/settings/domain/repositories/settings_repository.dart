import 'package:fintrack/features/settings/domain/entities/user_preferences.dart';
import 'package:fintrack/features/settings/domain/entities/user_profile.dart';

abstract class SettingsRepository {
  /// Returns a stream of user profile (cache-first with background refresh)
  Stream<UserProfile> watchProfile();

  /// Returns a stream of user preferences (cache-first with background refresh)
  Stream<UserPreferences> watchPreferences();

  /// Update user profile
  Future<void> updateProfile(UserProfile profile);

  /// Update user preferences
  Future<void> updatePreferences(UserPreferences preferences);

  /// Clear all user data (for logout/reset)
  Future<void> clearAllData();
}

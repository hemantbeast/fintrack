import 'dart:async';

import 'package:fintrack/features/settings/data/models/user_preferences_model.dart';
import 'package:fintrack/features/settings/data/models/user_profile_model.dart';
import 'package:fintrack/features/settings/data/sources/local/settings_local.dart';
import 'package:fintrack/features/settings/data/sources/remote/settings_service.dart';
import 'package:fintrack/features/settings/domain/entities/user_preferences.dart';
import 'package:fintrack/features/settings/domain/entities/user_profile.dart';
import 'package:fintrack/features/settings/domain/repositories/settings_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final service = ref.read(settingsServiceProvider);
  final local = ref.read(settingsLocalProvider);

  return SettingsRepositoryImpl(service: service, local: local);
});

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl({
    required this.service,
    required this.local,
  });

  final SettingsService service;
  final SettingsLocal local;

  /// Get user profile with stale-while-revalidate strategy
  @override
  Stream<UserProfile> watchProfile() async* {
    // Get cached data from local storage
    final cachedProfile = await local.getProfile();

    if (cachedProfile != null) {
      yield cachedProfile.toEntity();
    }

    try {
      // Fetch data from API
      final profile = await service.getProfile();
      await local.saveProfile(profile);

      // Yield fresh data
      yield profile.toEntity();
    } on Exception catch (_) {
      // Throw error if fetching fails
      if (cachedProfile == null) {
        rethrow;
      }
    }
  }

  /// Get user preferences with stale-while-revalidate strategy
  @override
  Stream<UserPreferences> watchPreferences() async* {
    // Get cached data from local storage
    final cachedPreferences = await local.getPreferences();

    if (cachedPreferences != null) {
      yield cachedPreferences.toEntity();
    }

    try {
      // Fetch data from API
      final preferences = await service.getPreferences();
      await local.savePreferences(preferences);

      // Yield fresh data
      yield preferences.toEntity();
    } on Exception catch (_) {
      // Throw error if fetching fails
      if (cachedPreferences == null) {
        rethrow;
      }
    }
  }

  /// Update user profile
  @override
  Future<void> updateProfile(UserProfile profile) async {
    final model = UserProfileModel.fromEntity(profile);
    final updated = await service.updateProfile(model);
    await local.saveProfile(updated);
  }

  /// Update user preferences
  @override
  Future<void> updatePreferences(UserPreferences preferences) async {
    final model = UserPreferencesModel.fromEntity(preferences);
    final updated = await service.updatePreferences(model);
    await local.savePreferences(updated);
  }

  /// Clear all user data
  @override
  Future<void> clearAllData() async {
    await service.clearAllData();
    await local.clearAllData();
  }
}

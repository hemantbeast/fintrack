import 'dart:async';

import 'package:fintrack/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:fintrack/features/dashboard/domain/entities/exchange_rates.dart';
import 'package:fintrack/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:fintrack/features/settings/domain/entities/currency.dart';
import 'package:fintrack/features/settings/domain/entities/user_preferences.dart';
import 'package:fintrack/features/settings/domain/entities/user_profile.dart';
import 'package:fintrack/features/settings/ui/states/settings_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

final settingsProvider = NotifierProvider<SettingsNotifier, SettingsState>(
  SettingsNotifier.new,
);

class SettingsNotifier extends Notifier<SettingsState> {
  StreamSubscription<UserProfile>? _profileSubscription;
  StreamSubscription<UserPreferences>? _preferencesSubscription;
  StreamSubscription<ExchangeRates>? _exchangeRatesSubscription;

  UserProfile? _latestProfile;
  UserPreferences? _latestPreferences;
  ExchangeRates? _latestExchangeRates;

  @override
  SettingsState build() {
    // Cleanup subscriptions when provider is disposed
    ref.onDispose(() {
      _profileSubscription?.cancel();
      _preferencesSubscription?.cancel();
      _exchangeRatesSubscription?.cancel();
    });

    Future.microtask(_getVersion);

    // Start listening to streams
    _setupStreams();

    return SettingsState.initial();
  }

  /// Get app version
  Future<void> _getVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    state = state.copyWith(version: packageInfo.version);
  }

  void _setupStreams() {
    final repository = ref.read(settingsRepositoryProvider);

    // Listen to profile stream
    _profileSubscription = repository.watchProfile().listen(
      (profile) {
        _latestProfile = profile;
        _updateState();
      },
      onError: (Object error, StackTrace stack) {
        state = state.copyWith(screenData: AsyncError(error, stack));
      },
    );

    // Listen to preferences stream
    _preferencesSubscription = repository.watchPreferences().listen(
      (preferences) {
        _latestPreferences = preferences;
        _updateState();
      },
      onError: (Object error, StackTrace stack) {
        state = state.copyWith(screenData: AsyncError(error, stack));
      },
    );

    // Listen to exchange rates stream for available currencies
    final dashboardRepository = ref.read(dashboardRepositoryProvider);
    _exchangeRatesSubscription = dashboardRepository.watchExchangeRates().listen(
      (rates) {
        _latestExchangeRates = rates;
        _updateState();
      },
      onError: (Object error, StackTrace stack) {
        // Log error but don't fail - we can use default currencies
        debugPrint('Exchange rate error in settings: $error');
      },
    );
  }

  void _updateState() {
    if (_latestProfile == null || _latestPreferences == null) {
      state = state.copyWith(screenData: const AsyncLoading());
      return;
    }

    state = state.copyWith(
      screenData: AsyncData(
        SettingsScreenData(
          profile: _latestProfile!,
          preferences: _latestPreferences!,
          exchangeRates: _latestExchangeRates,
        ),
      ),
    );
  }

  /// Get list of available currencies from exchange rates or use defaults
  List<Currency> get availableCurrencies {
    if (_latestExchangeRates == null) {
      // Return major currencies if no exchange rates available
      return Currency.majorCodes.map(Currency.fromCode).toList();
    }

    // Filter currencies that are available in exchange rates
    final availableCodes = _latestExchangeRates!.availableCurrencies;
    return availableCodes.map(Currency.maybeFromCode).whereType<Currency>().toList()..sort((a, b) => a.code.compareTo(b.code));
  }

  Future<void> updateProfile(UserProfile profile) async {
    final repository = ref.read(settingsRepositoryProvider);
    await repository.updateProfile(profile);
  }

  Future<void> updatePreferences(UserPreferences preferences) async {
    final repository = ref.read(settingsRepositoryProvider);
    await repository.updatePreferences(preferences);
  }

  Future<void> clearAllData() async {
    final repository = ref.read(settingsRepositoryProvider);
    await repository.clearAllData();
  }

  Future<void> refresh() async {
    // Cancel existing subscriptions
    await _profileSubscription?.cancel();
    await _preferencesSubscription?.cancel();
    await _exchangeRatesSubscription?.cancel();

    // Clear current data
    _latestProfile = null;
    _latestPreferences = null;
    _latestExchangeRates = null;

    // Show loading state
    state = state.copyWith(screenData: const AsyncLoading());

    // Re-setup streams to fetch fresh data
    _setupStreams();
  }
}

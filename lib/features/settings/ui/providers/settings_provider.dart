import 'dart:async';

import 'package:fintrack/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:fintrack/features/dashboard/domain/entities/exchange_rates.dart';
import 'package:fintrack/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:fintrack/features/settings/domain/entities/currency.dart';
import 'package:fintrack/features/settings/domain/entities/user_preferences.dart';
import 'package:fintrack/features/settings/domain/entities/user_profile.dart';
import 'package:fintrack/features/settings/ui/states/settings_state.dart';
import 'package:fintrack/themes/theme_manager.dart';
import 'package:flutter/material.dart';
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

        // Apply saved theme when preferences are loaded
        final mode = switch (preferences.theme) {
          ThemeOption.light => ThemeMode.light,
          ThemeOption.dark => ThemeMode.dark,
          ThemeOption.system => ThemeMode.system,
        };
        ref.read(themeProvider.notifier).updateMode(mode);

        _updateState();

        // Refresh exchange rates when currency changes
        _refreshExchangeRatesIfNeeded(preferences.currency);
      },
      onError: (Object error, StackTrace stack) {
        state = state.copyWith(screenData: AsyncError(error, stack));
      },
    );

    // Get initial currency preference and set up exchange rates stream
    _setupExchangeRatesStream();
  }

  String _currentExchangeRateCurrency = 'INR';

  Future<void> _setupExchangeRatesStream() async {
    // Get current preferences to determine the base currency
    final repository = ref.read(settingsRepositoryProvider);
    final preferences = await repository.getPreferences();
    final baseCurrency = preferences?.currency ?? 'INR';
    _currentExchangeRateCurrency = baseCurrency;

    // Listen to exchange rates stream for available currencies
    final dashboardRepository = ref.read(dashboardRepositoryProvider);
    _exchangeRatesSubscription = dashboardRepository
        .watchExchangeRates(baseCurrency: baseCurrency)
        .listen(
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

  void _refreshExchangeRatesIfNeeded(String newCurrency) {
    // If the currency has changed, we need to refresh exchange rates
    if (newCurrency != _currentExchangeRateCurrency) {
      _currentExchangeRateCurrency = newCurrency;

      // Cancel existing subscription
      _exchangeRatesSubscription?.cancel();

      // Set up new stream with new base currency
      final dashboardRepository = ref.read(dashboardRepositoryProvider);
      _exchangeRatesSubscription = dashboardRepository
          .watchExchangeRates(baseCurrency: newCurrency)
          .listen(
            (rates) {
              _latestExchangeRates = rates;
              _updateState();
            },
            onError: (Object error, StackTrace stack) {
              debugPrint('Exchange rate error in settings: $error');
            },
          );
    }
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

    // Update local state immediately so UI reflects changes
    _latestProfile = profile;
    _updateState();
  }

  Future<void> updatePreferences(UserPreferences preferences) async {
    final repository = ref.read(settingsRepositoryProvider);

    final mode = switch (preferences.theme) {
      ThemeOption.light => ThemeMode.light,
      ThemeOption.dark => ThemeMode.dark,
      ThemeOption.system => ThemeMode.system,
    };

    ref.read(themeProvider.notifier).updateMode(mode);
    await repository.updatePreferences(preferences);

    // Update local state immediately so UI reflects changes
    _latestPreferences = preferences;

    // Refresh exchange rates if currency changed
    _refreshExchangeRatesIfNeeded(preferences.currency);

    _updateState();
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

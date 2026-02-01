import 'package:fintrack/features/dashboard/domain/entities/exchange_rates.dart';
import 'package:fintrack/features/settings/domain/entities/user_preferences.dart';
import 'package:fintrack/features/settings/domain/entities/user_profile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_state.freezed.dart';

@freezed
abstract class SettingsState with _$SettingsState {
  const factory SettingsState({
    required AsyncValue<SettingsScreenData> screenData,
    @Default('') String version,
  }) = _SettingsState;

  factory SettingsState.initial() {
    return const SettingsState(screenData: AsyncLoading());
  }
}

class SettingsScreenData {
  SettingsScreenData({
    required this.profile,
    required this.preferences,
    this.exchangeRates,
  });

  final UserProfile profile;
  final UserPreferences preferences;
  final ExchangeRates? exchangeRates;

  SettingsScreenData copyWith({
    UserProfile? profile,
    UserPreferences? preferences,
    ExchangeRates? exchangeRates,
  }) {
    return SettingsScreenData(
      profile: profile ?? this.profile,
      preferences: preferences ?? this.preferences,
      exchangeRates: exchangeRates ?? this.exchangeRates,
    );
  }
}

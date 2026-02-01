import 'package:fintrack/themes/dark_theme.dart';
import 'package:fintrack/themes/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'theme_manager.freezed.dart';

final themeProvider = NotifierProvider<ThemeNotifier, ThemeState>(ThemeNotifier.new);

class ThemeNotifier extends Notifier<ThemeState> {
  @override
  ThemeState build() {
    return ThemeState.initial();
  }

  void updateMode(ThemeMode mode) {
    state = state.copyWith(mode: mode);
  }
}

@freezed
abstract class ThemeState with _$ThemeState {
  const factory ThemeState({
    required ThemeData lightTheme,
    required ThemeData darkTheme,
    required ThemeMode mode,
  }) = _ThemeState;

  factory ThemeState.initial() => ThemeState(
    lightTheme: lightTheme,
    darkTheme: darkTheme,
    mode: ThemeMode.light,
  );
}

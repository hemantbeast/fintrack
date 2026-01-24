import 'package:fintrack/themes/colors.dart';
import 'package:flutter/material.dart';

const _lightColorScheme = ColorScheme.light(
  primary: primaryColor,
  secondary: secondaryColor,
  surface: backgroundColor,
  error: errorColor,
  tertiary: accentColor,
);

final lightTheme = ThemeData(
  useMaterial3: false,
  colorScheme: _lightColorScheme,
);

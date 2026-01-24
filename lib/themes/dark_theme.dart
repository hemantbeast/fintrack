import 'package:fintrack/themes/colors.dart';
import 'package:fintrack/themes/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _darkColorScheme = ColorScheme.dark(
  primary: primaryColor,
  onPrimary: Colors.white,
  primaryContainer: Color(0xFF4E47CC),
  onPrimaryContainer: Color(0xFFDFDCFF),
  secondary: secondaryColor,
  onSecondary: Colors.white,
  secondaryContainer: Color(0xFF388E3C),
  onSecondaryContainer: Color(0xFFC8E6C9),
  tertiary: accentColor,
  onTertiary: Colors.white,
  tertiaryContainer: Color(0xFFCC5555),
  onTertiaryContainer: Color(0xFFFFDADA),
  error: errorColor,
  onError: Colors.white,
  surface: Color(0xFF1B1C1E),
  onSurface: Color(0xFFE3E2E6),
  surfaceContainerHighest: Color(0xFF3B3C3E),
  outline: Color(0xFF5C5D60),
  shadow: Colors.black,
);

final _darkCustomTheme = CustomTheme(
  blackWhiteColor: Colors.white70,
  whiteBlackColor: Colors.black87,
  whiteBgColor: const Color(0xFF1B1C1E),
  shimmerBaseColor: Colors.grey.shade900,
  shimmerHighlightColor: Colors.grey.shade700,
  navigationTitleStyle: defaultTextStyle(
    color: Colors.white70,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  ),
  blackTextStyle: defaultTextStyle(
    color: Colors.white70,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  ),
  grayTextStyle: defaultTextStyle(
    color: Colors.grey.shade400,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  ),
  lightGrayTextStyle: defaultTextStyle(
    color: Colors.grey.shade600,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  ),
  whiteTextStyle: defaultTextStyle(
    color: Colors.white,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  ),
);

final darkTheme = ThemeData(
  useMaterial3: false,
  colorScheme: _darkColorScheme,
  extensions: [_darkCustomTheme],
  dividerTheme: DividerThemeData(
    color: _darkColorScheme.outline,
    space: 1,
    thickness: 0.75,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: _darkColorScheme.primary,
    systemOverlayStyle: SystemUiOverlayStyle.light,
    shadowColor: _darkColorScheme.shadow.withValues(alpha: 0.2),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: _darkColorScheme.primary,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 1,
      backgroundColor: _darkColorScheme.primary,
      foregroundColor: _darkColorScheme.onPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      textStyle: defaultTextStyle(
        color: _darkColorScheme.onPrimary,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
    ),
  ),
  iconTheme: IconThemeData(
    color: _darkColorScheme.onSurface,
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(10),
    ),
    filled: true,
    fillColor: gray33,
    prefixIconColor: _darkColorScheme.onSurface,
    suffixIconColor: _darkColorScheme.onSurface,
    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    constraints: const BoxConstraints(minHeight: 54),
    hintStyle: defaultTextStyle(
      color: gray98,
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    labelStyle: defaultTextStyle(
      color: _darkColorScheme.onSurface,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: _darkColorScheme.primary,
      minimumSize: const Size(50, 35),
      shadowColor: Colors.transparent,
      textStyle: defaultTextStyle(
        color: _darkColorScheme.primary,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
    ),
  ),
  dialogTheme: DialogThemeData(backgroundColor: _darkColorScheme.onPrimary),
);

import 'package:fintrack/themes/colors.dart';
import 'package:fintrack/themes/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _lightColorScheme = ColorScheme.light(
  primary: primaryColor,
  primaryContainer: Color(0xFF8A84FF),
  onPrimaryContainer: Color(0xFF1A0072),
  secondary: secondaryColor,
  secondaryContainer: Color(0xFF7BC67E),
  onSecondaryContainer: Color(0xFF003A03),
  tertiary: accentColor,
  tertiaryContainer: Color(0xFFFF9999),
  onTertiaryContainer: Color(0xFF5F0000),
  error: errorColor,
  surface: backgroundColor,
  onSurface: textColor,
  surfaceContainerHighest: Color(0xFFEBECF0),
  outline: Color(0xFFDCDCE0),
  shadow: Colors.black,
);

final _lightCustomTheme = CustomTheme(
  blackWhiteColor: Colors.black87,
  whiteBlackColor: Colors.white,
  whiteBgColor: const Color(0xFFFDFCFA),
  shimmerBaseColor: Colors.grey.shade300,
  shimmerHighlightColor: Colors.grey.shade100,
  navigationTitleStyle: defaultTextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  ),
  blackTextStyle: defaultTextStyle(
    color: Colors.black87,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  ),
  grayTextStyle: defaultTextStyle(
    color: gray98,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  ),
  lightGrayTextStyle: defaultTextStyle(
    color: grayF5,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  ),
  whiteTextStyle: defaultTextStyle(
    color: Colors.white,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  ),
);

final lightTheme = ThemeData(
  useMaterial3: false,
  colorScheme: _lightColorScheme,
  extensions: [_lightCustomTheme],
  dividerTheme: DividerThemeData(
    color: _lightColorScheme.outline,
    space: 1,
    thickness: 0.75,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: _lightColorScheme.primary,
    systemOverlayStyle: SystemUiOverlayStyle.light,
    shadowColor: _lightColorScheme.shadow.withValues(alpha: 0.2),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    foregroundColor: _lightColorScheme.onPrimary,
    backgroundColor: _lightColorScheme.primary,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 1,
      backgroundColor: _lightColorScheme.primary,
      foregroundColor: _lightColorScheme.onPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      textStyle: defaultTextStyle(
        color: _lightColorScheme.onPrimary,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
    ),
  ),
  iconTheme: IconThemeData(
    color: _lightColorScheme.onSurface,
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(10),
    ),
    filled: true,
    fillColor: grayF5,
    prefixIconColor: _lightColorScheme.onSurface,
    suffixIconColor: _lightColorScheme.onSurface,
    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    constraints: const BoxConstraints(minHeight: 54),
    hintStyle: defaultTextStyle(
      color: gray98,
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    labelStyle: defaultTextStyle(
      color: _lightColorScheme.onSurface,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: _lightColorScheme.primary,
      minimumSize: const Size(50, 35),
      shadowColor: Colors.transparent,
      textStyle: defaultTextStyle(
        color: _lightColorScheme.primary,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
    ),
  ),
  dialogTheme: DialogThemeData(backgroundColor: _lightColorScheme.onPrimary),
);

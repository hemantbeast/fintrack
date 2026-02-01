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
  surface: darkSurfaceColor,
  surfaceContainerHighest: darkCardColor,
  outline: darkBorderColor,
  shadow: Colors.black,
);

final _darkCustomTheme = CustomTheme(
  blackWhiteColor: darkTextPrimary,
  whiteBlackColor: darkBackgroundColor,
  whiteBgColor: darkBackgroundColor,
  shimmerBaseColor: const Color(0xFF2A2A2A),
  shimmerHighlightColor: const Color(0xFF3A3A3A),
  navigationTitleStyle: defaultTextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  ),
  blackTextStyle: defaultTextStyle(
    color: darkTextPrimary,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  ),
  grayTextStyle: defaultTextStyle(
    color: darkTextSecondary,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  ),
  lightGrayTextStyle: defaultTextStyle(
    color: darkTextMuted,
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
  brightness: Brightness.dark,
  colorScheme: _darkColorScheme,
  extensions: [_darkCustomTheme],
  dividerTheme: DividerThemeData(
    color: _darkColorScheme.outline,
    space: 1,
    thickness: 0.75,
  ),
  scaffoldBackgroundColor: darkBackgroundColor,
  cardColor: darkCardColor,
  appBarTheme: AppBarTheme(
    backgroundColor: darkSurfaceColor,
    foregroundColor: darkTextPrimary,
    systemOverlayStyle: SystemUiOverlayStyle.light,
    shadowColor: _darkColorScheme.shadow.withValues(alpha: 0.3),
    elevation: 0,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    foregroundColor: _darkColorScheme.onPrimary,
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
    fillColor: darkInputColor,
    prefixIconColor: darkTextSecondary,
    suffixIconColor: darkTextSecondary,
    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    constraints: const BoxConstraints(minHeight: 54),
    hintStyle: defaultTextStyle(
      color: darkTextMuted,
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    labelStyle: defaultTextStyle(
      color: darkTextPrimary,
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
  dialogTheme: DialogThemeData(
    backgroundColor: darkSurfaceColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
  switchTheme: SwitchThemeData(
    trackColor: WidgetStatePropertyAll(_darkColorScheme.secondaryContainer),
    thumbColor: WidgetStatePropertyAll(_darkColorScheme.secondary),
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: darkSurfaceColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadiusGeometry.vertical(
        top: Radius.circular(15),
      ),
    ),
  ),
  cardTheme: CardThemeData(
    color: darkCardColor,
    elevation: 2,
    shadowColor: Colors.black.withValues(alpha: 0.3),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  ),
  listTileTheme: const ListTileThemeData(
    tileColor: darkCardColor,
    selectedTileColor: darkInputColor,
    iconColor: darkTextSecondary,
    textColor: darkTextPrimary,
  ),
);

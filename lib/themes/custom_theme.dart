import 'package:fintrack/core/extensions/color_extensions.dart';
import 'package:fintrack/core/extensions/context_extensions.dart';
import 'package:fintrack/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

part 'custom_theme.tailor.dart';

@TailorMixin()
class CustomTheme extends ThemeExtension<CustomTheme> with _$CustomThemeTailorMixin {
  CustomTheme({
    required this.blackWhiteColor,
    required this.whiteBlackColor,
    required this.whiteBgColor,
    required this.shimmerBaseColor,
    required this.shimmerHighlightColor,
    required this.navigationTitleStyle,
    required this.blackTextStyle,
    required this.grayTextStyle,
    required this.lightGrayTextStyle,
    required this.whiteTextStyle,
  });

  @override
  final Color blackWhiteColor;

  @override
  final Color whiteBlackColor;

  @override
  final Color whiteBgColor;

  @override
  final Color shimmerBaseColor;

  @override
  final Color shimmerHighlightColor;

  @override
  final TextStyle navigationTitleStyle;

  @override
  final TextStyle blackTextStyle;

  @override
  final TextStyle grayTextStyle;

  @override
  final TextStyle lightGrayTextStyle;

  @override
  final TextStyle whiteTextStyle;
}

// primary color text style
TextStyle primaryTextStyle(BuildContext context) {
  if (context.isDarkTheme) {
    return defaultTextStyle(
      color: primaryColor.toMaterialColor.shade100,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    );
  }
  return defaultTextStyle(
    color: primaryColor,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
}

// primary color text button style
ButtonStyle primaryTextButtonStyle(BuildContext context) {
  if (context.isDarkTheme) {
    return textButtonStyle(
      textColor: primaryColor.toMaterialColor.shade100,
      fontSize: 15,
      fontWeight: FontWeight.w500,
    );
  }
  return textButtonStyle(
    textColor: primaryColor,
    fontSize: 15,
    fontWeight: FontWeight.w500,
  );
}

// primary button style
ButtonStyle primaryButtonStyle(BuildContext context) {
  return ElevatedButton.styleFrom(
    disabledBackgroundColor: grayF9,
    fixedSize: Size(context.screenWidth - 40, 54),
  );
}

// default text style
TextStyle defaultTextStyle({
  required Color? color,
  required double? fontSize,
  required FontWeight? fontWeight,
  double? letterSpacing,
  double? height = 1.4,
}) {
  return TextStyle(
    color: color,
    fontSize: fontSize,
    letterSpacing: letterSpacing,
    height: height,
    fontFamily: 'GoogleSansFlex',
    fontVariations: [
      FontVariation('wght', fontWeight?.value.toDouble() ?? 400),
    ],
  );
}

// bold text style
TextStyle boldTextStyle({
  required Color? color,
  required double? fontSize,
  double? letterSpacing,
  double? height = 1.4,
}) {
  return TextStyle(
    color: color,
    fontSize: fontSize,
    letterSpacing: letterSpacing,
    height: height,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.bold,
  );
}

// semi-bold text style
TextStyle semiboldTextStyle({
  required Color? color,
  required double? fontSize,
  double? letterSpacing,
  double? height = 1.4,
}) {
  return TextStyle(
    color: color,
    fontSize: fontSize,
    letterSpacing: letterSpacing,
    height: height,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w600,
  );
}

// button style
ButtonStyle buttonStyle({
  Color? textColor,
  double? fontSize,
  FontWeight? fontWeight,
}) {
  return ElevatedButton.styleFrom(
    foregroundColor: textColor,
    textStyle: defaultTextStyle(
      color: textColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
    ),
  );
}

// text button style
ButtonStyle textButtonStyle({
  required Color? textColor,
  required double? fontSize,
  required FontWeight? fontWeight,
}) {
  return TextButton.styleFrom(
    foregroundColor: textColor,
    textStyle: defaultTextStyle(
      color: textColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
    ),
  );
}

// text field border
OutlineInputBorder textFieldBorder({
  required Color color,
  double? width,
  BorderRadius? borderRadius,
}) {
  width ??= 0.75;
  borderRadius ??= BorderRadius.circular(8);

  return OutlineInputBorder(
    borderRadius: borderRadius,
    borderSide: BorderSide(
      color: color,
      width: width,
    ),
  );
}

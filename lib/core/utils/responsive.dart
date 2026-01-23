import 'package:fintrack/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

class Responsive {
  static bool isMobile(BuildContext context) => context.screenWidth < 600;

  static bool isTablet(BuildContext context) => context.screenWidth >= 600 && context.screenWidth < 900;

  static bool isDesktop(BuildContext context) => context.screenWidth >= 900;

  static bool isSmallPhone(BuildContext context) => isMobile(context) && context.screenWidth < 360;

  static bool isLargePhone(BuildContext context) => isMobile(context) && context.screenWidth > 450;

  // Get responsive value
  static T value<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop(context) && desktop != null) return desktop;
    if (isTablet(context) && tablet != null) return tablet;
    return mobile;
  }

  // Responsive padding
  static double horizontalPadding(BuildContext context) {
    return value(
      context,
      mobile: 16,
      tablet: 24,
      desktop: 32,
    );
  }

  // Responsive font sizes
  static double fontSize(BuildContext context, double baseSize) {
    return value(
      context,
      mobile: baseSize,
      tablet: baseSize * 1.1,
      desktop: baseSize * 1.2,
    );
  }

  // Get responsive columns for grid
  static int gridCrossAxisCount(BuildContext context) {
    return value(
      context,
      mobile: 2,
      tablet: 3,
      desktop: 4,
    );
  }
}

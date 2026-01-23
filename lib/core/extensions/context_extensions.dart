import 'package:fintrack/core/platform/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

extension ContextExt on BuildContext {
  double get screenHeight => MediaQuery.sizeOf(this).height;

  double get screenWidth => MediaQuery.sizeOf(this).width;

  double get statusBarHeight => MediaQuery.viewPaddingOf(this).top;

  bool get isSmallDevice => screenHeight < 700;

  bool get isIPad => MediaQuery.sizeOf(this).shortestSide > 600;

  bool get isPortrait => MediaQuery.orientationOf(this) == Orientation.portrait;

  ThemeData get theme => Theme.of(this);

  bool get isDarkTheme => theme.brightness == Brightness.dark;

  bool get isIPhoneX => isIOS && View.of(this).viewPadding.bottom > 0;

  double get bottomInset => MediaQuery.viewInsetsOf(this).bottom;

  double get bottomMargin {
    return MediaQuery.viewPaddingOf(this).bottom + 10.0;
  }

  double get bottomPadding {
    return bottomInset > 0
        ? bottomInset
        : isIPad && isPortrait
        ? 60.0
        : bottomMargin;
  }

  double get popupBottomMargin {
    return bottomInset > 0 ? bottomInset : bottomMargin;
  }

  // read a provider from context
  T readProvider<T>(ProviderListenable<T> provider) {
    return ProviderScope.containerOf(this, listen: false).read(provider);
  }

  // read a notifier from context
  T? readNotifier<T, Y>(ProviderBase<Y> provider, Refreshable<T> notifier) {
    if (ProviderScope.containerOf(this, listen: false).exists(provider)) {
      return ProviderScope.containerOf(this, listen: false).read(notifier);
    }
    return null;
  }

  // refresh provider from context
  T? refreshProvider<T>(ProviderBase<T> provider) {
    if (ProviderScope.containerOf(this, listen: false).exists(provider)) {
      return ProviderScope.containerOf(this, listen: false).refresh(provider);
    } else {
      return null;
    }
  }
}

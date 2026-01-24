import 'dart:async';

import 'package:fintrack/generated/l10n.dart';
import 'package:fintrack/hive/index.dart';
import 'package:fintrack/routes/app_router.dart';
import 'package:fintrack/themes/theme_manager.dart';
import 'package:fintrack/widgets/custom_image.dart';
import 'package:fintrack/widgets/error_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FintrackApp extends ConsumerStatefulWidget {
  const FintrackApp({super.key});

  @override
  ConsumerState createState() => _FintrackAppState();
}

class _FintrackAppState extends ConsumerState<FintrackApp> {
  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);

    return MaterialApp.router(
      title: 'FinTrack',
      debugShowCheckedModeBanner: false,
      theme: theme.lightTheme,
      darkTheme: theme.darkTheme,
      themeMode: theme.mode,
      routerConfig: AppRouter.router,
      localizationsDelegates: const [
        S.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      builder: (context, child) {
        ErrorWidget.builder = _buildErrorWidget;

        if (child == null) {
          return const SizedBox.shrink();
        }

        return UnFocusWidget(child: child);
      },
    );
  }

  @override
  void dispose() {
    CacheImageManager().instance.dispose();

    if (kReleaseMode) {
      unawaited(ref.read(hiveStorageProvider).closeAllBoxes());
    }
    super.dispose();
  }

  /// Custom error widget builder
  Widget _buildErrorWidget(FlutterErrorDetails errorDetails) {
    return ErrorView(error: errorDetails);
  }
}

class UnFocusWidget extends StatelessWidget {
  const UnFocusWidget({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: child,
    );
  }
}

import 'package:fintrack/core/utils/responsive.dart';
import 'package:fintrack/generated/assets.dart';
import 'package:fintrack/generated/l10n.dart';
import 'package:fintrack/routes/app_router.dart';
import 'package:fintrack/routes/route_enum.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:navigation_history_observer/navigation_history_observer.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({required this.error, super.key});

  final FlutterErrorDetails error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          padding: EdgeInsets.zero,
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            try {
              final history = NavigationHistoryObserver().history;

              if (history.length > 1) {
                final lastIndex = history.indexOf(history.last);
                final pageSettings = history[lastIndex - 1].settings;

                if (pageSettings.name != null && pageSettings.name!.isNotEmpty) {
                  AppRouter.popUntil(pageSettings.name!);
                  return;
                }
              }
              AppRouter.startNewRoute(RouteEnum.dashboardScreen.name);
            } on Exception catch (_) {
              AppRouter.startNewRoute(RouteEnum.dashboardScreen.name);
            }
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (Responsive.isSmallPhone(context)) ...{
              const SizedBox(height: 70),
            } else ...{
              const SizedBox(height: 100),
            },
            Lottie.asset(
              Assets.lottieIcError,
              frameRate: const FrameRate(60),
              height: 250,
              width: 250,
              repeat: true,
              addRepaintBoundary: true,
              options: LottieOptions(enableMergePaths: true),
            ),
            const SizedBox(height: 8),
            Text(
              S.of(context).somethingWentWrong,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              S.of(context).somethingWentWrongDesc,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

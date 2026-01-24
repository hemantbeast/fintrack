import 'package:fintrack/features/onboarding/providers/onboarding_provider.dart';
import 'package:fintrack/features/onboarding/widgets/onboarding_widget.dart';
import 'package:fintrack/generated/l10n.dart';
import 'package:fintrack/hive/settings.dart';
import 'package:fintrack/routes/app_router.dart';
import 'package:fintrack/routes/route_enum.dart';
import 'package:fintrack/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingPage extends ConsumerWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: _completeOnboarding,
                  child: Text(
                    S.of(context).skip,
                    style: const TextStyle(
                      fontSize: 16,
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            // Page view
            Expanded(
              child: PageView(
                controller: notifier.pageController,
                onPageChanged: notifier.setPage,
                children: [
                  OnboardingWidget(
                    icon: Icons.account_balance_wallet_rounded,
                    iconColor: primaryColor,
                    title: S.of(context).onboarding1Title,
                    description: S.of(context).onboarding1Description,
                  ),
                  OnboardingWidget(
                    icon: Icons.analytics_outlined,
                    iconColor: secondaryColor,
                    title: S.of(context).onboarding2Title,
                    description: S.of(context).onboarding2Description,
                  ),
                  OnboardingWidget(
                    icon: Icons.rocket_launch_rounded,
                    iconColor: accentColor,
                    title: S.of(context).onboarding3Title,
                    description: S.of(context).onboarding3Description,
                  ),
                ],
              ),
            ),

            // Page indicators
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: provider.currentPage == index ? 32 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: provider.currentPage == index ? primaryColor : primaryColor.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),

            // Navigation buttons
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button (only show if not on first page)
                  if (provider.currentPage > 0)
                    TextButton(
                      onPressed: notifier.previousPage,
                      child: const Icon(
                        Icons.arrow_back,
                        color: primaryColor,
                      ),
                    )
                  else
                    const SizedBox(width: 48),

                  // Next/Get Started button
                  ElevatedButton(
                    onPressed: provider.isLoading
                        ? null
                        : () {
                            if (provider.currentPage < 2) {
                              notifier.nextPage();
                            } else {
                              _completeOnboarding();
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 2,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          provider.currentPage < 2 ? S.of(context).next : S.of(context).getStarted,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (provider.isLoading)
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        else
                          const Icon(Icons.arrow_forward, size: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _completeOnboarding() {
    Settings.isOnboardingShown = true;
    // Replace onboarding with dashboard (can't go back)
    AppRouter.startNewRoute(RouteEnum.dashboardScreen.name);
  }
}

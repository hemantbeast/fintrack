import 'package:fintrack/features/onboarding/states/onboarding_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final onboardingProvider = NotifierProvider.autoDispose<OnboardingNotifier, OnboardingState>(
  OnboardingNotifier.new,
);

class OnboardingNotifier extends Notifier<OnboardingState> {
  late PageController pageController;

  @override
  OnboardingState build() {
    pageController = PageController();

    ref.onDispose(() {
      pageController.dispose();
    });
    return const OnboardingState();
  }

  void setPage(int page) {
    state = state.copyWith(currentPage: page);
  }

  void nextPage() {
    if (state.currentPage < 2) {
      state = state.copyWith(currentPage: state.currentPage + 1);
    }

    pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void previousPage() {
    if (state.currentPage > 0) {
      state = state.copyWith(currentPage: state.currentPage - 1);
    }

    pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}

import 'dart:async';

import 'package:fintrack/features/budget/data/repositories/budget_repository_impl.dart';
import 'package:fintrack/features/budget/domain/entities/budget.dart';
import 'package:fintrack/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:fintrack/features/dashboard/domain/entities/exchange_rates.dart';
import 'package:fintrack/features/dashboard/domain/entities/transaction.dart';
import 'package:fintrack/features/dashboard/ui/states/dashboard_state.dart';
import 'package:fintrack/features/settings/ui/providers/settings_provider.dart';
import 'package:fintrack/features/settings/ui/states/settings_state.dart';
import 'package:fintrack/providers/transactions_stream_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dashboardProvider = NotifierProvider<DashboardNotifier, DashboardState>(DashboardNotifier.new);

class DashboardNotifier extends Notifier<DashboardState> {
  StreamSubscription<List<Budget>>? _budgetsSubscription;
  StreamSubscription<ExchangeRates>? _exchangeRatesSubscription;

  List<Transaction>? _latestTransactions;
  List<Budget>? _latestBudgets;
  ExchangeRates? _latestExchangeRates;

  String _currentBaseCurrency = 'INR';

  @override
  DashboardState build() {
    // Cleanup subscriptions when provider is disposed
    ref.onDispose(() {
      _budgetsSubscription?.cancel();
      _exchangeRatesSubscription?.cancel();
    });

    // Listen to shared transactions provider for reactive updates
    ref.listen<AsyncValue<List<Transaction>>>(
      transactionsStreamProvider,
      (previous, next) {
        next.whenData((transactions) {
          _latestTransactions = transactions;
          _updateState();
        });
      },
      fireImmediately: true,
    );

    // Listen to settings provider for currency changes
    ref.listen<SettingsState>(
      settingsProvider,
      (previous, next) {
        next.screenData.whenData((data) {
          final newCurrency = data.preferences.currency;
          if (newCurrency != _currentBaseCurrency) {
            _currentBaseCurrency = newCurrency;
            _refreshExchangeRates(newCurrency);
          }
        });
      },
    );

    // Start listening to other streams
    _setupStreams();

    return DashboardState.initial();
  }

  void _setupStreams() {
    // Listen to budgets stream from budget repository
    final budgetRepository = ref.read(budgetRepositoryProvider);
    _budgetsSubscription = budgetRepository.watchBudgets().listen(
      (budgets) {
        _latestBudgets = budgets;
        _updateState();
      },
      onError: (error) {
        // Ignore budget errors if we have other data
      },
    );

    // Get user's preferred currency from settings
    final settingsState = ref.read(settingsProvider);
    _currentBaseCurrency = settingsState.screenData.when(
      data: (data) => data.preferences.currency,
      loading: () => 'INR',
      error: (_, _) => 'INR',
    );

    // Listen to exchange rates stream from dashboard repository
    _setupExchangeRatesStream(_currentBaseCurrency);
  }

  void _setupExchangeRatesStream(String baseCurrency) {
    final dashboardRepository = ref.read(dashboardRepositoryProvider);
    _exchangeRatesSubscription = dashboardRepository
        .watchExchangeRates(baseCurrency: baseCurrency)
        .listen(
          (rates) {
            _latestExchangeRates = rates;
            _updateState();
          },
          onError: (Object error, StackTrace stackTrace) {
            // Log exchange rate errors for debugging
            debugPrint('Exchange rate error: $error');
            debugPrint('Stack trace: $stackTrace');
          },
        );
  }

  void _refreshExchangeRates(String newCurrency) {
    // Cancel existing subscription
    _exchangeRatesSubscription?.cancel();
    // Set up new stream with new base currency
    _setupExchangeRatesStream(newCurrency);
  }

  void _updateState() {
    // Only update if we have transactions data
    if (_latestTransactions == null) {
      state = state.copyWith(screenData: const AsyncLoading());
      return;
    }

    // Compute balance from transactions
    final transactionsNotifier = ref.read(transactionsStreamProvider.notifier);
    final computedBalance = transactionsNotifier.computeBalance();

    state = state.copyWith(
      screenData: AsyncData(
        DashboardScreenData(
          balance: computedBalance,
          recentTransactions: _latestTransactions ?? [],
          budgets: _latestBudgets ?? [],
          exchangeRates: _latestExchangeRates,
        ),
      ),
    );
  }

  Future<void> refresh() async {
    // Cancel existing subscriptions
    await _budgetsSubscription?.cancel();
    await _exchangeRatesSubscription?.cancel();

    // Clear current data
    _latestTransactions = null;
    _latestBudgets = null;
    _latestExchangeRates = null;

    // Show loading state
    state = state.copyWith(screenData: const AsyncLoading());

    // Refresh shared transactions
    await ref.read(transactionsStreamProvider.notifier).refresh();

    // Re-setup streams to fetch fresh data
    _setupStreams();
  }
}

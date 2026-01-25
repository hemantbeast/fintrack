import 'dart:async';

import 'package:fintrack/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:fintrack/features/dashboard/domain/entities/budget.dart';
import 'package:fintrack/features/dashboard/domain/entities/exchange_rates.dart';
import 'package:fintrack/features/dashboard/domain/entities/transaction.dart';
import 'package:fintrack/features/dashboard/ui/states/dashboard_state.dart';
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

    // Start listening to other streams
    _setupStreams();

    return DashboardState.initial();
  }

  void _setupStreams() {
    final repository = ref.read(dashboardRepositoryProvider);

    // Listen to budgets stream
    _budgetsSubscription = repository.watchBudgets().listen(
      (budgets) {
        _latestBudgets = budgets;
        _updateState();
      },
      onError: (error) {
        // Ignore budget errors if we have other data
      },
    );

    // Listen to exchange rates stream
    _exchangeRatesSubscription = repository.watchExchangeRates().listen(
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

  void _updateStateWithError(Object error, [StackTrace? stackTrace]) {
    // If we have no data at all, show error
    if (_latestTransactions == null && _latestBudgets == null) {
      state = state.copyWith(
        screenData: AsyncError(error, stackTrace ?? StackTrace.current),
      );
    }
    // Otherwise keep showing existing data
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

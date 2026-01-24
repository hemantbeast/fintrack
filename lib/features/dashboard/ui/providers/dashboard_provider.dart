import 'dart:async';

import 'package:fintrack/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:fintrack/features/dashboard/domain/entities/balance.dart';
import 'package:fintrack/features/dashboard/domain/entities/budget.dart';
import 'package:fintrack/features/dashboard/domain/entities/transaction.dart';
import 'package:fintrack/features/dashboard/ui/states/dashboard_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dashboardProvider = NotifierProvider<DashboardNotifier, DashboardState>(DashboardNotifier.new);

class DashboardNotifier extends Notifier<DashboardState> {
  StreamSubscription<Balance>? _balanceSubscription;
  StreamSubscription<List<Transaction>>? _transactionsSubscription;
  StreamSubscription<List<Budget>>? _budgetsSubscription;

  Balance? _latestBalance;
  List<Transaction>? _latestTransactions;
  List<Budget>? _latestBudgets;

  @override
  DashboardState build() {
    // Cleanup subscriptions when provider is disposed
    ref.onDispose(() {
      _balanceSubscription?.cancel();
      _transactionsSubscription?.cancel();
      _budgetsSubscription?.cancel();
    });

    // Start listening to streams
    _setupStreams();

    return DashboardState.initial();
  }

  void _setupStreams() {
    final repository = ref.read(dashboardRepositoryProvider);

    // Listen to balance stream
    _balanceSubscription = repository.watchBalance().listen(
      (balance) {
        _latestBalance = balance;
        _updateState();
      },
      onError: (Object error) {
        _updateStateWithError(error);
      },
    );

    // Listen to transactions stream
    _transactionsSubscription = repository.watchTransactions().listen(
      (transactions) {
        _latestTransactions = transactions;
        _updateState();
      },
      onError: (error) {
        // Ignore transaction errors if we have other data
      },
    );

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
  }

  void _updateState() {
    // Only update if we have at least some data
    if (_latestBalance == null && _latestTransactions == null && _latestBudgets == null) {
      state = state.copyWith(screenData: const AsyncLoading());
      return;
    }

    state = state.copyWith(
      screenData: AsyncData(
        DashboardScreenData(
          balance: _latestBalance ?? Balance(currentBalance: 0, income: 0, expenses: 0),
          recentTransactions: _latestTransactions ?? [],
          budgets: _latestBudgets ?? [],
        ),
      ),
    );
  }

  void _updateStateWithError(Object error, [StackTrace? stackTrace]) {
    // If we have no data at all, show error
    if (_latestBalance == null && _latestTransactions == null && _latestBudgets == null) {
      state = state.copyWith(
        screenData: AsyncError(error, stackTrace ?? StackTrace.current),
      );
    }
    // Otherwise keep showing existing data
  }

  Future<void> refresh() async {
    // Cancel existing subscriptions
    await _balanceSubscription?.cancel();
    await _transactionsSubscription?.cancel();
    await _budgetsSubscription?.cancel();

    // Clear current data
    _latestBalance = null;
    _latestTransactions = null;
    _latestBudgets = null;

    // Show loading state
    state = state.copyWith(screenData: const AsyncLoading());

    // Re-setup streams to fetch fresh data
    _setupStreams();
  }
}

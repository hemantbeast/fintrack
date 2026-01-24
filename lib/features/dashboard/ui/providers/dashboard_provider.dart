import 'dart:async';

import 'package:fintrack/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:fintrack/features/dashboard/domain/entities/balance.dart';
import 'package:fintrack/features/dashboard/domain/entities/budget.dart';
import 'package:fintrack/features/dashboard/domain/entities/transaction.dart';
import 'package:fintrack/features/dashboard/ui/states/dashboard_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dashboardProvider = NotifierProvider<DashboardNotifier, DashboardState>(DashboardNotifier.new);

// Stream providers for each data type (cache-first with background refresh)
final balanceStreamProvider = StreamProvider<Balance>((ref) {
  final repository = ref.watch(dashboardRepositoryProvider);
  return repository.watchBalance();
});

final transactionsStreamProvider = StreamProvider<List<Transaction>>((ref) {
  final repository = ref.watch(dashboardRepositoryProvider);
  return repository.watchTransactions();
});

final budgetsStreamProvider = StreamProvider<List<Budget>>((ref) {
  final repository = ref.watch(dashboardRepositoryProvider);
  return repository.watchBudgets();
});

class DashboardNotifier extends Notifier<DashboardState> {
  @override
  DashboardState build() {
    Future<void>.delayed(Duration.zero, _listenStreamChanges);
    return DashboardState.initial();
  }

  void _listenStreamChanges() {
    final balance = ref.watch(balanceStreamProvider);
    final transactions = ref.watch(transactionsStreamProvider);
    final budgets = ref.watch(budgetsStreamProvider);

    final screenData = _combineScreenData(balance, transactions, budgets);
    state = state.copyWith(screenData: screenData);
  }

  AsyncValue<DashboardScreenData> _combineScreenData(
    AsyncValue<Balance> balance,
    AsyncValue<List<Transaction>> transactions,
    AsyncValue<List<Budget>> budgets,
  ) {
    final allProviders = [balance, transactions, budgets];

    // Check if we have ANY data from any provider
    final hasAnyData = allProviders.any((provider) => provider.hasValue);

    // Show loading ONLY if ALL are loading AND no data yet
    if (!hasAnyData) {
      final allLoading = allProviders.every((provider) => provider.isLoading);
      if (allLoading) {
        return const AsyncLoading();
      }

      // All providers failed and no cached data available
      final allHaveError = allProviders.every((provider) => provider.hasError);
      if (allHaveError) {
        return AsyncError(allProviders.first.error!, allProviders.first.stackTrace!);
      }
    }

    // Safely extract values with fallbacks
    // Use .hasValue check before accessing .value to avoid throws
    final balanceData = balance.hasValue ? balance.value! : Balance(currentBalance: 0, income: 0, expenses: 0);

    final transactionsData = transactions.hasValue ? transactions.value! : <Transaction>[];

    final budgetsData = budgets.hasValue ? budgets.value! : <Budget>[];

    return AsyncData(
      DashboardScreenData(
        balance: balanceData,
        recentTransactions: transactionsData,
        budgets: budgetsData,
      ),
    );
  }

  Future<void> refresh() async {
    // Invalidate all stream providers to trigger fresh data fetch
    ref.invalidate(balanceStreamProvider);
    ref.invalidate(transactionsStreamProvider);
    ref.invalidate(budgetsStreamProvider);
  }
}

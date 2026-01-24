import 'package:fintrack/features/dashboard/data/repositories/dashboard_repository.dart';
import 'package:fintrack/features/dashboard/ui/states/dashboard_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dashboardProvider = NotifierProvider<DashboardNotifier, DashboardState>(DashboardNotifier.new);

class DashboardNotifier extends Notifier<DashboardState> {
  @override
  DashboardState build() {
    Future.delayed(Duration.zero, _loadDashboardData);
    return DashboardState.initial();
  }

  Future<void> _loadDashboardData() async {
    state = state.copyWith(isLoading: true);

    // Simulate network delay
    await Future<void>.delayed(const Duration(milliseconds: 500));

    final repository = ref.read(dashboardRepositoryProvider);
    final balance = repository.getBalance();
    final transactions = repository.getRecentTransactions();
    final budgets = repository.getBudgetOverview();

    state = state.copyWith(
      balance: balance,
      recentTransactions: transactions,
      budgets: budgets,
      isLoading: false,
    );
  }

  Future<void> refresh() async {
    await _loadDashboardData();
  }
}

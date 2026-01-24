import 'package:fintrack/features/dashboard/domain/entities/balance.dart';
import 'package:fintrack/features/dashboard/domain/entities/budget.dart';
import 'package:fintrack/features/dashboard/domain/entities/transaction.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_state.freezed.dart';

@freezed
abstract class DashboardState with _$DashboardState {
  const factory DashboardState({
    required Balance balance,
    @Default([]) List<Transaction> recentTransactions,
    @Default([]) List<Budget> budgets,
    @Default(true) bool isLoading,
  }) = _DashboardState;

  factory DashboardState.initial() {
    return DashboardState(
      balance: Balance(currentBalance: 0, income: 0, expenses: 0),
    );
  }
}

import 'package:fintrack/features/dashboard/domain/entities/balance.dart';
import 'package:fintrack/features/dashboard/domain/entities/budget.dart';
import 'package:fintrack/features/dashboard/domain/entities/transaction.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_state.freezed.dart';

@freezed
abstract class DashboardState with _$DashboardState {
  const factory DashboardState({
    required AsyncValue<DashboardScreenData> screenData,
  }) = _DashboardState;

  factory DashboardState.initial() {
    return const DashboardState(screenData: AsyncLoading());
  }
}

class DashboardScreenData {
  DashboardScreenData({
    required this.balance,
    required this.recentTransactions,
    required this.budgets,
  });

  final Balance balance;
  final List<Transaction> recentTransactions;
  final List<Budget> budgets;

  DashboardScreenData copyWith({
    Balance? balance,
    List<Transaction>? recentTransactions,
    List<Budget>? budgets,
  }) {
    return DashboardScreenData(
      balance: balance ?? this.balance,
      recentTransactions: recentTransactions ?? this.recentTransactions,
      budgets: budgets ?? this.budgets,
    );
  }
}

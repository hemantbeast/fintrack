import 'package:fintrack/features/budget/domain/entities/budget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'budget_planning_state.freezed.dart';

class BudgetStats {
  const BudgetStats({
    required this.totalSpent,
    required this.totalLimit,
    required this.percentage,
  });

  final double totalSpent;
  final double totalLimit;
  final double percentage;

  double get remaining => (totalLimit - totalSpent).clamp(0, totalLimit);
}

@freezed
abstract class BudgetPlanningState with _$BudgetPlanningState {
  const factory BudgetPlanningState({
    required AsyncValue<List<Budget>> budgets,
    required BudgetStats stats,
  }) = _BudgetPlanningState;

  factory BudgetPlanningState.initial() {
    return const BudgetPlanningState(
      budgets: AsyncLoading(),
      stats: BudgetStats(totalSpent: 0, totalLimit: 0, percentage: 0),
    );
  }
}

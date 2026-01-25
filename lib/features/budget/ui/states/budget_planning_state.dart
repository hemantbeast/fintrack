import 'package:fintrack/features/dashboard/domain/entities/budget.dart';
import 'package:fintrack/providers/budgets_stream_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'budget_planning_state.freezed.dart';

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

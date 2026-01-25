import 'package:fintrack/features/budget/domain/entities/budget.dart';
import 'package:fintrack/features/expenses/domain/entities/category.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_budget_state.freezed.dart';

@freezed
abstract class AddBudgetState with _$AddBudgetState {
  const factory AddBudgetState({
    required AsyncValue<List<ExpenseCategory>> categories,
    @Default(0) double limitAmount,
    @Default(false) bool isLoading,
    @Default(false) bool isSaved,
    @Default(true) bool alertAt75,
    @Default(true) bool alertAt90,
    @Default(true) bool alertWhenExceeded,
    String? errorMessage,
    ExpenseCategory? selectedCategory,
    Budget? editingBudget,
  }) = _AddBudgetState;

  factory AddBudgetState.initial() {
    return const AddBudgetState(
      categories: AsyncLoading(),
    );
  }
}

extension AddBudgetStateX on AddBudgetState {
  bool get isValid => selectedCategory != null && limitAmount > 0;

  bool get isEditing => editingBudget != null;
}

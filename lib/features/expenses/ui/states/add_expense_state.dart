import 'package:fintrack/features/expenses/domain/entities/category.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_expense_state.freezed.dart';

enum ExpenseFrequency { daily, weekly, monthly, yearly }

@freezed
abstract class AddExpenseState with _$AddExpenseState {
  const factory AddExpenseState({
    required AsyncValue<List<ExpenseCategory>> categories,
    required DateTime selectedDate,
    @Default(0) double amount,
    @Default('') String title,
    @Default('') String description,
    @Default(false) bool isRecurring,
    @Default(false) bool isLoading,
    @Default('') String? errorMessage,
    @Default(false) bool isSaved,
    ExpenseCategory? selectedCategory,
    ExpenseFrequency? frequency,
  }) = _AddExpenseState;

  factory AddExpenseState.initial() {
    return AddExpenseState(
      categories: const AsyncLoading(),
      selectedDate: DateTime.now(),
    );
  }
}

extension AddExpenseStateX on AddExpenseState {
  bool get isValid => selectedCategory != null && amount > 0 && title.isNotEmpty;
}

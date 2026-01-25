import 'package:fintrack/features/expenses/domain/entities/category.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_expense_state.freezed.dart';

enum ExpenseFrequency { daily, weekly, monthly, yearly }

@freezed
abstract class AddExpenseState with _$AddExpenseState {
  const factory AddExpenseState({
    required AsyncValue<List<ExpenseCategory>> categories,
    required ExpenseCategory? selectedCategory,
    required DateTime selectedDate,
    required double amount,
    required String description,
    required bool isRecurring,
    required ExpenseFrequency? frequency,
    required bool isLoading,
    required String? errorMessage,
    required bool isSaved,
  }) = _AddExpenseState;

  factory AddExpenseState.initial() {
    return AddExpenseState(
      categories: const AsyncLoading(),
      selectedCategory: null,
      selectedDate: DateTime.now(),
      amount: 0,
      description: '',
      isRecurring: false,
      frequency: null,
      isLoading: false,
      errorMessage: null,
      isSaved: false,
    );
  }
}

extension AddExpenseStateX on AddExpenseState {
  bool get isValid =>
      selectedCategory != null &&
      amount > 0 &&
      description.isNotEmpty;
}

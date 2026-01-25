import 'dart:async';

import 'package:fintrack/features/dashboard/domain/entities/transaction.dart';
import 'package:fintrack/features/expenses/data/repositories/expenses_repository_impl.dart';
import 'package:fintrack/features/expenses/domain/entities/category.dart';
import 'package:fintrack/features/expenses/ui/states/add_expense_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final addExpenseProvider = NotifierProvider<AddExpenseNotifier, AddExpenseState>(
  AddExpenseNotifier.new,
);

class AddExpenseNotifier extends Notifier<AddExpenseState> {
  StreamSubscription<List<ExpenseCategory>>? _categoriesSubscription;
  List<ExpenseCategory>? _latestCategories;

  @override
  AddExpenseState build() {
    ref.onDispose(() => _categoriesSubscription?.cancel());
    _setupStreams();
    return AddExpenseState.initial();
  }

  void _setupStreams() {
    final repository = ref.read(expensesRepositoryProvider);

    _categoriesSubscription = repository.watchCategories().listen(
      (categories) {
        _latestCategories = categories;
        _updateCategoriesState();
      },
      onError: (Object error, StackTrace stack) {
        state = state.copyWith(
          categories: AsyncError(error, stack),
        );
      },
    );
  }

  void _updateCategoriesState() {
    state = state.copyWith(
      categories: AsyncData(_latestCategories ?? []),
    );
  }

  void onCategoryChanged(ExpenseCategory? category) {
    state = state.copyWith(
      selectedCategory: category,
      errorMessage: null,
    );
  }

  void onDateChanged(DateTime? date) {
    if (date == null) return;
    state = state.copyWith(
      selectedDate: date,
      errorMessage: null,
    );
  }

  void onAmountChanged(String value) {
    final amount = double.tryParse(value) ?? 0;
    state = state.copyWith(
      amount: amount,
      errorMessage: null,
    );
  }

  void onDescriptionChanged(String value) {
    state = state.copyWith(
      description: value,
      errorMessage: null,
    );
  }

  // ignore: avoid_positional_boolean_parameters
  void onRecurringChanged(bool value) {
    state = state.copyWith(
      isRecurring: value,
      frequency: value ? ExpenseFrequency.monthly : null,
      errorMessage: null,
    );
  }

  void onFrequencyChanged(ExpenseFrequency? frequency) {
    state = state.copyWith(
      frequency: frequency,
      errorMessage: null,
    );
  }

  Future<void> saveExpense() async {
    if (!state.isValid) {
      state = state.copyWith(
        errorMessage: 'Please fill all required fields',
      );
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final repository = ref.read(expensesRepositoryProvider);

      final transaction = Transaction(
        id: const Uuid().v4(),
        title: state.selectedCategory!.name,
        category: state.selectedCategory!.name,
        amount: state.amount,
        description: state.description,
        date: state.selectedDate,
        type: TransactionType.expense,
        emoji: state.selectedCategory!.icon,
        isRecurring: state.isRecurring,
        frequency: state.frequency?.name,
      );

      await repository.saveTransaction(transaction);

      state = state.copyWith(
        isLoading: false,
        isSaved: true,
      );
    } on Exception catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  void reset() {
    state = AddExpenseState.initial().copyWith(
      categories: AsyncData(_latestCategories ?? []),
    );
  }
}

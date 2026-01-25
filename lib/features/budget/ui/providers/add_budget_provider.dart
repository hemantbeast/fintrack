import 'dart:async';

import 'package:fintrack/features/budget/ui/states/add_budget_state.dart';
import 'package:fintrack/features/dashboard/domain/entities/budget.dart';
import 'package:fintrack/features/expenses/data/repositories/expenses_repository_impl.dart';
import 'package:fintrack/features/expenses/domain/entities/category.dart';
import 'package:fintrack/providers/budgets_stream_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final addBudgetProvider =
    NotifierProvider.autoDispose<AddBudgetNotifier, AddBudgetState>(
  AddBudgetNotifier.new,
);

class AddBudgetNotifier extends Notifier<AddBudgetState> {
  StreamSubscription<List<ExpenseCategory>>? _categoriesSubscription;
  List<ExpenseCategory>? _latestCategories;

  @override
  AddBudgetState build() {
    ref.onDispose(() => _categoriesSubscription?.cancel());
    _setupStreams();
    return AddBudgetState.initial();
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

  void initForEdit(Budget budget) {
    // Find category by name
    final category = _latestCategories?.firstWhere(
      (c) => c.name == budget.category,
      orElse: () => ExpenseCategory(
        id: '',
        name: budget.category,
        icon: budget.emoji,
        color: '#6C63FF', // Default color
      ),
    );

    state = state.copyWith(
      editingBudget: budget,
      selectedCategory: category,
      limitAmount: budget.limit,
    );
  }

  void onCategoryChanged(ExpenseCategory? category) {
    state = state.copyWith(
      selectedCategory: category,
      errorMessage: null,
    );
  }

  void onLimitChanged(String value) {
    final amount = double.tryParse(value) ?? 0;
    state = state.copyWith(
      limitAmount: amount,
      errorMessage: null,
    );
  }

  void onAlertAt75Changed({required bool value}) {
    state = state.copyWith(alertAt75: value);
  }

  void onAlertAt90Changed({required bool value}) {
    state = state.copyWith(alertAt90: value);
  }

  void onAlertWhenExceededChanged({required bool value}) {
    state = state.copyWith(alertWhenExceeded: value);
  }

  Future<void> saveBudget() async {
    if (!state.isValid) {
      state = state.copyWith(errorMessage: 'Please fill all required fields');
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final budget = Budget(
        id: state.editingBudget?.id ?? const Uuid().v4(),
        category: state.selectedCategory!.name,
        emoji: state.selectedCategory!.icon,
        spent: state.editingBudget?.spent ?? 0,
        limit: state.limitAmount,
      );

      final budgetsNotifier = ref.read(budgetsStreamProvider.notifier);
      await budgetsNotifier.saveBudget(budget);

      state = state.copyWith(isLoading: false, isSaved: true);
    } on Exception catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void reset() {
    state = AddBudgetState.initial().copyWith(
      categories: AsyncData(_latestCategories ?? []),
    );
  }
}

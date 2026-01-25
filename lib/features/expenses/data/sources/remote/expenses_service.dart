import 'dart:convert';

import 'package:fintrack/core/utils/typedefs.dart';
import 'package:fintrack/features/dashboard/data/mock/mock_data.dart';
import 'package:fintrack/features/dashboard/data/models/transaction_model.dart';
import 'package:fintrack/features/expenses/data/mock/mock_data.dart';
import 'package:fintrack/features/expenses/data/models/category_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final expensesServiceProvider = Provider<ExpensesService>((ref) {
  return ExpensesService(ref: ref);
});

class ExpensesService {
  ExpensesService({required this.ref});

  final Ref ref;

  // Categories
  Future<List<ExpenseCategoryModel>> getCategories() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final jsonList = json.decode(categoriesMockJson) as List<dynamic>;
    return jsonList.map((json) => ExpenseCategoryModel.fromJson(json as JSON)).toList();
  }

  Future<ExpenseCategoryModel> saveCategory(ExpenseCategoryModel category) async {
    // TODO: Replace with actual API call
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return category;
  }

  Future<void> deleteCategory(String categoryId) async {
    // TODO: Replace with actual API call
    await Future<void>.delayed(const Duration(milliseconds: 200));
  }

  // Transactions
  Future<List<TransactionModel>> getTransactions() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final jsonList = json.decode(transactionsMockJson) as List<dynamic>;
    return jsonList.map((json) => TransactionModel.fromJson(json as JSON)).toList();
  }

  Future<TransactionModel> saveTransaction(TransactionModel transaction) async {
    // TODO: Replace with actual API call
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return transaction;
  }

  Future<void> deleteTransaction(String transactionId) async {
    // TODO: Replace with actual API call
    await Future<void>.delayed(const Duration(milliseconds: 200));
  }
}

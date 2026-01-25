import 'package:fintrack/features/dashboard/data/models/transaction_model.dart';
import 'package:fintrack/features/expenses/data/models/category_model.dart';
import 'package:fintrack/hive/hive_keys.dart';
import 'package:fintrack/hive/hive_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final expensesLocalProvider = Provider<ExpensesLocal>((ref) {
  return ExpensesLocal(ref: ref);
});

class ExpensesLocal {
  ExpensesLocal({required this.ref}) {
    _storage = ref.read(hiveStorageProvider);
  }

  final Ref ref;
  late HiveStorage _storage;

  // Categories
  Future<List<ExpenseCategoryModel>> getCategories() async {
    final categories = await _storage.getAllItems<ExpenseCategoryModel>(HiveBoxes.categories);
    return categories;
  }

  Future<void> saveCategories(List<ExpenseCategoryModel> categories) async {
    await _storage.saveAllItems<ExpenseCategoryModel>(
      HiveBoxes.categories,
      categories,
      keyExtractor: (item) => item.id ?? '',
    );
  }

  Future<void> saveCategory(ExpenseCategoryModel category) async {
    await _storage.saveAllItems<ExpenseCategoryModel>(
      HiveBoxes.categories,
      [category],
      keyExtractor: (item) => item.id ?? '',
    );
  }

  Future<void> deleteCategory(String categoryId) async {
    final box = await _storage.getBox<ExpenseCategoryModel>(HiveBoxes.categories);
    await box.delete(categoryId);
  }

  // Transactions
  Future<List<TransactionModel>> getTransactions() async {
    final transactions = await _storage.getAllItems<TransactionModel>(HiveBoxes.transactions);
    return transactions;
  }

  Future<void> saveTransactions(List<TransactionModel> transactions) async {
    await _storage.saveAllItems<TransactionModel>(
      HiveBoxes.transactions,
      transactions,
      keyExtractor: (item) => item.id ?? '',
    );
  }

  Future<void> saveTransaction(TransactionModel transaction) async {
    await _storage.saveAllItems<TransactionModel>(
      HiveBoxes.transactions,
      [transaction],
      keyExtractor: (item) => item.id ?? '',
    );
  }

  Future<void> deleteTransaction(String transactionId) async {
    final box = await _storage.getBox<TransactionModel>(HiveBoxes.transactions);
    await box.delete(transactionId);
  }
}

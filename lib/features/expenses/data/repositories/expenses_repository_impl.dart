import 'package:fintrack/features/dashboard/data/models/transaction_model.dart';
import 'package:fintrack/features/dashboard/domain/entities/transaction.dart';
import 'package:fintrack/features/expenses/data/models/category_model.dart';
import 'package:fintrack/features/expenses/data/sources/local/expenses_local.dart';
import 'package:fintrack/features/expenses/data/sources/remote/expenses_service.dart';
import 'package:fintrack/features/expenses/domain/entities/category.dart';
import 'package:fintrack/features/expenses/domain/repositories/expenses_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final expensesRepositoryProvider = Provider<ExpensesRepository>((ref) {
  final service = ref.read(expensesServiceProvider);
  final local = ref.read(expensesLocalProvider);

  return ExpensesRepositoryImpl(service: service, local: local);
});

class ExpensesRepositoryImpl implements ExpensesRepository {
  ExpensesRepositoryImpl({
    required this.service,
    required this.local,
  });

  final ExpensesService service;
  final ExpensesLocal local;

  // Categories
  @override
  Stream<List<ExpenseCategory>> watchCategories() async* {
    final cached = await local.getCategories();

    if (cached.isNotEmpty) {
      yield cached.map((e) => e.toEntity()).toList();
    }

    try {
      final fresh = await service.getCategories();
      await local.saveCategories(fresh);

      yield fresh.map((e) => e.toEntity()).toList();
    } on Exception catch (_) {
      if (cached.isEmpty) rethrow;
    }
  }

  @override
  Future<void> saveCategory(ExpenseCategory category) async {
    final model = ExpenseCategoryModel.fromEntity(category);
    final saved = await service.saveCategory(model);
    await local.saveCategory(saved);
  }

  @override
  Future<void> deleteCategory(String categoryId) async {
    await service.deleteCategory(categoryId);
    await local.deleteCategory(categoryId);
  }

  // Transactions
  @override
  Stream<List<Transaction>> watchTransactions() async* {
    final cached = await local.getTransactions();

    if (cached.isNotEmpty) {
      yield cached.map((e) => e.toEntity()).toList();
    }

    try {
      final fresh = await service.getTransactions();
      await local.saveTransactions(fresh);

      yield fresh.map((e) => e.toEntity()).toList();
    } on Exception catch (_) {
      if (cached.isEmpty) rethrow;
    }
  }

  @override
  Future<void> saveTransaction(Transaction transaction) async {
    final model = TransactionModel.fromEntity(transaction);
    final saved = await service.saveTransaction(model);
    await local.saveTransaction(saved);
  }

  @override
  Future<void> deleteTransaction(String transactionId) async {
    await service.deleteTransaction(transactionId);
    await local.deleteTransaction(transactionId);
  }
}

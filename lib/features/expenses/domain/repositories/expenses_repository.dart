import 'package:fintrack/features/dashboard/domain/entities/transaction.dart';
import 'package:fintrack/features/expenses/domain/entities/category.dart';

abstract class ExpensesRepository {
  Stream<List<Transaction>> watchTransactions();
  Future<void> saveTransaction(Transaction transaction);
  Future<void> deleteTransaction(String transactionId);

  Stream<List<ExpenseCategory>> watchCategories();
  Future<void> saveCategory(ExpenseCategory category);
  Future<void> deleteCategory(String categoryId);
}

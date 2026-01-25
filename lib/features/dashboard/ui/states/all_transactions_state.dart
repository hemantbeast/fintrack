import 'package:fintrack/features/dashboard/domain/entities/transaction.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'all_transactions_state.freezed.dart';

enum TransactionFilter { all, income, expense }

@freezed
abstract class AllTransactionsState with _$AllTransactionsState {
  const factory AllTransactionsState({
    required AsyncValue<List<Transaction>> transactions,
    required TransactionFilter filter,
  }) = _AllTransactionsState;

  factory AllTransactionsState.initial() {
    return const AllTransactionsState(
      transactions: AsyncLoading(),
      filter: TransactionFilter.all,
    );
  }
}

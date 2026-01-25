import 'package:fintrack/features/dashboard/data/models/balance_model.dart';
import 'package:fintrack/features/dashboard/data/models/budget_model.dart';
import 'package:fintrack/features/dashboard/data/models/exchange_rate_model.dart';
import 'package:fintrack/features/dashboard/data/models/transaction_model.dart';
import 'package:hive_ce/hive_ce.dart';

part 'hive_adapters.g.dart';

const dashboardAdapters = [
  AdapterSpec<BalanceModel>(),
  AdapterSpec<TransactionModel>(),
  AdapterSpec<BudgetModel>(),
  AdapterSpec<ExchangeRateModel>(),
];

@GenerateAdapters([
  ...dashboardAdapters,
])
// This is for code generation
// ignore: unused_element
void _() {}

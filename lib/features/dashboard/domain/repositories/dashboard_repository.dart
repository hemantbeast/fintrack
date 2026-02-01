import 'package:fintrack/features/dashboard/domain/entities/balance.dart';
import 'package:fintrack/features/dashboard/domain/entities/currency_rate.dart';
import 'package:fintrack/features/dashboard/domain/entities/exchange_rates.dart';
import 'package:fintrack/features/dashboard/domain/entities/transaction.dart';

abstract class DashboardRepository {
  /// Returns a stream of balance data (cache-first with background refresh)
  Stream<Balance> watchBalance();

  /// Returns a stream of transactions data (cache-first with background refresh)
  Stream<List<Transaction>> watchTransactions();

  /// Returns a stream of exchange rates (cache-first with 24h refresh)
  /// [baseCurrency] - The base currency code (e.g., 'INR')
  Stream<ExchangeRates> watchExchangeRates({required String baseCurrency});

  /// Get currency rate from cached exchange rates
  CurrencyRate getCurrencyRate({required String from, required String to});
}

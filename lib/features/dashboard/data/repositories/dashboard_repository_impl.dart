import 'dart:async';

import 'package:fintrack/features/dashboard/data/sources/local/dashboard_local.dart';
import 'package:fintrack/features/dashboard/data/sources/remote/dashboard_service.dart';
import 'package:fintrack/features/dashboard/domain/entities/balance.dart';
import 'package:fintrack/features/dashboard/domain/entities/currency_rate.dart';
import 'package:fintrack/features/dashboard/domain/entities/exchange_rates.dart';
import 'package:fintrack/features/dashboard/domain/entities/transaction.dart';
import 'package:fintrack/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  final service = ref.read(dashboardServiceProvider);
  final local = ref.read(dashboardLocalProvider);

  return DashboardRepositoryImpl(local: local, service: service);
});

class DashboardRepositoryImpl implements DashboardRepository {
  DashboardRepositoryImpl({
    required this.service,
    required this.local,
  });

  final DashboardService service;

  final DashboardLocal local;

  /// Get balance with stale-while-revalidate strategy
  @override
  Stream<Balance> watchBalance() async* {
    // Get cached data from local storage
    final cachedBalance = await local.getBalance();

    if (cachedBalance != null) {
      yield cachedBalance.toEntity();
    }

    try {
      // Fetch data from API
      final balance = await service.getBalance();
      await local.saveBalance(balance);

      // Yield fresh data
      yield balance.toEntity();
    } on Exception catch (_) {
      // Throw error if fetching fails
      if (cachedBalance == null) {
        rethrow;
      }
    }
  }

  /// Get transactions with stale-while-revalidate strategy
  @override
  Stream<List<Transaction>> watchTransactions() async* {
    // Get cached data from local storage
    final cachedTransactions = await local.getTransactions();

    if (cachedTransactions != null) {
      yield cachedTransactions.map((m) => m.toEntity()).toList();
    }

    try {
      // Fetch data from API
      final transactions = await service.getTransactions();
      await local.saveTransactions(transactions);

      // Yield fresh data
      yield transactions.map((m) => m.toEntity()).toList();
    } on Exception catch (_) {
      // Throw error if fetching fails
      if (cachedTransactions == null) {
        rethrow;
      }
    }
  }

  // Cached exchange rates for synchronous access
  ExchangeRates? _cachedExchangeRates;

  /// Get exchange rates with stale-while-revalidate strategy
  /// Cache is valid for 24 hours
  @override
  Stream<ExchangeRates> watchExchangeRates({String baseCurrency = 'INR'}) async* {
    // Get cached data from local storage
    final cachedRates = await local.getExchangeRates();

    if (cachedRates != null) {
      final entity = cachedRates.toEntity();
      _cachedExchangeRates = entity;
      yield entity;

      // If cache is still valid (less than 24 hours), don't fetch new data
      if (entity.isValid) {
        return;
      }
    }

    try {
      // Fetch fresh data from API
      final freshRates = await service.getExchangeRates(
        baseCurrency: baseCurrency,
      );
      await local.saveExchangeRates(freshRates);

      final entity = freshRates.toEntity();
      _cachedExchangeRates = entity;

      // Yield fresh data
      yield entity;
    } on Exception catch (_) {
      // Only throw error if no cached data available
      if (cachedRates == null) {
        rethrow;
      }
    }
  }

  /// Get currency rate from cached exchange rates
  @override
  CurrencyRate getCurrencyRate({required String from, required String to}) {
    // Use cached exchange rates if available
    if (_cachedExchangeRates != null && _cachedExchangeRates!.baseCurrency == from) {
      return CurrencyRate(
        fromCurrency: from,
        toCurrency: to,
        rate: _cachedExchangeRates!.getRate(to),
      );
    }

    // Fallback to hardcoded rates if cache not available or base doesn't match
    final rates = {
      'INR-USD': 0.012,
      'INR-EUR': 0.011,
      'INR-GBP': 0.0095,
      'INR-JPY': 1.79,
      'INR-CAD': 0.016,
      'INR-AUD': 0.018,
      'USD-INR': 83.0,
      'EUR-INR': 90.0,
      'GBP-INR': 105.0,
    };

    return CurrencyRate(
      fromCurrency: from,
      toCurrency: to,
      rate: rates['$from-$to'] ?? 1.0,
    );
  }
}

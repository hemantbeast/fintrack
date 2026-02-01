import 'dart:async';
import 'dart:convert';

import 'package:fintrack/constants/api_constants.dart';
import 'package:fintrack/core/network/api_method.dart';
import 'package:fintrack/core/network/api_network.dart';
import 'package:fintrack/core/utils/json_utils.dart';
import 'package:fintrack/core/utils/typedefs.dart';
import 'package:fintrack/features/dashboard/data/mock/mock_data.dart';
import 'package:fintrack/features/dashboard/data/models/balance_model.dart';
import 'package:fintrack/features/dashboard/data/models/exchange_rate_model.dart';
import 'package:fintrack/features/dashboard/data/models/transaction_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dashboardServiceProvider = Provider<DashboardService>((ref) {
  return DashboardService(ref: ref);
});

class DashboardService with ApiNetwork {
  DashboardService({required this.ref});

  final Ref ref;

  /// Fetches balance data from API
  Future<BalanceModel> getBalance() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return JsonUtils.parseJson(balanceMockJson, BalanceModel.fromJson);
  }

  /// Fetches transactions data from API
  Future<List<TransactionModel>> getTransactions() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final jsonList = json.decode(transactionsMockJson) as List<dynamic>;
    return jsonList.map((json) => TransactionModel.fromJson(json as JSON)).toList();
  }

  /// Fetches exchange rates from API
  /// [baseCurrency] - The base currency code (e.g., 'INR')
  Future<ExchangeRateModel> getExchangeRates({String baseCurrency = 'INR'}) async {
    final completer = Completer<ExchangeRateModel>();

    await apiRequest(
      url: '${ApiConstants.latestExchangeRateUrl}/$baseCurrency',
      method: ApiMethod.get,
      isAuthorization: false,
      onSuccess: (response) {
        if (response is JSON) {
          final model = ExchangeRateModel.fromJson(response);
          completer.complete(model);
        } else {
          completer.completeError(Exception('Invalid response format'));
        }
      },
      onError: (error) {
        completer.completeError(
          Exception(error?.toString() ?? 'Failed to fetch exchange rates'),
        );
      },
    );

    return completer.future;
  }
}

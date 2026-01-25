import 'package:fintrack/config/app_config.dart';

class ApiConstants {
  // Exchange Rate API Url
  static String get exchangeApiUrl => '${AppConfig.exchangeUrl}/v6/${AppConfig.exchangeApiKey}';

  // Latest Exchange Rate
  static String get latestExchangeRateUrl => '$exchangeApiUrl/latest';
}

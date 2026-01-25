import 'package:envied/envied.dart';

part 'app_config.g.dart';

@Envied(path: '.env', obfuscate: true)
abstract class AppConfig {
  @EnviedField(varName: 'BASE_URL')
  static final String baseUrl = _AppConfig.baseUrl;

  @EnviedField(varName: 'EXCHANGE_URL')
  static final String exchangeUrl = _AppConfig.exchangeUrl;

  @EnviedField(varName: 'EXCHANGE_API_KEY')
  static final String exchangeApiKey = _AppConfig.exchangeApiKey;
}

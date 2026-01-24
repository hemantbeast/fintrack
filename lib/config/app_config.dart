import 'package:envied/envied.dart';

part 'app_config.g.dart';

@Envied(path: '.env', obfuscate: true)
abstract class AppConfig {
  @EnviedField(varName: 'BASE_URL')
  static final String baseUrl = _AppConfig.baseUrl;
}

import 'package:dio/browser.dart';
import 'package:dio/dio.dart';
import 'package:fintrack/config/app_config.dart';

bool get isAndroid => false;

bool get isIOS => false;

String get currentPlatform => 'Web';

class DioFactory {
  factory DioFactory() {
    return _instance;
  }

  DioFactory._constructor() {
    final options = BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 40),
      sendTimeout: const Duration(seconds: 30),
      contentType: Headers.jsonContentType,
    );

    instance = DioForBrowser(options);
  }

  late final Dio instance;

  static final DioFactory _instance = DioFactory._constructor();

  void updateBaseUrl() {
    instance.options.baseUrl = AppConfig.baseUrl;
  }
}

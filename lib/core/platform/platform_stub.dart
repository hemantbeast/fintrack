import 'package:dio/dio.dart';
import 'package:fintrack/core/config/app_config.dart';

bool get isAndroid => throw UnimplementedError('Platform not supported');

bool get isIOS => throw UnimplementedError('Platform not supported');

String get currentPlatform => throw UnimplementedError('Platform not supported');

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

    instance = Dio(options);
  }

  late final Dio instance;

  static final DioFactory _instance = DioFactory._constructor();

  void updateBaseUrl() {
    instance.options.baseUrl = AppConfig.baseUrl;
  }
}

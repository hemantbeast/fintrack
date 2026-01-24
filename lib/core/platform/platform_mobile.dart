import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fintrack/config/app_config.dart';
import 'package:flutter/foundation.dart';

bool get isAndroid => Platform.isAndroid;

bool get isIOS => Platform.isIOS;

String get currentPlatform {
  if (isAndroid) return 'Android';
  if (isIOS) return 'iOS';
  return 'Unknown';
}

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

    // Add interceptors in order of execution
    if (kDebugMode) {
      instance.interceptors.add(_createLoggingInterceptor());
    }

    instance.interceptors.add(_createErrorInterceptor());
  }

  late final Dio instance;

  static final DioFactory _instance = DioFactory._constructor();

  void updateBaseUrl() {
    instance.options.baseUrl = AppConfig.baseUrl;
  }
}

/// Create logging interceptor for debug mode
Interceptor _createLoggingInterceptor() {
  return InterceptorsWrapper(
    onRequest: (options, handler) {
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      debugPrint('REQUEST[${options.method}] => PATH: ${options.path}');
      debugPrint('Headers: ${options.headers}');
      if (options.queryParameters.isNotEmpty) {
        debugPrint('Query Parameters: ${options.queryParameters}');
      }
      if (options.data != null) {
        debugPrint('Body: ${options.data}');
      }
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      return handler.next(options);
    },
    onResponse: (response, handler) {
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      debugPrint('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
      debugPrint('Data: ${response.data}');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      return handler.next(response);
    },
    onError: (error, handler) {
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      debugPrint('ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}');
      debugPrint('Message: ${error.message}');
      if (error.response != null) {
        debugPrint('Data: ${error.response?.data}');
      }
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      return handler.next(error);
    },
  );
}

/// Create global error handling interceptor
Interceptor _createErrorInterceptor() {
  return InterceptorsWrapper(
    onError: (error, handler) {
      if (error.type == DioExceptionType.badCertificate) {
        debugPrint('SSL Certificate error detected');
      }

      if (error.type == DioExceptionType.connectionError) {
        debugPrint('Connection error - possible network issue');
      }

      return handler.next(error);
    },
  );
}

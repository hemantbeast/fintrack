import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fintrack/core/extensions/string_extensions.dart';
import 'package:fintrack/core/network/api_method.dart';
import 'package:fintrack/core/platform/index.dart';
import 'package:fintrack/core/utils/network_utils.dart';
import 'package:fintrack/core/utils/toast_utils.dart';
import 'package:fintrack/core/utils/typedefs.dart';
import 'package:fintrack/generated/l10n.dart';
import 'package:flutter/foundation.dart';

mixin ApiNetwork {
  // Constants
  static const Set<int> _serverErrorCodes = {500, 501, 502, 503, 504};

  @protected
  Future<void> apiRequest({
    required String url,
    required ApiMethod method,
    required void Function(dynamic response) onSuccess,
    required void Function(dynamic error) onError,
    JSON? queries,
    dynamic content,
    Options? options,
    bool isAuthorization = true,
    bool checkInternet = true,
    String? accessToken,
    CancelToken? cancelToken,
  }) async {
    // Early internet check
    if (checkInternet && !kIsWeb && !await _checkInternetConnection()) {
      onError.call(null);
      return;
    }

    final dio = DioFactory().instance;
    _configureHeaders(dio, isAuthorization, accessToken);

    try {
      final response = await _executeRequest(
        dio: dio,
        url: url,
        method: method,
        queries: queries,
        content: content,
        options: options,
        cancelToken: cancelToken,
      );

      if (kDebugMode) {
        _logRequest(method: method, response: response, content: content);
      }

      onSuccess.call(response.data);
    } on DioException catch (e) {
      await _handleDioException(
        exception: e,
        url: url,
        method: method,
        queries: queries,
        content: content,
        onError: onError,
      );
    } on Exception catch (e, stackTrace) {
      debugPrint('Unexpected error: $e');
      debugPrint('StackTrace: $stackTrace');
      onError.call(null);
    }
  }

  /// Check internet connection with rate-limited toast
  Future<bool> _checkInternetConnection() async {
    final isAvailable = await NetworkUtils.isInternetAvailable();

    if (!isAvailable) {
      ToastUtils.showToast(S.current.checkInternet);
    }

    return isAvailable;
  }

  /// Configure authorization headers
  void _configureHeaders(Dio dio, bool isAuthorization, String? accessToken) {
    if (isAuthorization) {
      // final token = accessToken ?? Settings.accessToken;

      if (!accessToken.isNullOrEmpty()) {
        dio.options.headers['authorization'] = 'Bearer $accessToken';
      }
    } else {
      dio.options.headers.remove('authorization');
    }
  }

  /// Execute the actual HTTP request
  Future<Response<dynamic>> _executeRequest({
    required Dio dio,
    required String url,
    required ApiMethod method,
    JSON? queries,
    dynamic content,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    switch (method) {
      case ApiMethod.get:
        return dio.get(url, queryParameters: queries, options: options, cancelToken: cancelToken);
      case ApiMethod.delete:
        return dio.delete(url, queryParameters: queries, options: options, cancelToken: cancelToken);
      case ApiMethod.post:
        return dio.post(url, data: content, queryParameters: queries, options: options, cancelToken: cancelToken);
      case ApiMethod.put:
        return dio.put(url, data: content, queryParameters: queries, options: options, cancelToken: cancelToken);
    }
  }

  /// Handle DioException with proper error categorization
  Future<void> _handleDioException({
    required DioException exception,
    required String url,
    required ApiMethod method,
    required void Function(dynamic error) onError,
    JSON? queries,
    dynamic content,
  }) async {
    final response = exception.response;

    // Handle timeout errors
    if (_isTimeoutError(exception.type)) {
      ToastUtils.showToast(S.current.connectionTimedOut);
      onError.call(null);
      return;
    }

    // Handle cancelled or null response
    if (response == null || CancelToken.isCancel(exception)) {
      onError.call(null);
      return;
    }

    if (kDebugMode) {
      _logRequest(method: method, response: response, content: content);
    }

    // Handle unauthorized
    if (response.statusCode == HttpStatus.unauthorized) {
      await _handleUnauthorized(response, method, content);
      onError.call(null);
      return;
    }

    // Handle server errors (5xx) and not found (404)
    if (response.statusCode == HttpStatus.notFound || _serverErrorCodes.contains(response.statusCode)) {
      ToastUtils.showToast(S.current.networkError);
      _recordError(method: method, response: response, content: content);

      onError.call(null);
      return;
    }

    // Handle client errors (4xx)
    if (response.statusCode != null && response.statusCode! >= 400 && response.statusCode! < 500) {
      onError.call(response.data);

      // Only log non-bad-request errors to Crashlytics
      if (response.statusCode != HttpStatus.badRequest) {
        _recordError(method: method, response: response, content: content);
      }
      return;
    }

    // Default error handling
    onError.call(null);
  }

  /// Check if the error is a timeout error
  bool _isTimeoutError(DioExceptionType type) {
    return type == DioExceptionType.connectionTimeout || type == DioExceptionType.receiveTimeout || type == DioExceptionType.sendTimeout;
  }

  /// Handle unauthorized error with automatic logout
  Future<void> _handleUnauthorized(
    Response<dynamic> response,
    ApiMethod method,
    dynamic content,
  ) async {
    _recordError(method: method, response: response, content: content);
    ToastUtils.showToast(S.current.sessionExpired);

    // Use lock to prevent multiple simultaneous logouts
  }

  /// Log request details for debugging
  void _logRequest({
    required ApiMethod method,
    required Response<dynamic> response,
    dynamic content,
  }) {
    final buffer = StringBuffer()
      ..writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━')
      ..writeln('URL: ${response.realUri}')
      ..writeln('Method: ${method.name.toUpperCase()}')
      ..writeln('Status: ${response.statusCode}');

    if (method == ApiMethod.post || method == ApiMethod.put) {
      buffer.writeln('Request: ${_formatJson(content)}');
    }

    buffer
      ..writeln('Response: ${_formatJson(response.data)}')
      ..writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    log(buffer.toString());
  }

  /// Record error to Crashlytics
  void _recordError({
    required ApiMethod method,
    required Response<dynamic> response,
    dynamic content,
  }) {
    // Skip logging for login endpoints to avoid logging sensitive data
    // if (response.realUri.toString().contains(ApiConstants.loginUrl)) {
    //   return;
    // }

    if (!kReleaseMode || kIsWeb) return;

    final buffer = StringBuffer()
      ..writeln('API Error')
      ..writeln('Url: ${response.realUri}')
      ..writeln('Method: ${method.name.toUpperCase()}')
      ..writeln('Status: ${response.statusCode}')
      ..writeln('Headers: ${response.requestOptions.headers}');

    if (method == ApiMethod.post || method == ApiMethod.put) {
      buffer.writeln('Request: ${_formatJson(content)}');
    }

    buffer.writeln('Response: ${_formatJson(response.data)}');
  }

  /// Format JSON for better readability
  String _formatJson(dynamic data) {
    try {
      if (data == null) return 'null';
      if (data is String) return data;

      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(data);
    } on Exception catch (_) {
      return data.toString();
    }
  }
}

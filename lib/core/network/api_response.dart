import 'package:fintrack/core/utils/typedefs.dart';

class ApiResponse<T> {
  ApiResponse({this.status, this.message, this.result});

  factory ApiResponse.fromJson(JSON json, T? Function(dynamic data) build) {
    return ApiResponse<T>(
      status: json['Status'] as int?,
      message: json['Message'] as String?,
      result: json['Result'] != null ? build(json['Result']) : null,
    );
  }

  int? status;
  String? message;
  T? result;

  bool get isSuccess => status == 200 || status == 201;
}

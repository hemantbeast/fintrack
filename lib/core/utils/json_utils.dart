import 'dart:convert';

import 'package:fintrack/core/utils/typedefs.dart';

class JsonUtils {
  /// Parse a json string
  static T parseJson<T>(String json, T Function(JSON data) fromJson) {
    final jsonMap = jsonDecode(json) as JSON;
    return fromJson(jsonMap);
  }
}

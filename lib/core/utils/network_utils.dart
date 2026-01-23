import 'dart:io';

import 'package:flutter/foundation.dart';

class NetworkUtils {
  static Future<bool> isInternetAvailable() async {
    if (kIsWeb) {
      return true;
    }

    var connected = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      connected = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      connected = false;
    }
    return connected;
  }
}

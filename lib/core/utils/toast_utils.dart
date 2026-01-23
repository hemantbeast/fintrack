import 'package:fintrack/core/extensions/string_extensions.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtils {
  static DateTime? _lastToastTime;
  static const Duration _toastDuration = Duration(seconds: 1, milliseconds: 200);

  static void showToast(String msg) {
    if (msg.isEmpty || msg.equalsIgnoreCase('null')) {
      return;
    }

    final now = DateTime.now();

    if (_lastToastTime == null || now.difference(_lastToastTime!) > _toastDuration) {
      _lastToastTime = now;
      Fluttertoast.showToast(msg: msg, toastLength: Toast.LENGTH_LONG);
    }
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension StringExt on String {
  Color toColor() {
    if (isEmpty) {
      return Colors.transparent;
    }

    var hexColor = replaceAll('#', '');

    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor'.toUpperCase();
    }

    return Color(int.parse(hexColor, radix: 16));
  }

  bool equalsIgnoreCase(String value) {
    return toLowerCase() == value.toLowerCase();
  }

  bool containsIgnoreCase(String value) {
    return toLowerCase().contains(value.toLowerCase());
  }

  bool isValidEmail() {
    const p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    final regExp = RegExp(p);
    return regExp.hasMatch(this);
  }

  bool isValidPassword() {
    const passwordPattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*./-]).{6,}$';
    final regex = RegExp(passwordPattern);
    return regex.hasMatch(this);
  }

  bool isValidNumber() {
    const pattern = r'^[0-9]{10}$';
    final regex = RegExp(pattern);
    return regex.hasMatch(this);
  }

  bool isValidWebsiteUrl() {
    const webPattern =
        r'^((ftp|http|https):\/\/)?(www.)?(?!.*(ftp|http|https|www.))[a-zA-Z0-9_-]+(\.[a-zA-Z]+)+((\/)[\w#]+)*'
        '(/w+?[a-zA-Z0-9_]+=w+(&[a-zA-Z0-9_]+=w+)*)?/?';

    final regex = RegExp(webPattern);
    return regex.hasMatch(this);
  }

  String changeHtmlColor() {
    final regex = RegExp(r'color: rgb\((\d{1,3}, \d{1,3}, \d{1,3})\)');
    final lstMatch = regex.allMatches(this);

    var html = this;
    for (final item in lstMatch) {
      final newStr = item.group(0);
      final split = newStr!.replaceAll('color: rgb(', '').replaceAll(')', '').split(',').map((e) => int.parse(e.trim())).toList();
      final list = <int>[];

      for (final val in split) {
        list.add(255 - val);
      }

      final colorStr = newStr.replaceAll(regex, 'color: rgb(${list[0]}, ${list[1]}, ${list[2]})');
      html = html.replaceFirst(regex, colorStr, item.start);
    }
    return html;
    // return replaceAll(regex, 'color: rgba(${color.red}, ${color.green}, ${color.blue}, ${color.alpha})');
  }

  DateTime? toFormattedDateTime(String pattern, {bool isUtc = false}) {
    return DateFormat(pattern, 'en').parse(this, isUtc);
  }

  bool isValidZipcode() {
    const zipcodePattern = r'^[1-9][0-9]{5}$';
    final regex = RegExp(zipcodePattern);
    return regex.hasMatch(this);
  }
}

extension NullStringExt on String? {
  bool isNullOrEmpty() => this == null || this!.isEmpty || this == 'null';

  bool equalsIgnoreCase(String? value) {
    if (this == null) {
      return false;
    }
    return this?.toLowerCase() == value?.toLowerCase();
  }

  bool containsIgnoreCase(String? value) {
    if (isNullOrEmpty() || value.isNullOrEmpty()) {
      return false;
    }

    return this!.toLowerCase().contains(value!.toLowerCase());
  }

  DateTime? toFormattedDateTime(String pattern, {bool isUtc = false}) {
    if (this == null) {
      return null;
    }
    return DateFormat(pattern, 'en').parse(this!, isUtc);
  }

  Color? toColor() {
    if (isNullOrEmpty()) {
      return null;
    }

    var hexColor = this!.replaceAll('#', '');

    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return Color(int.parse(hexColor, radix: 16));
  }
}

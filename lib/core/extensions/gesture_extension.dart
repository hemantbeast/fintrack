import 'package:flutter/material.dart';

extension GestureExt on Widget {
  InkWell onTap(void Function() function) {
    return InkWell(
      onTap: function,
      child: this,
    );
  }

  InkWell onDoubleTap(void Function() function) {
    return InkWell(
      onDoubleTap: function,
      child: this,
    );
  }
}

import 'package:flutter/material.dart';

extension WidgetExt on Widget {
  SafeArea applySafeArea({
    bool left = true,
    bool top = true,
    bool right = true,
    bool bottom = true,
  }) {
    return SafeArea(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      child: this,
    );
  }

  Visibility visibility({bool visible = true}) {
    return Visibility(
      visible: visible,
      child: this,
    );
  }

  Center toCenter() {
    return Center(
      child: this,
    );
  }

  Tooltip withTooltip(
    String message, {
    Key? key,
    Decoration? decoration,
    BoxConstraints? constraints,
    bool? preferBelow,
    EdgeInsetsGeometry? padding,
    TextStyle? textStyle,
    Duration? waitDuration,
    Duration? showDuration,
    EdgeInsetsGeometry? margin,
    TooltipTriggerMode? triggerMode,
  }) {
    triggerMode ??= TooltipTriggerMode.tap;
    return Tooltip(
      key: key,
      message: message,
      decoration: decoration,
      constraints: constraints,
      padding: padding,
      preferBelow: preferBelow,
      textStyle: textStyle,
      waitDuration: waitDuration,
      showDuration: showDuration,
      margin: margin,
      triggerMode: triggerMode,
      child: this,
    );
  }
}

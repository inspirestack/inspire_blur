import 'package:flutter/material.dart';

extension KeyLayoutExtensions on GlobalKey {
  Rect? getGlobalRenderBoxBounds() {
    final context = currentContext;

    if (context == null || !context.mounted) return null;

    try {
      final renderBox = context.findRenderObject() as RenderBox?;
      if (renderBox == null || !renderBox.hasSize) return null;

      return renderBox.localToGlobal(Offset.zero) & renderBox.size;
    } catch (_) {
      return null;
    }
  }
}

extension RectExtensions on Rect {
  bool isClose(Rect other, {double epsilon = 1.0e-1}) {
    if (identical(this, other)) return true;

    if ((left - other.left).abs() > epsilon) return false;
    if ((top - other.top).abs() > epsilon) return false;
    if ((right - other.right).abs() > epsilon) return false;
    if ((bottom - other.bottom).abs() > epsilon) return false;

    return true;
  }

  bool isNotClose(Rect other, {double epsilon = 1.0e-1}) =>
      !isClose(other, epsilon: epsilon);
}

extension NumExtensions on double {
  double coerceAtLeast(double min) {
    return this < min ? min : this;
  }

  double takeNegativeOrZero() {
    return this < 0.0 ? this : 0.0;
  }

  double takePositiveOrZero() {
    return this > 0.0 ? this : 0.0;
  }
}

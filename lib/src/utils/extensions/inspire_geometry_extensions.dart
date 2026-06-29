import 'package:flutter/painting.dart';

extension RectExtensions on Rect {
  /// Returns `true` if this rectangle is close to the [other] rectangle,
  /// i.e. the edges are close within the [epsilon] threshold.
  ///
  /// If the distance for a given edge is equal to [epsilon], that edge
  /// from both rectangles is still considered as close.
  bool isClose(Rect other, {double epsilon = 1.0e-7}) {
    if (identical(this, other)) return true;

    if ((left - other.left).abs() > epsilon) return false;
    if ((top - other.top).abs() > epsilon) return false;
    if ((right - other.right).abs() > epsilon) return false;
    if ((bottom - other.bottom).abs() > epsilon) return false;

    return true;
  }

  /// Returns the negation of [isClose].
  bool isNotClose(Rect other, {double epsilon = 1.0e-7}) =>
      !isClose(other, epsilon: epsilon);
}

extension OffsetExtensions on Offset {
  /// Returns `true` if this offset is close to the [other] offset,
  /// i.e. both coordinates are close within the [epsilon] threshold.
  ///
  /// If the distance for a given coordinate is equal to [epsilon], that
  /// coordinate from both offsets is still considered as close.
  bool isClose(Offset other, {double epsilon = 1.0e-7}) {
    if (identical(this, other)) return true;

    if ((dx - other.dx).abs() > epsilon) return false;
    if ((dy - other.dy).abs() > epsilon) return false;

    return true;
  }

  /// Returns the negation of [isClose].
  bool isNotClose(Offset other, {double epsilon = 1.0e-7}) =>
      !isClose(other, epsilon: epsilon);

  double dot(Offset other) => dx * other.dx + dy * other.dy;
}

extension AlignmentExtensions on Alignment {
  /// Converts an [Alignment] from the `[-1.0, 1.0]` coordinate space
  /// to normalized UV coordinates in the `[0.0, 1.0]` range.
  Offset toNormalizedOffset() {
    final u = (x * 0.5) + 0.5;
    final v = (y * 0.5) + 0.5;

    return Offset(u, v);
  }
}

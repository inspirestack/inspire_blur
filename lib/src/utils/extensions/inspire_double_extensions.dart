extension DoubleExtensions on double {
  /// Returns a double that is at least [min].
  double coerceAtLeast(double min) => this < min ? min : this;

  /// Returns a double that is at most [max].
  double coerceAtMost(double max) => this > max ? max : this;

  /// Returns this value if negative, otherwise zero.
  double takeNegativeOrZero() => this < 0.0 ? this : 0.0;

  /// Returns this value if positive, otherwise zero.
  double takePositiveOrZero() => this > 0.0 ? this : 0.0;

  /// Returns `true` if this number differs from [other] by at most [epsilon].
  bool isCloseTo(double other, {double epsilon = 1e-7}) =>
      (this - other).abs() <= epsilon;

  /// Returns the negation of [isCloseTo].
  bool isNotCloseTo(double other, {double epsilon = 1e-7}) =>
      !isCloseTo(other, epsilon: epsilon);
}

/// Scale applied to the blur distribution.
///
/// Use [BlurScale.uniform] to scale uniformly in all directions,
/// or [BlurScale.nonUniform] to scale independently along the
/// horizontal and vertical axes.
class BlurScale {
  /// Horizontal scaling factor.
  final double scaleX;

  /// Vertical scaling factor.
  final double scaleY;

  const BlurScale._({required this.scaleX, required this.scaleY});

  /// Identity scale that leaves the blur distribution unchanged.
  ///
  /// Equivalent to `BlurScale.uniform(scale: 1.0)`.
  static const BlurScale identity = BlurScale.uniform(scale: 1.0);

  /// Scales the blur distribution uniformly in all directions.
  ///
  /// A value of 0.0 fully collapses the blur distribution.
  ///
  /// Negative [scale] mirrors the blur distribution horizontally
  /// and vertically.
  const BlurScale.uniform({required double scale})
      : this._(scaleX: scale, scaleY: scale);

  /// Scales the blur distribution independently along the horizontal
  /// and vertical axes.
  ///
  /// A value of 0.0 for either axis fully collapses the blur distribution
  /// along that axis.
  ///
  /// Negative [scaleX] mirrors the blur distribution horizontally.
  /// Negative [scaleY] mirrors the blur distribution vertically.
  const factory BlurScale.nonUniform({
    required double scaleX,
    required double scaleY,
  }) = BlurScale._;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BlurScale &&
        other.scaleX == scaleX &&
        other.scaleY == scaleY;
  }

  @override
  int get hashCode => Object.hash(scaleX, scaleY);

  @override
  String toString() => 'BlurScale(scaleX: $scaleX, scaleY: $scaleY)';
}

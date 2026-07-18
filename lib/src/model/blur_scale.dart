import 'dart:ui' show lerpDouble;

/// Scaling factor applied to the blur distribution.
///
/// Use [BlurScale.uniform] to scale it uniformly in all directions,
/// or [BlurScale.nonUniform] to scale it independently along the
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
  /// A value of `0.0` collapses the blur distribution.
  ///
  /// Negative [scale] mirrors the blur distribution horizontally
  /// and vertically.
  const BlurScale.uniform({required double scale})
      : this._(scaleX: scale, scaleY: scale);

  /// Scales the blur distribution independently along the horizontal
  /// and vertical axes.
  ///
  /// A value of `0.0` for either axis collapses the blur distribution
  /// along that axis.
  ///
  /// * Negative [scaleX] mirrors the blur distribution horizontally.
  /// * Negative [scaleY] mirrors the blur distribution vertically.
  const factory BlurScale.nonUniform({
    required double scaleX,
    required double scaleY,
  }) = BlurScale._;

  /// Returns a copy of this scale with the provided properties updated.
  ///
  /// Any parameter left `null` retains its current value.
  BlurScale copyWith({
    double? scaleX,
    double? scaleY,
  }) {
    return BlurScale._(
      scaleX: scaleX ?? this.scaleX,
      scaleY: scaleY ?? this.scaleY,
    );
  }

  /// Linearly interpolates between two [BlurScale] objects.
  ///
  /// Enables seamless transitions inside implicit animations or tweens.
  static BlurScale lerp(
    BlurScale? a,
    BlurScale? b,
    double t,
  ) {
    if (identical(a, b) && a != null) return a;

    a ??= BlurScale.identity;
    b ??= BlurScale.identity;

    return BlurScale._(
      scaleX: lerpDouble(a.scaleX, b.scaleX, t)!,
      scaleY: lerpDouble(a.scaleY, b.scaleY, t)!,
    );
  }

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

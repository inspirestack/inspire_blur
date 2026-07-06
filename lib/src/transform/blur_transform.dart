import 'package:flutter/widgets.dart';
import 'package:inspire_blur/src/model/blur_scale.dart';

/// Adds extra transformations to the blur distribution.
///
/// It is animation-friendly, changing its values frame by frame is
/// supported and optimized for smooth rendering.
class BlurTransform {
  /// Scaling factor for the blur distribution.
  final BlurScale scale;

  /// Offset of the blur distribution in normalized UV coordinates.
  ///
  /// - `Offset(1.0, 0.0)` moves the distribution to the right by one
  ///   widget width.
  /// - `Offset(0.0, 1.0)` moves it down by one widget height.
  final Offset offset;

  /// Rotation of the blur distribution in radians.
  final double rotation;

  /// Origin around which scaling and rotation are applied.
  ///
  /// Defaults to [Alignment.center].
  final Alignment origin;

  /// Inversion factor for the blur distribution.
  ///
  /// Values in the range `[0.0, 1.0]` interpolate between the original
  /// and inverted blur distribution.
  ///
  /// Values outside this range extrapolate the effect, which can be useful
  /// for overshooting animations, such as [Curves.easeOutBack].
  ///
  /// - 0.0 keeps the original map.
  /// - 1.0 fully inverts the distribution map.
  final double inversionFactor;

  /// Neutral no-op transform that leaves the original distribution map intact.
  static const identity = BlurTransform();

  /// Creates a blur distribution transform.
  ///
  /// By default, it is an identity transform.
  const BlurTransform({
    this.scale = BlurScale.identity,
    this.offset = Offset.zero,
    this.rotation = 0.0,
    this.origin = Alignment.center,
    this.inversionFactor = 0.0,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BlurTransform &&
        other.scale == scale &&
        other.offset == offset &&
        other.rotation == rotation &&
        other.origin == origin &&
        other.inversionFactor == inversionFactor;
  }

  @override
  int get hashCode => Object.hash(
        scale,
        offset,
        rotation,
        origin,
        inversionFactor,
      );

  @override
  String toString() => 'BlurTransform('
      'scale: $scale, '
      'offset: $offset, '
      'rotation: $rotation, '
      'origin: $origin, '
      'inversionFactor: $inversionFactor'
      ')';
}

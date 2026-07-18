import 'dart:ui';

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

  /// Point around which scaling and rotation are applied.
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
  /// * Value `0.0` keeps the original map.
  /// * Value `1.0` fully inverts the distribution map.
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

  /// Returns a copy of this distribution with the provided properties updated.
  ///
  /// Any parameter left `null` retains its current value.
  BlurTransform copyWith({
    BlurScale? scale,
    Offset? offset,
    double? rotation,
    Alignment? origin,
    double? inversionFactor,
  }) {
    return BlurTransform(
      scale: scale ?? this.scale,
      offset: offset ?? this.offset,
      rotation: rotation ?? this.rotation,
      origin: origin ?? this.origin,
      inversionFactor: inversionFactor ?? this.inversionFactor,
    );
  }

  /// Linearly interpolates between two [BlurTransform] objects.
  ///
  /// Enables seamless transitions inside implicit animations or tweens.
  static BlurTransform lerp(
    BlurTransform? a,
    BlurTransform? b,
    double t,
  ) {
    if (identical(a, b) && a != null) return a;

    a ??= BlurTransform.identity;
    b ??= BlurTransform.identity;

    return BlurTransform(
      scale: BlurScale.lerp(a.scale, b.scale, t),
      offset: Offset.lerp(a.offset, b.offset, t)!,
      rotation: lerpDouble(a.rotation, b.rotation, t)!,
      origin: Alignment.lerp(a.origin, b.origin, t)!,
      inversionFactor: lerpDouble(a.inversionFactor, b.inversionFactor, t)!,
    );
  }

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

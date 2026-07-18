import 'dart:math';
import 'dart:ui' show lerpDouble;

import 'package:inspire_blur/src/utils/extensions/inspire_double_extensions.dart';

/// Adjusts the color of the blurred effect.
///
/// The adjustment parameters allow all positive and negative values by default,
/// unless specified otherwise.
///
/// The values follow a perceptual scale where each 10x increase in magnitude
/// represents roughly one additional level of perceived effect strength.
///
/// | Magnitude | Perceived effect |
/// |----------:|------------------|
/// | `0.1`     | Subtle           |
/// | `1.0`     | Noticeable       |
/// | `10.0`    | Extreme          |
///
/// The scale applies for both positive and negative values, unless
/// specified otherwise.
///
/// Value `0.0` is the default where no adjustment is applied.
///
/// **Example values:**
/// * `0.1` - quite subtle
/// * `0.5` - moderate
/// * `1.0` - clearly noticeable
/// * `2.0-4.0` - more pronounced
/// * `5.0-10.0` - very strong
/// * `> 10.0` - typically extreme
class BlurColorAdjustment {
  /// Brightness adjustment.
  ///
  /// Value `0.0` keeps the original brightness.
  final double brightness;

  /// Brightness value converted into a shader scale.
  ///
  /// For internal use only.
  double get shaderBrightness =>
      brightness.sign * _brightnessFactor * sqrt(brightness.abs());

  static const _brightnessFactor = 0.03;

  /// Contrast adjustment.
  ///
  /// Value `0.0` keeps the original contrast.
  final double contrast;

  /// Contrast value converted into a shader scale.
  ///
  /// For internal use only.
  double get shaderContrast {
    if (contrast >= 0.0) return 1.0 + _positiveContrastFactor * sqrt(contrast);

    final scaledContrast = contrast * _negativeContrastFactor;
    return 1.0 + scaledContrast / (1.0 + scaledContrast.abs());
  }

  static const _positiveContrastFactor = 2.0;
  static const _negativeContrastFactor = 0.1;

  /// Exposure adjustment.
  ///
  /// Changes the perceived illumination of the blurred effect.
  ///
  /// Value `0.0` keeps the original exposure.
  final double exposure;

  /// Exposure value converted into a shader scale.
  ///
  /// For internal use only.
  double get shaderExposure =>
      exposure.sign * _exposureFactor * sqrt(exposure.abs());

  static const _exposureFactor = 0.08;

  /// Saturation adjustment.
  ///
  /// Uniformly increases or decreases the color intensity.
  ///
  /// * `0.0` - original saturation.
  /// * `-1.0` - grayscale.
  /// * Values below `-1.0` are treated as grayscale.
  /// * Positive values progressively increase saturation.
  final double saturation;

  /// Saturation value converted into a shader scale.
  ///
  /// For internal use only.
  double get shaderSaturation {
    if (saturation <= 0.0) {
      return (1.0 + saturation).coerceAtLeast(0.0);
    }

    return 1.0 + _positiveSaturationFactor * sqrt(saturation);
  }

  static const _positiveSaturationFactor = 0.25;

  /// Vibrance adjustment.
  ///
  /// Selectively increases or decreases the intensity of less saturated colors.
  ///
  /// * `0.0` - original vibrance.
  /// * `-1.0` - minimal vibrance.
  /// * Values below `-1.0` are treated as the minimal vibrance.
  /// * Positive values progressively increase vibrance.
  final double vibrance;

  /// Vibrance value converted into a shader scale.
  ///
  /// For internal use only.
  double get shaderVibrance {
    if (vibrance <= 0.0) {
      return vibrance.coerceAtLeast(-1.0);
    }

    return _positiveVibranceFactor * sqrt(vibrance);
  }

  static const _positiveVibranceFactor = 0.5;

  /// Controls how strongly color adjustments affect the blurred area.
  ///
  /// To use the adjustment over the whole area (blurred and non-blurred)
  /// uniformly, provide [blurAdjustmentStrength] as `1.0` and
  /// [nonBlurAdjustmentStrength] as `1.0`.
  ///
  /// The adjustment for partially blurred areas is computed by
  /// interpolating between [blurAdjustmentStrength] and
  /// [nonBlurAdjustmentStrength] proportionally.
  ///
  /// * Value `0.0` doesn't adjust colors.
  /// * Value `0.5` applies the adjustments with half strength.
  /// * Value `1.0` applies full color adjustment.
  final double blurAdjustmentStrength;

  /// Controls how strongly color adjustments affect the non-blurred area.
  ///
  /// In tandem with [blurAdjustmentStrength] it controls the amount of
  /// the color adjustment applied to the area.
  final double nonBlurAdjustmentStrength;

  /// Creates a color adjustment with neutral default values.
  const BlurColorAdjustment({
    this.brightness = 0.0,
    this.contrast = 0.0,
    this.exposure = 0.0,
    this.saturation = 0.0,
    this.vibrance = 0.0,
    this.blurAdjustmentStrength = 1.0,
    this.nonBlurAdjustmentStrength = 0.0,
  })  : assert(
          blurAdjustmentStrength >= 0.0 && blurAdjustmentStrength <= 1.0,
        ),
        assert(
          nonBlurAdjustmentStrength >= 0.0 && nonBlurAdjustmentStrength <= 1.0,
        );

  /// Returns a copy of this color adjustment with the provided
  /// properties updated.
  ///
  /// Any parameter left `null` retains its current value.
  BlurColorAdjustment copyWith({
    double? brightness,
    double? contrast,
    double? exposure,
    double? vibrance,
    double? saturation,
    double? blurAdjustmentStrength,
    double? nonBlurAdjustmentStrength,
  }) {
    return BlurColorAdjustment(
      brightness: brightness ?? this.brightness,
      contrast: contrast ?? this.contrast,
      exposure: exposure ?? this.exposure,
      vibrance: vibrance ?? this.vibrance,
      saturation: saturation ?? this.saturation,
      blurAdjustmentStrength:
          blurAdjustmentStrength ?? this.blurAdjustmentStrength,
      nonBlurAdjustmentStrength:
          nonBlurAdjustmentStrength ?? this.nonBlurAdjustmentStrength,
    );
  }

  /// Returns an adjustment with zero strength.
  ///
  /// An adjustment with strength of `0.0` has de facto no effect,
  /// as the shader will bypass it entrirely.
  BlurColorAdjustment disabled() => copyWith(
        blurAdjustmentStrength: 0.0,
        nonBlurAdjustmentStrength: 0.0,
      );

  /// Returns `true` if either adjustment strength is greater than zero.
  bool get isEnabled =>
      blurAdjustmentStrength > 0.0 || nonBlurAdjustmentStrength > 0.0;

  /// Returns `true` if any adjustment params have non-default values.
  bool get hasAdjustments =>
      brightness != 0.0 ||
      contrast != 0.0 ||
      exposure != 0.0 ||
      saturation != 0.0 ||
      vibrance != 0.0;

  /// Returns `true` if the adjustment has any visual effect.
  bool get isActive => isEnabled && hasAdjustments;

  /// Linearly interpolates between two [BlurColorAdjustment] objects.
  ///
  /// Enables seamless transitions inside implicit animations or tweens.
  static BlurColorAdjustment lerp(
    BlurColorAdjustment? a,
    BlurColorAdjustment? b,
    double t,
  ) {
    if (identical(a, b) && a != null) return a;

    a ??= const BlurColorAdjustment();
    b ??= const BlurColorAdjustment();

    return BlurColorAdjustment(
      brightness: lerpDouble(a.brightness, b.brightness, t)!,
      contrast: lerpDouble(a.contrast, b.contrast, t)!,
      exposure: lerpDouble(a.exposure, b.exposure, t)!,
      vibrance: lerpDouble(a.vibrance, b.vibrance, t)!,
      saturation: lerpDouble(a.saturation, b.saturation, t)!,
      blurAdjustmentStrength: lerpDouble(
        a.blurAdjustmentStrength,
        b.blurAdjustmentStrength,
        t,
      )!,
      nonBlurAdjustmentStrength: lerpDouble(
        a.nonBlurAdjustmentStrength,
        b.nonBlurAdjustmentStrength,
        t,
      )!,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BlurColorAdjustment &&
        other.brightness == brightness &&
        other.contrast == contrast &&
        other.exposure == exposure &&
        other.saturation == saturation &&
        other.vibrance == vibrance &&
        other.blurAdjustmentStrength == blurAdjustmentStrength &&
        other.nonBlurAdjustmentStrength == nonBlurAdjustmentStrength;
  }

  @override
  int get hashCode => Object.hash(
        brightness,
        contrast,
        exposure,
        saturation,
        vibrance,
        blurAdjustmentStrength,
        nonBlurAdjustmentStrength,
      );

  @override
  String toString() => 'BlurColorAdjustment('
      'brightness: $brightness, '
      'contrast: $contrast, '
      'exposure: $exposure, '
      'saturation: $saturation, '
      'vibrance: $vibrance, '
      'blurAdjustmentStrength: $blurAdjustmentStrength, '
      'nonBlurAdjustmentStrength: $nonBlurAdjustmentStrength'
      ')';
}

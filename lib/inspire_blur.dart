/// Inspire Blur provides high-performance progressive and variable blur
/// effects for Flutter.
///
/// The package includes:
/// * Child blur and backdrop blur widgets
/// * Directional and shape-based blur distributions
/// * Tint effects
/// * GPU shader-powered rendering optimized for Impeller
///
/// Designed for building modern, visually rich Flutter interfaces.
library;

export 'src/color_adjustment/blur_color_adjustment.dart'
    show BlurColorAdjustment;
export 'src/distribution/blur_distribution.dart';
export 'src/inspire_backdrop_blur.dart' show InspireBackdropBlur;
export 'src/inspire_blur.dart' show Inspire;
export 'src/inspire_blur_config.dart' show InspireBlurConfig;
export 'src/inspire_blur_mode.dart' show InspireBlurMode;
export 'src/inspire_child_blur.dart' show InspireChildBlur;
export 'src/inspire_tint_api.dart' show InspireTintApi;
export 'src/model/blur_scale.dart' show BlurScale;
export 'src/transform/blur_transform.dart' show BlurTransform;

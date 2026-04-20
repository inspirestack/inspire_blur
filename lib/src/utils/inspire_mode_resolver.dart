import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:inspire_blur/src/inspire_blur_mode.dart';

InspireBlurResolvedMode resolveBlurMode({
  required BuildContext context,
  required InspireBlurMode userPreferredMode,
}) {
  // Animated sampler is always safe, so use it if it's preferred
  if (userPreferredMode == InspireBlurMode.animatedSampler) {
    return InspireBlurResolvedMode.animatedSampler;
  }

  // Override to animated sampler, if Impeller is not available
  if (!ui.ImageFilter.isShaderFilterSupported) {
    return InspireBlurResolvedMode.animatedSampler;
  }

  if (userPreferredMode == InspireBlurMode.imageFilter) {
    return InspireBlurResolvedMode.imageFilter;
  }

  // Auto detection based on heuristics
  if (_isOnScrollableList(context) || _isTransforming(context)) {
    return InspireBlurResolvedMode.animatedSampler;
  } else {
    return InspireBlurResolvedMode.imageFilter;
  }
}

bool _isOnScrollableList(BuildContext context) {
  // Check if widget is inside at least one Scrollable (e.g. ListView or
  // SingleChildScrollView)
  final scrollable = Scrollable.maybeOf(context);
  return scrollable != null;
}

bool _isTransforming(BuildContext context) {
  final renderObject = context.findRenderObject();
  if (renderObject == null) return false;

  final transform = renderObject.getTransformTo(null);

  // Check if transformation matrix is more than just a simple translation
  return !transform.isIdentity() &&
      (transform.getColumn(0).length != 1.0 || // X scale
          transform.getColumn(1).length != 1.0 || // Y scale
          transform.getRotation().isIdentity() == false); // Rotation
}

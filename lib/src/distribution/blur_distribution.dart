import 'dart:ui' as ui show Image;
import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:inspire_blur/src/utils/math/inspire_lerp.dart';

part 'package:inspire_blur/src/distribution/models/directional_distribution.dart';
part 'package:inspire_blur/src/distribution/models/ellipse_distribution.dart';
part 'package:inspire_blur/src/distribution/models/gradient_distribution.dart';
part 'package:inspire_blur/src/distribution/models/image_mask_distribution.dart';
part 'package:inspire_blur/src/distribution/models/rrect_distribution.dart';
part 'package:inspire_blur/src/distribution/models/uniform_distribution.dart';

/// Defines how blur strength is distributed spatially.
sealed class BlurDistribution {
  const BlurDistribution();

  /// Returns a copy of this distribution with the provided properties updated.
  ///
  /// Any parameter left `null` retains its current value.
  BlurDistribution copyWith();
}

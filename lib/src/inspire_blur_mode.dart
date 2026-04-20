import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

/// Defines mechanism that Inspire blur uses for rendering.
///
/// Different modes offer different trade-offs affecting performance,
/// visual stability and compatibility in different use cases.
///
/// **Quick guide:**
/// - Use [auto] for most cases.
/// - Use [imageFilter] for static, complex UI.
/// - Use [animatedSampler] for stability in scrollable or transformed layouts.
///
/// **Performance:**
/// Performance between [imageFilter] and [animatedSampler] might differ
/// depending on the context where blur is used. One might be slightly faster
/// than the other depending on specific use case. It is advised to measure
/// their performance if it is a critical factor.
enum InspireBlurMode {
  /// Determines the best suitable mode in runtime.
  ///
  /// The selection is based on rendering capabilities and layout context:
  ///
  /// - If Impeller engine is not available, it resolves to [animatedSampler].
  /// - If the widget is used inside a scrollable container or is subject
  ///   to complex transformations (e.g. scrolling, animations), it resolves
  ///   to [animatedSampler] for better stability.
  /// - Otherwise, it prefers [imageFilter].
  ///
  /// This is the recommended mode for most use cases.
  auto,

  /// This mode integrates directly with Flutter's rendering pipeline
  /// and is usually better for blurring complex widgets which are
  /// deeply nested, or contain (not limited to):
  /// - [Stack]
  /// - [BoxShadow]
  /// - [Opacity]
  ///
  /// This mode internally uses [ImageFilter.shader].
  /// It is available on _Impeller_ engine only.
  ///
  /// **Pros:**
  /// - High visual fidelity due to tight GPU integration
  ///   (especially noticeable with low sigma values).
  /// - Superior color precision and smooth gradients (Linear Color Space).
  /// - No intermediate texture capture.
  /// - Works well for static or mostly stationary widgets.
  /// - Handles complex widget trees reliably without producing artifacts.
  ///
  /// **Cons:**
  /// - May produce visual artifacts when the widget moves off-screen
  ///   (e.g. inside scrollable containers).
  /// - Flutter may translate cached layers instead of repainting them,
  ///   which can lead to subtle inconsistencies in shader-based effects.
  /// - Coordinate Mismatch: [FlutterFragCoord] may become desynced during
  ///   Layer Translations (e.g., when a parent translates without repainting).
  /// - Clipping: May exhibit "hard edges" or sampling artifacts near the
  ///   boundaries of a [ClipRect].
  ///
  /// Use this mode for complex widgets which are mostly stationary, or for
  /// blurring platform views.
  imageFilter,

  /// This mode captures the widget into an offscreen texture and applies
  /// the blur shader to that snapshot.
  ///
  /// This mode internally uses [AnimatedSampler].
  ///
  /// **Pros:**
  /// - Visually stable when the widget is moving off-screen (e.g. scrolling) —
  ///   produces consistent results regardless of viewport position.
  /// - Not affected by Flutter's layer translation or partial clipping.
  /// - Works even when Impeller is not available.
  ///
  /// **Cons:**
  /// - Potentially lower performance due to texture capture.
  /// - May be less efficient for large or frequently updating widgets.
  /// - Cannot capture platform views (e.g. WebView, Google Maps, some ads).
  /// - Breaks tight integration with Flutter's GPU rendering pipeline,
  ///   as the widget is first rasterized into a texture and then processed
  ///   by the shader. This may introduce additional overhead and reduce
  ///   rendering fidelity compared to [imageFilter] in some scenarios.
  ///
  /// Use this mode when [imageFilter] is producing inaccurate blur around
  /// the edges, especially for widgets moving off-screen.
  animatedSampler,
}

enum InspireBlurResolvedMode { imageFilter, animatedSampler }

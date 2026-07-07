import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:inspire_blur/src/child_blur/inspire_child_blur_animated_sampler_pass.dart';
import 'package:inspire_blur/src/child_blur/inspire_child_blur_image_filter_pass.dart';
import 'package:inspire_blur/src/inspire_backdrop_blur.dart';
import 'package:inspire_blur/src/inspire_blur_config.dart';
import 'package:inspire_blur/src/inspire_blur_mode.dart';
import 'package:inspire_blur/src/inspire_blur_wrapper.dart';
import 'package:inspire_blur/src/utils/inspire_mode_resolver.dart';

/// Applies a blur effect to the [child] widget.
///
/// Unlike [InspireBackdropBlur], this widget only blurs its content inside
/// and does not sample or modify the background.
///
/// The blur is applied directly to the rendered output of [child],
/// making it suitable for blurring specific UI elements without
/// affecting the surrounding scene (e.g. cards or images).
class InspireChildBlur extends StatelessWidget {
  /// Configuration of the child blur.
  ///
  /// Specifies the strength and spatial distribution of the blur effect.
  final InspireBlurConfig config;

  /// Rendering mode of the child blur mode.
  ///
  /// By default, the mode will be resolved automatically.
  final InspireBlurMode mode;

  /// Defines how the blur effect is clipped.
  ///
  /// Disabling clipping allows the blur to extend beyond widget bounds.
  final Clip clipBehavior;

  /// Whether to isolate the widget into a [RepaintBoundary].
  ///
  /// Can improve rendering performance and stability.
  ///
  /// In some cases, disabling it may produce more accurate blur updates,
  /// such as in deeply nested scrollable lists.
  final bool useRepaintBoundary;

  /// Allows to manually invalidate the cached screen position of the
  /// blur effect.
  ///
  /// Set [layoutInvalidationKey] to a different value whenever the blur effect
  /// should recalculate its position on the screen. The value can be a simple
  /// integer counter.
  ///
  /// In most cases, this is not needed. The blur effect automatically tracks
  /// changes to the blurred widget's position.
  ///
  /// This might be needed during advanced transitions or animations, where
  /// the blur effect is not receiving a callback about the change of its
  /// screen bounds.
  ///
  /// For example, this might be required when the blur widget is
  /// transformed with [ScaleTransition] or [PositionedTransition].
  final Object? layoutInvalidationKey;

  /// Child widget to which the blur effect will be applied.
  final Widget child;

  /// Creates a blur for the [child] with given [config].
  ///
  /// For performance and stability adjustments, refer to documentation of the
  /// [clipBehavior] and [useRepaintBoundary].
  const InspireChildBlur({
    super.key,
    this.mode = InspireBlurMode.auto,
    this.clipBehavior = Clip.antiAlias,
    this.useRepaintBoundary = true,
    this.layoutInvalidationKey,
    required this.config,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedMode = resolveBlurMode(
      context: context,
      userPreferredMode: mode,
    );

    return InspireBlurWrapper(
      config: config,
      layoutInvalidationKey: layoutInvalidationKey,
      builder: (context, builderData) {
        final gradientMap = builderData.blurGradientMap;

        // Gradient map is not ready yet — skip a frame with no blur.
        // Typically it should not happen, unless during very low performance.
        if (gradientMap == null) return child;

        final sigmaHorizontal = config.effectiveSigmaX;
        final sigmaVertical = config.effectiveSigmaY;

        if (sigmaHorizontal != null &&
            sigmaVertical != null &&
            sigmaHorizontal > 0 &&
            sigmaVertical > 0) {
          return _wrapWithClipRect(
            child: _maybeWrapWithRepaintBoundary(
              child: _buildBlurPass(
                context: context,
                resolvedMode: resolvedMode,
                gradientMap: gradientMap,
                direction: Axis.horizontal,
                sigma: sigmaHorizontal,
                child: _buildBlurPass(
                  context: context,
                  resolvedMode: resolvedMode,
                  gradientMap: gradientMap,
                  direction: Axis.vertical,
                  sigma: sigmaVertical,
                  child: child,
                ),
              ),
            ),
          );
        }

        if (sigmaHorizontal != null && sigmaHorizontal > 0) {
          return _wrapWithClipRect(
            child: _maybeWrapWithRepaintBoundary(
              child: _buildBlurPass(
                context: context,
                resolvedMode: resolvedMode,
                gradientMap: gradientMap,
                direction: Axis.horizontal,
                sigma: sigmaHorizontal,
                child: child,
              ),
            ),
          );
        }

        if (sigmaVertical != null && sigmaVertical > 0) {
          return _wrapWithClipRect(
            child: _maybeWrapWithRepaintBoundary(
              child: _buildBlurPass(
                context: context,
                resolvedMode: resolvedMode,
                gradientMap: gradientMap,
                direction: Axis.vertical,
                sigma: sigmaVertical,
                child: child,
              ),
            ),
          );
        }

        return child;
      },
    );
  }

  Widget _wrapWithClipRect({required Widget child}) {
    return ClipRect(clipBehavior: clipBehavior, child: child);
  }

  Widget _maybeWrapWithRepaintBoundary({required Widget child}) {
    if (useRepaintBoundary) {
      return RepaintBoundary(child: child);
    } else {
      return child;
    }
  }

  Widget _buildBlurPass({
    required BuildContext context,
    required InspireBlurResolvedMode resolvedMode,
    required ui.Image gradientMap,
    required Axis direction,
    required double sigma,
    required Widget child,
  }) {
    return switch (resolvedMode) {
      InspireBlurResolvedMode.imageFilter => InspireChildBlurImageFilterPass(
          gradientMap: gradientMap,
          transform: config.transform,
          direction: direction,
          sigma: sigma,
          child: child,
        ),
      InspireBlurResolvedMode.animatedSampler =>
        InspireChildBlurAnimatedSamplerPass(
          gradientMap: gradientMap,
          transform: config.transform,
          direction: direction,
          sigma: sigma,
          child: child,
        )
    };
  }
}

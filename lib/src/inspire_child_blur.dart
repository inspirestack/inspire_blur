import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:inspire_blur/src/child_blur/inspire_child_blur_animated_sampler_pass.dart';
import 'package:inspire_blur/src/child_blur/inspire_child_blur_image_filter_pass.dart';
import 'package:inspire_blur/src/inspire_backdrop_blur.dart';
import 'package:inspire_blur/src/inspire_blur_config.dart';
import 'package:inspire_blur/src/inspire_blur_mode.dart';
import 'package:inspire_blur/src/inspire_blur_wrapper.dart';
import 'package:inspire_blur/src/utils/inspire_mode_resolver.dart';

/// Applies a blur effect to the [child].
///
/// Unlike [InspireBackdropBlur], this widget only blurs its own content
/// and does not sample or modify the background.
///
/// The blur is applied directly to the rendered output of [child],
/// making it suitable for blurring specific UI elements without
/// affecting the surrounding scene (e.g. cards or images).
///
/// Behavior and performance:
///
/// By default, the blur effect is clipped to the bounds of this widget.
/// Disabling clipping may cause the blur to extend beyond the widget bounds.
///
/// A [RepaintBoundary] is used by default to optimize rendering.
/// In some cases (e.g. scrolling in nested lists), disabling it may
/// result in more accurate blur updates, at the expense of performance.
class InspireChildBlur extends StatelessWidget {
  final InspireBlurConfig config;
  final InspireBlurMode mode;
  final Clip clipBehavior;
  final bool useRepaintBoundary;
  final Widget child;

  const InspireChildBlur({
    super.key,
    this.mode = InspireBlurMode.auto,
    this.clipBehavior = Clip.antiAlias,
    this.useRepaintBoundary = true,
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
      builder: (context, builderData) {
        final gradientMap = builderData.blurGradientMap;

        // Gradient map is not ready yet — skip a frame with no blur.
        // Typically it should not happen, unless device is slow.
        if (gradientMap == null) return child;

        final sigmaHorizontal = config.overallSigmaHorizontally();
        final sigmaVertical = config.overallSigmaVertically();

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
          direction: direction,
          sigma: sigma,
          child: child,
        ),
      InspireBlurResolvedMode.animatedSampler =>
        InspireChildBlurAnimatedSamplerPass(
          gradientMap: gradientMap,
          direction: direction,
          sigma: sigma,
          child: child,
        )
    };
  }
}

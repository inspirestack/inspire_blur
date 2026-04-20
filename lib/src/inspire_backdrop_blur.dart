import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:inspire_blur/src/inspire_blur_config.dart';
import 'package:inspire_blur/src/inspire_blur_wrapper.dart';
import 'package:inspire_blur/src/inspire_child_blur.dart';
import 'package:inspire_blur/src/inspire_shaders.dart';

/// Applies a blur effect to the content behind this widget.
///
/// Unlike [InspireChildBlur], this widget does not blur its child.
/// Instead, it blurs everything rendered beneath it in the widget tree.
///
/// Typically used inside a [Stack], positioned above the content that
/// should be blurred.
///
/// An optional [child] can be provided. The main use for it is to specify
/// the size of the backdrop. Alternatively, a [child] can be left empty,
/// and the size can be provided by wrapping this widget in an external
/// [SizedBox] or [Positioned] with specified [width] and [height].
///
/// Behavior and performance:
///
/// By default, the blur effect is clipped to the bounds of this widget.
/// Disabling clipping may cause the blur to extend beyond the widget bounds.
///
/// A [RepaintBoundary] is used by default to optimize rendering.
/// In some cases (e.g. scrolling in nested lists), disabling it may
/// result in more accurate blur updates, at the expense of performance.
class InspireBackdropBlur extends StatelessWidget {
  final InspireBlurConfig config;
  final Clip clipBehavior;
  final bool useRepaintBoundary;
  final Widget? child;

  const InspireBackdropBlur({
    super.key,
    required this.config,
    this.clipBehavior = Clip.antiAlias,
    this.useRepaintBoundary = true,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (!ui.ImageFilter.isShaderFilterSupported) {
      // No Impeller support, exit gracefully
      return child ?? const SizedBox.shrink();
    }

    final childValue = child;

    return InspireBlurWrapper(
      config: config,
      builder: (context, builderData) {
        final gradientMap = builderData.blurGradientMap;
        final globalBounds = builderData.globalBounds;

        // Dependencies are not ready yet — skip a frame with no blur.
        // Typically it should not happen, unless device is slow.
        if (gradientMap == null || globalBounds == null) {
          return const SizedBox.shrink();
        }

        final sigmaHorizontal = config.overallSigmaHorizontally();
        final sigmaVertical = config.overallSigmaVertically();

        if (sigmaHorizontal != null &&
            sigmaVertical != null &&
            sigmaHorizontal > 0 &&
            sigmaVertical > 0) {
          return _wrapWithClipRect(
            child: _maybeWrapWithRepaintBoundary(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: _InspireBackdropBlurPass(
                      gradientMap: gradientMap,
                      globalBounds: globalBounds,
                      direction: Axis.horizontal,
                      sigma: sigmaHorizontal,
                    ),
                  ),
                  Positioned.fill(
                    child: _InspireBackdropBlurPass(
                      gradientMap: gradientMap,
                      globalBounds: globalBounds,
                      direction: Axis.vertical,
                      sigma: sigmaVertical,
                    ),
                  ),
                  if (childValue != null) childValue,
                ],
              ),
            ),
          );
        }

        if (sigmaHorizontal != null && sigmaHorizontal > 0) {
          return _wrapWithClipRect(
            child: _maybeWrapWithRepaintBoundary(
              child: _InspireBackdropBlurPass(
                gradientMap: gradientMap,
                globalBounds: globalBounds,
                direction: Axis.horizontal,
                sigma: sigmaHorizontal,
                child: childValue,
              ),
            ),
          );
        }

        if (sigmaVertical != null && sigmaVertical > 0) {
          return _wrapWithClipRect(
            child: _maybeWrapWithRepaintBoundary(
              child: _InspireBackdropBlurPass(
                gradientMap: gradientMap,
                globalBounds: globalBounds,
                direction: Axis.vertical,
                sigma: sigmaVertical,
                child: childValue,
              ),
            ),
          );
        }

        return childValue ?? const SizedBox.shrink();
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
}

class _InspireBackdropBlurPass extends StatefulWidget {
  final ui.Image gradientMap;
  final Rect globalBounds;
  final Axis direction;
  final double sigma;
  final Widget? child;

  const _InspireBackdropBlurPass({
    required this.gradientMap,
    required this.globalBounds,
    required this.direction,
    required this.sigma,
    this.child,
  });

  @override
  State<_InspireBackdropBlurPass> createState() =>
      _InspireBackdropBlurPassState();
}

class _InspireBackdropBlurPassState extends State<_InspireBackdropBlurPass> {
  ui.FragmentShader? _shader;

  @override
  void initState() {
    super.initState();
    _loadShader();
  }

  void _loadShader() {
    InspireShaders.backdropBlur.then((program) {
      final shader = program.fragmentShader();
      if (mounted) {
        setState(() {
          _shader = shader;
          _updateShader();
        });
      } else {
        _shader = shader;
        _updateShader();
      }
    });
  }

  @override
  void didUpdateWidget(covariant _InspireBackdropBlurPass oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateShader();
  }

  void _updateShader() {
    final dpr = MediaQuery.of(context).devicePixelRatio;

    _shader?.setImageSampler(1, widget.gradientMap);
    _shader?.setFloat(2, widget.sigma);
    _shader?.setFloat(3, widget.direction == Axis.horizontal ? 1.0 : 0.0);
    _shader?.setFloat(4, widget.direction == Axis.vertical ? 1.0 : 0.0);
    _shader?.setFloat(5, widget.globalBounds.left * dpr);
    _shader?.setFloat(6, widget.globalBounds.top * dpr);
    _shader?.setFloat(7, widget.globalBounds.width * dpr);
    _shader?.setFloat(8, widget.globalBounds.height * dpr);
  }

  @override
  void dispose() {
    _shader?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shader = _shader;
    if (shader == null) return widget.child ?? const SizedBox.shrink();

    return BackdropFilter(
      filter: ui.ImageFilter.shader(shader),
      // The child of BackdropFilter is drawn over the blurred background.
      //
      // If no child is provided, a transparent content is filled in order
      // to semantically indicate to the engine that there is content
      // inside, and thus it should not collapse the backdrop filter area.
      child: widget.child ??
          const ColoredBox(
            color: Colors.transparent,
            child: SizedBox.expand(),
          ),
    );
  }
}

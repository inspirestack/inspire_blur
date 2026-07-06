import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:inspire_blur/src/inspire_blur_config.dart';
import 'package:inspire_blur/src/inspire_blur_wrapper.dart';
import 'package:inspire_blur/src/inspire_child_blur.dart';
import 'package:inspire_blur/src/inspire_shaders.dart';
import 'package:inspire_blur/src/transform/blur_transform.dart';
import 'package:inspire_blur/src/utils/extensions/inspire_geometry_extensions.dart';

/// Applies a blur effect to the content behind this widget.
///
/// Unlike [InspireChildBlur], this widget does not blur its child.
/// Instead, it blurs everything rendered beneath it in the widget tree.
///
/// Typically used inside a [Stack], positioned above the content that
/// should be blurred.
class InspireBackdropBlur extends StatelessWidget {
  /// Configuration of the backdrop blur.
  ///
  /// Specifies the strength and spatial distribution of the blur effect.
  final InspireBlurConfig config;

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

  /// Optional child widget.
  ///
  /// Typically used to define the size of the backdrop blur area.
  ///
  /// Alternatively, the size can be controlled externally using widgets
  /// such as [SizedBox] or [Positioned].
  final Widget? child;

  /// Creates a backdrop blur.
  ///
  /// Blur effect visual properties are specified in the [config].
  ///
  /// An optional [child] may be used, mainly for sizing.
  ///
  /// For performance and stability adjustments, refer to documentation of the
  /// [clipBehavior] and [useRepaintBoundary].
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

        final sigmaHorizontal = config.effectiveSigmaX;
        final sigmaVertical = config.effectiveSigmaY;

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
                      transform: config.transform,
                      globalBounds: globalBounds,
                      direction: Axis.horizontal,
                      sigma: sigmaHorizontal,
                    ),
                  ),
                  Positioned.fill(
                    child: _InspireBackdropBlurPass(
                      gradientMap: gradientMap,
                      transform: config.transform,
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
                transform: config.transform,
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
                transform: config.transform,
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
  final BlurTransform transform;
  final Rect globalBounds;
  final Axis direction;
  final double sigma;
  final Widget? child;

  const _InspireBackdropBlurPass({
    required this.gradientMap,
    required this.transform,
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
      final shader = program?.fragmentShader();
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

    final normalizedOrigin = widget.transform.origin.toNormalizedOffset();

    _shader?.setImageSampler(1, widget.gradientMap);
    _shader?.setFloat(2, widget.sigma);
    _shader?.setFloat(3, widget.direction == Axis.horizontal ? 1.0 : 0.0);
    _shader?.setFloat(4, widget.direction == Axis.vertical ? 1.0 : 0.0);
    _shader?.setFloat(5, widget.globalBounds.left * dpr);
    _shader?.setFloat(6, widget.globalBounds.top * dpr);
    _shader?.setFloat(7, widget.globalBounds.width * dpr);
    _shader?.setFloat(8, widget.globalBounds.height * dpr);
    _shader?.setFloat(9, widget.transform.scale.scaleX);
    _shader?.setFloat(10, widget.transform.scale.scaleY);
    _shader?.setFloat(11, widget.transform.offset.dx);
    _shader?.setFloat(12, widget.transform.offset.dy);
    _shader?.setFloat(13, widget.transform.rotation);
    _shader?.setFloat(14, widget.transform.inversionFactor);
    _shader?.setFloat(15, normalizedOrigin.dx);
    _shader?.setFloat(16, normalizedOrigin.dy);
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

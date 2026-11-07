import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:inspire_blur/src/color_adjustment/blur_color_adjustment.dart';
import 'package:inspire_blur/src/distribution/distribution_image.dart';
import 'package:inspire_blur/src/inspire_shaders.dart';
import 'package:inspire_blur/src/model/aspect_ratio_correction.dart';
import 'package:inspire_blur/src/opacity/widget_opacity.dart';
import 'package:inspire_blur/src/transform/blur_transform.dart';
import 'package:inspire_blur/src/utils/extensions/inspire_double_extensions.dart';
import 'package:inspire_blur/src/utils/extensions/inspire_geometry_extensions.dart';
import 'package:inspire_blur/src/utils/inspire_shader_utils.dart';

class InspireChildBlurImageFilterPass extends StatefulWidget {
  final DistributionImage blurDistributionImage;
  final DistributionImage opacityDistributionImage;
  final BlurTransform transform;
  final WidgetOpacity widgetOpacity;
  final BlurColorAdjustment colorAdjustment;
  final AspectRatioCorrection aspectRatioCorrection;
  final Axis direction;
  final double sigma;

  /// How the blurred child is clipped to this widget's bounds. Matches
  /// [InspireChildBlur.clipBehavior]; [Clip.none] leaves the child unclipped.
  final Clip clipBehavior;
  final Widget child;

  const InspireChildBlurImageFilterPass({
    super.key,
    required this.blurDistributionImage,
    required this.opacityDistributionImage,
    required this.transform,
    required this.widgetOpacity,
    required this.colorAdjustment,
    required this.aspectRatioCorrection,
    required this.direction,
    required this.sigma,
    this.clipBehavior = Clip.hardEdge,
    required this.child,
  });

  @override
  State<InspireChildBlurImageFilterPass> createState() =>
      _InspireChildBlurImageFilterPassState();
}

class _InspireChildBlurImageFilterPassState
    extends State<InspireChildBlurImageFilterPass> {
  ui.FragmentShader? _shader;

  @override
  void initState() {
    super.initState();
    _loadShader();
  }

  void _loadShader() {
    InspireShaders.childBlur.then((program) {
      final shader = program?.fragmentShader();
      if (mounted) {
        setState(() => _shader = shader);
      } else {
        _shader = shader;
      }
    });
  }

  @override
  void dispose() {
    _shader?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shader = _shader;
    if (shader == null) return widget.child;

    return _BlurFiltered(
      shader: shader,
      blurDistributionImage: widget.blurDistributionImage,
      opacityDistributionImage: widget.opacityDistributionImage,
      transform: widget.transform,
      widgetOpacity: widget.widgetOpacity,
      colorAdjustment: widget.colorAdjustment,
      aspectRatioCorrection: widget.aspectRatioCorrection,
      direction: widget.direction,
      sigma: widget.sigma,
      clipBehavior: widget.clipBehavior,
      child: widget.child,
    );
  }
}

class _BlurFiltered extends SingleChildRenderObjectWidget {
  final ui.FragmentShader shader;
  final DistributionImage blurDistributionImage;
  final DistributionImage opacityDistributionImage;
  final BlurTransform transform;
  final WidgetOpacity widgetOpacity;
  final BlurColorAdjustment colorAdjustment;
  final AspectRatioCorrection aspectRatioCorrection;
  final Axis direction;
  final double sigma;
  final Clip clipBehavior;

  const _BlurFiltered({
    super.child,
    required this.shader,
    required this.blurDistributionImage,
    required this.opacityDistributionImage,
    required this.transform,
    required this.widgetOpacity,
    required this.colorAdjustment,
    required this.aspectRatioCorrection,
    required this.direction,
    required this.sigma,
    required this.clipBehavior,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    final scrollPosition = Scrollable.maybeOf(context)?.position;
    final view = View.of(context);

    return _BlurFilterRenderObject(
      shader,
      blurDistributionImage,
      opacityDistributionImage,
      transform,
      widgetOpacity,
      colorAdjustment,
      aspectRatioCorrection,
      direction,
      sigma,
      clipBehavior,
      scrollPosition,
      _getScreenSize(view),
      _getDpr(context),
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _BlurFilterRenderObject renderObject,
  ) {
    final scrollPosition = Scrollable.maybeOf(context)?.position;
    final view = View.of(context);

    renderObject
      ..shader = shader
      ..blurDistributionImage = blurDistributionImage
      ..opacityDistributionImage = opacityDistributionImage
      ..transform = transform
      ..widgetOpacity = widgetOpacity
      ..colorAdjustment = colorAdjustment
      ..aspectRatioCorrection = aspectRatioCorrection
      ..direction = direction
      ..sigma = sigma
      ..clipBehavior = clipBehavior
      ..scrollPosition = scrollPosition
      ..screenSize = _getScreenSize(view)
      ..dpr = _getDpr(context);
  }

  Size _getScreenSize(ui.FlutterView view) =>
      view.physicalSize / view.devicePixelRatio;

  double _getDpr(BuildContext context) =>
      MediaQuery.of(context).devicePixelRatio;
}

class _BlurFilterRenderObject extends RenderProxyBox {
  ui.ImageFilter? _imageFilter;

  ui.FragmentShader _shader;
  set shader(ui.FragmentShader value) {
    if (identical(_shader, value)) return;
    _shader = value;
    _updateShader();
  }

  DistributionImage _blurDistributionImage;
  set blurDistributionImage(DistributionImage value) {
    if (_blurDistributionImage == value) return;
    _blurDistributionImage = value;
    _updateShader();
  }

  DistributionImage _opacityDistributionImage;
  set opacityDistributionImage(DistributionImage value) {
    if (_opacityDistributionImage == value) return;
    _opacityDistributionImage = value;
    _updateShader();
  }

  BlurTransform _transform;
  set transform(BlurTransform value) {
    if (_transform == value) return;
    _transform = value;
    _updateShader();
  }

  WidgetOpacity _widgetOpacity;
  set widgetOpacity(WidgetOpacity value) {
    if (_widgetOpacity == value) return;
    _widgetOpacity = value;
    _updateShader();
  }

  BlurColorAdjustment _colorAdjustment;
  set colorAdjustment(BlurColorAdjustment value) {
    if (_colorAdjustment == value) return;
    _colorAdjustment = value;
    _updateShader();
  }

  AspectRatioCorrection _aspectRatioCorrection;
  set aspectRatioCorrection(AspectRatioCorrection value) {
    if (_aspectRatioCorrection == value) return;
    _aspectRatioCorrection = value;
    _updateShader();
  }

  Axis _direction;
  set direction(Axis value) {
    if (_direction == value) return;
    _direction = value;
    _updateShader();
  }

  double _sigma;
  set sigma(double value) {
    if (_sigma == value) return;
    _sigma = value;
    _updateShader();
  }

  Clip _clipBehavior;
  set clipBehavior(Clip value) {
    if (_clipBehavior == value) return;
    _clipBehavior = value;
    markNeedsPaint();
  }

  Size _screenSize;
  set screenSize(Size value) {
    if (_screenSize == value) return;
    _screenSize = value;
    markNeedsPaint();
  }

  double _dpr;
  set dpr(double value) {
    if (_dpr == value) return;
    _dpr = value;
    markNeedsPaint();
  }

  ScrollPosition? _scrollPosition;
  set scrollPosition(ScrollPosition? value) {
    if (_scrollPosition == value) return;
    _detachListener();
    _scrollPosition = value;
    _attachListener();
  }

  _BlurFilterRenderObject(
    this._shader,
    this._blurDistributionImage,
    this._opacityDistributionImage,
    this._transform,
    this._widgetOpacity,
    this._colorAdjustment,
    this._aspectRatioCorrection,
    this._direction,
    this._sigma,
    this._clipBehavior,
    this._scrollPosition,
    this._screenSize,
    this._dpr,
  ) {
    _updateShader();
  }

  final LayerHandle<ClipRectLayer> _clipLayer = LayerHandle<ClipRectLayer>();

  Rect? _lastPaintedBounds;
  bool? _wasFullyVisible;

  void _attachListener() {
    if (!attached) return;
    _scrollPosition?.addListener(_onPositionChanged);
  }

  void _detachListener() => _scrollPosition?.removeListener(_onPositionChanged);

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _attachListener();
  }

  @override
  void dispose() {
    _clipLayer.layer = null;
    super.dispose();
  }

  @override
  void detach() {
    _detachListener();
    super.detach();
  }

  void _onPositionChanged() {
    if (!attached) return;

    final bounds = localToGlobal(Offset.zero) & size;
    final isFullyVisible = _isFullyVisible(bounds, _screenSize);

    if (!_shouldRepaint(bounds, isFullyVisible)) return;

    _wasFullyVisible = isFullyVisible;
    markNeedsPaint();
  }

  bool _isFullyVisible(Rect bounds, Size screenSize) {
    return bounds.top >= 0 &&
        bounds.bottom <= screenSize.height &&
        bounds.left >= 0 &&
        bounds.right <= screenSize.width;
  }

  bool _shouldRepaint(Rect bounds, bool isFullyVisible) {
    // If widget is still fully visible, no repaint is needed.
    // Flutter will simply offset the existing layer (when in RepaintBoundary).
    if (isFullyVisible && _wasFullyVisible == true) {
      return false;
    }

    if (bounds == _lastPaintedBounds) {
      return false;
    }

    return true;
  }

  void _updateShader() {
    final normalizedOrigin = _transform.origin.toNormalizedOffset();

    _shader.setImageSampler(
      1,
      _blurDistributionImage.image,
      filterQuality: kShaderMapSamplingQuality,
    );
    _shader.setImageSampler(
      2,
      _opacityDistributionImage.image,
      filterQuality: kShaderMapSamplingQuality,
    );
    _shader.setFloat(2, _sigma);
    _shader.setFloat(3, _direction == Axis.horizontal ? 1.0 : 0.0);
    _shader.setFloat(4, _direction == Axis.vertical ? 1.0 : 0.0);
    _shader.setFloat(9, _transform.scale.scaleX);
    _shader.setFloat(10, _transform.scale.scaleY);
    _shader.setFloat(11, _transform.offset.dx);
    _shader.setFloat(12, _transform.offset.dy);
    _shader.setFloat(13, _transform.rotation);
    _shader.setFloat(14, normalizedOrigin.dx);
    _shader.setFloat(15, normalizedOrigin.dy);
    _shader.setFloat(16, _transform.inversionFactor);
    _shader.setFloat(17, _colorAdjustment.shaderBrightness);
    _shader.setFloat(18, _colorAdjustment.shaderContrast);
    _shader.setFloat(19, _colorAdjustment.shaderExposure);
    _shader.setFloat(20, _colorAdjustment.shaderSaturation);
    _shader.setFloat(21, _colorAdjustment.shaderVibrance);
    _shader.setFloat(22, _colorAdjustment.blurAdjustmentStrength);
    _shader.setFloat(23, _colorAdjustment.nonBlurAdjustmentStrength);
    _shader.setFloat(24, _widgetOpacity.shaderOpacityType);
    _shader.setFloat(25, _widgetOpacity.shaderOpacityValue);
    _shader.setFloat(26, _aspectRatioCorrection.shaderAspectRatio);

    _recreateImageFilter();
    markNeedsPaint();
  }

  void _recreateImageFilter() {
    _imageFilter = ui.ImageFilter.shader(_shader);
  }

  @override
  void paint(PaintingContext context, ui.Offset offset) {
    final childValue = child;
    if (childValue == null) return;

    final newBounds = localToGlobal(Offset.zero) & size;

    if (_lastPaintedBounds?.isNotClose(newBounds) ?? true) {
      _lastPaintedBounds = newBounds;

      final screenWidth = _screenSize.width;
      final screenHeight = _screenSize.height;

      final deltaLeft = newBounds.left.takeNegativeOrZero().abs();
      final deltaTop = newBounds.top.takeNegativeOrZero().abs();
      final deltaRight = (newBounds.right - screenWidth).takePositiveOrZero();
      final deltaBottom =
          (newBounds.bottom - screenHeight).takePositiveOrZero();

      _shader.setFloat(5, deltaLeft * _dpr);
      _shader.setFloat(6, deltaTop * _dpr);
      _shader.setFloat(7, deltaRight * _dpr);
      _shader.setFloat(8, deltaBottom * _dpr);

      _imageFilter = ui.ImageFilter.shader(_shader);
    }

    final ImageFilterLayer filterLayer = ImageFilterLayer(
      imageFilter: _imageFilter,
    );

    context.pushLayer(filterLayer,
        (PaintingContext childContext, Offset childOffset) {
      // The shader receives the size of the filter's input texture as
      // `u_size`, and `FlutterFragCoord()` is relative to that texture. The
      // texture covers whatever the child subtree actually paints, so a
      // descendant that paints outside this box (e.g. a background moved
      // with `Transform.translate`) would stretch and shift the blur
      // distribution. Clipping the child to this box prevents descendants
      // from enlarging the texture past the widget's bounds, which the
      // animatedSampler pass gets for free by drawing `Offset.zero & size`.
      // `InspireChildBlur` clips the whole effect to the same box with the
      // same [clipBehavior], so this clip does not change what is visible;
      // with [Clip.none] the child is left unclipped, as before.
      if (_clipBehavior == Clip.none) {
        _clipLayer.layer = null;
        childContext.paintChild(childValue, childOffset);
        return;
      }
      _clipLayer.layer = childContext.pushClipRect(
        needsCompositing,
        childOffset,
        Offset.zero & size,
        (PaintingContext clipContext, Offset clipOffset) {
          clipContext.paintChild(childValue, clipOffset);
        },
        clipBehavior: _clipBehavior,
        oldLayer: _clipLayer.layer,
      );
    }, offset);
  }
}

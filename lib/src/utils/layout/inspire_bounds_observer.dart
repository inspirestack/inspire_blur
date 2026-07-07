import 'dart:typed_data' show Float64List;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:inspire_blur/src/utils/layout/inspire_layout_extensions.dart';

/// A centralized bounds observer that tracks a widget's exact global [Rect]
/// in real-time.
///
/// It automatically handles:
/// * Cupertino/Material route transitions and swipe-backs.
/// * Local and nested [Scrollable] viewport updates.
/// * External [Transform] or matrix paint-layer shifts.
/// * Custom triggers via [layoutInvalidationKey].
class InspireBoundsObserver extends StatefulWidget {
  const InspireBoundsObserver({
    super.key,
    required this.builder,
    this.layoutInvalidationKey,
  });

  /// Exposes the [ValueNotifier] containing the current global bounds.
  /// Wrap your dependent UI components inside a [ValueListenableBuilder].
  final Widget Function(
    BuildContext context,
    ValueNotifier<Rect?> boundsNotifier,
  ) builder;

  final Object? layoutInvalidationKey;

  @override
  State<InspireBoundsObserver> createState() => _InspireBoundsObserverState();
}

class _InspireBoundsObserverState extends State<InspireBoundsObserver> {
  final _paintKey = GlobalKey();
  final ValueNotifier<Rect?> _boundsNotifier = ValueNotifier<Rect?>(null);

  Animation<double>? _routeAnimation;
  ScrollPosition? _scrollPosition;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _scheduleBoundsUpdate();

    final newRouteAnimation = ModalRoute.of(context)?.animation;
    if (_routeAnimation != newRouteAnimation) {
      _routeAnimation?.removeListener(_updateBoundsNow);
      _routeAnimation = newRouteAnimation;
      _routeAnimation?.addListener(_updateBoundsNow);
    }

    final newScrollPosition = Scrollable.maybeOf(context)?.position;
    if (_scrollPosition != newScrollPosition) {
      _scrollPosition?.removeListener(_updateBoundsNow);
      _scrollPosition = newScrollPosition;
      _scrollPosition?.addListener(_updateBoundsNow);
    }
  }

  @override
  void didUpdateWidget(covariant InspireBoundsObserver oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.layoutInvalidationKey != oldWidget.layoutInvalidationKey) {
      _scheduleBoundsUpdate();
    }
  }

  void _updateBoundsNow() {
    if (!mounted) return;

    final newBounds = _paintKey.getGlobalRenderBoxBounds();

    if (newBounds != null && _boundsNotifier.value != newBounds) {
      _boundsNotifier.value = newBounds;
    }
  }

  @override
  void dispose() {
    _routeAnimation?.removeListener(_updateBoundsNow);
    _scrollPosition?.removeListener(_updateBoundsNow);
    _boundsNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scheduleBoundsUpdate();

    return _PaintMatrixInterceptor(
      onMatrixChanged: _scheduleBoundsUpdate,
      child: KeyedSubtree(
        key: _paintKey,
        child: widget.builder(context, _boundsNotifier),
      ),
    );
  }

  bool _updateScheduled = false;

  void _scheduleBoundsUpdate() {
    if (_updateScheduled) return;

    _updateScheduled = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateScheduled = false;
      _updateBoundsNow();
    });
  }
}

class _PaintMatrixInterceptor extends SingleChildRenderObjectWidget {
  final VoidCallback onMatrixChanged;

  const _PaintMatrixInterceptor({
    required this.onMatrixChanged,
    required super.child,
  });

  @override
  _RenderPaintMatrixInterceptor createRenderObject(BuildContext context) =>
      _RenderPaintMatrixInterceptor(onMatrixChanged: onMatrixChanged);

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderPaintMatrixInterceptor renderObject,
  ) {
    renderObject.onMatrixChanged = onMatrixChanged;
  }
}

class _RenderPaintMatrixInterceptor extends RenderProxyBox {
  VoidCallback onMatrixChanged;
  Float64List? _lastTransform;

  _RenderPaintMatrixInterceptor({
    required this.onMatrixChanged,
    RenderBox? child,
  }) : super(child);

  @override
  void paint(PaintingContext context, Offset offset) {
    final Float64List currentTransform = context.canvas.getTransform();

    if (!_matrixEquals(_lastTransform, currentTransform)) {
      _lastTransform = Float64List.fromList(currentTransform);

      onMatrixChanged();
    }

    super.paint(context, offset);
  }

  bool _matrixEquals(Float64List? a, Float64List b) {
    if (a == null) return false;

    if (identical(a, b)) return true;

    if (a.length != b.length) return false;

    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }

    return true;
  }
}

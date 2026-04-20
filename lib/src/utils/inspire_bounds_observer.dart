import 'package:flutter/material.dart';
import 'package:inspire_blur/src/utils/inspire_utils.dart';

class InspireBoundsObserver extends StatefulWidget {
  const InspireBoundsObserver({
    super.key,
    required this.builder,
  });

  final Widget Function(Rect?) builder;

  @override
  State<InspireBoundsObserver> createState() => _InspireBoundsObserverState();
}

class _InspireBoundsObserverState extends State<InspireBoundsObserver> {
  final _wrapperBoxKey = GlobalKey();

  bool _boundsUpdateBuild = true;
  Rect? _bounds;
  bool _callbackScheduled = false;

  @override
  Widget build(BuildContext context) {
    if (!_callbackScheduled && !_boundsUpdateBuild) {
      _callbackScheduled = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _callbackScheduled = false;

        _updateBounds();
      });
    }

    _boundsUpdateBuild = false;

    return SizedBox(
      key: _wrapperBoxKey,
      child: widget.builder(_bounds),
    );
  }

  void _updateBounds() {
    final newBounds = _wrapperBoxKey.getGlobalRenderBoxBounds();

    if (newBounds != null && newBounds != _bounds) {
      _boundsUpdateBuild = true;
      setState(() => _bounds = newBounds);
    }
  }
}

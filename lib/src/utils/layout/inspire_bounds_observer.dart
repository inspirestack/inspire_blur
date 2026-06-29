import 'package:flutter/widgets.dart';
import 'package:inspire_blur/src/utils/layout/inspire_layout_extensions.dart';

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

  bool _isBoundsUpdateBuild = true;
  bool _callbackScheduled = false;
  Rect? _bounds;

  @override
  Widget build(BuildContext context) {
    if (!_callbackScheduled && !_isBoundsUpdateBuild) {
      _callbackScheduled = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _callbackScheduled = false;

        _updateBounds();
      });
    }

    _isBoundsUpdateBuild = false;

    return SizedBox(
      key: _wrapperBoxKey,
      child: widget.builder(_bounds),
    );
  }

  void _updateBounds() {
    final newBounds = _wrapperBoxKey.getGlobalRenderBoxBounds();

    if (newBounds != null && newBounds != _bounds) {
      _isBoundsUpdateBuild = true;
      setState(() => _bounds = newBounds);
    }
  }
}

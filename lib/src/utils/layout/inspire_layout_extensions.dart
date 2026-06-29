import 'package:flutter/widgets.dart';

extension KeyLayoutExtensions on GlobalKey {
  /// Returns the global bounds of the [RenderBox] associated with this
  /// [GlobalKey].
  ///
  /// It returns `null` if:
  /// - widget is not mounted
  /// - widget doesn't have a size
  /// - render object is not available
  Rect? getGlobalRenderBoxBounds() {
    final context = currentContext;

    if (context == null || !context.mounted) return null;

    try {
      final renderBox = context.findRenderObject() as RenderBox?;
      if (renderBox == null || !renderBox.hasSize) return null;

      return renderBox.localToGlobal(Offset.zero) & renderBox.size;
    } catch (_) {
      // The render object may become temporarily unavailable during
      // widget rebuilds or layout changes.
      return null;
    }
  }
}

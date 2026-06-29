import 'package:flutter/widgets.dart';
import 'package:inspire_blur/src/utils/inspire_stops_generator.dart';

class InspireTint extends StatelessWidget {
  const InspireTint({
    super.key,
    required this.color,
    required this.opacity,
    required this.extent,
    required this.begin,
    required this.end,
    required this.curve,
    required this.child,
    this.stopsCount = 16,
  });

  final Color color;
  final double opacity;
  final double extent;
  final Alignment begin;
  final Alignment end;
  final Curve curve;
  final int stopsCount;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    if (extent <= 0.0 || opacity <= 0.0) {
      return child ?? const SizedBox.shrink();
    }

    final opacityControlPoints = curveToValuesAndStops(
      endStop: extent,
      curve: curve,
      stopsCount: stopsCount,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: begin,
          end: end,
          colors: opacityControlPoints
              .map((e) => color.withValues(alpha: e.$1 * opacity))
              .toList(),
          stops: opacityControlPoints.map((e) => e.$2).toList(),
        ),
      ),
      child: child,
    );
  }
}

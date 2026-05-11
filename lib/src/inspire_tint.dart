import 'package:flutter/widgets.dart';
import 'package:inspire_blur/src/utils/inspire_utils.dart';

class InspireTint extends StatelessWidget {
  const InspireTint({
    super.key,
    required this.color,
    required this.opacity,
    required this.extent,
    required this.begin,
    required this.end,
    required this.curve,
    this.stopsCount = 7,
    this.child,
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
    if (extent <= 0) return child ?? const SizedBox.shrink();

    final opacityFactors = curveToStops(
      extent: extent,
      curve: curve,
      stopsCount: stopsCount,
    );

    return IgnorePointer(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: begin,
            end: end,
            stops: opacityFactors.map((e) => e.$1).toList(),
            colors: opacityFactors
                .map((e) => color.withValues(alpha: e.$2 * opacity))
                .toList(),
          ),
        ),
        child: child,
      ),
    );
  }
}

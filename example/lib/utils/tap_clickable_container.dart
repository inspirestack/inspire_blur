import 'package:flutter/material.dart';

class TapClickableContainer extends StatefulWidget {
  const TapClickableContainer({
    super.key,
    this.duration,
    this.curve,
    required this.builder,
  });

  final Duration? duration;
  final Curve? curve;
  final Widget Function(double) builder;

  @override
  State<TapClickableContainer> createState() => _TapClickableContainerState();
}

class _TapClickableContainerState extends State<TapClickableContainer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration ?? const Duration(milliseconds: 400),
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.curve ?? Curves.easeInOutSine,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: (_) => _startAnimation(),
      onPanEnd: (_) => _endAnimation(),
      onPanCancel: () => _endAnimation(),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) => widget.builder(_animation.value),
      ),
    );
  }

  void _startAnimation() => _controller.forward();
  void _endAnimation() => _controller.reverse();
}

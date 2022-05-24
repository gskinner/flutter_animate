import 'dart:math';

import 'package:flutter/widgets.dart';

import '../flutter_animate.dart';

/// Effect that
@immutable
class ShineEffect extends Effect<double> {
  const ShineEffect({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    this.color = const Color(0x66FFFFFF),
    this.size = 1,
    this.angle = pi / 3,
  }) : super(
          delay: delay,
          duration: duration,
          curve: curve,
          begin: 0,
          end: 1,
        );

  final Color color;
  final double size;
  final double angle;

  @override
  Widget build(
    BuildContext context,
    Widget child,
    AnimationController controller,
    EffectEntry entry,
  ) {
    Animation<double> animation = buildAnimation(controller, entry);
    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (_, child) {
        return Container(
          foregroundDecoration: BoxDecoration(
            gradient: _buildGradient(animation.value),
          ),
          child: child,
        );
      },
    );
  }

  LinearGradient _buildGradient(double value) {
    double mid = (1 + size) * value - size / 2;
    double begin = mid - size / 2;
    double end = mid + size / 2;

    double x = cos(angle), y = sin(angle);
    double m = 1.42; // sqrt of 2. TODO: calculate the real value based on angle.
    
    return LinearGradient(
      colors: [
        _getEdgeColor(0 - begin),
        _getMidColor(mid, 0.92),
        _getMidColor(mid),
        _getMidColor(mid, 0.92),
        _getEdgeColor(end - 1),
      ],
      stops: [begin, mid - size * 0.08, mid, mid + size * 0.08, end],
      begin: Alignment(-x * m, -y * m),
      end: Alignment(x * m, y * m),
    );
  }

  Color _getMidColor(double value, [double opacity = 1]) {
    double a = max(0, max(value - 1, 0 - value));
    opacity = opacity * color.opacity * (1 - a / size * 2);
    return color.withOpacity(opacity);
  }

  Color _getEdgeColor(double value) {
    double a = max(0, value);
    double opacity = color.opacity * (0 + a / size);
    return color.withOpacity(opacity);
  }
}

extension ShineEffectExtensions<T> on AnimateManager<T> {
  /// Adds a `.shine()` extension to [AnimateManager] ([Animate] and [AnimateList]).
  T shine({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    Color color = const Color(0x66FFFFFF),
    double size = 1,
    double angle = pi / 6,
  }) =>
      addEffect(ShineEffect(
        delay: delay,
        duration: duration,
        curve: curve,
        color: color,
        size: size,
        angle: angle,
      ));
}

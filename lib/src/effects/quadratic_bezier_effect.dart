import 'package:flutter/widgets.dart';

import '../../flutter_animate.dart';

/// Effect that moves the target along a cubic bezier curve.
/// The curve is defined by two control points.
/// The [QuadraticBezierEffect] class implements quadratic bezier curve.
@immutable
class QuadraticBezierEffect extends Effect<double> {
  const QuadraticBezierEffect({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    required this.point1,
    required this.point2,
  }) : super(
          delay: delay,
          duration: duration,
          curve: curve,
          begin: 0,
          end: 1,
        );

  final Offset point1;
  final Offset point2;

  @override
  Widget build(
    BuildContext context,
    Widget child,
    AnimationController controller,
    EffectEntry entry,
  ) {
    final Animation<double> animation = buildAnimation(controller, entry);
    return getOptimizedBuilder<double>(
        animation: animation,
        builder: (_, value) {
          return Transform.translate(
            offset: Offset(
                _bezierInterpolate(point1.dx, point2.dx, animation.value),
                _bezierInterpolate(point1.dy, point2.dy, animation.value)),
            child: child,
          );
        });
  }
}

/// Cubic bezier interpolation.
/// to calculate the offset along the curve based on an input value.
double _bezierInterpolate(double p1, double p2, double t) {
  final double oneMinusT = 1 - t;
  return 2 * oneMinusT * t * p1 + t * t * p2;
}

extension QuadraticBezierEffectExtensions<T> on AnimateManager<T> {
  /// Adds a `bezier()` extension to [AnimateManager] ([Animate] and [AnimateList]).
  T quadraticBezier(
          {Duration? delay,
          Duration? duration,
          Curve? curve,
          required Offset point1,
          required Offset point2}) =>
      addEffect(QuadraticBezierEffect(
          delay: delay,
          duration: duration,
          curve: curve,
          point1: point1,
          point2: point2));
}

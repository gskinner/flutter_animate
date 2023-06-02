import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../flutter_animate.dart';

/// An effect that moves the target following the specified [path]. The path
/// coordinates are relative to the target's nominal position.
///
/// The path can have multiple segments (ex. multiple curves). It can also
/// have multiple contours (ie. disconnected segments), but only the first
/// contour will be used.
///
/// [begin] and [end] specify a position along the path (ie. 0 is the start of the path, 1 is the end).
/// For example, `begin: 0.5, end: 1` will move the target from the middle of the path to the end.
/// 
/// If [rotate] is set to `true`, the target will be rotated to match the path's direction.
/// You can use [rotationOffset] to adjust the rotation (in radians).
@immutable
class FollowPathEffect extends Effect<double> {
  static const double neutralValue = 0;
  static const double defaultValue = 1;

  static const bool defaultRotate = false;
  static const bool defaultTransformHitTests = true;
  static const double defaultRotationOffset = 0;

  const FollowPathEffect({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    double? begin,
    double? end,
    required this.path,
    bool? rotate,
    double? rotationOffset,
    bool? transformHitTests,
  })  : transformHitTests = transformHitTests ?? defaultTransformHitTests,
        rotate = rotate ?? defaultRotate,
        rotationOffset = rotationOffset ?? defaultRotationOffset,
        super(
          delay: delay,
          duration: duration,
          curve: curve,
          begin: begin ?? neutralValue,
          end: end ?? defaultValue,
        );

  final bool transformHitTests;
  final bool rotate;
  final double rotationOffset;
  final Path path;

  @override
  Widget build(
    BuildContext context,
    Widget child,
    AnimationController controller,
    EffectEntry entry,
  ) {
    Animation<double> animation = buildAnimation(controller, entry);
    List<PathMetric> metrics = path.computeMetrics().toList();
    if (metrics.isEmpty) return child;
    PathMetric metric = metrics.first;

    return getOptimizedBuilder<double>(
      animation: animation,
      builder: (_, __) {
        Tangent? tangent =
            metric.getTangentForOffset(metric.length * animation.value);

        Widget o = child;
        if (rotate) {
          o = Transform.rotate(
            angle: -(tangent?.angle ?? 0) + rotationOffset,
            child: child,
          );
        }

        return Transform.translate(
          offset: tangent?.position ?? Offset.zero,
          transformHitTests: transformHitTests,
          child: o,
        );
      },
    );
  }
}

extension FollowPathEffectExtensions<T> on AnimateManager<T> {
  /// Adds a [path] extension to [AnimateManager] ([Animate] and [AnimateList]).
  T followPath({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    double? begin,
    double? end,
    required path,
    bool? rotate,
    double? rotationOffset,
    bool? transformHitTests,
  }) =>
      addEffect(FollowPathEffect(
        delay: delay,
        duration: duration,
        curve: curve,
        begin: begin,
        end: end,
        path: path,
        rotate: rotate,
        rotationOffset: rotationOffset,
        transformHitTests: transformHitTests,
      ));
}

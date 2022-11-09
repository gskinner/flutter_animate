import 'package:flutter/widgets.dart';

import '../flutter_animate.dart';

/// Effect that rotates the target (via [RotationTransition]) between the specified begin and end.
/// Values are specified in "turns", so a `begin=0.25, end=2.25` would start with the child
/// rotated 90 degrees clockwise (ie. `0.25 * 360`), and rotate two full turns (ie. 720 degrees).
///
/// [alignment] lets you set the origin of the rotation (ie. the point around which the rotation
/// will occur). For example an alignment of [Alignment.topLeft] would rotate around the top left
/// corner of the child.
@immutable
class RotateEffect extends BeginEndEffect<double> {
  static const double neutralValue = 0.0;
  static const double defaultValue = -1.0;

  const RotateEffect({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    double? begin,
    double? end,
    this.alignment,
  }) : super(
          delay: delay,
          duration: duration,
          curve: curve,
          begin: begin ?? (end == null ? defaultValue : neutralValue),
          end: end ?? neutralValue,
        );

  final Alignment? alignment;

  @override
  Widget build(
    BuildContext context,
    Widget child,
    AnimationController controller,
    EffectEntry entry,
  ) {
    Animation<double> animation = buildAnimation(controller, entry);
    return RotationTransition(
      turns: animation,
      alignment: alignment ?? Alignment.center,
      child: child,
    );
  }
}

extension RotateEffectExtensions<T> on AnimateManager<T> {
  /// Adds a [rotate] extension to [AnimateManager] ([Animate] and [AnimateList]).
  T rotate({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    double? begin,
    double? end,
    Alignment? alignment,
  }) =>
      addEffect(RotateEffect(
        delay: delay,
        duration: duration,
        curve: curve,
        begin: begin,
        end: end,
        alignment: alignment,
      ));
}

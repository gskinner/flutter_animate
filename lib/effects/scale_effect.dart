import 'package:flutter/widgets.dart';

import '../flutter_animate.dart';

/// Effect that scales the target (via [ScaleTransition]) between the specified begin and end values.
/// Defaults to `begin=0, end=1`.
@immutable
class ScaleEffect extends Effect<Offset> {
  const ScaleEffect({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    Offset? begin,
    Offset? end,
    this.alignment,
  }) : super(
          delay: delay,
          duration: duration,
          curve: curve,
          begin: begin ?? (end == null ? Offset.zero : const Offset(1.0, 1.0)),
          end: end ?? const Offset(1.0, 1.0),
        );

  final Alignment? alignment;

  @override
  Widget build(
    BuildContext context,
    Widget child,
    AnimationController controller,
    EffectEntry entry,
  ) {
    Animation<Offset> animation = buildAnimation(controller, entry);
    return getOptimizedBuilder<Offset>(
      animation: animation,
      builder: (_, __) {
        return Transform.scale(
          scaleX: animation.value.dx,
          scaleY: animation.value.dy,
          child: child,
        );
      },
    );
  }
}

extension ScaleEffectExtensions<T> on AnimateManager<T> {
  /// Adds a [scale] extension to [AnimateManager] ([Animate] and [AnimateList]).
  T scale({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    Offset? begin,
    Offset? end,
    Alignment? alignment,
  }) =>
      addEffect(ScaleEffect(
        delay: delay,
        duration: duration,
        curve: curve,
        begin: begin,
        end: end,
        alignment: alignment,
      ));

  /// Adds a [scaleX] extension to [AnimateManager] ([Animate] and [AnimateList]).
  /// This scales only on the x-axis according to the `double` begin/end values.
  T scaleX({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    double? begin,
    double? end,
    Alignment? alignment,
  }) =>
      addEffect(ScaleEffect(
        delay: delay,
        duration: duration,
        curve: curve,
        begin: Offset(begin ?? (end == null ? 0 : 1), 1),
        end: Offset(end ?? 1, 1),
        alignment: alignment,
      ));

  /// Adds a [scaleY] extension to [AnimateManager] ([Animate] and [AnimateList]).
  /// This scales only on the y-axis according to the `double` begin/end values.
  T scaleY({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    double? begin,
    double? end,
    Alignment? alignment,
  }) =>
      addEffect(ScaleEffect(
        delay: delay,
        duration: duration,
        curve: curve,
        begin: Offset(1, begin ?? (end == null ? 0 : 1)),
        end: Offset(1, end ?? 1),
        alignment: alignment,
      ));

  /// Adds a [scaleXY] extension to [AnimateManager] ([Animate] and [AnimateList]).
  /// This scales uniformly according to the `double` begin/end values.
  T scaleXY({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    double? begin,
    double? end,
    Alignment? alignment,
  }) {
    begin ??= (end == null ? 0 : 1);
    end ??= 1;
    return addEffect(ScaleEffect(
      delay: delay,
      duration: duration,
      curve: curve,
      begin: Offset(begin, begin),
      end: Offset(end, end),
      alignment: alignment,
    ));
  }
}

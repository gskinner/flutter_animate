import 'package:flutter/widgets.dart';

import '../flutter_animate.dart';

/// Effect that moves the target (via [Transform.translate]) between the specified begin and end offsets.
/// Defaults to `begin=Offset(0, -16), end=Offset.zero`.
/// [transformHitTests] is simply passed on to [Transform.translate].
///
/// To specify offsets relative to the target's size, use [SlideEffect].
@immutable
class MoveEffect extends Effect<Offset> {
  const MoveEffect({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    Offset? begin,
    Offset? end,
    bool? transformHitTests,
  })  : transformHitTests = transformHitTests ?? true,
        super(
          delay: delay,
          duration: duration,
          curve: curve,
          begin: begin ??
              (end == null ? const Offset(0, -_defaultMove) : Offset.zero),
          end: end ?? Offset.zero,
        );

  final bool transformHitTests;

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
        return Transform.translate(
          offset: animation.value,
          transformHitTests: transformHitTests,
          child: child,
        );
      },
    );
  }
}

extension MoveEffectExtensions<T> on AnimateManager<T> {
  /// Adds a [move] extension to [AnimateManager] ([Animate] and [AnimateList]).
  T move({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    Offset? begin,
    Offset? end,
    bool? transformHitTests,
  }) =>
      addEffect(MoveEffect(
        delay: delay,
        duration: duration,
        curve: curve,
        begin: begin,
        end: end,
        transformHitTests: transformHitTests,
      ));

  /// Adds a [moveX] extension to [AnimateManager] ([Animate] and [AnimateList]).
  /// This moves only on the x-axis according to the `double` begin/end values.
  T moveX({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    double? begin,
    double? end,
    bool? transformHitTests,
  }) =>
      addEffect(MoveEffect(
        delay: delay,
        duration: duration,
        curve: curve,
        begin: Offset(begin ?? (end == null ? -_defaultMove : 0), 0),
        end: Offset(end ?? 0, 0),
        transformHitTests: transformHitTests,
      ));

  /// Adds a [moveY] extension to [AnimateManager] ([Animate] and [AnimateList]).
  /// This moves only on the y-axis according to the `double` begin/end values.
  T moveY({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    double? begin,
    double? end,
    bool? transformHitTests,
  }) =>
      addEffect(MoveEffect(
        delay: delay,
        duration: duration,
        curve: curve,
        begin: Offset(0, begin ?? (end == null ? -_defaultMove : 0)),
        end: Offset(0, end ?? 0),
        transformHitTests: transformHitTests,
      ));

  // Note: there is no moveXY because diagonal movement isn't a significant use case.
}

const double _defaultMove = 16;

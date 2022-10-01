import 'package:flutter/widgets.dart';

import '../flutter_animate.dart';

/// Effect that moves the target (via [Transform.translate]) between the specified begin and end offsets.
/// Defaults to `begin=Offset(0, -16), end=Offset.zero`.
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
  }) : super(
          delay: delay,
          duration: duration,
          curve: curve,
          begin: begin ?? const Offset(0, -_defaultMove),
          end: end ?? Offset.zero,
        );

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
        return Transform.translate(offset: animation.value, child: child);
      },
    );
  }
}

extension MoveEffectExtensions<T> on AnimateManager<T> {
  /// Adds a `.move()` extension to [AnimateManager] ([Animate] and [AnimateList]).
  T move({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    Offset? begin,
    Offset? end,
  }) =>
      addEffect(MoveEffect(
        delay: delay,
        duration: duration,
        curve: curve,
        begin: begin,
        end: end,
      ));

  /// Adds a `.moveX()` extension to [AnimateManager] ([Animate] and [AnimateList]).
  /// This moves only on the x-axis according to the `double` begin/end values.
  T moveX({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    double? begin,
    double? end,
  }) =>
      addEffect(MoveEffect(
        delay: delay,
        duration: duration,
        curve: curve,
        begin: Offset(begin ?? -_defaultMove, 0),
        end: Offset(end ?? 0, 0),
      ));

  /// Adds a `.moveY()` extension to [AnimateManager] ([Animate] and [AnimateList]).
  /// This moves only on the y-axis according to the `double` begin/end values.
  T moveY({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    double? begin,
    double? end,
  }) =>
      addEffect(MoveEffect(
        delay: delay,
        duration: duration,
        curve: curve,
        begin: Offset(0, begin ?? -_defaultMove),
        end: Offset(0, end ?? 0),
      ));

  // Note: there is no moveXY because diagonal movement isn't a significant use case.
}

const double _defaultMove = 16;
